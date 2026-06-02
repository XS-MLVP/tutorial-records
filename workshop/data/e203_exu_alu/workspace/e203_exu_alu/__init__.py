#coding=utf8


try:
    from . import xspcomm as xsp
except Exception as e:
    import xspcomm as xsp

if __package__ or "." in __name__:
    from .libUT_e203_exu_alu import *
else:
    from libUT_e203_exu_alu import *


class DUTe203_exu_alu(object):

    # initialize
    def __init__(self, *args, **kwargs):
        
        self.dut = DutUnifiedBase(*args)
        self.xclock = xsp.XClock(self.dut.pxcStep, self.dut.pSelf)
        self.xport  = xsp.XPort()
        self.xclock.Add(self.xport)
        self.event = self.xclock.getEvent()
        self.internal_signals = {}
        self.xcfg = xsp.XSignalCFG(self.dut.GetXSignalCFGPath(), self.dut.GetXSignalCFGBasePtr())
        

        # set output files
        if kwargs.get("waveform_filename"):
            self.dut.SetWaveform(kwargs.get("waveform_filename"))
        if kwargs.get("coverage_filename"):
            self.dut.SetCoverage(kwargs.get("coverage_filename"))

        # All pins
        self.i_valid = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.i_ready = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.i_longpipe = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.nice_xs_off = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.amo_wait = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.oitf_empty = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.i_itag = xsp.XPin(xsp.XData(1, xsp.XData.In), self.event)
        self.i_rs1 = xsp.XPin(xsp.XData(32, xsp.XData.In), self.event)
        self.i_rs2 = xsp.XPin(xsp.XData(32, xsp.XData.In), self.event)
        self.i_imm = xsp.XPin(xsp.XData(32, xsp.XData.In), self.event)
        self.i_info = xsp.XPin(xsp.XData(32, xsp.XData.In), self.event)
        self.i_pc = xsp.XPin(xsp.XData(32, xsp.XData.In), self.event)
        self.i_instr = xsp.XPin(xsp.XData(32, xsp.XData.In), self.event)
        self.i_pc_vld = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.i_rdidx = xsp.XPin(xsp.XData(5, xsp.XData.In), self.event)
        self.i_rdwen = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.i_ilegl = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.i_buserr = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.i_misalgn = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.flush_req = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.flush_pulse = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.cmt_o_valid = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.cmt_o_ready = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.cmt_o_pc_vld = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.cmt_o_pc = xsp.XPin(xsp.XData(32, xsp.XData.Out), self.event)
        self.cmt_o_instr = xsp.XPin(xsp.XData(32, xsp.XData.Out), self.event)
        self.cmt_o_imm = xsp.XPin(xsp.XData(32, xsp.XData.Out), self.event)
        self.cmt_o_rv32 = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.cmt_o_bjp = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.cmt_o_mret = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.cmt_o_dret = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.cmt_o_ecall = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.cmt_o_ebreak = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.cmt_o_fencei = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.cmt_o_wfi = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.cmt_o_ifu_misalgn = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.cmt_o_ifu_buserr = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.cmt_o_ifu_ilegl = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.cmt_o_bjp_prdt = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.cmt_o_bjp_rslv = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.cmt_o_misalgn = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.cmt_o_ld = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.cmt_o_stamo = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.cmt_o_buserr = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.cmt_o_badaddr = xsp.XPin(xsp.XData(32, xsp.XData.Out), self.event)
        self.wbck_o_valid = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.wbck_o_ready = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.wbck_o_wdat = xsp.XPin(xsp.XData(32, xsp.XData.Out), self.event)
        self.wbck_o_rdidx = xsp.XPin(xsp.XData(5, xsp.XData.Out), self.event)
        self.mdv_nob2b = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.csr_ena = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.csr_wr_en = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.csr_rd_en = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.csr_idx = xsp.XPin(xsp.XData(12, xsp.XData.Out), self.event)
        self.nonflush_cmt_ena = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.csr_access_ilgl = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.read_csr_dat = xsp.XPin(xsp.XData(32, xsp.XData.In), self.event)
        self.wbck_csr_dat = xsp.XPin(xsp.XData(32, xsp.XData.Out), self.event)
        self.agu_icb_cmd_valid = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.agu_icb_cmd_ready = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.agu_icb_cmd_addr = xsp.XPin(xsp.XData(32, xsp.XData.Out), self.event)
        self.agu_icb_cmd_read = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.agu_icb_cmd_wdata = xsp.XPin(xsp.XData(32, xsp.XData.Out), self.event)
        self.agu_icb_cmd_wmask = xsp.XPin(xsp.XData(4, xsp.XData.Out), self.event)
        self.agu_icb_cmd_lock = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.agu_icb_cmd_excl = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.agu_icb_cmd_size = xsp.XPin(xsp.XData(2, xsp.XData.Out), self.event)
        self.agu_icb_cmd_back2agu = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.agu_icb_cmd_usign = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.agu_icb_cmd_itag = xsp.XPin(xsp.XData(1, xsp.XData.Out), self.event)
        self.agu_icb_rsp_valid = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.agu_icb_rsp_ready = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.agu_icb_rsp_err = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.agu_icb_rsp_excl_ok = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.agu_icb_rsp_rdata = xsp.XPin(xsp.XData(32, xsp.XData.In), self.event)
        self.nice_req_valid = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.nice_req_ready = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.nice_req_instr = xsp.XPin(xsp.XData(32, xsp.XData.Out), self.event)
        self.nice_req_rs1 = xsp.XPin(xsp.XData(32, xsp.XData.Out), self.event)
        self.nice_req_rs2 = xsp.XPin(xsp.XData(32, xsp.XData.Out), self.event)
        self.nice_rsp_multicyc_valid = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.nice_rsp_multicyc_ready = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.nice_longp_wbck_valid = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.nice_longp_wbck_ready = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.nice_o_itag = xsp.XPin(xsp.XData(1, xsp.XData.Out), self.event)
        self.i_nice_cmt_off_ilgl = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.clk = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.rst_n = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)


        # BindDPI or Native pin address
        self.i_valid.BindNativeData(self.dut.NativeSignalAddr("i_valid"))
        self.i_ready.BindNativeData(self.dut.NativeSignalAddr("i_ready"))
        self.i_longpipe.BindNativeData(self.dut.NativeSignalAddr("i_longpipe"))
        self.nice_xs_off.BindNativeData(self.dut.NativeSignalAddr("nice_xs_off"))
        self.amo_wait.BindNativeData(self.dut.NativeSignalAddr("amo_wait"))
        self.oitf_empty.BindNativeData(self.dut.NativeSignalAddr("oitf_empty"))
        self.i_itag.BindNativeData(self.dut.NativeSignalAddr("i_itag"))
        self.i_rs1.BindNativeData(self.dut.NativeSignalAddr("i_rs1"))
        self.i_rs2.BindNativeData(self.dut.NativeSignalAddr("i_rs2"))
        self.i_imm.BindNativeData(self.dut.NativeSignalAddr("i_imm"))
        self.i_info.BindNativeData(self.dut.NativeSignalAddr("i_info"))
        self.i_pc.BindNativeData(self.dut.NativeSignalAddr("i_pc"))
        self.i_instr.BindNativeData(self.dut.NativeSignalAddr("i_instr"))
        self.i_pc_vld.BindNativeData(self.dut.NativeSignalAddr("i_pc_vld"))
        self.i_rdidx.BindNativeData(self.dut.NativeSignalAddr("i_rdidx"))
        self.i_rdwen.BindNativeData(self.dut.NativeSignalAddr("i_rdwen"))
        self.i_ilegl.BindNativeData(self.dut.NativeSignalAddr("i_ilegl"))
        self.i_buserr.BindNativeData(self.dut.NativeSignalAddr("i_buserr"))
        self.i_misalgn.BindNativeData(self.dut.NativeSignalAddr("i_misalgn"))
        self.flush_req.BindNativeData(self.dut.NativeSignalAddr("flush_req"))
        self.flush_pulse.BindNativeData(self.dut.NativeSignalAddr("flush_pulse"))
        self.cmt_o_valid.BindNativeData(self.dut.NativeSignalAddr("cmt_o_valid"))
        self.cmt_o_ready.BindNativeData(self.dut.NativeSignalAddr("cmt_o_ready"))
        self.cmt_o_pc_vld.BindNativeData(self.dut.NativeSignalAddr("cmt_o_pc_vld"))
        self.cmt_o_pc.BindNativeData(self.dut.NativeSignalAddr("cmt_o_pc"))
        self.cmt_o_instr.BindNativeData(self.dut.NativeSignalAddr("cmt_o_instr"))
        self.cmt_o_imm.BindNativeData(self.dut.NativeSignalAddr("cmt_o_imm"))
        self.cmt_o_rv32.BindNativeData(self.dut.NativeSignalAddr("cmt_o_rv32"))
        self.cmt_o_bjp.BindNativeData(self.dut.NativeSignalAddr("cmt_o_bjp"))
        self.cmt_o_mret.BindNativeData(self.dut.NativeSignalAddr("cmt_o_mret"))
        self.cmt_o_dret.BindNativeData(self.dut.NativeSignalAddr("cmt_o_dret"))
        self.cmt_o_ecall.BindNativeData(self.dut.NativeSignalAddr("cmt_o_ecall"))
        self.cmt_o_ebreak.BindNativeData(self.dut.NativeSignalAddr("cmt_o_ebreak"))
        self.cmt_o_fencei.BindNativeData(self.dut.NativeSignalAddr("cmt_o_fencei"))
        self.cmt_o_wfi.BindNativeData(self.dut.NativeSignalAddr("cmt_o_wfi"))
        self.cmt_o_ifu_misalgn.BindNativeData(self.dut.NativeSignalAddr("cmt_o_ifu_misalgn"))
        self.cmt_o_ifu_buserr.BindNativeData(self.dut.NativeSignalAddr("cmt_o_ifu_buserr"))
        self.cmt_o_ifu_ilegl.BindNativeData(self.dut.NativeSignalAddr("cmt_o_ifu_ilegl"))
        self.cmt_o_bjp_prdt.BindNativeData(self.dut.NativeSignalAddr("cmt_o_bjp_prdt"))
        self.cmt_o_bjp_rslv.BindNativeData(self.dut.NativeSignalAddr("cmt_o_bjp_rslv"))
        self.cmt_o_misalgn.BindNativeData(self.dut.NativeSignalAddr("cmt_o_misalgn"))
        self.cmt_o_ld.BindNativeData(self.dut.NativeSignalAddr("cmt_o_ld"))
        self.cmt_o_stamo.BindNativeData(self.dut.NativeSignalAddr("cmt_o_stamo"))
        self.cmt_o_buserr.BindNativeData(self.dut.NativeSignalAddr("cmt_o_buserr"))
        self.cmt_o_badaddr.BindNativeData(self.dut.NativeSignalAddr("cmt_o_badaddr"))
        self.wbck_o_valid.BindNativeData(self.dut.NativeSignalAddr("wbck_o_valid"))
        self.wbck_o_ready.BindNativeData(self.dut.NativeSignalAddr("wbck_o_ready"))
        self.wbck_o_wdat.BindNativeData(self.dut.NativeSignalAddr("wbck_o_wdat"))
        self.wbck_o_rdidx.BindNativeData(self.dut.NativeSignalAddr("wbck_o_rdidx"))
        self.mdv_nob2b.BindNativeData(self.dut.NativeSignalAddr("mdv_nob2b"))
        self.csr_ena.BindNativeData(self.dut.NativeSignalAddr("csr_ena"))
        self.csr_wr_en.BindNativeData(self.dut.NativeSignalAddr("csr_wr_en"))
        self.csr_rd_en.BindNativeData(self.dut.NativeSignalAddr("csr_rd_en"))
        self.csr_idx.BindNativeData(self.dut.NativeSignalAddr("csr_idx"))
        self.nonflush_cmt_ena.BindNativeData(self.dut.NativeSignalAddr("nonflush_cmt_ena"))
        self.csr_access_ilgl.BindNativeData(self.dut.NativeSignalAddr("csr_access_ilgl"))
        self.read_csr_dat.BindNativeData(self.dut.NativeSignalAddr("read_csr_dat"))
        self.wbck_csr_dat.BindNativeData(self.dut.NativeSignalAddr("wbck_csr_dat"))
        self.agu_icb_cmd_valid.BindNativeData(self.dut.NativeSignalAddr("agu_icb_cmd_valid"))
        self.agu_icb_cmd_ready.BindNativeData(self.dut.NativeSignalAddr("agu_icb_cmd_ready"))
        self.agu_icb_cmd_addr.BindNativeData(self.dut.NativeSignalAddr("agu_icb_cmd_addr"))
        self.agu_icb_cmd_read.BindNativeData(self.dut.NativeSignalAddr("agu_icb_cmd_read"))
        self.agu_icb_cmd_wdata.BindNativeData(self.dut.NativeSignalAddr("agu_icb_cmd_wdata"))
        self.agu_icb_cmd_wmask.BindNativeData(self.dut.NativeSignalAddr("agu_icb_cmd_wmask"))
        self.agu_icb_cmd_lock.BindNativeData(self.dut.NativeSignalAddr("agu_icb_cmd_lock"))
        self.agu_icb_cmd_excl.BindNativeData(self.dut.NativeSignalAddr("agu_icb_cmd_excl"))
        self.agu_icb_cmd_size.BindNativeData(self.dut.NativeSignalAddr("agu_icb_cmd_size"))
        self.agu_icb_cmd_back2agu.BindNativeData(self.dut.NativeSignalAddr("agu_icb_cmd_back2agu"))
        self.agu_icb_cmd_usign.BindNativeData(self.dut.NativeSignalAddr("agu_icb_cmd_usign"))
        self.agu_icb_cmd_itag.BindNativeData(self.dut.NativeSignalAddr("agu_icb_cmd_itag"))
        self.agu_icb_rsp_valid.BindNativeData(self.dut.NativeSignalAddr("agu_icb_rsp_valid"))
        self.agu_icb_rsp_ready.BindNativeData(self.dut.NativeSignalAddr("agu_icb_rsp_ready"))
        self.agu_icb_rsp_err.BindNativeData(self.dut.NativeSignalAddr("agu_icb_rsp_err"))
        self.agu_icb_rsp_excl_ok.BindNativeData(self.dut.NativeSignalAddr("agu_icb_rsp_excl_ok"))
        self.agu_icb_rsp_rdata.BindNativeData(self.dut.NativeSignalAddr("agu_icb_rsp_rdata"))
        self.nice_req_valid.BindNativeData(self.dut.NativeSignalAddr("nice_req_valid"))
        self.nice_req_ready.BindNativeData(self.dut.NativeSignalAddr("nice_req_ready"))
        self.nice_req_instr.BindNativeData(self.dut.NativeSignalAddr("nice_req_instr"))
        self.nice_req_rs1.BindNativeData(self.dut.NativeSignalAddr("nice_req_rs1"))
        self.nice_req_rs2.BindNativeData(self.dut.NativeSignalAddr("nice_req_rs2"))
        self.nice_rsp_multicyc_valid.BindNativeData(self.dut.NativeSignalAddr("nice_rsp_multicyc_valid"))
        self.nice_rsp_multicyc_ready.BindNativeData(self.dut.NativeSignalAddr("nice_rsp_multicyc_ready"))
        self.nice_longp_wbck_valid.BindNativeData(self.dut.NativeSignalAddr("nice_longp_wbck_valid"))
        self.nice_longp_wbck_ready.BindNativeData(self.dut.NativeSignalAddr("nice_longp_wbck_ready"))
        self.nice_o_itag.BindNativeData(self.dut.NativeSignalAddr("nice_o_itag"))
        self.i_nice_cmt_off_ilgl.BindNativeData(self.dut.NativeSignalAddr("i_nice_cmt_off_ilgl"))
        self.clk.BindNativeData(self.dut.NativeSignalAddr("clk"))
        self.rst_n.BindNativeData(self.dut.NativeSignalAddr("rst_n"))


        # Add2Port
        self.xport.Add("i_valid", self.i_valid.xdata)
        self.xport.Add("i_ready", self.i_ready.xdata)
        self.xport.Add("i_longpipe", self.i_longpipe.xdata)
        self.xport.Add("nice_xs_off", self.nice_xs_off.xdata)
        self.xport.Add("amo_wait", self.amo_wait.xdata)
        self.xport.Add("oitf_empty", self.oitf_empty.xdata)
        self.xport.Add("i_itag", self.i_itag.xdata)
        self.xport.Add("i_rs1", self.i_rs1.xdata)
        self.xport.Add("i_rs2", self.i_rs2.xdata)
        self.xport.Add("i_imm", self.i_imm.xdata)
        self.xport.Add("i_info", self.i_info.xdata)
        self.xport.Add("i_pc", self.i_pc.xdata)
        self.xport.Add("i_instr", self.i_instr.xdata)
        self.xport.Add("i_pc_vld", self.i_pc_vld.xdata)
        self.xport.Add("i_rdidx", self.i_rdidx.xdata)
        self.xport.Add("i_rdwen", self.i_rdwen.xdata)
        self.xport.Add("i_ilegl", self.i_ilegl.xdata)
        self.xport.Add("i_buserr", self.i_buserr.xdata)
        self.xport.Add("i_misalgn", self.i_misalgn.xdata)
        self.xport.Add("flush_req", self.flush_req.xdata)
        self.xport.Add("flush_pulse", self.flush_pulse.xdata)
        self.xport.Add("cmt_o_valid", self.cmt_o_valid.xdata)
        self.xport.Add("cmt_o_ready", self.cmt_o_ready.xdata)
        self.xport.Add("cmt_o_pc_vld", self.cmt_o_pc_vld.xdata)
        self.xport.Add("cmt_o_pc", self.cmt_o_pc.xdata)
        self.xport.Add("cmt_o_instr", self.cmt_o_instr.xdata)
        self.xport.Add("cmt_o_imm", self.cmt_o_imm.xdata)
        self.xport.Add("cmt_o_rv32", self.cmt_o_rv32.xdata)
        self.xport.Add("cmt_o_bjp", self.cmt_o_bjp.xdata)
        self.xport.Add("cmt_o_mret", self.cmt_o_mret.xdata)
        self.xport.Add("cmt_o_dret", self.cmt_o_dret.xdata)
        self.xport.Add("cmt_o_ecall", self.cmt_o_ecall.xdata)
        self.xport.Add("cmt_o_ebreak", self.cmt_o_ebreak.xdata)
        self.xport.Add("cmt_o_fencei", self.cmt_o_fencei.xdata)
        self.xport.Add("cmt_o_wfi", self.cmt_o_wfi.xdata)
        self.xport.Add("cmt_o_ifu_misalgn", self.cmt_o_ifu_misalgn.xdata)
        self.xport.Add("cmt_o_ifu_buserr", self.cmt_o_ifu_buserr.xdata)
        self.xport.Add("cmt_o_ifu_ilegl", self.cmt_o_ifu_ilegl.xdata)
        self.xport.Add("cmt_o_bjp_prdt", self.cmt_o_bjp_prdt.xdata)
        self.xport.Add("cmt_o_bjp_rslv", self.cmt_o_bjp_rslv.xdata)
        self.xport.Add("cmt_o_misalgn", self.cmt_o_misalgn.xdata)
        self.xport.Add("cmt_o_ld", self.cmt_o_ld.xdata)
        self.xport.Add("cmt_o_stamo", self.cmt_o_stamo.xdata)
        self.xport.Add("cmt_o_buserr", self.cmt_o_buserr.xdata)
        self.xport.Add("cmt_o_badaddr", self.cmt_o_badaddr.xdata)
        self.xport.Add("wbck_o_valid", self.wbck_o_valid.xdata)
        self.xport.Add("wbck_o_ready", self.wbck_o_ready.xdata)
        self.xport.Add("wbck_o_wdat", self.wbck_o_wdat.xdata)
        self.xport.Add("wbck_o_rdidx", self.wbck_o_rdidx.xdata)
        self.xport.Add("mdv_nob2b", self.mdv_nob2b.xdata)
        self.xport.Add("csr_ena", self.csr_ena.xdata)
        self.xport.Add("csr_wr_en", self.csr_wr_en.xdata)
        self.xport.Add("csr_rd_en", self.csr_rd_en.xdata)
        self.xport.Add("csr_idx", self.csr_idx.xdata)
        self.xport.Add("nonflush_cmt_ena", self.nonflush_cmt_ena.xdata)
        self.xport.Add("csr_access_ilgl", self.csr_access_ilgl.xdata)
        self.xport.Add("read_csr_dat", self.read_csr_dat.xdata)
        self.xport.Add("wbck_csr_dat", self.wbck_csr_dat.xdata)
        self.xport.Add("agu_icb_cmd_valid", self.agu_icb_cmd_valid.xdata)
        self.xport.Add("agu_icb_cmd_ready", self.agu_icb_cmd_ready.xdata)
        self.xport.Add("agu_icb_cmd_addr", self.agu_icb_cmd_addr.xdata)
        self.xport.Add("agu_icb_cmd_read", self.agu_icb_cmd_read.xdata)
        self.xport.Add("agu_icb_cmd_wdata", self.agu_icb_cmd_wdata.xdata)
        self.xport.Add("agu_icb_cmd_wmask", self.agu_icb_cmd_wmask.xdata)
        self.xport.Add("agu_icb_cmd_lock", self.agu_icb_cmd_lock.xdata)
        self.xport.Add("agu_icb_cmd_excl", self.agu_icb_cmd_excl.xdata)
        self.xport.Add("agu_icb_cmd_size", self.agu_icb_cmd_size.xdata)
        self.xport.Add("agu_icb_cmd_back2agu", self.agu_icb_cmd_back2agu.xdata)
        self.xport.Add("agu_icb_cmd_usign", self.agu_icb_cmd_usign.xdata)
        self.xport.Add("agu_icb_cmd_itag", self.agu_icb_cmd_itag.xdata)
        self.xport.Add("agu_icb_rsp_valid", self.agu_icb_rsp_valid.xdata)
        self.xport.Add("agu_icb_rsp_ready", self.agu_icb_rsp_ready.xdata)
        self.xport.Add("agu_icb_rsp_err", self.agu_icb_rsp_err.xdata)
        self.xport.Add("agu_icb_rsp_excl_ok", self.agu_icb_rsp_excl_ok.xdata)
        self.xport.Add("agu_icb_rsp_rdata", self.agu_icb_rsp_rdata.xdata)
        self.xport.Add("nice_req_valid", self.nice_req_valid.xdata)
        self.xport.Add("nice_req_ready", self.nice_req_ready.xdata)
        self.xport.Add("nice_req_instr", self.nice_req_instr.xdata)
        self.xport.Add("nice_req_rs1", self.nice_req_rs1.xdata)
        self.xport.Add("nice_req_rs2", self.nice_req_rs2.xdata)
        self.xport.Add("nice_rsp_multicyc_valid", self.nice_rsp_multicyc_valid.xdata)
        self.xport.Add("nice_rsp_multicyc_ready", self.nice_rsp_multicyc_ready.xdata)
        self.xport.Add("nice_longp_wbck_valid", self.nice_longp_wbck_valid.xdata)
        self.xport.Add("nice_longp_wbck_ready", self.nice_longp_wbck_ready.xdata)
        self.xport.Add("nice_o_itag", self.nice_o_itag.xdata)
        self.xport.Add("i_nice_cmt_off_ilgl", self.i_nice_cmt_off_ilgl.xdata)
        self.xport.Add("clk", self.clk.xdata)
        self.xport.Add("rst_n", self.rst_n.xdata)


        # Cascaded ports
        self.agu_icb = self.xport.NewSubPort("agu_icb_")
        self.agu_icb_cmd = self.xport.NewSubPort("agu_icb_cmd_")
        self.agu_icb_rsp = self.xport.NewSubPort("agu_icb_rsp_")
        self.cmt_o = self.xport.NewSubPort("cmt_o_")
        self.cmt_o_ifu = self.xport.NewSubPort("cmt_o_ifu_")
        self.csr = self.xport.NewSubPort("csr_")
        self.flush = self.xport.NewSubPort("flush_")
        self.i = self.xport.NewSubPort("i_")
        self.nice = self.xport.NewSubPort("nice_")
        self.nice_longp_wbck = self.xport.NewSubPort("nice_longp_wbck_")
        self.nice_req = self.xport.NewSubPort("nice_req_")
        self.nice_rsp_multicyc = self.xport.NewSubPort("nice_rsp_multicyc_")
        self.wbck = self.xport.NewSubPort("wbck_")
        self.wbck_o = self.xport.NewSubPort("wbck_o_")


    def __del__(self):
        self.Finish()

    ################################
    #         User APIs            #
    ################################
    def InitClock(self, name: str):
        self.xclock.Add(self.xport[name])

    def Step(self, i:int = 1):
        self.xclock.Step(i)

    def StepRis(self, callback, args=(), kwargs={}):
        self.xclock.StepRis(callback, args, kwargs)

    def StepFal(self, callback, args=(), kwargs={}):
        self.xclock.StepFal(callback, args, kwargs)

    def ResumeWaveformDump(self):
        return self.dut.ResumeWaveformDump()

    def PauseWaveformDump(self):
        return self.dut.PauseWaveformDump()

    def WaveformPaused(self) -> int:
        """ Returns 1 if waveform export is paused """
        return self.dut.WaveformPaused()

    def GetXPort(self):
        return self.xport

    def GetXClock(self):
        return self.xclock

    def SetWaveform(self, filename: str):
        self.dut.SetWaveform(filename)

    def GetWaveFormat(self) -> str:
        """
        Get the waveform extension, or an empty string if disabled.

        Returns:
            str: The extension of waveform file.
        """
        return self.dut.GetWaveFormat()

    def FlushWaveform(self):
        self.dut.FlushWaveform()

    def SetCoverage(self, filename: str):
        self.dut.SetCoverage(filename)

    def GetCovMetrics(self) -> int:
        """
        Get the bitmask for collected coverage metrics. 0 means coverage is disabled

        Returns:
            int: Collected coverage metrics bitmask:
                - Bit 0: line   (Line coverage)
                - Bit 1: cond   (Condition coverage)
                - Bit 2: fsm    (Finite-State Machine coverage)
                - Bit 3: toggle (Toggle coverage)
                - Bit 4: branch (Branch coverage)
                - Bit 5: assert (Assertion coverage)
        """
        return self.dut.GetCovMetrics()
    
    def CheckPoint(self, name: str) -> int:
        self.dut.CheckPoint(name)

    def Restore(self, name: str) -> int:
        self.dut.Restore(name)

    def GetInternalSignal(self, name: str, index=-1, is_array=False, use_vpi=False):
        if name not in self.internal_signals:
            signal = None
            if self.dut.GetXSignalCFGBasePtr() != 0 and not use_vpi:
                xname = "CFG:" + name
                if is_array:
                    assert index < 0, "Index is not supported for array signal"
                    signal = self.xcfg.NewXDataArray(name, xname)
                elif index >= 0:
                    signal = self.xcfg.NewXData(name, index, xname)
                else:
                    signal = self.xcfg.NewXData(name, xname)
            else:
                assert index < 0, "Index is not supported for VPI signal"
                assert not is_array, "Array is not supported for VPI signal"
                signal = xsp.XData.FromVPI(self.dut.GetVPIHandleObj(name),
                                           self.dut.GetVPIFuncPtr("vpi_get"),
                                           self.dut.GetVPIFuncPtr("vpi_get_value"),
                                           self.dut.GetVPIFuncPtr("vpi_put_value"), "VPI:" + name)
                if use_vpi:
                    assert signal is not None, f"Internal signal {name} not found (Check VPI is enabled)"
            if signal is None:
                return None
            if not isinstance(signal, xsp.XData):
                self.internal_signals[name] = [xsp.XPin(s, self.event) for s in signal]
            else:
                self.internal_signals[name] = xsp.XPin(signal, self.event)
        return self.internal_signals[name]

    def GetInternalSignalList(self, prefix="", deep=99, use_vpi=False):
        if self.dut.GetXSignalCFGBasePtr() != 0 and not use_vpi:
            return self.xcfg.GetSignalNames(prefix)
        else:
            return self.dut.VPIInternalSignalList(prefix, deep)

    def VPIInternalSignalList(self, prefix="", deep=99):
        return self.dut.VPIInternalSignalList(prefix, deep)

    def Finish(self):
        self.dut.Finish()

    def RefreshComb(self):
        self.dut.RefreshComb()

    def AtClone(self):
        """Re-init simulator state in child after fork."""
        return self.dut.atClone()

    ################################
    #      End of User APIs        #
    ################################

    def __getitem__(self, key):
        return xsp.XPin(self.port[key], self.event)

    # Async APIs wrapped from XClock
    async def AStep(self,i: int):
        return await self.xclock.AStep(i)

    async def ACondition(self,fc_cheker):
        return await self.xclock.ACondition(fc_cheker)

    def RunStep(self,i: int):
        return self.xclock.RunStep(i)

    def __setattr__(self, name, value):
        assert not isinstance(getattr(self, name, None),
                              (xsp.XPin, xsp.XData)), \
        f"XPin and XData of DUT are read-only, do you mean to set the value of the signal? please use `{name}.value = ` instead."
        return super().__setattr__(name, value)


if __name__=="__main__":
    dut=DUTe203_exu_alu()
    dut.Step(100)
