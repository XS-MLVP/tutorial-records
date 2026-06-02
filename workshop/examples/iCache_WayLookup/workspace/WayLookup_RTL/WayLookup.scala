/***************************************************************************************
* Copyright (c) 2024 Beijing Institute of Open Source Chip (BOSC)
* Copyright (c) 2020-2024 Institute of Computing Technology, Chinese Academy of Sciences
* Copyright (c) 2020-2021 Peng Cheng Laboratory
*
* XiangShan is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*          http://license.coscl.org.cn/MulanPSL2
*
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
*
* See the Mulan PSL v2 for more details.
***************************************************************************************/

package xiangshan.frontend.icache

import chisel3._
import chisel3.util._
import org.chipsalliance.cde.config.Parameters
import utility._


object Pbmt {
  def pma:  UInt = "b00".U  // None
  def nc:   UInt = "b01".U  // Non-cacheable, idempotent, weakly-ordered (RVWMO), main memory
  def io:   UInt = "b10".U  // Non-cacheable, non-idempotent, strongly-ordered (I/O ordering), I/O
  def rsvd: UInt = "b11".U  // Reserved for future standard use
  def width: Int = 2

  def apply() = UInt(2.W)
  def isUncache(a: UInt) = a===nc || a===io
  def isPMA(a: UInt) = a===pma
  def isNC(a: UInt) = a===nc
  def isIO(a: UInt) = a===io
}

object ExceptionType {
  def width: Int  = 2
  def none:  UInt = "b00".U(width.W)
  def pf:    UInt = "b01".U(width.W) // instruction page fault
  def gpf:   UInt = "b10".U(width.W) // instruction guest page fault
  def af:    UInt = "b11".U(width.W) // instruction access fault

  def hasException(e: UInt):             Bool = e =/= none
  def hasException(e: Vec[UInt]):        Bool = e.map(_ =/= none).reduce(_ || _)
  def hasException(e: IndexedSeq[UInt]): Bool = hasException(VecInit(e))

  def fromOH(has_pf: Bool, has_gpf: Bool, has_af: Bool): UInt = {
    assert(
      PopCount(VecInit(has_pf, has_gpf, has_af)) <= 1.U,
      "ExceptionType.fromOH receives input that is not one-hot: pf=%d, gpf=%d, af=%d",
      has_pf,
      has_gpf,
      has_af
    )
    // input is at-most-one-hot encoded, so we don't worry about priority here.
    MuxCase(
      none,
      Seq(
        has_pf  -> pf,
        has_gpf -> gpf,
        has_af  -> af
      )
    )
  }

  // raise pf/gpf/af according to itlb response
  def fromTlbResp(resp: TlbResp, useDup: Int = 0): UInt = {
    require(useDup >= 0 && useDup < resp.excp.length)
    // itlb is guaranteed to respond at most one exception
    fromOH(
      resp.excp(useDup).pf.instr,
      resp.excp(useDup).gpf.instr,
      resp.excp(useDup).af.instr
    )
  }

  // raise af if pmp check failed
  def fromPMPResp(resp: PMPRespBundle): UInt =
    Mux(resp.instr, af, none)

  // raise af if meta/data array ecc check failed or l2 cache respond with tilelink corrupt
  /* FIXME: RISC-V Machine ISA v1.13 (draft) introduced a "hardware error" exception, described as:
   * > A Hardware Error exception is a synchronous exception triggered when corrupted or
   * > uncorrectable data is accessed explicitly or implicitly by an instruction. In this context,
   * > "data" encompasses all types of information used within a RISC-V hart. Upon a hardware
   * > error exception, the xepc register is set to the address of the instruction that attempted to
   * > access corrupted data, while the xtval register is set either to 0 or to the virtual address
   * > of an instruction fetch, load, or store that attempted to access corrupted data. The priority
   * > of Hardware Error exception is implementation-defined, but any given occurrence is
   * > generally expected to be recognized at the point in the overall priority order at which the
   * > hardware error is discovered.
   * Maybe it's better to raise hardware error instead of access fault when ECC check failed.
   * But it's draft and XiangShan backend does not implement this exception code yet, so we still raise af here.
   */
  def fromECC(enable: Bool, corrupt: Bool): UInt =
    Mux(enable && corrupt, af, none)

  /**Generates exception mux tree
   *
   * Exceptions that are further to the left in the parameter list have higher priority
   * @example
   * {{{
   *   val itlb_exception = ExceptionType.fromTlbResp(io.itlb.resp.bits)
   *   // so as pmp_exception, meta_corrupt
   *   // ExceptionType.merge(itlb_exception, pmp_exception, meta_corrupt) is equivalent to:
   *   Mux(
   *     itlb_exception =/= none,
   *     itlb_exception,
   *     Mux(pmp_exception =/= none, pmp_exception, meta_corrupt)
   *   )
   * }}}
   */
  def merge(exceptions: UInt*): UInt = {
//    // recursively generate mux tree
//    if (exceptions.length == 1) {
//      require(exceptions.head.getWidth == width)
//      exceptions.head
//    } else {
//      Mux(exceptions.head =/= none, exceptions.head, merge(exceptions.tail: _*))
//    }
    // use MuxCase with default
    exceptions.foreach(e => require(e.getWidth == width))
    val mapping = exceptions.init.map(e => (e =/= none) -> e)
    val default = exceptions.last
    MuxCase(default, mapping)
  }

  /**Generates exception mux tree for multi-port exception vectors
   *
   * Exceptions that are further to the left in the parameter list have higher priority
   * @example
   * {{{
   *   val itlb_exception = VecInit((0 until PortNumber).map(i => ExceptionType.fromTlbResp(io.itlb(i).resp.bits)))
   *   // so as pmp_exception, meta_corrupt
   *   // ExceptionType.merge(itlb_exception, pmp_exception, meta_corrupt) is equivalent to:
   *   VecInit((0 until PortNumber).map(i => Mux(
   *     itlb_exception(i) =/= none,
   *     itlb_exception(i),
   *     Mux(pmp_exception(i) =/= none, pmp_exception(i), meta_corrupt(i))
   *   ))
   * }}}
   */
  def merge(exceptionVecs: Vec[UInt]*): Vec[UInt] = {
//    // recursively generate mux tree
//    if (exceptionVecs.length == 1) {
//      exceptionVecs.head.foreach(e => require(e.getWidth == width))
//      exceptionVecs.head
//    } else {
//      require(exceptionVecs.head.length == exceptionVecs.last.length)
//      VecInit((exceptionVecs.head zip merge(exceptionVecs.tail: _*)).map{ case (high, low) =>
//        Mux(high =/= none, high, low)
//      })
//    }
    // merge port-by-port
    val length = exceptionVecs.head.length
    exceptionVecs.tail.foreach(vec => require(vec.length == length))
    VecInit((0 until length).map(i => merge(exceptionVecs.map(_(i)): _*)))
  }
}


/* WayLookupEntry is for internal storage, while WayLookupInfo is for interface
 * Notes:
 *   1. there must be a flush (caused by guest page fault) after excp_tlb_gpf === true.B,
 *      so, we need only the first excp_tlb_gpf and the corresponding gpaddr.
 *      to save area, we separate those signals from WayLookupEntry and store only once.
 */
class WayLookupEntry(implicit p: Parameters) extends ICacheBundle {
  val vSetIdx:        Vec[UInt] = Vec(PortNumber, UInt(idxBits.W))
  val waymask:        Vec[UInt] = Vec(PortNumber, UInt(nWays.W))
  val ptag:           Vec[UInt] = Vec(PortNumber, UInt(tagBits.W))
  val itlb_exception: Vec[UInt] = Vec(PortNumber, UInt(ExceptionType.width.W))
  val itlb_pbmt:      Vec[UInt] = Vec(PortNumber, UInt(Pbmt.width.W))
  val meta_codes:     Vec[UInt] = Vec(PortNumber, UInt(ICacheMetaCodeBits.W))
}

class WayLookupGPFEntry(implicit p: Parameters) extends ICacheBundle {
  // NOTE: we don't use GPAddrBits here, refer to ICacheMainPipe.scala L43-48 and PR#3795
  val gpaddr:            UInt = UInt(PAddrBitsMax.W)
  val isForVSnonLeafPTE: Bool = Bool()
}

class WayLookupInfo(implicit p: Parameters) extends ICacheBundle {
  val entry = new WayLookupEntry
  val gpf   = new WayLookupGPFEntry

  // for compatibility
  def vSetIdx:           Vec[UInt] = entry.vSetIdx
  def waymask:           Vec[UInt] = entry.waymask
  def ptag:              Vec[UInt] = entry.ptag
  def itlb_exception:    Vec[UInt] = entry.itlb_exception
  def itlb_pbmt:         Vec[UInt] = entry.itlb_pbmt
  def meta_codes:        Vec[UInt] = entry.meta_codes
  def gpaddr:            UInt      = gpf.gpaddr
  def isForVSnonLeafPTE: Bool      = gpf.isForVSnonLeafPTE
}

class WayLookupInterface(implicit p: Parameters) extends ICacheBundle {
  val flush:  Bool                       = Input(Bool())
  val read:   DecoupledIO[WayLookupInfo] = DecoupledIO(new WayLookupInfo)
  val write:  DecoupledIO[WayLookupInfo] = Flipped(DecoupledIO(new WayLookupInfo))
  val update: Valid[ICacheMissResp]      = Flipped(ValidIO(new ICacheMissResp))
}

class WayLookup(implicit p: Parameters) extends ICacheModule with HasICacheECCHelper {
  val io: WayLookupInterface = IO(new WayLookupInterface)

  class WayLookupPtr extends CircularQueuePtr[WayLookupPtr](nWayLookupSize)
  private object WayLookupPtr {
    def apply(f: Bool, v: UInt): WayLookupPtr = {
      val ptr = Wire(new WayLookupPtr)
      ptr.flag  := f
      ptr.value := v
      ptr
    }
  }

  private val entries  = RegInit(VecInit(Seq.fill(nWayLookupSize)(0.U.asTypeOf(new WayLookupEntry))))
  private val readPtr  = RegInit(WayLookupPtr(false.B, 0.U))
  private val writePtr = RegInit(WayLookupPtr(false.B, 0.U))

  private val empty = readPtr === writePtr
  private val full  = (readPtr.value === writePtr.value) && (readPtr.flag ^ writePtr.flag)

  when(io.flush) {
    writePtr.value := 0.U
    writePtr.flag  := false.B
  }.elsewhen(io.write.fire) {
    writePtr := writePtr + 1.U
  }

  when(io.flush) {
    readPtr.value := 0.U
    readPtr.flag  := false.B
  }.elsewhen(io.read.fire) {
    readPtr := readPtr + 1.U
  }

  private val gpf_entry = RegInit(0.U.asTypeOf(Valid(new WayLookupGPFEntry)))
  private val gpfPtr    = RegInit(WayLookupPtr(false.B, 0.U))
  private val gpf_hit   = gpfPtr === readPtr && gpf_entry.valid

  when(io.flush) {
    // we don't need to reset gpfPtr, since the valid is actually gpf_entries.excp_tlb_gpf
    gpf_entry.valid := false.B
    gpf_entry.bits  := 0.U.asTypeOf(new WayLookupGPFEntry)
  }

  /**
    ******************************************************************************
    * update
    ******************************************************************************
    */
  private val hits = Wire(Vec(nWayLookupSize, Bool()))
  entries.zip(hits).foreach { case (entry, hit) =>
    val hit_vec = Wire(Vec(PortNumber, Bool()))
    (0 until PortNumber).foreach { i =>
      val vset_same = (io.update.bits.vSetIdx === entry.vSetIdx(i)) && !io.update.bits.corrupt && io.update.valid
      val ptag_same = getPhyTagFromBlk(io.update.bits.blkPaddr) === entry.ptag(i)
      val way_same  = io.update.bits.waymask === entry.waymask(i)
      when(vset_same) {
        when(ptag_same) {
          // miss -> hit
          entry.waymask(i) := io.update.bits.waymask
          // also update meta_codes
          // NOTE: we have getPhyTagFromBlk(io.update.bits.blkPaddr) === entry.ptag(i),
          //       so we can use entry.ptag(i) for better timing
          entry.meta_codes(i) := encodeMetaECC(entry.ptag(i))
        }.elsewhen(way_same) {
          // data is overwritten: hit -> miss
          entry.waymask(i) := 0.U
          // don't care meta_codes, since it's not used for a missed request
        }
      }
      hit_vec(i) := vset_same && (ptag_same || way_same)
    }
    hit := hit_vec.reduce(_ || _)
  }

  /**
    ******************************************************************************
    * read
    ******************************************************************************
    */
  // if the entry is empty, but there is a valid write, we can bypass it to read port (maybe timing critical)
  private val can_bypass = empty && io.write.valid
  io.read.valid := !empty || io.write.valid
  when(can_bypass) {
    io.read.bits := io.write.bits
  }.otherwise { // can't bypass
    io.read.bits.entry := entries(readPtr.value)
    when(gpf_hit) { // ptr match && entry valid
      io.read.bits.gpf := gpf_entry.bits
      // also clear gpf_entry.valid when it's read, note this will be overridden by write (L175)
      when(io.read.fire) {
        gpf_entry.valid := false.B
      }
    }.otherwise { // gpf not hit
      io.read.bits.gpf := 0.U.asTypeOf(new WayLookupGPFEntry)
    }
  }

  /**
    ******************************************************************************
    * write
    ******************************************************************************
    */
  // if there is a valid gpf to be read, we should stall write
  private val gpf_stall = gpf_entry.valid && !(io.read.fire && gpf_hit)
  io.write.ready := !full && !gpf_stall
  when(io.write.fire) {
    entries(writePtr.value) := io.write.bits.entry
    when(io.write.bits.itlb_exception.map(_ === ExceptionType.gpf).reduce(_ || _)) {
      // if gpf_entry is bypassed, we don't need to save it
      // note this will override the read (L156)
      gpf_entry.valid := !(can_bypass && io.read.fire)
      gpf_entry.bits  := io.write.bits.gpf
      gpfPtr          := writePtr
    }
  }
}
