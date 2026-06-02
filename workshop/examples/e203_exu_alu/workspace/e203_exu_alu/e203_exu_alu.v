 /*                                                                      
 Copyright 2018-2020 Nuclei System Technology, Inc.                
                                                                         
 Licensed under the Apache License, Version 2.0 (the "License");         
 you may not use this file except in compliance with the License.        
 You may obtain a copy of the License at                                 
                                                                         
     http://www.apache.org/licenses/LICENSE-2.0                          
                                                                         
  Unless required by applicable law or agreed to in writing, software    
 distributed under the License is distributed on an "AS IS" BASIS,       
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and     
 limitations under the License.                                          
 */                                                                      
                                                                         
                                                                         
                                                                         
//=====================================================================
//
// Designer   : Bob Hu
//
// Description:
//  The ALU module to implement the compute function unit
//    and the AGU (address generate unit) for LSU is also handled by ALU
//    additionaly, the shared-impelmentation of MUL and DIV instruction 
//    is also shared by ALU in E200
//
// ====================================================================
// `include "e203_defines.v"

 /*                                                                      
 Copyright 2018-2020 Nuclei System Technology, Inc.                
                                                                         
 Licensed under the Apache License, Version 2.0 (the "License");         
 you may not use this file except in compliance with the License.        
 You may obtain a copy of the License at                                 
                                                                         
     http://www.apache.org/licenses/LICENSE-2.0                          
                                                                         
  Unless required by applicable law or agreed to in writing, software    
 distributed under the License is distributed on an "AS IS" BASIS,       
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and     
 limitations under the License.                                          
 */                                                                      
                                                                         
                                                                         
                                                                         
//=====================================================================
//
// Designer   : Bob Hu
//
// Description:
//  The files to include all the macro defines
//
// ====================================================================
// `include "config.v"


 /*                                                                      
 Copyright 2018-2020 Nuclei System Technology, Inc.                
                                                                         
 Licensed under the Apache License, Version 2.0 (the "License");         
 you may not use this file except in compliance with the License.        
 You may obtain a copy of the License at                                 
                                                                         
     http://www.apache.org/licenses/LICENSE-2.0                          
                                                                         
  Unless required by applicable law or agreed to in writing, software    
 distributed under the License is distributed on an "AS IS" BASIS,       
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and     
 limitations under the License.                                          
 */                                                                      
                                                                         
                                                                         
                                                                         

`define E203_CFG_DEBUG_HAS_JTAG
`define E203_CFG_IRQ_NEED_SYNC

//`define E203_CFG_ADDR_SIZE_IS_16
//`define E203_CFG_ADDR_SIZE_IS_24
`define E203_CFG_ADDR_SIZE_IS_32

`ifdef E203_CFG_ADDR_SIZE_IS_16
   `define E203_CFG_ADDR_SIZE   16
`endif
`ifdef E203_CFG_ADDR_SIZE_IS_32
   `define E203_CFG_ADDR_SIZE   32
`endif
`ifdef E203_CFG_ADDR_SIZE_IS_24
   `define E203_CFG_ADDR_SIZE   24
`endif

//`define E203_CFG_SUPPORT_MSCRATCH
`define E203_CFG_SUPPORT_MCYCLE_MINSTRET

`define E203_CFG_REGNUM_IS_32
/////////////////////////////////////////////////////////////////
`define E203_CFG_HAS_ITCM
    // 64KB have address 16bits wide
    //   The depth is 64*1024*8/64=8192
`define E203_CFG_ITCM_ADDR_WIDTH  16

//    // 1024KB have address 20bits wide
//    //   The depth is 1024*1024*8/64=131072
//`define E203_CFG_ITCM_ADDR_WIDTH  20

//    // 2048KB have address 21bits wide
//    //   The depth is 2*1024*1024*8/64=262144
//`define E203_CFG_ITCM_ADDR_WIDTH  21


/////////////////////////////////////////////////////////////////
`define E203_CFG_HAS_DTCM
    // 16KB have address 14 wide
    //   The depth is 16*1024*8/32=4096

    // 256KB have address 18 wide
    //   The depth is 256*1024*8/32=65536

//    // 1MB have address 20bits wide
//    //   The depth is 1024*1024*8/32=262144

/////////////////////////////////////////////////////////////////
//`define E203_CFG_REGFILE_LATCH_BASED
//




//
`define E203_CFG_ITCM_ADDR_BASE   `E203_CFG_ADDR_SIZE'h8000_0000 
`define E203_CFG_DTCM_ADDR_BASE   `E203_CFG_ADDR_SIZE'h9000_0000 

 //   * PPI       : 0x1000 0000 -- 0x1FFF FFFF
`define E203_CFG_PPI_ADDR_BASE  `E203_CFG_ADDR_SIZE'h1000_0000
    `define E203_CFG_PPI_BASE_REGION  `E203_CFG_ADDR_SIZE-1:`E203_CFG_ADDR_SIZE-4

  //  * CLINT     : 0x0200 0000 -- 0x0200 FFFF
  //  * PLIC      : 0x0C00 0000 -- 0x0CFF FFFF
`define E203_CFG_CLINT_ADDR_BASE  `E203_CFG_ADDR_SIZE'h0200_0000
    `define E203_CFG_CLINT_BASE_REGION  `E203_CFG_ADDR_SIZE-1:`E203_CFG_ADDR_SIZE-16
`define E203_CFG_PLIC_ADDR_BASE  `E203_CFG_ADDR_SIZE'h0C00_0000
    `define E203_CFG_PLIC_BASE_REGION  `E203_CFG_ADDR_SIZE-1:`E203_CFG_ADDR_SIZE-8

`define E203_CFG_FIO_ADDR_BASE  `E203_CFG_ADDR_SIZE'hf000_0000 
    `define E203_CFG_FIO_BASE_REGION  `E203_CFG_ADDR_SIZE-1:`E203_CFG_ADDR_SIZE-4





`define E203_CFG_HAS_ECC
`define E203_CFG_HAS_NICE
`define E203_CFG_SUPPORT_SHARE_MULDIV
`define E203_CFG_SUPPORT_AMO
`define E203_CFG_DTCM_ADDR_WIDTH 16


 /*                                                                      
 Copyright 2018-2020 Nuclei System Technology, Inc.                
                                                                         
 Licensed under the Apache License, Version 2.0 (the "License");         
 you may not use this file except in compliance with the License.        
 You may obtain a copy of the License at                                 
                                                                         
     http://www.apache.org/licenses/LICENSE-2.0                          
                                                                         
  Unless required by applicable law or agreed to in writing, software    
 distributed under the License is distributed on an "AS IS" BASIS,       
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and     
 limitations under the License.                                          
 */                                                                      
                                                                         
  /*                                                                      
 Copyright 2018-2020 Nuclei System Technology, Inc.                
                                                                         
 Licensed under the Apache License, Version 2.0 (the "License");         
 you may not use this file except in compliance with the License.        
 You may obtain a copy of the License at                                 
                                                                         
     http://www.apache.org/licenses/LICENSE-2.0                          
                                                                         
  Unless required by applicable law or agreed to in writing, software    
 distributed under the License is distributed on an "AS IS" BASIS,       
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and     
 limitations under the License.                                          
 */                                                                      
                                                                         
                                                                         
                                                                         

`define E203_CFG_DEBUG_HAS_JTAG
`define E203_CFG_IRQ_NEED_SYNC

//`define E203_CFG_ADDR_SIZE_IS_16
//`define E203_CFG_ADDR_SIZE_IS_24
`define E203_CFG_ADDR_SIZE_IS_32

`ifdef E203_CFG_ADDR_SIZE_IS_16
   `define E203_CFG_ADDR_SIZE   16
`endif
`ifdef E203_CFG_ADDR_SIZE_IS_32
   `define E203_CFG_ADDR_SIZE   32
`endif
`ifdef E203_CFG_ADDR_SIZE_IS_24
   `define E203_CFG_ADDR_SIZE   24
`endif

//`define E203_CFG_SUPPORT_MSCRATCH
`define E203_CFG_SUPPORT_MCYCLE_MINSTRET

`define E203_CFG_REGNUM_IS_32
/////////////////////////////////////////////////////////////////
`define E203_CFG_HAS_ITCM
    // 64KB have address 16bits wide
    //   The depth is 64*1024*8/64=8192
`define E203_CFG_ITCM_ADDR_WIDTH  16

//    // 1024KB have address 20bits wide
//    //   The depth is 1024*1024*8/64=131072
//`define E203_CFG_ITCM_ADDR_WIDTH  20

//    // 2048KB have address 21bits wide
//    //   The depth is 2*1024*1024*8/64=262144
//`define E203_CFG_ITCM_ADDR_WIDTH  21


/////////////////////////////////////////////////////////////////
`define E203_CFG_HAS_DTCM
    // 16KB have address 14 wide
    //   The depth is 16*1024*8/32=4096

    // 256KB have address 18 wide
    //   The depth is 256*1024*8/32=65536

//    // 1MB have address 20bits wide
//    //   The depth is 1024*1024*8/32=262144

/////////////////////////////////////////////////////////////////
//`define E203_CFG_REGFILE_LATCH_BASED
//




//
`define E203_CFG_ITCM_ADDR_BASE   `E203_CFG_ADDR_SIZE'h8000_0000 
`define E203_CFG_DTCM_ADDR_BASE   `E203_CFG_ADDR_SIZE'h9000_0000 

 //   * PPI       : 0x1000 0000 -- 0x1FFF FFFF
`define E203_CFG_PPI_ADDR_BASE  `E203_CFG_ADDR_SIZE'h1000_0000
    `define E203_CFG_PPI_BASE_REGION  `E203_CFG_ADDR_SIZE-1:`E203_CFG_ADDR_SIZE-4

  //  * CLINT     : 0x0200 0000 -- 0x0200 FFFF
  //  * PLIC      : 0x0C00 0000 -- 0x0CFF FFFF
`define E203_CFG_CLINT_ADDR_BASE  `E203_CFG_ADDR_SIZE'h0200_0000
    `define E203_CFG_CLINT_BASE_REGION  `E203_CFG_ADDR_SIZE-1:`E203_CFG_ADDR_SIZE-16
`define E203_CFG_PLIC_ADDR_BASE  `E203_CFG_ADDR_SIZE'h0C00_0000
    `define E203_CFG_PLIC_BASE_REGION  `E203_CFG_ADDR_SIZE-1:`E203_CFG_ADDR_SIZE-8

`define E203_CFG_FIO_ADDR_BASE  `E203_CFG_ADDR_SIZE'hf000_0000 
    `define E203_CFG_FIO_BASE_REGION  `E203_CFG_ADDR_SIZE-1:`E203_CFG_ADDR_SIZE-4





`define E203_CFG_HAS_ECC
`define E203_CFG_HAS_NICE
`define E203_CFG_SUPPORT_SHARE_MULDIV
`define E203_CFG_SUPPORT_AMO
`define E203_CFG_DTCM_ADDR_WIDTH 16
                                                                        
                                                                         

`define E203_CFG_DEBUG_HAS_JTAG
`define E203_CFG_IRQ_NEED_SYNC

//`define E203_CFG_ADDR_SIZE_IS_16
//`define E203_CFG_ADDR_SIZE_IS_24
`define E203_CFG_ADDR_SIZE_IS_32

`ifdef E203_CFG_ADDR_SIZE_IS_16
   `define E203_CFG_ADDR_SIZE   16
`endif
`ifdef E203_CFG_ADDR_SIZE_IS_32
   `define E203_CFG_ADDR_SIZE   32
`endif
`ifdef E203_CFG_ADDR_SIZE_IS_24
   `define E203_CFG_ADDR_SIZE   24
`endif

//`define E203_CFG_SUPPORT_MSCRATCH
`define E203_CFG_SUPPORT_MCYCLE_MINSTRET

`define E203_CFG_REGNUM_IS_32
/////////////////////////////////////////////////////////////////
`define E203_CFG_HAS_ITCM
    // 64KB have address 16bits wide
    //   The depth is 64*1024*8/64=8192
`define E203_CFG_ITCM_ADDR_WIDTH  16

//    // 1024KB have address 20bits wide
//    //   The depth is 1024*1024*8/64=131072
//`define E203_CFG_ITCM_ADDR_WIDTH  20

//    // 2048KB have address 21bits wide
//    //   The depth is 2*1024*1024*8/64=262144
//`define E203_CFG_ITCM_ADDR_WIDTH  21


/////////////////////////////////////////////////////////////////
`define E203_CFG_HAS_DTCM
    // 16KB have address 14 wide
    //   The depth is 16*1024*8/32=4096

    // 256KB have address 18 wide
    //   The depth is 256*1024*8/32=65536

//    // 1MB have address 20bits wide
//    //   The depth is 1024*1024*8/32=262144

/////////////////////////////////////////////////////////////////
//`define E203_CFG_REGFILE_LATCH_BASED
//




//
`define E203_CFG_ITCM_ADDR_BASE   `E203_CFG_ADDR_SIZE'h8000_0000 
`define E203_CFG_DTCM_ADDR_BASE   `E203_CFG_ADDR_SIZE'h9000_0000 

 //   * PPI       : 0x1000 0000 -- 0x1FFF FFFF
`define E203_CFG_PPI_ADDR_BASE  `E203_CFG_ADDR_SIZE'h1000_0000
    `define E203_CFG_PPI_BASE_REGION  `E203_CFG_ADDR_SIZE-1:`E203_CFG_ADDR_SIZE-4

  //  * CLINT     : 0x0200 0000 -- 0x0200 FFFF
  //  * PLIC      : 0x0C00 0000 -- 0x0CFF FFFF
`define E203_CFG_CLINT_ADDR_BASE  `E203_CFG_ADDR_SIZE'h0200_0000
    `define E203_CFG_CLINT_BASE_REGION  `E203_CFG_ADDR_SIZE-1:`E203_CFG_ADDR_SIZE-16
`define E203_CFG_PLIC_ADDR_BASE  `E203_CFG_ADDR_SIZE'h0C00_0000
    `define E203_CFG_PLIC_BASE_REGION  `E203_CFG_ADDR_SIZE-1:`E203_CFG_ADDR_SIZE-8

`define E203_CFG_FIO_ADDR_BASE  `E203_CFG_ADDR_SIZE'hf000_0000 
    `define E203_CFG_FIO_BASE_REGION  `E203_CFG_ADDR_SIZE-1:`E203_CFG_ADDR_SIZE-4





`define E203_CFG_HAS_ECC
`define E203_CFG_HAS_NICE
`define E203_CFG_SUPPORT_SHARE_MULDIV
`define E203_CFG_SUPPORT_AMO
`define E203_CFG_DTCM_ADDR_WIDTH 16


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////// ISA relevant macro
//
`ifdef E203_CFG_ADDR_SIZE_IS_16
   `define E203_ADDR_SIZE_IS_16
   `define E203_PC_SIZE_IS_16
   `define E203_ADDR_SIZE   16
   `define E203_PC_SIZE     16
`endif
`ifdef E203_CFG_ADDR_SIZE_IS_32
   `define E203_ADDR_SIZE_IS_32
   `define E203_PC_SIZE_IS_32
   `define E203_ADDR_SIZE   32
   `define E203_PC_SIZE     32
`endif
`ifdef E203_CFG_ADDR_SIZE_IS_24
   `define E203_ADDR_SIZE_IS_24
   `define E203_PC_SIZE_IS_24
   `define E203_ADDR_SIZE   24
   `define E203_PC_SIZE     24
`endif


//`ifdef E203_CFG_SUPPORT_MSCRATCH
   `define E203_SUPPORT_MSCRATCH 
//`endif
//`ifdef E203_CFG_SUPPORT_MTVEC
   `define E203_SUPPORT_MTVEC
//`endif
`ifdef E203_CFG_SUPPORT_MCYCLE_MINSTRET
   `define E203_SUPPORT_MCYCLE_MINSTRET 
`endif


`define E203_CFG_XLEN_IS_32
`ifdef E203_CFG_XLEN_IS_32//{
  `define E203_XLEN_IS_32 
  `define E203_XLEN          32
  `define E203_XLEN_MW       4
`endif//}

`define E203_INSTR_SIZE    32

//
`define E203_RFIDX_WIDTH   5
`ifdef E203_CFG_REGNUM_IS_32//{
  `define E203_RFREG_NUM_IS_32 
  `define E203_RFREG_NUM     32
`endif//}
`ifdef E203_CFG_REGNUM_IS_16//{
  `define E203_RFREG_NUM_IS_16 
  `define E203_RFREG_NUM     16
`endif//}
`ifdef E203_CFG_REGNUM_IS_8//{
  `define E203_RFREG_NUM_IS_8 
  `define E203_RFREG_NUM     8
`endif//}
`ifdef E203_CFG_REGNUM_IS_4//{
  `define E203_RFREG_NUM_IS_4 
  `define E203_RFREG_NUM     4
`endif//}

`ifdef E203_CFG_REGFILE_LATCH_BASED//{
    `ifndef FPGA_SOURCE//{ Only If there is not on FPGA
        `define E203_REGFILE_LATCH_BASED 
    `endif//}
`endif//}

`define E203_PPI_ADDR_BASE    `E203_CFG_PPI_ADDR_BASE  
`define E203_PPI_BASE_REGION  `E203_CFG_PPI_BASE_REGION
`define E203_CLINT_ADDR_BASE    `E203_CFG_CLINT_ADDR_BASE  
`define E203_CLINT_BASE_REGION  `E203_CFG_CLINT_BASE_REGION
`define E203_PLIC_ADDR_BASE    `E203_CFG_PLIC_ADDR_BASE  
`define E203_PLIC_BASE_REGION  `E203_CFG_PLIC_BASE_REGION
`define E203_FIO_ADDR_BASE    `E203_CFG_FIO_ADDR_BASE  
`define E203_FIO_BASE_REGION  `E203_CFG_FIO_BASE_REGION
                              
`define E203_DTCM_ADDR_BASE   `E203_CFG_DTCM_ADDR_BASE 
`define E203_ITCM_ADDR_BASE   `E203_CFG_ITCM_ADDR_BASE 
                             



/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////// Interface relevant macro
//
`define E203_HART_NUM   1
`define E203_HART_ID_W  1
`define E203_LIRQ_NUM   1
`define E203_EVT_NUM    1

`define E203_CFG_DEBUG_HAS_DM
`ifdef E203_CFG_DEBUG_HAS_DM//{
   `define E203_DEBUG_HAS_DM 
`endif//}

`ifdef E203_CFG_IRQ_NEED_SYNC//{
   `define E203_IRQ_NEED_SYNC 
`endif//}

`ifdef E203_CFG_DEBUG_HAS_JTAG//{
   `define E203_DEBUG_HAS_JTAG 
`endif//}

`define E203_HAS_MEM_ITF
`define E203_CFG_SYSMEM_DATA_WIDTH_IS_32
`ifdef E203_CFG_SYSMEM_DATA_WIDTH_IS_32
    `define E203_SYSMEM_DATA_WIDTH_IS_32
    `define E203_SYSMEM_DATA_WIDTH   32
`endif
`ifdef E203_CFG_SYSMEM_DATA_WIDTH_IS_64
    `define E203_SYSMEM_DATA_WIDTH_IS_64
    `define E203_SYSMEM_DATA_WIDTH   64
`endif

//`ifdef E203_CFG_HAS_FIO//{
//  `define E203_HAS_FIO 
//`endif//}

`define E203_HAS_PPI 
`define E203_HAS_PLIC 
`define E203_HAS_CLINT 
`define E203_HAS_FIO 

`ifdef E203_CFG_HAS_ECC//{
`endif//}
`ifdef E203_CFG_HAS_NICE//{
   `define E203_HAS_NICE
   //`define E203_HAS_CSR_NICE 
`endif//}

`ifdef E203_CFG_HAS_LOCKSTEP//{
`endif//}

/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////// ITCM relevant macro
//
`ifdef E203_CFG_HAS_ITCM//{
  `define E203_HAS_ITCM 1
  `define E203_ITCM_ADDR_WIDTH  `E203_CFG_ITCM_ADDR_WIDTH
  // The ITCM size is 2^addr_width bytes, and ITCM is 64bits wide (8 bytes)
  //  so the DP is 2^addr_wdith/8
  //  so the AW is addr_wdith - 3
  `define E203_ITCM_RAM_DP      (1<<(`E203_CFG_ITCM_ADDR_WIDTH-3)) 
  `define E203_ITCM_RAM_AW          (`E203_CFG_ITCM_ADDR_WIDTH-3) 
  `define E203_ITCM_BASE_REGION  `E203_ADDR_SIZE-1:`E203_ITCM_ADDR_WIDTH
  
  `define E203_CFG_ITCM_DATA_WIDTH_IS_64
  `ifdef E203_CFG_ITCM_DATA_WIDTH_IS_64
    `define E203_ITCM_DATA_WIDTH_IS_64
    `define E203_ITCM_DATA_WIDTH  64
    `define E203_ITCM_WMSK_WIDTH  8
  
    `define E203_ITCM_RAM_ECC_DW  8
    `define E203_ITCM_RAM_ECC_MW  1
  `endif
  `ifndef E203_HAS_ECC //{
    `define E203_ITCM_RAM_DW      `E203_ITCM_DATA_WIDTH
    `define E203_ITCM_RAM_MW      `E203_ITCM_WMSK_WIDTH
    `define E203_ITCM_OUTS_NUM 1 // If no-ECC, ITCM is 1 cycle latency then only allow 1 oustanding for external agent
  `endif//}

  `define E203_HAS_ITCM_EXTITF
`endif//}

/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////// DTCM relevant macro
//
`ifdef E203_CFG_HAS_DTCM//{
  `define E203_HAS_DTCM 1
  `define E203_DTCM_ADDR_WIDTH  `E203_CFG_DTCM_ADDR_WIDTH
  // The DTCM size is 2^addr_width bytes, and DTCM is 32bits wide (4 bytes)
  //  so the DP is 2^addr_wdith/4
  //  so the AW is addr_wdith - 2
  `define E203_DTCM_RAM_DP      (1<<(`E203_CFG_DTCM_ADDR_WIDTH-2)) 
  `define E203_DTCM_RAM_AW          (`E203_CFG_DTCM_ADDR_WIDTH-2) 
  `define E203_DTCM_BASE_REGION `E203_ADDR_SIZE-1:`E203_DTCM_ADDR_WIDTH
  
    `define E203_DTCM_DATA_WIDTH  32
    `define E203_DTCM_WMSK_WIDTH  4
  
    `define E203_DTCM_RAM_ECC_DW  7
    `define E203_DTCM_RAM_ECC_MW  1

  `ifndef E203_HAS_ECC //{
    `define E203_DTCM_RAM_DW      `E203_DTCM_DATA_WIDTH
    `define E203_DTCM_RAM_MW      `E203_DTCM_WMSK_WIDTH
    `define E203_DTCM_OUTS_NUM 1 // If no-ECC, DTCM is 1 cycle latency then only allow 1 oustanding for external agent
  `endif//}


  `define E203_HAS_DTCM_EXTITF
`endif//}








/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////// MULDIV relevant macro
//
  `ifdef E203_CFG_SUPPORT_SHARE_MULDIV//{
`define E203_SUPPORT_MULDIV
`define E203_SUPPORT_SHARE_MULDIV
  `endif//}

  `ifdef E203_CFG_SUPPORT_INDEP_MULDIV//{
`define E203_SUPPORT_MULDIV
`define E203_SUPPORT_INDEP_MUL_1CYC
  `endif//}


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////// ALU relevant macro
//
`define E203_MULDIV_ADDER_WIDTH 35

  `ifdef E203_CFG_SUPPORT_SHARE_MULDIV
`define E203_ALU_ADDER_WIDTH `E203_MULDIV_ADDER_WIDTH
  `endif
  `ifndef E203_CFG_SUPPORT_SHARE_MULDIV
`define E203_ALU_ADDER_WIDTH (`E203_XLEN+1)
  `endif


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////// MAS relevant macro
//
`define E203_ASYNC_FF_LEVELS   2
//`ifdef E203_CFG_OITF_DEPTH_IS_1
//  `define E203_OITF_DEPTH     1
//  `define E203_OITF_DEPTH_IS_1
//`endif
 // To cut down the loop between ALU write-back valid --> oitf_ret_ena --> oitf_ready ---> dispatch_ready --- > alu_i_valid
 //   we exclude the ret_ena from the ready signal
 //   so in order to back2back dispatch, we need at least 2 entries in OITF
`define E203_CFG_OITF_DEPTH_IS_2
`ifdef E203_CFG_SUPPORT_INDEP_MULDIV//{
  `define E203_CFG_OITF_DEPTH_IS_4
`endif//}
`ifdef E203_CFG_HAS_FPU//{
  `define E203_CFG_OITF_DEPTH_IS_4
`endif//}

`ifdef E203_CFG_OITF_DEPTH_IS_4
  `define E203_OITF_DEPTH     4
  `define E203_OITF_DEPTH_IS_4
  `define E203_ITAG_WIDTH  2
`elsif E203_CFG_OITF_DEPTH_IS_2
  `define E203_OITF_DEPTH     2
  `define E203_OITF_DEPTH_IS_2
  `define E203_ITAG_WIDTH  1
`endif

`ifdef E203_CFG_HAS_FPU
  `ifdef E203_CFG_FPU_DOUBLE
    `define E203_FPU_DOUBLE     
    `define E203_FLEN 64
  `else
    `define E203_FLEN 32
  `endif
`else
    `define E203_FLEN 32
`endif


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////// Decode relevant macro
//
  `define E203_DECINFO_GRP_WIDTH    3
  `define E203_DECINFO_GRP_ALU      `E203_DECINFO_GRP_WIDTH'd0
  `define E203_DECINFO_GRP_AGU      `E203_DECINFO_GRP_WIDTH'd1
  `define E203_DECINFO_GRP_BJP      `E203_DECINFO_GRP_WIDTH'd2
  `define E203_DECINFO_GRP_CSR      `E203_DECINFO_GRP_WIDTH'd3
  `define E203_DECINFO_GRP_MULDIV   `E203_DECINFO_GRP_WIDTH'd4
  `define E203_DECINFO_GRP_NICE      `E203_DECINFO_GRP_WIDTH'd5
  `define E203_DECINFO_GRP_FPU      `E203_DECINFO_GRP_WIDTH'd6

  `define E203_DECINFO_GRP_FPU_WIDTH    2
  `define E203_DECINFO_GRP_FPU_FLSU     `E203_DECINFO_GRP_FPU_WIDTH'd0
  `define E203_DECINFO_GRP_FPU_FMAC     `E203_DECINFO_GRP_FPU_WIDTH'd1
  `define E203_DECINFO_GRP_FPU_FDIV     `E203_DECINFO_GRP_FPU_WIDTH'd2
  `define E203_DECINFO_GRP_FPU_FMIS     `E203_DECINFO_GRP_FPU_WIDTH'd3

      `define E203_DECINFO_GRP_LSB  0
      `define E203_DECINFO_GRP_MSB  (`E203_DECINFO_GRP_LSB+`E203_DECINFO_GRP_WIDTH-1)
  `define E203_DECINFO_GRP          `E203_DECINFO_GRP_MSB:`E203_DECINFO_GRP_LSB
      `define E203_DECINFO_RV32_LSB  (`E203_DECINFO_GRP_MSB+1)
      `define E203_DECINFO_RV32_MSB  (`E203_DECINFO_RV32_LSB+1-1)
  `define E203_DECINFO_RV32          `E203_DECINFO_RV32_MSB:`E203_DECINFO_RV32_LSB

  `define E203_DECINFO_SUBDECINFO_LSB    (`E203_DECINFO_RV32_MSB+1)

  // ALU group
      `define E203_DECINFO_ALU_ADD_LSB    `E203_DECINFO_SUBDECINFO_LSB
      `define E203_DECINFO_ALU_ADD_MSB    (`E203_DECINFO_ALU_ADD_LSB+1-1)
  `define E203_DECINFO_ALU_ADD    `E203_DECINFO_ALU_ADD_MSB :`E203_DECINFO_ALU_ADD_LSB 
      `define E203_DECINFO_ALU_SUB_LSB    (`E203_DECINFO_ALU_ADD_MSB+1)
      `define E203_DECINFO_ALU_SUB_MSB    (`E203_DECINFO_ALU_SUB_LSB+1-1)
  `define E203_DECINFO_ALU_SUB    `E203_DECINFO_ALU_SUB_MSB :`E203_DECINFO_ALU_SUB_LSB 
      `define E203_DECINFO_ALU_XOR_LSB    (`E203_DECINFO_ALU_SUB_MSB+1)
      `define E203_DECINFO_ALU_XOR_MSB    (`E203_DECINFO_ALU_XOR_LSB+1-1)
  `define E203_DECINFO_ALU_XOR    `E203_DECINFO_ALU_XOR_MSB :`E203_DECINFO_ALU_XOR_LSB 
      `define E203_DECINFO_ALU_SLL_LSB    (`E203_DECINFO_ALU_XOR_MSB+1)
      `define E203_DECINFO_ALU_SLL_MSB    (`E203_DECINFO_ALU_SLL_LSB+1-1)
  `define E203_DECINFO_ALU_SLL    `E203_DECINFO_ALU_SLL_MSB :`E203_DECINFO_ALU_SLL_LSB 
      `define E203_DECINFO_ALU_SRL_LSB    (`E203_DECINFO_ALU_SLL_MSB+1)
      `define E203_DECINFO_ALU_SRL_MSB    (`E203_DECINFO_ALU_SRL_LSB+1-1)
  `define E203_DECINFO_ALU_SRL    `E203_DECINFO_ALU_SRL_MSB :`E203_DECINFO_ALU_SRL_LSB 
      `define E203_DECINFO_ALU_SRA_LSB    (`E203_DECINFO_ALU_SRL_MSB+1)
      `define E203_DECINFO_ALU_SRA_MSB    (`E203_DECINFO_ALU_SRA_LSB+1-1)
  `define E203_DECINFO_ALU_SRA    `E203_DECINFO_ALU_SRA_MSB :`E203_DECINFO_ALU_SRA_LSB 
      `define E203_DECINFO_ALU_OR_LSB    (`E203_DECINFO_ALU_SRA_MSB+1)
      `define E203_DECINFO_ALU_OR_MSB    (`E203_DECINFO_ALU_OR_LSB+1-1)
  `define E203_DECINFO_ALU_OR     `E203_DECINFO_ALU_OR_MSB  :`E203_DECINFO_ALU_OR_LSB  
      `define E203_DECINFO_ALU_AND_LSB    (`E203_DECINFO_ALU_OR_MSB+1)
      `define E203_DECINFO_ALU_AND_MSB    (`E203_DECINFO_ALU_AND_LSB+1-1)
  `define E203_DECINFO_ALU_AND    `E203_DECINFO_ALU_AND_MSB :`E203_DECINFO_ALU_AND_LSB 
      `define E203_DECINFO_ALU_SLT_LSB    (`E203_DECINFO_ALU_AND_MSB+1)
      `define E203_DECINFO_ALU_SLT_MSB    (`E203_DECINFO_ALU_SLT_LSB+1-1)
  `define E203_DECINFO_ALU_SLT    `E203_DECINFO_ALU_SLT_MSB :`E203_DECINFO_ALU_SLT_LSB 
      `define E203_DECINFO_ALU_SLTU_LSB    (`E203_DECINFO_ALU_SLT_MSB+1)
      `define E203_DECINFO_ALU_SLTU_MSB    (`E203_DECINFO_ALU_SLTU_LSB+1-1)
  `define E203_DECINFO_ALU_SLTU   `E203_DECINFO_ALU_SLTU_MSB:`E203_DECINFO_ALU_SLTU_LSB
      `define E203_DECINFO_ALU_LUI_LSB    (`E203_DECINFO_ALU_SLTU_MSB+1)
      `define E203_DECINFO_ALU_LUI_MSB    (`E203_DECINFO_ALU_LUI_LSB+1-1)
  `define E203_DECINFO_ALU_LUI    `E203_DECINFO_ALU_LUI_MSB :`E203_DECINFO_ALU_LUI_LSB 
      `define E203_DECINFO_ALU_OP2IMM_LSB    (`E203_DECINFO_ALU_LUI_MSB+1)
      `define E203_DECINFO_ALU_OP2IMM_MSB    (`E203_DECINFO_ALU_OP2IMM_LSB+1-1)
  `define E203_DECINFO_ALU_OP2IMM    `E203_DECINFO_ALU_OP2IMM_MSB :`E203_DECINFO_ALU_OP2IMM_LSB 
      `define E203_DECINFO_ALU_OP1PC_LSB    (`E203_DECINFO_ALU_OP2IMM_MSB+1)
      `define E203_DECINFO_ALU_OP1PC_MSB    (`E203_DECINFO_ALU_OP1PC_LSB+1-1)
  `define E203_DECINFO_ALU_OP1PC    `E203_DECINFO_ALU_OP1PC_MSB :`E203_DECINFO_ALU_OP1PC_LSB 
      `define E203_DECINFO_ALU_NOP_LSB    (`E203_DECINFO_ALU_OP1PC_MSB+1)
      `define E203_DECINFO_ALU_NOP_MSB    (`E203_DECINFO_ALU_NOP_LSB+1-1)
  `define E203_DECINFO_ALU_NOP    `E203_DECINFO_ALU_NOP_MSB :`E203_DECINFO_ALU_NOP_LSB 
      `define E203_DECINFO_ALU_ECAL_LSB  (`E203_DECINFO_ALU_NOP_MSB+1)
      `define E203_DECINFO_ALU_ECAL_MSB  (`E203_DECINFO_ALU_ECAL_LSB+1-1)
  `define E203_DECINFO_ALU_ECAL   `E203_DECINFO_ALU_ECAL_MSB:`E203_DECINFO_ALU_ECAL_LSB 
      `define E203_DECINFO_ALU_EBRK_LSB  (`E203_DECINFO_ALU_ECAL_MSB+1)
      `define E203_DECINFO_ALU_EBRK_MSB  (`E203_DECINFO_ALU_EBRK_LSB+1-1)
  `define E203_DECINFO_ALU_EBRK   `E203_DECINFO_ALU_EBRK_MSB:`E203_DECINFO_ALU_EBRK_LSB 
      `define E203_DECINFO_ALU_WFI_LSB  (`E203_DECINFO_ALU_EBRK_MSB+1)
      `define E203_DECINFO_ALU_WFI_MSB  (`E203_DECINFO_ALU_WFI_LSB+1-1)
  `define E203_DECINFO_ALU_WFI   `E203_DECINFO_ALU_WFI_MSB:`E203_DECINFO_ALU_WFI_LSB 

  `define E203_DECINFO_ALU_WIDTH    (`E203_DECINFO_ALU_WFI_MSB+1)

   //AGU group
    `define E203_DECINFO_AGU_LOAD_LSB      `E203_DECINFO_SUBDECINFO_LSB
    `define E203_DECINFO_AGU_LOAD_MSB      (`E203_DECINFO_AGU_LOAD_LSB+1-1)   
  `define E203_DECINFO_AGU_LOAD      `E203_DECINFO_AGU_LOAD_MSB   :`E203_DECINFO_AGU_LOAD_LSB   
    `define E203_DECINFO_AGU_STORE_LSB      (`E203_DECINFO_AGU_LOAD_MSB+1)
    `define E203_DECINFO_AGU_STORE_MSB      (`E203_DECINFO_AGU_STORE_LSB+1-1)   
  `define E203_DECINFO_AGU_STORE     `E203_DECINFO_AGU_STORE_MSB  :`E203_DECINFO_AGU_STORE_LSB  
    `define E203_DECINFO_AGU_SIZE_LSB      (`E203_DECINFO_AGU_STORE_MSB+1)
    `define E203_DECINFO_AGU_SIZE_MSB      (`E203_DECINFO_AGU_SIZE_LSB+2-1)   
  `define E203_DECINFO_AGU_SIZE      `E203_DECINFO_AGU_SIZE_MSB   :`E203_DECINFO_AGU_SIZE_LSB   
    `define E203_DECINFO_AGU_USIGN_LSB      (`E203_DECINFO_AGU_SIZE_MSB+1)
    `define E203_DECINFO_AGU_USIGN_MSB      (`E203_DECINFO_AGU_USIGN_LSB+1-1)   
  `define E203_DECINFO_AGU_USIGN     `E203_DECINFO_AGU_USIGN_MSB  :`E203_DECINFO_AGU_USIGN_LSB  
    `define E203_DECINFO_AGU_EXCL_LSB      (`E203_DECINFO_AGU_USIGN_MSB+1)
    `define E203_DECINFO_AGU_EXCL_MSB      (`E203_DECINFO_AGU_EXCL_LSB+1-1)   
  `define E203_DECINFO_AGU_EXCL      `E203_DECINFO_AGU_EXCL_MSB   :`E203_DECINFO_AGU_EXCL_LSB   
    `define E203_DECINFO_AGU_AMO_LSB      (`E203_DECINFO_AGU_EXCL_MSB+1)
    `define E203_DECINFO_AGU_AMO_MSB      (`E203_DECINFO_AGU_AMO_LSB+1-1)   
  `define E203_DECINFO_AGU_AMO       `E203_DECINFO_AGU_AMO_MSB    :`E203_DECINFO_AGU_AMO_LSB    
    `define E203_DECINFO_AGU_AMOSWAP_LSB      (`E203_DECINFO_AGU_AMO_MSB+1)
    `define E203_DECINFO_AGU_AMOSWAP_MSB      (`E203_DECINFO_AGU_AMOSWAP_LSB+1-1)   
  `define E203_DECINFO_AGU_AMOSWAP   `E203_DECINFO_AGU_AMOSWAP_MSB:`E203_DECINFO_AGU_AMOSWAP_LSB
    `define E203_DECINFO_AGU_AMOADD_LSB      (`E203_DECINFO_AGU_AMOSWAP_MSB+1)
    `define E203_DECINFO_AGU_AMOADD_MSB      (`E203_DECINFO_AGU_AMOADD_LSB+1-1)   
  `define E203_DECINFO_AGU_AMOADD    `E203_DECINFO_AGU_AMOADD_MSB :`E203_DECINFO_AGU_AMOADD_LSB 
    `define E203_DECINFO_AGU_AMOAND_LSB      (`E203_DECINFO_AGU_AMOADD_MSB+1)
    `define E203_DECINFO_AGU_AMOAND_MSB      (`E203_DECINFO_AGU_AMOAND_LSB+1-1)   
  `define E203_DECINFO_AGU_AMOAND    `E203_DECINFO_AGU_AMOAND_MSB :`E203_DECINFO_AGU_AMOAND_LSB 
    `define E203_DECINFO_AGU_AMOOR_LSB      (`E203_DECINFO_AGU_AMOAND_MSB+1)
    `define E203_DECINFO_AGU_AMOOR_MSB      (`E203_DECINFO_AGU_AMOOR_LSB+1-1)   
  `define E203_DECINFO_AGU_AMOOR     `E203_DECINFO_AGU_AMOOR_MSB  :`E203_DECINFO_AGU_AMOOR_LSB  
    `define E203_DECINFO_AGU_AMOXOR_LSB      (`E203_DECINFO_AGU_AMOOR_MSB+1)
    `define E203_DECINFO_AGU_AMOXOR_MSB      (`E203_DECINFO_AGU_AMOXOR_LSB+1-1)   
  `define E203_DECINFO_AGU_AMOXOR    `E203_DECINFO_AGU_AMOXOR_MSB :`E203_DECINFO_AGU_AMOXOR_LSB 
    `define E203_DECINFO_AGU_AMOMAX_LSB      (`E203_DECINFO_AGU_AMOXOR_MSB+1)
    `define E203_DECINFO_AGU_AMOMAX_MSB      (`E203_DECINFO_AGU_AMOMAX_LSB+1-1)   
  `define E203_DECINFO_AGU_AMOMAX    `E203_DECINFO_AGU_AMOMAX_MSB :`E203_DECINFO_AGU_AMOMAX_LSB 
    `define E203_DECINFO_AGU_AMOMIN_LSB      (`E203_DECINFO_AGU_AMOMAX_MSB+1)
    `define E203_DECINFO_AGU_AMOMIN_MSB      (`E203_DECINFO_AGU_AMOMIN_LSB+1-1)   
  `define E203_DECINFO_AGU_AMOMIN    `E203_DECINFO_AGU_AMOMIN_MSB :`E203_DECINFO_AGU_AMOMIN_LSB 
    `define E203_DECINFO_AGU_AMOMAXU_LSB      (`E203_DECINFO_AGU_AMOMIN_MSB+1)
    `define E203_DECINFO_AGU_AMOMAXU_MSB      (`E203_DECINFO_AGU_AMOMAXU_LSB+1-1)   
  `define E203_DECINFO_AGU_AMOMAXU   `E203_DECINFO_AGU_AMOMAXU_MSB:`E203_DECINFO_AGU_AMOMAXU_LSB
    `define E203_DECINFO_AGU_AMOMINU_LSB      (`E203_DECINFO_AGU_AMOMAXU_MSB+1)
    `define E203_DECINFO_AGU_AMOMINU_MSB      (`E203_DECINFO_AGU_AMOMINU_LSB+1-1)   
  `define E203_DECINFO_AGU_AMOMINU   `E203_DECINFO_AGU_AMOMINU_MSB:`E203_DECINFO_AGU_AMOMINU_LSB
    `define E203_DECINFO_AGU_OP2IMM_LSB      (`E203_DECINFO_AGU_AMOMINU_MSB+1)
    `define E203_DECINFO_AGU_OP2IMM_MSB      (`E203_DECINFO_AGU_OP2IMM_LSB+1-1)   
  `define E203_DECINFO_AGU_OP2IMM   `E203_DECINFO_AGU_OP2IMM_MSB:`E203_DECINFO_AGU_OP2IMM_LSB

  `define E203_DECINFO_AGU_WIDTH    (`E203_DECINFO_AGU_OP2IMM_MSB+1)

  // Bxx group
      `define E203_DECINFO_BJP_JUMP_LSB `E203_DECINFO_SUBDECINFO_LSB
      `define E203_DECINFO_BJP_JUMP_MSB (`E203_DECINFO_BJP_JUMP_LSB+1-1)
  `define E203_DECINFO_BJP_JUMP   `E203_DECINFO_BJP_JUMP_MSB :`E203_DECINFO_BJP_JUMP_LSB 
      `define E203_DECINFO_BJP_BPRDT_LSB (`E203_DECINFO_BJP_JUMP_MSB+1)
      `define E203_DECINFO_BJP_BPRDT_MSB (`E203_DECINFO_BJP_BPRDT_LSB+1-1)
  `define E203_DECINFO_BJP_BPRDT  `E203_DECINFO_BJP_BPRDT_MSB:`E203_DECINFO_BJP_BPRDT_LSB
      `define E203_DECINFO_BJP_BEQ_LSB (`E203_DECINFO_BJP_BPRDT_MSB+1)
      `define E203_DECINFO_BJP_BEQ_MSB (`E203_DECINFO_BJP_BEQ_LSB+1-1)
  `define E203_DECINFO_BJP_BEQ    `E203_DECINFO_BJP_BEQ_MSB  :`E203_DECINFO_BJP_BEQ_LSB  
      `define E203_DECINFO_BJP_BNE_LSB (`E203_DECINFO_BJP_BEQ_MSB+1)
      `define E203_DECINFO_BJP_BNE_MSB (`E203_DECINFO_BJP_BNE_LSB+1-1)
  `define E203_DECINFO_BJP_BNE    `E203_DECINFO_BJP_BNE_MSB  :`E203_DECINFO_BJP_BNE_LSB  
      `define E203_DECINFO_BJP_BLT_LSB (`E203_DECINFO_BJP_BNE_MSB+1)
      `define E203_DECINFO_BJP_BLT_MSB (`E203_DECINFO_BJP_BLT_LSB+1-1)
  `define E203_DECINFO_BJP_BLT    `E203_DECINFO_BJP_BLT_MSB  :`E203_DECINFO_BJP_BLT_LSB  
      `define E203_DECINFO_BJP_BGT_LSB (`E203_DECINFO_BJP_BLT_MSB+1)
      `define E203_DECINFO_BJP_BGT_MSB (`E203_DECINFO_BJP_BGT_LSB+1-1)
  `define E203_DECINFO_BJP_BGT    `E203_DECINFO_BJP_BGT_MSB  :`E203_DECINFO_BJP_BGT_LSB  
      `define E203_DECINFO_BJP_BLTU_LSB (`E203_DECINFO_BJP_BGT_MSB+1)
      `define E203_DECINFO_BJP_BLTU_MSB (`E203_DECINFO_BJP_BLTU_LSB+1-1)
  `define E203_DECINFO_BJP_BLTU   `E203_DECINFO_BJP_BLTU_MSB :`E203_DECINFO_BJP_BLTU_LSB 
      `define E203_DECINFO_BJP_BGTU_LSB (`E203_DECINFO_BJP_BLTU_MSB+1)
      `define E203_DECINFO_BJP_BGTU_MSB (`E203_DECINFO_BJP_BGTU_LSB+1-1)
  `define E203_DECINFO_BJP_BGTU   `E203_DECINFO_BJP_BGTU_MSB :`E203_DECINFO_BJP_BGTU_LSB 
      `define E203_DECINFO_BJP_BXX_LSB  (`E203_DECINFO_BJP_BGTU_MSB+1)
      `define E203_DECINFO_BJP_BXX_MSB  (`E203_DECINFO_BJP_BXX_LSB+1-1)
  `define E203_DECINFO_BJP_BXX    `E203_DECINFO_BJP_BXX_MSB :`E203_DECINFO_BJP_BXX_LSB
      `define E203_DECINFO_BJP_MRET_LSB  (`E203_DECINFO_BJP_BXX_MSB+1)
      `define E203_DECINFO_BJP_MRET_MSB  (`E203_DECINFO_BJP_MRET_LSB+1-1)
  `define E203_DECINFO_BJP_MRET    `E203_DECINFO_BJP_MRET_MSB :`E203_DECINFO_BJP_MRET_LSB
      `define E203_DECINFO_BJP_DRET_LSB  (`E203_DECINFO_BJP_MRET_MSB+1)
      `define E203_DECINFO_BJP_DRET_MSB  (`E203_DECINFO_BJP_DRET_LSB+1-1)
  `define E203_DECINFO_BJP_DRET    `E203_DECINFO_BJP_DRET_MSB :`E203_DECINFO_BJP_DRET_LSB
      `define E203_DECINFO_BJP_FENCE_LSB  (`E203_DECINFO_BJP_DRET_MSB+1)
      `define E203_DECINFO_BJP_FENCE_MSB  (`E203_DECINFO_BJP_FENCE_LSB+1-1)
  `define E203_DECINFO_BJP_FENCE    `E203_DECINFO_BJP_FENCE_MSB :`E203_DECINFO_BJP_FENCE_LSB
      `define E203_DECINFO_BJP_FENCEI_LSB  (`E203_DECINFO_BJP_FENCE_MSB+1)
      `define E203_DECINFO_BJP_FENCEI_MSB  (`E203_DECINFO_BJP_FENCEI_LSB+1-1)
  `define E203_DECINFO_BJP_FENCEI    `E203_DECINFO_BJP_FENCEI_MSB :`E203_DECINFO_BJP_FENCEI_LSB

`define E203_DECINFO_BJP_WIDTH  (`E203_DECINFO_BJP_FENCEI_MSB+1)


  // CSR group
      `define E203_DECINFO_CSR_CSRRW_LSB   `E203_DECINFO_SUBDECINFO_LSB
      `define E203_DECINFO_CSR_CSRRW_MSB   (`E203_DECINFO_CSR_CSRRW_LSB+1-1)    
  `define E203_DECINFO_CSR_CSRRW   `E203_DECINFO_CSR_CSRRW_MSB:`E203_DECINFO_CSR_CSRRW_LSB    
      `define E203_DECINFO_CSR_CSRRS_LSB   (`E203_DECINFO_CSR_CSRRW_MSB+1)
      `define E203_DECINFO_CSR_CSRRS_MSB   (`E203_DECINFO_CSR_CSRRS_LSB+1-1)    
  `define E203_DECINFO_CSR_CSRRS   `E203_DECINFO_CSR_CSRRS_MSB:`E203_DECINFO_CSR_CSRRS_LSB 
      `define E203_DECINFO_CSR_CSRRC_LSB   (`E203_DECINFO_CSR_CSRRS_MSB+1)
      `define E203_DECINFO_CSR_CSRRC_MSB   (`E203_DECINFO_CSR_CSRRC_LSB+1-1)    
  `define E203_DECINFO_CSR_CSRRC   `E203_DECINFO_CSR_CSRRC_MSB:`E203_DECINFO_CSR_CSRRC_LSB 
      `define E203_DECINFO_CSR_RS1IMM_LSB  (`E203_DECINFO_CSR_CSRRC_MSB+1)
      `define E203_DECINFO_CSR_RS1IMM_MSB   (`E203_DECINFO_CSR_RS1IMM_LSB+1-1)    
  `define E203_DECINFO_CSR_RS1IMM  `E203_DECINFO_CSR_RS1IMM_MSB:`E203_DECINFO_CSR_RS1IMM_LSB
      `define E203_DECINFO_CSR_ZIMMM_LSB   (`E203_DECINFO_CSR_RS1IMM_MSB+1)
      `define E203_DECINFO_CSR_ZIMMM_MSB   (`E203_DECINFO_CSR_ZIMMM_LSB+5-1)    
  `define E203_DECINFO_CSR_ZIMMM   `E203_DECINFO_CSR_ZIMMM_MSB:`E203_DECINFO_CSR_ZIMMM_LSB 
      `define E203_DECINFO_CSR_RS1IS0_LSB  (`E203_DECINFO_CSR_ZIMMM_MSB+1)
      `define E203_DECINFO_CSR_RS1IS0_MSB  (`E203_DECINFO_CSR_RS1IS0_LSB+1-1)    
  `define E203_DECINFO_CSR_RS1IS0  `E203_DECINFO_CSR_RS1IS0_MSB:`E203_DECINFO_CSR_RS1IS0_LSB
      `define E203_DECINFO_CSR_CSRIDX_LSB  (`E203_DECINFO_CSR_RS1IS0_MSB+1)
      `define E203_DECINFO_CSR_CSRIDX_MSB  (`E203_DECINFO_CSR_CSRIDX_LSB+12-1)    
  `define E203_DECINFO_CSR_CSRIDX  `E203_DECINFO_CSR_CSRIDX_MSB:`E203_DECINFO_CSR_CSRIDX_LSB

`define E203_DECINFO_CSR_WIDTH  (`E203_DECINFO_CSR_CSRIDX_MSB+1)

  // NICE group
      `define E203_DECINFO_NICE_INSTR_LSB   `E203_DECINFO_SUBDECINFO_LSB
      `define E203_DECINFO_NICE_INSTR_MSB   (`E203_DECINFO_NICE_INSTR_LSB+27-1)    
  `define E203_DECINFO_NICE_INSTR   `E203_DECINFO_NICE_INSTR_MSB:`E203_DECINFO_NICE_INSTR_LSB    

`define E203_DECINFO_NICE_WIDTH  (`E203_DECINFO_NICE_INSTR_MSB+1)

      `define E203_DECINFO_FPU_GRP_LSB   `E203_DECINFO_SUBDECINFO_LSB
      `define E203_DECINFO_FPU_GRP_MSB   (`E203_DECINFO_FPU_GRP_LSB+`E203_DECINFO_GRP_FPU_WIDTH-1)    
  `define E203_DECINFO_FPU_GRP   `E203_DECINFO_FPU_GRP_MSB:`E203_DECINFO_FPU_GRP_LSB    
      `define E203_DECINFO_FPU_RM_LSB   (`E203_DECINFO_FPU_GRP_MSB+1)
      `define E203_DECINFO_FPU_RM_MSB   (`E203_DECINFO_FPU_RM_LSB+3-1)    
  `define E203_DECINFO_FPU_RM   `E203_DECINFO_FPU_RM_MSB:`E203_DECINFO_FPU_RM_LSB    
      `define E203_DECINFO_FPU_USERM_LSB   (`E203_DECINFO_FPU_RM_MSB+1)
      `define E203_DECINFO_FPU_USERM_MSB   (`E203_DECINFO_FPU_USERM_LSB+1-1)    
  `define E203_DECINFO_FPU_USERM   `E203_DECINFO_FPU_USERM_MSB:`E203_DECINFO_FPU_USERM_LSB    

  // FLSU group
      `define E203_DECINFO_FLSU_LOAD_LSB   (`E203_DECINFO_FPU_USERM_MSB+1)
      `define E203_DECINFO_FLSU_LOAD_MSB   (`E203_DECINFO_FLSU_LOAD_LSB+1-1)    
  `define E203_DECINFO_FLSU_LOAD   `E203_DECINFO_FLSU_LOAD_MSB:`E203_DECINFO_FLSU_LOAD_LSB 
      `define E203_DECINFO_FLSU_STORE_LSB   (`E203_DECINFO_FLSU_LOAD_MSB+1)
      `define E203_DECINFO_FLSU_STORE_MSB   (`E203_DECINFO_FLSU_STORE_LSB+1-1)    
  `define E203_DECINFO_FLSU_STORE   `E203_DECINFO_FLSU_STORE_MSB:`E203_DECINFO_FLSU_STORE_LSB 
      `define E203_DECINFO_FLSU_DOUBLE_LSB  (`E203_DECINFO_FLSU_STORE_MSB+1)
      `define E203_DECINFO_FLSU_DOUBLE_MSB   (`E203_DECINFO_FLSU_DOUBLE_LSB+1-1)    
  `define E203_DECINFO_FLSU_DOUBLE  `E203_DECINFO_FLSU_DOUBLE_MSB:`E203_DECINFO_FLSU_DOUBLE_LSB
      `define E203_DECINFO_FLSU_OP2IMM_LSB   (`E203_DECINFO_FLSU_DOUBLE_MSB+1)
      `define E203_DECINFO_FLSU_OP2IMM_MSB   (`E203_DECINFO_FLSU_OP2IMM_LSB+1-1)    
  `define E203_DECINFO_FLSU_OP2IMM   `E203_DECINFO_FLSU_OP2IMM_MSB:`E203_DECINFO_FLSU_OP2IMM_LSB 

`define E203_DECINFO_FLSU_WIDTH  (`E203_DECINFO_FLSU_OP2IMM_MSB+1)

  // FDIV group
      `define E203_DECINFO_FDIV_DIV_LSB   (`E203_DECINFO_FPU_USERM_MSB+1)
      `define E203_DECINFO_FDIV_DIV_MSB   (`E203_DECINFO_FDIV_DIV_LSB+1-1)    
  `define E203_DECINFO_FDIV_DIV   `E203_DECINFO_FDIV_DIV_MSB:`E203_DECINFO_FDIV_DIV_LSB 
      `define E203_DECINFO_FDIV_SQRT_LSB   (`E203_DECINFO_FDIV_DIV_MSB+1)
      `define E203_DECINFO_FDIV_SQRT_MSB   (`E203_DECINFO_FDIV_SQRT_LSB+1-1)    
  `define E203_DECINFO_FDIV_SQRT   `E203_DECINFO_FDIV_SQRT_MSB:`E203_DECINFO_FDIV_SQRT_LSB 
      `define E203_DECINFO_FDIV_DOUBLE_LSB  (`E203_DECINFO_FDIV_SQRT_MSB+1)
      `define E203_DECINFO_FDIV_DOUBLE_MSB   (`E203_DECINFO_FDIV_DOUBLE_LSB+1-1)    
  `define E203_DECINFO_FDIV_DOUBLE  `E203_DECINFO_FDIV_DOUBLE_MSB:`E203_DECINFO_FDIV_DOUBLE_LSB

`define E203_DECINFO_FDIV_WIDTH  (`E203_DECINFO_FDIV_DOUBLE_MSB+1)

  // FMIS group
      `define E203_DECINFO_FMIS_FSGNJ_LSB   (`E203_DECINFO_FPU_USERM_MSB+1)
      `define E203_DECINFO_FMIS_FSGNJ_MSB   (`E203_DECINFO_FMIS_FSGNJ_LSB+1-1)    
  `define E203_DECINFO_FMIS_FSGNJ   `E203_DECINFO_FMIS_FSGNJ_MSB:`E203_DECINFO_FMIS_FSGNJ_LSB 
      `define E203_DECINFO_FMIS_FSGNJN_LSB   (`E203_DECINFO_FMIS_FSGNJ_MSB+1)
      `define E203_DECINFO_FMIS_FSGNJN_MSB   (`E203_DECINFO_FMIS_FSGNJN_LSB+1-1)    
  `define E203_DECINFO_FMIS_FSGNJN   `E203_DECINFO_FMIS_FSGNJN_MSB:`E203_DECINFO_FMIS_FSGNJN_LSB 
      `define E203_DECINFO_FMIS_FSGNJX_LSB  (`E203_DECINFO_FMIS_FSGNJN_MSB+1)
      `define E203_DECINFO_FMIS_FSGNJX_MSB   (`E203_DECINFO_FMIS_FSGNJX_LSB+1-1)    
  `define E203_DECINFO_FMIS_FSGNJX  `E203_DECINFO_FMIS_FSGNJX_MSB:`E203_DECINFO_FMIS_FSGNJX_LSB
      `define E203_DECINFO_FMIS_FMVXW_LSB  (`E203_DECINFO_FMIS_FSGNJX_MSB+1)
      `define E203_DECINFO_FMIS_FMVXW_MSB   (`E203_DECINFO_FMIS_FMVXW_LSB+1-1)    
  `define E203_DECINFO_FMIS_FMVXW  `E203_DECINFO_FMIS_FMVXW_MSB:`E203_DECINFO_FMIS_FMVXW_LSB
      `define E203_DECINFO_FMIS_FCLASS_LSB  (`E203_DECINFO_FMIS_FMVXW_MSB+1)
      `define E203_DECINFO_FMIS_FCLASS_MSB   (`E203_DECINFO_FMIS_FCLASS_LSB+1-1)    
  `define E203_DECINFO_FMIS_FCLASS  `E203_DECINFO_FMIS_FCLASS_MSB:`E203_DECINFO_FMIS_FCLASS_LSB
      `define E203_DECINFO_FMIS_FMVWX_LSB  (`E203_DECINFO_FMIS_FCLASS_MSB+1)
      `define E203_DECINFO_FMIS_FMVWX_MSB   (`E203_DECINFO_FMIS_FMVWX_LSB+1-1)    
  `define E203_DECINFO_FMIS_FMVWX  `E203_DECINFO_FMIS_FMVWX_MSB:`E203_DECINFO_FMIS_FMVWX_LSB
      `define E203_DECINFO_FMIS_CVTWS_LSB  (`E203_DECINFO_FMIS_FMVWX_MSB+1)
      `define E203_DECINFO_FMIS_CVTWS_MSB   (`E203_DECINFO_FMIS_CVTWS_LSB+1-1)    
  `define E203_DECINFO_FMIS_CVTWS  `E203_DECINFO_FMIS_CVTWS_MSB:`E203_DECINFO_FMIS_CVTWS_LSB
      `define E203_DECINFO_FMIS_CVTWUS_LSB  (`E203_DECINFO_FMIS_CVTWS_MSB+1)
      `define E203_DECINFO_FMIS_CVTWUS_MSB   (`E203_DECINFO_FMIS_CVTWUS_LSB+1-1)    
  `define E203_DECINFO_FMIS_CVTWUS  `E203_DECINFO_FMIS_CVTWUS_MSB:`E203_DECINFO_FMIS_CVTWUS_LSB
      `define E203_DECINFO_FMIS_CVTSW_LSB  (`E203_DECINFO_FMIS_CVTWUS_MSB+1)
      `define E203_DECINFO_FMIS_CVTSW_MSB   (`E203_DECINFO_FMIS_CVTSW_LSB+1-1)    
  `define E203_DECINFO_FMIS_CVTSW  `E203_DECINFO_FMIS_CVTSW_MSB:`E203_DECINFO_FMIS_CVTSW_LSB
      `define E203_DECINFO_FMIS_CVTSWU_LSB  (`E203_DECINFO_FMIS_CVTSW_MSB+1)
      `define E203_DECINFO_FMIS_CVTSWU_MSB   (`E203_DECINFO_FMIS_CVTSWU_LSB+1-1)    
  `define E203_DECINFO_FMIS_CVTSWU  `E203_DECINFO_FMIS_CVTSWU_MSB:`E203_DECINFO_FMIS_CVTSWU_LSB
      `define E203_DECINFO_FMIS_CVTSD_LSB  (`E203_DECINFO_FMIS_CVTSWU_MSB+1)
      `define E203_DECINFO_FMIS_CVTSD_MSB   (`E203_DECINFO_FMIS_CVTSD_LSB+1-1)    
  `define E203_DECINFO_FMIS_CVTSD  `E203_DECINFO_FMIS_CVTSD_MSB:`E203_DECINFO_FMIS_CVTSD_LSB
      `define E203_DECINFO_FMIS_CVTDS_LSB  (`E203_DECINFO_FMIS_CVTSD_MSB+1)
      `define E203_DECINFO_FMIS_CVTDS_MSB   (`E203_DECINFO_FMIS_CVTDS_LSB+1-1)    
  `define E203_DECINFO_FMIS_CVTDS  `E203_DECINFO_FMIS_CVTDS_MSB:`E203_DECINFO_FMIS_CVTDS_LSB
      `define E203_DECINFO_FMIS_CVTWD_LSB  (`E203_DECINFO_FMIS_CVTDS_MSB+1)
      `define E203_DECINFO_FMIS_CVTWD_MSB   (`E203_DECINFO_FMIS_CVTWD_LSB+1-1)    
  `define E203_DECINFO_FMIS_CVTWD  `E203_DECINFO_FMIS_CVTWD_MSB:`E203_DECINFO_FMIS_CVTWD_LSB
      `define E203_DECINFO_FMIS_CVTWUD_LSB  (`E203_DECINFO_FMIS_CVTWD_MSB+1)
      `define E203_DECINFO_FMIS_CVTWUD_MSB   (`E203_DECINFO_FMIS_CVTWUD_LSB+1-1)    
  `define E203_DECINFO_FMIS_CVTWUD  `E203_DECINFO_FMIS_CVTWUD_MSB:`E203_DECINFO_FMIS_CVTWUD_LSB
      `define E203_DECINFO_FMIS_CVTDW_LSB  (`E203_DECINFO_FMIS_CVTWUD_MSB+1)
      `define E203_DECINFO_FMIS_CVTDW_MSB   (`E203_DECINFO_FMIS_CVTDW_LSB+1-1)    
  `define E203_DECINFO_FMIS_CVTDW  `E203_DECINFO_FMIS_CVTDW_MSB:`E203_DECINFO_FMIS_CVTDW_LSB
      `define E203_DECINFO_FMIS_CVTDWU_LSB  (`E203_DECINFO_FMIS_CVTDW_MSB+1)
      `define E203_DECINFO_FMIS_CVTDWU_MSB   (`E203_DECINFO_FMIS_CVTDWU_LSB+1-1)    
  `define E203_DECINFO_FMIS_CVTDWU  `E203_DECINFO_FMIS_CVTDWU_MSB:`E203_DECINFO_FMIS_CVTDWU_LSB
      `define E203_DECINFO_FMIS_DOUBLE_LSB  (`E203_DECINFO_FMIS_CVTDWU_MSB+1)
      `define E203_DECINFO_FMIS_DOUBLE_MSB   (`E203_DECINFO_FMIS_DOUBLE_LSB+1-1)    
  `define E203_DECINFO_FMIS_DOUBLE  `E203_DECINFO_FMIS_DOUBLE_MSB:`E203_DECINFO_FMIS_DOUBLE_LSB

`define E203_DECINFO_FMIS_WIDTH  (`E203_DECINFO_FMIS_DOUBLE_MSB+1)



  // FMAC group
      `define E203_DECINFO_FMAC_FMADD_LSB   (`E203_DECINFO_FPU_USERM_MSB+1)
      `define E203_DECINFO_FMAC_FMADD_MSB   (`E203_DECINFO_FMAC_FMADD_LSB+1-1)    
  `define E203_DECINFO_FMAC_FMADD   `E203_DECINFO_FMAC_FMADD_MSB:`E203_DECINFO_FMAC_FMADD_LSB 
      `define E203_DECINFO_FMAC_FMSUB_LSB   (`E203_DECINFO_FMAC_FMADD_MSB+1)
      `define E203_DECINFO_FMAC_FMSUB_MSB   (`E203_DECINFO_FMAC_FMSUB_LSB+1-1)    
  `define E203_DECINFO_FMAC_FMSUB   `E203_DECINFO_FMAC_FMSUB_MSB:`E203_DECINFO_FMAC_FMSUB_LSB 
      `define E203_DECINFO_FMAC_FNMSUB_LSB  (`E203_DECINFO_FMAC_FMSUB_MSB+1)
      `define E203_DECINFO_FMAC_FNMSUB_MSB   (`E203_DECINFO_FMAC_FNMSUB_LSB+1-1)    
  `define E203_DECINFO_FMAC_FNMSUB  `E203_DECINFO_FMAC_FNMSUB_MSB:`E203_DECINFO_FMAC_FNMSUB_LSB
      `define E203_DECINFO_FMAC_FNMADD_LSB  (`E203_DECINFO_FMAC_FNMSUB_MSB+1)
      `define E203_DECINFO_FMAC_FNMADD_MSB   (`E203_DECINFO_FMAC_FNMADD_LSB+1-1)    
  `define E203_DECINFO_FMAC_FNMADD  `E203_DECINFO_FMAC_FNMADD_MSB:`E203_DECINFO_FMAC_FNMADD_LSB
      `define E203_DECINFO_FMAC_FADD_LSB  (`E203_DECINFO_FMAC_FNMADD_MSB+1)
      `define E203_DECINFO_FMAC_FADD_MSB   (`E203_DECINFO_FMAC_FADD_LSB+1-1)    
  `define E203_DECINFO_FMAC_FADD  `E203_DECINFO_FMAC_FADD_MSB:`E203_DECINFO_FMAC_FADD_LSB
      `define E203_DECINFO_FMAC_FSUB_LSB  (`E203_DECINFO_FMAC_FADD_MSB+1)
      `define E203_DECINFO_FMAC_FSUB_MSB   (`E203_DECINFO_FMAC_FSUB_LSB+1-1)    
  `define E203_DECINFO_FMAC_FSUB  `E203_DECINFO_FMAC_FSUB_MSB:`E203_DECINFO_FMAC_FSUB_LSB
      `define E203_DECINFO_FMAC_FMUL_LSB  (`E203_DECINFO_FMAC_FSUB_MSB+1)
      `define E203_DECINFO_FMAC_FMUL_MSB   (`E203_DECINFO_FMAC_FMUL_LSB+1-1)    
  `define E203_DECINFO_FMAC_FMUL  `E203_DECINFO_FMAC_FMUL_MSB:`E203_DECINFO_FMAC_FMUL_LSB
      `define E203_DECINFO_FMAC_FMIN_LSB  (`E203_DECINFO_FMAC_FMUL_MSB+1)
      `define E203_DECINFO_FMAC_FMIN_MSB   (`E203_DECINFO_FMAC_FMIN_LSB+1-1)    
  `define E203_DECINFO_FMAC_FMIN  `E203_DECINFO_FMAC_FMIN_MSB:`E203_DECINFO_FMAC_FMIN_LSB
      `define E203_DECINFO_FMAC_FMAX_LSB  (`E203_DECINFO_FMAC_FMIN_MSB+1)
      `define E203_DECINFO_FMAC_FMAX_MSB   (`E203_DECINFO_FMAC_FMAX_LSB+1-1)    
  `define E203_DECINFO_FMAC_FMAX  `E203_DECINFO_FMAC_FMAX_MSB:`E203_DECINFO_FMAC_FMAX_LSB
      `define E203_DECINFO_FMAC_FEQ_LSB  (`E203_DECINFO_FMAC_FMAX_MSB+1)
      `define E203_DECINFO_FMAC_FEQ_MSB   (`E203_DECINFO_FMAC_FEQ_LSB+1-1)    
  `define E203_DECINFO_FMAC_FEQ  `E203_DECINFO_FMAC_FEQ_MSB:`E203_DECINFO_FMAC_FEQ_LSB
      `define E203_DECINFO_FMAC_FLT_LSB  (`E203_DECINFO_FMAC_FEQ_MSB+1)
      `define E203_DECINFO_FMAC_FLT_MSB   (`E203_DECINFO_FMAC_FLT_LSB+1-1)    
  `define E203_DECINFO_FMAC_FLT  `E203_DECINFO_FMAC_FLT_MSB:`E203_DECINFO_FMAC_FLT_LSB
      `define E203_DECINFO_FMAC_FLE_LSB  (`E203_DECINFO_FMAC_FLT_MSB+1)
      `define E203_DECINFO_FMAC_FLE_MSB   (`E203_DECINFO_FMAC_FLE_LSB+1-1)    
  `define E203_DECINFO_FMAC_FLE  `E203_DECINFO_FMAC_FLE_MSB:`E203_DECINFO_FMAC_FLE_LSB
      `define E203_DECINFO_FMAC_DOUBLE_LSB  (`E203_DECINFO_FMAC_FLE_MSB+1)
      `define E203_DECINFO_FMAC_DOUBLE_MSB   (`E203_DECINFO_FMAC_DOUBLE_LSB+1-1)    
  `define E203_DECINFO_FMAC_DOUBLE  `E203_DECINFO_FMAC_DOUBLE_MSB:`E203_DECINFO_FMAC_DOUBLE_LSB

`define E203_DECINFO_FMAC_WIDTH  (`E203_DECINFO_FMAC_DOUBLE_MSB+1)

  // MULDIV group
      `define E203_DECINFO_MULDIV_MUL_LSB   `E203_DECINFO_SUBDECINFO_LSB
      `define E203_DECINFO_MULDIV_MUL_MSB   (`E203_DECINFO_MULDIV_MUL_LSB+1-1)    
  `define E203_DECINFO_MULDIV_MUL   `E203_DECINFO_MULDIV_MUL_MSB:`E203_DECINFO_MULDIV_MUL_LSB    
      `define E203_DECINFO_MULDIV_MULH_LSB   (`E203_DECINFO_MULDIV_MUL_MSB+1)
      `define E203_DECINFO_MULDIV_MULH_MSB   (`E203_DECINFO_MULDIV_MULH_LSB+1-1)    
  `define E203_DECINFO_MULDIV_MULH   `E203_DECINFO_MULDIV_MULH_MSB:`E203_DECINFO_MULDIV_MULH_LSB 
      `define E203_DECINFO_MULDIV_MULHSU_LSB   (`E203_DECINFO_MULDIV_MULH_MSB+1)
      `define E203_DECINFO_MULDIV_MULHSU_MSB   (`E203_DECINFO_MULDIV_MULHSU_LSB+1-1)    
  `define E203_DECINFO_MULDIV_MULHSU   `E203_DECINFO_MULDIV_MULHSU_MSB:`E203_DECINFO_MULDIV_MULHSU_LSB 
      `define E203_DECINFO_MULDIV_MULHU_LSB  (`E203_DECINFO_MULDIV_MULHSU_MSB+1)
      `define E203_DECINFO_MULDIV_MULHU_MSB   (`E203_DECINFO_MULDIV_MULHU_LSB+1-1)    
  `define E203_DECINFO_MULDIV_MULHU  `E203_DECINFO_MULDIV_MULHU_MSB:`E203_DECINFO_MULDIV_MULHU_LSB
      `define E203_DECINFO_MULDIV_DIV_LSB   (`E203_DECINFO_MULDIV_MULHU_MSB+1)
      `define E203_DECINFO_MULDIV_DIV_MSB   (`E203_DECINFO_MULDIV_DIV_LSB+1-1)    
  `define E203_DECINFO_MULDIV_DIV   `E203_DECINFO_MULDIV_DIV_MSB:`E203_DECINFO_MULDIV_DIV_LSB 
      `define E203_DECINFO_MULDIV_DIVU_LSB  (`E203_DECINFO_MULDIV_DIV_MSB+1)
      `define E203_DECINFO_MULDIV_DIVU_MSB  (`E203_DECINFO_MULDIV_DIVU_LSB+1-1)    
  `define E203_DECINFO_MULDIV_DIVU  `E203_DECINFO_MULDIV_DIVU_MSB:`E203_DECINFO_MULDIV_DIVU_LSB
      `define E203_DECINFO_MULDIV_REM_LSB   (`E203_DECINFO_MULDIV_DIVU_MSB+1)
      `define E203_DECINFO_MULDIV_REM_MSB   (`E203_DECINFO_MULDIV_REM_LSB+1-1)    
  `define E203_DECINFO_MULDIV_REM   `E203_DECINFO_MULDIV_REM_MSB:`E203_DECINFO_MULDIV_REM_LSB    
      `define E203_DECINFO_MULDIV_REMU_LSB   (`E203_DECINFO_MULDIV_REM_MSB+1)
      `define E203_DECINFO_MULDIV_REMU_MSB   (`E203_DECINFO_MULDIV_REMU_LSB+1-1)    
  `define E203_DECINFO_MULDIV_REMU   `E203_DECINFO_MULDIV_REMU_MSB:`E203_DECINFO_MULDIV_REMU_LSB 
      `define E203_DECINFO_MULDIV_B2B_LSB   (`E203_DECINFO_MULDIV_REMU_MSB+1)
      `define E203_DECINFO_MULDIV_B2B_MSB   (`E203_DECINFO_MULDIV_B2B_LSB+1-1)    
  `define E203_DECINFO_MULDIV_B2B   `E203_DECINFO_MULDIV_B2B_MSB:`E203_DECINFO_MULDIV_B2B_LSB 

`define E203_DECINFO_MULDIV_WIDTH  (`E203_DECINFO_MULDIV_B2B_MSB+1)

// Choose the longest group as the final DEC info width
`define E203_DECINFO_WIDTH  (`E203_DECINFO_NICE_WIDTH+1)






/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////// LSU relevant macro
//
    // Currently is OITF_DEPTH, In the future, if the ROCC
    // support multiple oustanding
    // we can enlarge this number to 2 or 4
    //
    //
  //`ifdef E203_CFG_HAS_NICE //{
  //  //`define E203_LSU_OUTS_NUM 2 
  //`else//}{
    //`define E203_LSU_OUTS_NUM `E203_OITF_DEPTH 
    //`ifdef E203_OITF_DEPTH_IS_1
    //  `define E203_LSU_OUTS_NUM_IS_1
    //`endif
    // Although we defined the OITF depth as 2, but for LSU, we still only allow 1 oustanding for LSU
    `define E203_LSU_OUTS_NUM    1
    `define E203_LSU_OUTS_NUM_IS_1
  //`endif//}

  `ifdef E203_CFG_SUPPORT_AMO//{
     `define E203_SUPPORT_AMO
  `endif//}
  // No unalign
  //`ifdef E203_CFG_SUPPORT_UNALGNLDST//{
  //   `define E203_SUPPORT_UNALGNLDST
  //`endif//}
 
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////// BIU relevant macro
//
    // Currently is 1, In the future, if the DCache
    // support hit-under-miss (out of order return), then
    // we can enlarge this number to 2 or 4
    //
  `ifdef E203_HAS_DCACHE //{
    //`define E203_BIU_OUTS_NUM 2 
  `else//}{
    `define E203_BIU_OUTS_NUM `E203_LSU_OUTS_NUM 
    `ifdef E203_LSU_OUTS_NUM_IS_1
      `define E203_BIU_OUTS_NUM_IS_1
      `define E203_BIU_OUTS_CNT_W  1
    `endif
  `endif//}



  // To cut the potential comb loop and critical path between LSU and IFU
  //   and also core and external system, we always cut the ready by BIU Stage
  //   You may argue: Always cut ready may potentially hurt throughput when the DP is just 1
  //   but it is actually a Pseudo proposition because:
  //     * If the BIU oustanding is just 1 in low end core, then we set DP as 1, and there is no 
  //         throughput issue becuase just only 1 oustanding. Even for the PPI or FIO port ideally
  //         if it is 0 cycle response and throughput can be bck-to-back ideally, but we just
  //         sacrafy sacrifice this performance lost, since this is a low end core
  //     * If the BIU oustanding is more than 1 in middle or high end core, then we
  //         set DP as 2 as ping-pong buffer, and then throughput is back-to-back
  //
  `define E203_BIU_CMD_CUT_READY 1
  `define E203_BIU_RSP_CUT_READY 1

  // If oustanding is just 1, then we just need 1 entry
  // If oustanding is more than 1, then we need ping-pong buffer to enhance throughput
  //   You may argue: why not allow 0 depth to save areas, well this is to cut the potential
  //   comb loop and critical path between LSU and IFU and external bus
    `ifdef E203_BIU_OUTS_NUM_IS_1
  `define E203_BIU_CMD_DP 1
  `define E203_BIU_RSP_DP_RAW 1
    `else
  `define E203_BIU_CMD_DP 2
  `define E203_BIU_RSP_DP_RAW 2
    `endif
  //  // We allow such configurability to cut timing path of not to save areas
  `define E203_TIMING_BOOST
  `ifdef E203_TIMING_BOOST
    `define E203_BIU_RSP_DP        `E203_BIU_RSP_DP_RAW       
  `else
    `define E203_BIU_RSP_DP        0
  `endif



module e203_exu_alu(

  //////////////////////////////////////////////////////////////
  // The operands and decode info from dispatch
  input  i_valid, 
  output i_ready, 

  output i_longpipe, // Indicate this instruction is 
                     //   issued as a long pipe instruction

  `ifdef E203_HAS_CSR_NICE//{
  output         nice_csr_valid,
  input          nice_csr_ready,
  output  [31:0] nice_csr_addr,
  output         nice_csr_wr,
  output  [31:0] nice_csr_wdata,
  input   [31:0] nice_csr_rdata,
  `endif//}

  `ifdef E203_HAS_NICE//{
  input  nice_xs_off,
  `endif//}

  output amo_wait,
  input  oitf_empty,

                     
  input  [0:0] i_itag,
  input  [31:0] i_rs1,
  input  [31:0] i_rs2,
  input  [31:0] i_imm,
  input  [31:0]  i_info,  
  input  [31:0] i_pc,
  input  [31:0] i_instr,
  input  i_pc_vld,
  input  [4:0] i_rdidx,
  input  i_rdwen,
  input  i_ilegl,
  input  i_buserr,
  input  i_misalgn,

  input  flush_req,
  input  flush_pulse,

  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The Commit Interface
  output cmt_o_valid, // Handshake valid
  input  cmt_o_ready, // Handshake ready
  output cmt_o_pc_vld,  
  output [31:0] cmt_o_pc,  
  output [31:0] cmt_o_instr,  
  output [31:0]    cmt_o_imm,// The resolved ture/false
    //   The Branch and Jump Commit
  output cmt_o_rv32,// The predicted ture/false  
  output cmt_o_bjp,
  output cmt_o_mret,
  output cmt_o_dret,
  output cmt_o_ecall,
  output cmt_o_ebreak,
  output cmt_o_fencei,
  output cmt_o_wfi,
  output cmt_o_ifu_misalgn,
  output cmt_o_ifu_buserr,
  output cmt_o_ifu_ilegl,
  output cmt_o_bjp_prdt,// The predicted ture/false  
  output cmt_o_bjp_rslv,// The resolved ture/false
    //   The AGU Exception 
  output cmt_o_misalgn, // The misalign exception generated
  output cmt_o_ld,
  output cmt_o_stamo,
  output cmt_o_buserr , // The bus-error exception generated
  output [31:0] cmt_o_badaddr,


  //////////////////////////////////////////////////////////////
  // The ALU Write-Back Interface
  output wbck_o_valid, // Handshake valid
  input  wbck_o_ready, // Handshake ready
  output [31:0] wbck_o_wdat,
  output [4:0] wbck_o_rdidx,
  
  input  mdv_nob2b,

  //////////////////////////////////////////////////////////////
  // The CSR Interface
  output csr_ena,
  output csr_wr_en,
  output csr_rd_en,
  output [12-1:0] csr_idx,

  input  nonflush_cmt_ena,
  input  csr_access_ilgl,
  input  [31:0] read_csr_dat,
  output [31:0] wbck_csr_dat,

  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The AGU ICB Interface to LSU-ctrl
  //    * Bus cmd channel
  output                         agu_icb_cmd_valid, // Handshake valid
  input                          agu_icb_cmd_ready, // Handshake ready
  output [31:0]   agu_icb_cmd_addr, // Bus transaction start addr 
  output                         agu_icb_cmd_read,   // Read or write
  output [31:0]        agu_icb_cmd_wdata, 
  output [3:0]      agu_icb_cmd_wmask, 
  output                         agu_icb_cmd_lock,
  output                         agu_icb_cmd_excl,
  output [1:0]                   agu_icb_cmd_size,
  output                         agu_icb_cmd_back2agu, 
  output                         agu_icb_cmd_usign,
  output [0:0] agu_icb_cmd_itag,
  //    * Bus RSP channel
  input                          agu_icb_rsp_valid, // Response valid 
  output                         agu_icb_rsp_ready, // Response ready
  input                          agu_icb_rsp_err  , // Response error
  input                          agu_icb_rsp_excl_ok,
  input  [31:0]        agu_icb_rsp_rdata,
  
  `ifdef E203_HAS_NICE//{
  //////////////////////////////////////////////////////////////
  // The nice interface
  //    * cmd channel
  output                         nice_req_valid, // Handshake valid
  input                          nice_req_ready, // Handshake ready
  output [31:0]       nice_req_instr,                               
  output [31:0]       nice_req_rs1, 
  output [31:0]       nice_req_rs2, 
  //output                         nice_req_mmode , // O: current insns' mmode 

  //    * RSP channel will be directly pass to longp-wback module
  input                          nice_rsp_multicyc_valid, //I: current insn is multi-cycle.
  output                         nice_rsp_multicyc_ready, //O:                             

  output                         nice_longp_wbck_valid, // Handshake valid
  input                          nice_longp_wbck_ready, // Handshake ready
  output [0:0] nice_o_itag, 

  input                          i_nice_cmt_off_ilgl,
  `endif//}

  input  clk,
  input  rst_n
  );



  //////////////////////////////////////////////////////////////
  // Dispatch to different sub-modules according to their types

  wire ifu_excp_op = i_ilegl | i_buserr | i_misalgn;
  wire alu_op = (~ifu_excp_op) & (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_ALU); 
  wire agu_op = (~ifu_excp_op) & (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_AGU); 
  wire bjp_op = (~ifu_excp_op) & (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_BJP); 
  wire csr_op = (~ifu_excp_op) & (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_CSR); 
`ifdef E203_SUPPORT_SHARE_MULDIV //{
  wire mdv_op = (~ifu_excp_op) & (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_MULDIV); 
`endif//E203_SUPPORT_SHARE_MULDIV}
`ifdef E203_HAS_NICE//{
  wire nice_op = (~ifu_excp_op) & (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_NICE);
`endif//}

  // The ALU incoming instruction may go to several different targets:
  //   * The ALUDATAPATH if it is a regular ALU instructions
  //   * The Branch-cmp if it is a BJP instructions
  //   * The AGU if it is a load/store relevant instructions
  //   * The MULDIV if it is a MUL/DIV relevant instructions and MULDIV
  //       is reusing the ALU adder
`ifdef E203_SUPPORT_SHARE_MULDIV //{
  wire mdv_i_valid = i_valid & mdv_op;
`endif//E203_SUPPORT_SHARE_MULDIV}
  wire agu_i_valid = i_valid & agu_op;
  wire alu_i_valid = i_valid & alu_op;
  wire bjp_i_valid = i_valid & bjp_op;
  wire csr_i_valid = i_valid & csr_op;
  wire ifu_excp_i_valid = i_valid & ifu_excp_op;
`ifdef E203_HAS_NICE//{
  wire nice_i_valid = i_valid & nice_op;
  wire nice_i_ready;
`endif//}
`ifdef E203_SUPPORT_SHARE_MULDIV //{
  wire mdv_i_ready;
`endif//E203_SUPPORT_SHARE_MULDIV}
  wire agu_i_ready;
  wire alu_i_ready;
  wire bjp_i_ready;
  wire csr_i_ready;
  wire ifu_excp_i_ready;

  assign i_ready =   (agu_i_ready & agu_op)
                   `ifdef E203_SUPPORT_SHARE_MULDIV //{
                   | (mdv_i_ready & mdv_op)
                   `endif//E203_SUPPORT_SHARE_MULDIV}
                   | (alu_i_ready & alu_op)
                   | (ifu_excp_i_ready & ifu_excp_op)
                   | (bjp_i_ready & bjp_op)
                   | (csr_i_ready & csr_op)
                   `ifdef E203_HAS_NICE//{
                   | (nice_i_ready & nice_op)
		   `endif//}
                     ;

  wire agu_i_longpipe;
`ifdef E203_SUPPORT_SHARE_MULDIV //{
  wire mdv_i_longpipe;
`endif//E203_SUPPORT_SHARE_MULDIV}
`ifdef E203_HAS_NICE//{
  wire nice_o_longpipe;
  wire nice_i_longpipe = nice_o_longpipe;
`endif//}

  assign i_longpipe = (agu_i_longpipe & agu_op) 
                   `ifdef E203_SUPPORT_SHARE_MULDIV //{
                    | (mdv_i_longpipe & mdv_op) 
                   `endif//E203_SUPPORT_SHARE_MULDIV}
                   `ifdef E203_HAS_NICE//{
                    | (nice_i_longpipe & nice_op)
		   `endif//}
                   ;

  //////////////////////////////////////////////////////////////
  // Instantiate the CSR module
  //
  wire csr_o_valid;
  wire csr_o_ready;
  wire [`E203_XLEN-1:0] csr_o_wbck_wdat;
  wire csr_o_wbck_err;

  wire  [`E203_XLEN-1:0]           csr_i_rs1   = {`E203_XLEN         {csr_op}} & i_rs1;
  wire  [`E203_XLEN-1:0]           csr_i_rs2   = {`E203_XLEN         {csr_op}} & i_rs2;
  wire  [`E203_XLEN-1:0]           csr_i_imm   = {`E203_XLEN         {csr_op}} & i_imm;
  wire  [`E203_DECINFO_WIDTH-1:0]  csr_i_info  = {`E203_DECINFO_WIDTH{csr_op}} & i_info;  
  wire                             csr_i_rdwen =                      csr_op   & i_rdwen;  

  `ifdef E203_HAS_CSR_NICE//{
  wire csr_sel_nice;
  `endif//}

  `ifdef E203_HAS_NICE//{
  wire [`E203_XLEN-1:0]           nice_i_rs1  = {`E203_XLEN         {nice_op}} & i_rs1;
  wire [`E203_XLEN-1:0]           nice_i_rs2  = {`E203_XLEN         {nice_op}} & i_rs2;
  wire [`E203_ITAG_WIDTH-1:0]     nice_i_itag = {`E203_ITAG_WIDTH   {nice_op}} & i_itag;  
  wire nice_o_valid; 
  wire nice_o_ready;
  //wire [`E203_XLEN-1:0] nice_o_wbck_wdat;
  wire nice_o_wbck_err = i_nice_cmt_off_ilgl;
  //wire nice_i_mmode = nice_op & i_mmode;


  e203_exu_nice   u_e203_exu_nice (

  .nice_i_xs_off      (nice_xs_off),
  .nice_i_valid       (nice_i_valid), // Handshake valid
  .nice_i_ready       (nice_i_ready), // Handshake ready
  .nice_i_instr       (i_instr),
  .nice_i_rs1         (nice_i_rs1), // Handshake valid
  .nice_i_rs2         (nice_i_rs2), // Handshake ready
  //.nice_i_mmode       (nice_i_mmode), // Handshake ready
  .nice_i_itag        (nice_i_itag),
  .nice_o_longpipe    (nice_o_longpipe),
  // The nice Commit Interface
  .nice_o_valid       (nice_o_valid), // Handshake valid
  .nice_o_ready       (nice_o_ready), // Handshake ready

  .nice_o_itag_valid  (nice_longp_wbck_valid), // Handshake valid
  .nice_o_itag_ready  (nice_longp_wbck_ready), // Handshake ready
  .nice_o_itag        (nice_o_itag),   
  // The nice Response Interface
  .nice_rsp_multicyc_valid(nice_rsp_multicyc_valid), //I: current insn is multi-cycle.
  .nice_rsp_multicyc_ready(nice_rsp_multicyc_ready), //O:                             
  // The nice Request Interface
  .nice_req_valid     (nice_req_valid), // Handshake valid
  .nice_req_ready     (nice_req_ready), // Handshake ready
  .nice_req_instr     (nice_req_instr), // Handshake ready
  .nice_req_rs1       (nice_req_rs1), // Handshake valid
  .nice_req_rs2       (nice_req_rs2), // Handshake ready
  //.nice_req_mmode     (nice_req_mmode), // Handshake ready

  .clk               (clk),
  .rst_n             (rst_n)       

  );
  `endif//}

  
  e203_exu_alu_csrctrl u_e203_exu_alu_csrctrl(

  `ifdef E203_HAS_CSR_NICE//{
    .nice_xs_off       (nice_xs_off),
    .csr_sel_nice      (csr_sel_nice),
    .nice_csr_valid    (nice_csr_valid),
    .nice_csr_ready    (nice_csr_ready),
    .nice_csr_addr     (nice_csr_addr ),
    .nice_csr_wr       (nice_csr_wr ),
    .nice_csr_wdata    (nice_csr_wdata),
    .nice_csr_rdata    (nice_csr_rdata),
  `endif//}
    .csr_access_ilgl  (csr_access_ilgl),

    .csr_i_valid      (csr_i_valid),
    .csr_i_ready      (csr_i_ready),

    .csr_i_rs1        (csr_i_rs1  ),
    .csr_i_info       (csr_i_info[`E203_DECINFO_CSR_WIDTH-1:0]),
    .csr_i_rdwen      (csr_i_rdwen),

    .csr_ena          (csr_ena),
    .csr_idx          (csr_idx),
    .csr_rd_en        (csr_rd_en),
    .csr_wr_en        (csr_wr_en),
    .read_csr_dat     (read_csr_dat),
    .wbck_csr_dat     (wbck_csr_dat),

    .csr_o_valid      (csr_o_valid      ),   
    .csr_o_ready      (csr_o_ready      ),   
    .csr_o_wbck_wdat  (csr_o_wbck_wdat  ),
    .csr_o_wbck_err   (csr_o_wbck_err   ),

     .clk             (clk),
     .rst_n           (rst_n)
  );

  //////////////////////////////////////////////////////////////
  // Instantiate the BJP module
  //
  wire bjp_o_valid; 
  wire bjp_o_ready; 
  wire [`E203_XLEN-1:0] bjp_o_wbck_wdat;
  wire bjp_o_wbck_err;
  wire bjp_o_cmt_bjp;
  wire bjp_o_cmt_mret;
  wire bjp_o_cmt_dret;
  wire bjp_o_cmt_fencei;
  wire bjp_o_cmt_prdt;
  wire bjp_o_cmt_rslv;

  wire [`E203_XLEN-1:0] bjp_req_alu_op1;
  wire [`E203_XLEN-1:0] bjp_req_alu_op2;
  wire bjp_req_alu_cmp_eq ;
  wire bjp_req_alu_cmp_ne ;
  wire bjp_req_alu_cmp_lt ;
  wire bjp_req_alu_cmp_gt ;
  wire bjp_req_alu_cmp_ltu;
  wire bjp_req_alu_cmp_gtu;
  wire bjp_req_alu_add;
  wire bjp_req_alu_cmp_res;
  wire [`E203_XLEN-1:0] bjp_req_alu_add_res;

  wire  [`E203_XLEN-1:0]           bjp_i_rs1  = {`E203_XLEN         {bjp_op}} & i_rs1;
  wire  [`E203_XLEN-1:0]           bjp_i_rs2  = {`E203_XLEN         {bjp_op}} & i_rs2;
  wire  [`E203_XLEN-1:0]           bjp_i_imm  = {`E203_XLEN         {bjp_op}} & i_imm;
  wire  [`E203_DECINFO_WIDTH-1:0]  bjp_i_info = {`E203_DECINFO_WIDTH{bjp_op}} & i_info;  
  wire  [`E203_PC_SIZE-1:0]        bjp_i_pc   = {`E203_PC_SIZE      {bjp_op}} & i_pc;  

  e203_exu_alu_bjp u_e203_exu_alu_bjp(
      .bjp_i_valid         (bjp_i_valid         ),
      .bjp_i_ready         (bjp_i_ready         ),
      .bjp_i_rs1           (bjp_i_rs1           ),
      .bjp_i_rs2           (bjp_i_rs2           ),
      .bjp_i_info          (bjp_i_info[`E203_DECINFO_BJP_WIDTH-1:0]),
      .bjp_i_imm           (bjp_i_imm           ),
      .bjp_i_pc            (bjp_i_pc            ),

      .bjp_o_valid         (bjp_o_valid      ),
      .bjp_o_ready         (bjp_o_ready      ),
      .bjp_o_wbck_wdat     (bjp_o_wbck_wdat  ),
      .bjp_o_wbck_err      (bjp_o_wbck_err   ),

      .bjp_o_cmt_bjp       (bjp_o_cmt_bjp    ),
      .bjp_o_cmt_mret      (bjp_o_cmt_mret    ),
      .bjp_o_cmt_dret      (bjp_o_cmt_dret    ),
      .bjp_o_cmt_fencei    (bjp_o_cmt_fencei  ),
      .bjp_o_cmt_prdt      (bjp_o_cmt_prdt   ),
      .bjp_o_cmt_rslv      (bjp_o_cmt_rslv   ),

      .bjp_req_alu_op1     (bjp_req_alu_op1       ),
      .bjp_req_alu_op2     (bjp_req_alu_op2       ),
      .bjp_req_alu_cmp_eq  (bjp_req_alu_cmp_eq    ),
      .bjp_req_alu_cmp_ne  (bjp_req_alu_cmp_ne    ),
      .bjp_req_alu_cmp_lt  (bjp_req_alu_cmp_lt    ),
      .bjp_req_alu_cmp_gt  (bjp_req_alu_cmp_gt    ),
      .bjp_req_alu_cmp_ltu (bjp_req_alu_cmp_ltu   ),
      .bjp_req_alu_cmp_gtu (bjp_req_alu_cmp_gtu   ),
      .bjp_req_alu_add     (bjp_req_alu_add       ),
      .bjp_req_alu_cmp_res (bjp_req_alu_cmp_res   ),
      .bjp_req_alu_add_res (bjp_req_alu_add_res   ),

      .clk                 (clk),
      .rst_n               (rst_n)
  );



  
  //////////////////////////////////////////////////////////////
  // Instantiate the AGU module
  //
  wire agu_o_valid; 
  wire agu_o_ready; 
  
  wire [`E203_XLEN-1:0] agu_o_wbck_wdat;
  wire agu_o_wbck_err;   
  
  wire agu_o_cmt_misalgn; 
  wire agu_o_cmt_ld; 
  wire agu_o_cmt_stamo; 
  wire agu_o_cmt_buserr ; 
  wire [`E203_ADDR_SIZE-1:0]agu_o_cmt_badaddr ; 
  
  wire [`E203_XLEN-1:0] agu_req_alu_op1;
  wire [`E203_XLEN-1:0] agu_req_alu_op2;
  wire agu_req_alu_swap;
  wire agu_req_alu_add ;
  wire agu_req_alu_and ;
  wire agu_req_alu_or  ;
  wire agu_req_alu_xor ;
  wire agu_req_alu_max ;
  wire agu_req_alu_min ;
  wire agu_req_alu_maxu;
  wire agu_req_alu_minu;
  wire [`E203_XLEN-1:0] agu_req_alu_res;
     
  wire agu_sbf_0_ena;
  wire [`E203_XLEN-1:0] agu_sbf_0_nxt;
  wire [`E203_XLEN-1:0] agu_sbf_0_r;
  wire agu_sbf_1_ena;
  wire [`E203_XLEN-1:0] agu_sbf_1_nxt;
  wire [`E203_XLEN-1:0] agu_sbf_1_r;

  wire  [`E203_XLEN-1:0]           agu_i_rs1  = {`E203_XLEN         {agu_op}} & i_rs1;
  wire  [`E203_XLEN-1:0]           agu_i_rs2  = {`E203_XLEN         {agu_op}} & i_rs2;
  wire  [`E203_XLEN-1:0]           agu_i_imm  = {`E203_XLEN         {agu_op}} & i_imm;
  wire  [`E203_DECINFO_WIDTH-1:0]  agu_i_info = {`E203_DECINFO_WIDTH{agu_op}} & i_info;  
  wire  [`E203_ITAG_WIDTH-1:0]     agu_i_itag = {`E203_ITAG_WIDTH   {agu_op}} & i_itag;  


  e203_exu_alu_lsuagu u_e203_exu_alu_lsuagu(

      .agu_i_valid         (agu_i_valid     ),
      .agu_i_ready         (agu_i_ready     ),
      .agu_i_rs1           (agu_i_rs1       ),
      .agu_i_rs2           (agu_i_rs2       ),
      .agu_i_imm           (agu_i_imm       ),
      .agu_i_info          (agu_i_info[`E203_DECINFO_AGU_WIDTH-1:0]),
      .agu_i_longpipe      (agu_i_longpipe  ),
      .agu_i_itag          (agu_i_itag      ),

      .flush_pulse         (flush_pulse    ),
      .flush_req           (flush_req      ),
      .amo_wait            (amo_wait),
      .oitf_empty          (oitf_empty),

      .agu_o_valid         (agu_o_valid         ),
      .agu_o_ready         (agu_o_ready         ),
      .agu_o_wbck_wdat     (agu_o_wbck_wdat     ),
      .agu_o_wbck_err      (agu_o_wbck_err      ),
      .agu_o_cmt_misalgn   (agu_o_cmt_misalgn   ),
      .agu_o_cmt_ld        (agu_o_cmt_ld        ),
      .agu_o_cmt_stamo     (agu_o_cmt_stamo     ),
      .agu_o_cmt_buserr    (agu_o_cmt_buserr    ),
      .agu_o_cmt_badaddr   (agu_o_cmt_badaddr   ),
                                                
      .agu_icb_cmd_valid   (agu_icb_cmd_valid   ),
      .agu_icb_cmd_ready   (agu_icb_cmd_ready   ),
      .agu_icb_cmd_addr    (agu_icb_cmd_addr    ),
      .agu_icb_cmd_read    (agu_icb_cmd_read    ),
      .agu_icb_cmd_wdata   (agu_icb_cmd_wdata   ),
      .agu_icb_cmd_wmask   (agu_icb_cmd_wmask   ),
      .agu_icb_cmd_lock    (agu_icb_cmd_lock    ),
      .agu_icb_cmd_excl    (agu_icb_cmd_excl    ),
      .agu_icb_cmd_size    (agu_icb_cmd_size    ),
      .agu_icb_cmd_back2agu(agu_icb_cmd_back2agu),
      .agu_icb_cmd_usign   (agu_icb_cmd_usign   ),
      .agu_icb_cmd_itag    (agu_icb_cmd_itag    ),
      .agu_icb_rsp_valid   (agu_icb_rsp_valid   ),
      .agu_icb_rsp_ready   (agu_icb_rsp_ready   ),
      .agu_icb_rsp_err     (agu_icb_rsp_err     ),
      .agu_icb_rsp_excl_ok (agu_icb_rsp_excl_ok ),
      .agu_icb_rsp_rdata   (agu_icb_rsp_rdata   ),
                                                
      .agu_req_alu_op1     (agu_req_alu_op1     ),
      .agu_req_alu_op2     (agu_req_alu_op2     ),
      .agu_req_alu_swap    (agu_req_alu_swap    ),
      .agu_req_alu_add     (agu_req_alu_add     ),
      .agu_req_alu_and     (agu_req_alu_and     ),
      .agu_req_alu_or      (agu_req_alu_or      ),
      .agu_req_alu_xor     (agu_req_alu_xor     ),
      .agu_req_alu_max     (agu_req_alu_max     ),
      .agu_req_alu_min     (agu_req_alu_min     ),
      .agu_req_alu_maxu    (agu_req_alu_maxu    ),
      .agu_req_alu_minu    (agu_req_alu_minu    ),
      .agu_req_alu_res     (agu_req_alu_res     ),
                                                
      .agu_sbf_0_ena       (agu_sbf_0_ena       ),
      .agu_sbf_0_nxt       (agu_sbf_0_nxt       ),
      .agu_sbf_0_r         (agu_sbf_0_r         ),
                                                
      .agu_sbf_1_ena       (agu_sbf_1_ena       ),
      .agu_sbf_1_nxt       (agu_sbf_1_nxt       ),
      .agu_sbf_1_r         (agu_sbf_1_r         ),
     
      .clk                 (clk),
      .rst_n               (rst_n)
  );

  //////////////////////////////////////////////////////////////
  // Instantiate the regular ALU module
  //
  wire alu_o_valid; 
  wire alu_o_ready; 
  wire [`E203_XLEN-1:0] alu_o_wbck_wdat;
  wire alu_o_wbck_err;   
  wire alu_o_cmt_ecall;
  wire alu_o_cmt_ebreak;
  wire alu_o_cmt_wfi;

  wire alu_req_alu_add ;
  wire alu_req_alu_sub ;
  wire alu_req_alu_xor ;
  wire alu_req_alu_sll ;
  wire alu_req_alu_srl ;
  wire alu_req_alu_sra ;
  wire alu_req_alu_or  ;
  wire alu_req_alu_and ;
  wire alu_req_alu_slt ;
  wire alu_req_alu_sltu;
  wire alu_req_alu_lui ;
  wire [`E203_XLEN-1:0] alu_req_alu_op1;
  wire [`E203_XLEN-1:0] alu_req_alu_op2;
  wire [`E203_XLEN-1:0] alu_req_alu_res;

  wire  [`E203_XLEN-1:0]           alu_i_rs1  = {`E203_XLEN         {alu_op}} & i_rs1;
  wire  [`E203_XLEN-1:0]           alu_i_rs2  = {`E203_XLEN         {alu_op}} & i_rs2;
  wire  [`E203_XLEN-1:0]           alu_i_imm  = {`E203_XLEN         {alu_op}} & i_imm;
  wire  [`E203_DECINFO_WIDTH-1:0]  alu_i_info = {`E203_DECINFO_WIDTH{alu_op}} & i_info;  
  wire  [`E203_PC_SIZE-1:0]        alu_i_pc   = {`E203_PC_SIZE      {alu_op}} & i_pc;  

  e203_exu_alu_rglr u_e203_exu_alu_rglr(

      .alu_i_valid         (alu_i_valid     ),
      .alu_i_ready         (alu_i_ready     ),
      .alu_i_rs1           (alu_i_rs1           ),
      .alu_i_rs2           (alu_i_rs2           ),
      .alu_i_info          (alu_i_info[`E203_DECINFO_ALU_WIDTH-1:0]),
      .alu_i_imm           (alu_i_imm           ),
      .alu_i_pc            (alu_i_pc            ),

      .alu_o_valid         (alu_o_valid         ),
      .alu_o_ready         (alu_o_ready         ),
      .alu_o_wbck_wdat     (alu_o_wbck_wdat     ),
      .alu_o_wbck_err      (alu_o_wbck_err      ),
      .alu_o_cmt_ecall     (alu_o_cmt_ecall ),
      .alu_o_cmt_ebreak    (alu_o_cmt_ebreak),
      .alu_o_cmt_wfi       (alu_o_cmt_wfi   ),

      .alu_req_alu_add     (alu_req_alu_add       ),
      .alu_req_alu_sub     (alu_req_alu_sub       ),
      .alu_req_alu_xor     (alu_req_alu_xor       ),
      .alu_req_alu_sll     (alu_req_alu_sll       ),
      .alu_req_alu_srl     (alu_req_alu_srl       ),
      .alu_req_alu_sra     (alu_req_alu_sra       ),
      .alu_req_alu_or      (alu_req_alu_or        ),
      .alu_req_alu_and     (alu_req_alu_and       ),
      .alu_req_alu_slt     (alu_req_alu_slt       ),
      .alu_req_alu_sltu    (alu_req_alu_sltu      ),
      .alu_req_alu_lui     (alu_req_alu_lui       ),
      .alu_req_alu_op1     (alu_req_alu_op1       ),
      .alu_req_alu_op2     (alu_req_alu_op2       ),
      .alu_req_alu_res     (alu_req_alu_res       ),

      .clk                 (clk           ),
      .rst_n               (rst_n         ) 
  );

`ifdef E203_SUPPORT_SHARE_MULDIV //{
  //////////////////////////////////////////////////////
  // Instantiate the MULDIV module
  wire [`E203_XLEN-1:0]           mdv_i_rs1  = {`E203_XLEN         {mdv_op}} & i_rs1;
  wire [`E203_XLEN-1:0]           mdv_i_rs2  = {`E203_XLEN         {mdv_op}} & i_rs2;
  wire [`E203_XLEN-1:0]           mdv_i_imm  = {`E203_XLEN         {mdv_op}} & i_imm;
  wire [`E203_DECINFO_WIDTH-1:0]  mdv_i_info = {`E203_DECINFO_WIDTH{mdv_op}} & i_info;  
  wire  [`E203_ITAG_WIDTH-1:0]    mdv_i_itag = {`E203_ITAG_WIDTH   {mdv_op}} & i_itag;  

  wire mdv_o_valid; 
  wire mdv_o_ready;
  wire [`E203_XLEN-1:0] mdv_o_wbck_wdat;
  wire mdv_o_wbck_err;

  wire [`E203_ALU_ADDER_WIDTH-1:0] muldiv_req_alu_op1;
  wire [`E203_ALU_ADDER_WIDTH-1:0] muldiv_req_alu_op2;
  wire                             muldiv_req_alu_add ;
  wire                             muldiv_req_alu_sub ;
  wire [`E203_ALU_ADDER_WIDTH-1:0] muldiv_req_alu_res;

  wire          muldiv_sbf_0_ena;
  wire [33-1:0] muldiv_sbf_0_nxt;
  wire [33-1:0] muldiv_sbf_0_r;

  wire          muldiv_sbf_1_ena;
  wire [33-1:0] muldiv_sbf_1_nxt;
  wire [33-1:0] muldiv_sbf_1_r;

  e203_exu_alu_muldiv u_e203_exu_alu_muldiv(
      .mdv_nob2b           (mdv_nob2b),

      .muldiv_i_valid      (mdv_i_valid    ),
      .muldiv_i_ready      (mdv_i_ready    ),
                           
      .muldiv_i_rs1        (mdv_i_rs1      ),
      .muldiv_i_rs2        (mdv_i_rs2      ),
      .muldiv_i_imm        (mdv_i_imm      ),
      .muldiv_i_info       (mdv_i_info[`E203_DECINFO_MULDIV_WIDTH-1:0]),
      .muldiv_i_longpipe   (mdv_i_longpipe ),
      .muldiv_i_itag       (mdv_i_itag     ),
                          

      .flush_pulse         (flush_pulse    ),

      .muldiv_o_valid      (mdv_o_valid    ),
      .muldiv_o_ready      (mdv_o_ready    ),
      .muldiv_o_wbck_wdat  (mdv_o_wbck_wdat),
      .muldiv_o_wbck_err   (mdv_o_wbck_err ),

      .muldiv_req_alu_op1  (muldiv_req_alu_op1),
      .muldiv_req_alu_op2  (muldiv_req_alu_op2),
      .muldiv_req_alu_add  (muldiv_req_alu_add),
      .muldiv_req_alu_sub  (muldiv_req_alu_sub),
      .muldiv_req_alu_res  (muldiv_req_alu_res),
      
      .muldiv_sbf_0_ena    (muldiv_sbf_0_ena  ),
      .muldiv_sbf_0_nxt    (muldiv_sbf_0_nxt  ),
      .muldiv_sbf_0_r      (muldiv_sbf_0_r    ),
     
      .muldiv_sbf_1_ena    (muldiv_sbf_1_ena  ),
      .muldiv_sbf_1_nxt    (muldiv_sbf_1_nxt  ),
      .muldiv_sbf_1_r      (muldiv_sbf_1_r    ),

      .clk                 (clk               ),
      .rst_n               (rst_n             ) 
  );
`endif//E203_SUPPORT_SHARE_MULDIV}





  //////////////////////////////////////////////////////////////
  // Instantiate the Shared Datapath module
  //
  wire alu_req_alu = alu_op & i_rdwen;// Regular ALU only req datapath when it need to write-back
`ifdef E203_SUPPORT_SHARE_MULDIV //{
  wire muldiv_req_alu = mdv_op;// Since MULDIV have no point to let rd=0, so always need ALU datapath
`endif//E203_SUPPORT_SHARE_MULDIV}
  wire bjp_req_alu = bjp_op;// Since BJP may not write-back, but still need ALU datapath
  wire agu_req_alu = agu_op;// Since AGU may have some other features, so always need ALU datapath

  e203_exu_alu_dpath u_e203_exu_alu_dpath(
      .alu_req_alu         (alu_req_alu           ),    
      .alu_req_alu_add     (alu_req_alu_add       ),
      .alu_req_alu_sub     (alu_req_alu_sub       ),
      .alu_req_alu_xor     (alu_req_alu_xor       ),
      .alu_req_alu_sll     (alu_req_alu_sll       ),
      .alu_req_alu_srl     (alu_req_alu_srl       ),
      .alu_req_alu_sra     (alu_req_alu_sra       ),
      .alu_req_alu_or      (alu_req_alu_or        ),
      .alu_req_alu_and     (alu_req_alu_and       ),
      .alu_req_alu_slt     (alu_req_alu_slt       ),
      .alu_req_alu_sltu    (alu_req_alu_sltu      ),
      .alu_req_alu_lui     (alu_req_alu_lui       ),
      .alu_req_alu_op1     (alu_req_alu_op1       ),
      .alu_req_alu_op2     (alu_req_alu_op2       ),
      .alu_req_alu_res     (alu_req_alu_res       ),
           
      .bjp_req_alu         (bjp_req_alu           ),
      .bjp_req_alu_op1     (bjp_req_alu_op1       ),
      .bjp_req_alu_op2     (bjp_req_alu_op2       ),
      .bjp_req_alu_cmp_eq  (bjp_req_alu_cmp_eq    ),
      .bjp_req_alu_cmp_ne  (bjp_req_alu_cmp_ne    ),
      .bjp_req_alu_cmp_lt  (bjp_req_alu_cmp_lt    ),
      .bjp_req_alu_cmp_gt  (bjp_req_alu_cmp_gt    ),
      .bjp_req_alu_cmp_ltu (bjp_req_alu_cmp_ltu   ),
      .bjp_req_alu_cmp_gtu (bjp_req_alu_cmp_gtu   ),
      .bjp_req_alu_add     (bjp_req_alu_add       ),
      .bjp_req_alu_cmp_res (bjp_req_alu_cmp_res   ),
      .bjp_req_alu_add_res (bjp_req_alu_add_res   ),
             
      .agu_req_alu         (agu_req_alu           ),
      .agu_req_alu_op1     (agu_req_alu_op1       ),
      .agu_req_alu_op2     (agu_req_alu_op2       ),
      .agu_req_alu_swap    (agu_req_alu_swap      ),
      .agu_req_alu_add     (agu_req_alu_add       ),
      .agu_req_alu_and     (agu_req_alu_and       ),
      .agu_req_alu_or      (agu_req_alu_or        ),
      .agu_req_alu_xor     (agu_req_alu_xor       ),
      .agu_req_alu_max     (agu_req_alu_max       ),
      .agu_req_alu_min     (agu_req_alu_min       ),
      .agu_req_alu_maxu    (agu_req_alu_maxu      ),
      .agu_req_alu_minu    (agu_req_alu_minu      ),
      .agu_req_alu_res     (agu_req_alu_res       ),
             
      .agu_sbf_0_ena       (agu_sbf_0_ena         ),
      .agu_sbf_0_nxt       (agu_sbf_0_nxt         ),
      .agu_sbf_0_r         (agu_sbf_0_r           ),
            
      .agu_sbf_1_ena       (agu_sbf_1_ena         ),
      .agu_sbf_1_nxt       (agu_sbf_1_nxt         ),
      .agu_sbf_1_r         (agu_sbf_1_r           ),      

`ifdef E203_SUPPORT_SHARE_MULDIV //{
      .muldiv_req_alu      (muldiv_req_alu    ),

      .muldiv_req_alu_op1  (muldiv_req_alu_op1),
      .muldiv_req_alu_op2  (muldiv_req_alu_op2),
      .muldiv_req_alu_add  (muldiv_req_alu_add),
      .muldiv_req_alu_sub  (muldiv_req_alu_sub),
      .muldiv_req_alu_res  (muldiv_req_alu_res),
      
      .muldiv_sbf_0_ena    (muldiv_sbf_0_ena  ),
      .muldiv_sbf_0_nxt    (muldiv_sbf_0_nxt  ),
      .muldiv_sbf_0_r      (muldiv_sbf_0_r    ),
     
      .muldiv_sbf_1_ena    (muldiv_sbf_1_ena  ),
      .muldiv_sbf_1_nxt    (muldiv_sbf_1_nxt  ),
      .muldiv_sbf_1_r      (muldiv_sbf_1_r    ),
`endif//E203_SUPPORT_SHARE_MULDIV}

      .clk                 (clk           ),
      .rst_n               (rst_n         ) 
    );

  wire ifu_excp_o_valid;
  wire ifu_excp_o_ready;
  wire [`E203_XLEN-1:0] ifu_excp_o_wbck_wdat;
  wire ifu_excp_o_wbck_err;

  assign ifu_excp_i_ready = ifu_excp_o_ready;
  assign ifu_excp_o_valid = ifu_excp_i_valid;
  assign ifu_excp_o_wbck_wdat = `E203_XLEN'b0;
  assign ifu_excp_o_wbck_err  = 1'b1;// IFU illegal instruction always treat as error

  //////////////////////////////////////////////////////////////
  // Aribtrate the Result and generate output interfaces
  // 
  wire o_valid;
  wire o_ready;

  wire o_sel_ifu_excp = ifu_excp_op;
  wire o_sel_alu = alu_op;
  wire o_sel_bjp = bjp_op;
  wire o_sel_csr = csr_op;
  wire o_sel_agu = agu_op;
`ifdef E203_SUPPORT_SHARE_MULDIV //{
  wire o_sel_mdv = mdv_op;
`endif//E203_SUPPORT_SHARE_MULDIV}
`ifdef E203_HAS_NICE//{
  wire o_sel_nice = nice_op;
`endif//}

  assign o_valid =     (o_sel_alu      & alu_o_valid     )
                     | (o_sel_bjp      & bjp_o_valid     )
                     | (o_sel_csr      & csr_o_valid     )
                     | (o_sel_agu      & agu_o_valid     )
                     | (o_sel_ifu_excp & ifu_excp_o_valid)
                      `ifdef E203_SUPPORT_SHARE_MULDIV //{
                     | (o_sel_mdv      & mdv_o_valid     )
                      `endif//E203_SUPPORT_SHARE_MULDIV}
                      `ifdef E203_HAS_NICE//{
                     | (o_sel_nice      & nice_o_valid     )
                      `endif//}
                     ;

  assign ifu_excp_o_ready = o_sel_ifu_excp & o_ready;
  assign alu_o_ready      = o_sel_alu & o_ready;
  assign agu_o_ready      = o_sel_agu & o_ready;
`ifdef E203_SUPPORT_SHARE_MULDIV //{
  assign mdv_o_ready      = o_sel_mdv & o_ready;
`endif//E203_SUPPORT_SHARE_MULDIV}
  assign bjp_o_ready      = o_sel_bjp & o_ready;
  assign csr_o_ready      = o_sel_csr & o_ready;
`ifdef E203_HAS_NICE//{
  assign nice_o_ready      = o_sel_nice & o_ready;
`endif//}

  assign wbck_o_wdat = 
                    ({`E203_XLEN{o_sel_alu}} & alu_o_wbck_wdat)
                  | ({`E203_XLEN{o_sel_bjp}} & bjp_o_wbck_wdat)
                  | ({`E203_XLEN{o_sel_csr}} & csr_o_wbck_wdat)
                  | ({`E203_XLEN{o_sel_agu}} & agu_o_wbck_wdat)
                      `ifdef E203_SUPPORT_SHARE_MULDIV //{
                  | ({`E203_XLEN{o_sel_mdv}} & mdv_o_wbck_wdat)
                      `endif//E203_SUPPORT_SHARE_MULDIV}
                  | ({`E203_XLEN{o_sel_ifu_excp}} & ifu_excp_o_wbck_wdat)
                  //| ({`E203_XLEN{o_sel_nice}} & nice_o_wbck_wdat)
                  ;

  assign wbck_o_rdidx = i_rdidx; 

  wire wbck_o_rdwen = i_rdwen;
                  
  wire wbck_o_err = 
                    ({1{o_sel_alu}} & alu_o_wbck_err)
                  | ({1{o_sel_bjp}} & bjp_o_wbck_err)
                  | ({1{o_sel_csr}} & csr_o_wbck_err)
                  | ({1{o_sel_agu}} & agu_o_wbck_err)
                      `ifdef E203_SUPPORT_SHARE_MULDIV //{
                  | ({1{o_sel_mdv}} & mdv_o_wbck_err)
                      `endif//E203_SUPPORT_SHARE_MULDIV}
                  | ({1{o_sel_ifu_excp}} & ifu_excp_o_wbck_err)
                    `ifdef E203_HAS_NICE//{
                  | ({1{o_sel_nice}} & nice_o_wbck_err)
                    `endif//}
                  ;

  //  Each Instruction need to commit or write-back
  //   * The write-back only needed when the unit need to write-back
  //     the result (need to write RD), and it is not a long-pipe uop
  //     (need to be write back by its long-pipe write-back, not here)
  //   * Each instruction need to be commited 
  wire o_need_wbck = wbck_o_rdwen & (~i_longpipe) & (~wbck_o_err);
  wire o_need_cmt  = 1'b1;
  assign o_ready = 
           (o_need_cmt  ? cmt_o_ready  : 1'b1)  
         & (o_need_wbck ? wbck_o_ready : 1'b1); 

  assign wbck_o_valid = o_need_wbck & o_valid & (o_need_cmt  ? cmt_o_ready  : 1'b1);
  assign cmt_o_valid  = o_need_cmt  & o_valid & (o_need_wbck ? wbck_o_ready : 1'b1);
  // 
  //  The commint interface have some special signals
  assign cmt_o_instr   = i_instr;  
  assign cmt_o_pc   = i_pc;  
  assign cmt_o_imm  = i_imm;
  assign cmt_o_rv32 = i_info[`E203_DECINFO_RV32]; 
    // The cmt_o_pc_vld is used by the commit stage to check
    // if current instruction is outputing a valid current PC
    //   to guarante the commit to flush pipeline safely, this
    //   vld only be asserted when:
    //     * There is a valid instruction here
    //        --- otherwise, the commit stage may use wrong PC
    //             value to stored in DPC or EPC
  assign cmt_o_pc_vld      =
              // Otherwise, just use the i_pc_vld
                              i_pc_vld;

  assign cmt_o_misalgn     = (o_sel_agu & agu_o_cmt_misalgn) 
                           ;
  assign cmt_o_ld          = (o_sel_agu & agu_o_cmt_ld)      
                           ;
  assign cmt_o_badaddr     = ({`E203_ADDR_SIZE{o_sel_agu}} & agu_o_cmt_badaddr)  
                           ;
  assign cmt_o_buserr      = o_sel_agu & agu_o_cmt_buserr;
  assign cmt_o_stamo       = o_sel_agu & agu_o_cmt_stamo ;

  assign cmt_o_bjp         = o_sel_bjp & bjp_o_cmt_bjp;
  assign cmt_o_mret        = o_sel_bjp & bjp_o_cmt_mret;
  assign cmt_o_dret        = o_sel_bjp & bjp_o_cmt_dret;
  assign cmt_o_bjp_prdt    = o_sel_bjp & bjp_o_cmt_prdt;
  assign cmt_o_bjp_rslv    = o_sel_bjp & bjp_o_cmt_rslv;
  assign cmt_o_fencei      = o_sel_bjp & bjp_o_cmt_fencei;

  assign cmt_o_ecall       = o_sel_alu & alu_o_cmt_ecall;
  assign cmt_o_ebreak      = o_sel_alu & alu_o_cmt_ebreak;
  assign cmt_o_wfi         = o_sel_alu & alu_o_cmt_wfi;
  assign cmt_o_ifu_misalgn = i_misalgn;
  assign cmt_o_ifu_buserr  = i_buserr;
  assign cmt_o_ifu_ilegl   = i_ilegl
                           | (o_sel_csr & csr_access_ilgl)
                        ;

endmodule                                      
                                               
                                               
                                               
