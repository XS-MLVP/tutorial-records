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
//  This module to implement the 17cycles MUL and 33 cycles DIV unit, which is mostly 
//  share the datapath with ALU_DPATH module to save gatecount to mininum
//
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



`ifdef E203_SUPPORT_MULDIV //{
module e203_exu_alu_muldiv(
  input  mdv_nob2b,

  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The Issue Handshake Interface to MULDIV 
  //
  input  muldiv_i_valid, // Handshake valid
  output muldiv_i_ready, // Handshake ready

  input  [31:0] muldiv_i_rs1,
  input  [31:0] muldiv_i_rs2,
  input  [31:0] muldiv_i_imm,
  input  [12:0] muldiv_i_info,
  input  [0:0] muldiv_i_itag,

  output muldiv_i_longpipe,

  input  flush_pulse,

  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The MULDIV Write-Back/Commit Interface
  output muldiv_o_valid, // Handshake valid
  input  muldiv_o_ready, // Handshake ready
  output [31:0] muldiv_o_wbck_wdat,
  output muldiv_o_wbck_err,   
  //   There is no exception cases for MULDIV, so no addtional cmt signals

  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // To share the ALU datapath, generate interface to ALU
  // 
    // The operands and info to ALU
  output [34:0] muldiv_req_alu_op1,
  output [34:0] muldiv_req_alu_op2,
  output                                muldiv_req_alu_add ,
  output                                muldiv_req_alu_sub ,
  input  [34:0] muldiv_req_alu_res,

    // The Shared-Buffer interface to ALU-Shared-Buffer
  output          muldiv_sbf_0_ena,
  output [33-1:0] muldiv_sbf_0_nxt,
  input  [33-1:0] muldiv_sbf_0_r,

  output          muldiv_sbf_1_ena,
  output [33-1:0] muldiv_sbf_1_nxt,
  input  [33-1:0] muldiv_sbf_1_r,

  input  clk,
  input  rst_n
  );

  wire muldiv_i_hsked = muldiv_i_valid & muldiv_i_ready;
  wire muldiv_o_hsked = muldiv_o_valid & muldiv_o_ready;

  wire flushed_r;
  wire flushed_set = flush_pulse;
  wire flushed_clr = muldiv_o_hsked & (~flush_pulse);
  wire flushed_ena = flushed_set | flushed_clr;
  wire flushed_nxt = flushed_set | (~flushed_clr);
  sirv_gnrl_dfflr #(1) flushed_dfflr (flushed_ena, flushed_nxt, flushed_r, clk, rst_n);



  wire i_mul    = muldiv_i_info[`E203_DECINFO_MULDIV_MUL   ];// We treat this as signed X signed
  wire i_mulh   = muldiv_i_info[`E203_DECINFO_MULDIV_MULH  ];
  wire i_mulhsu = muldiv_i_info[`E203_DECINFO_MULDIV_MULHSU];
  wire i_mulhu  = muldiv_i_info[`E203_DECINFO_MULDIV_MULHU ];
  wire i_div    = muldiv_i_info[`E203_DECINFO_MULDIV_DIV   ];
  wire i_divu   = muldiv_i_info[`E203_DECINFO_MULDIV_DIVU  ];
  wire i_rem    = muldiv_i_info[`E203_DECINFO_MULDIV_REM   ];
  wire i_remu   = muldiv_i_info[`E203_DECINFO_MULDIV_REMU  ];
      // If it is flushed then it is not back2back real case
  wire i_b2b    = muldiv_i_info[`E203_DECINFO_MULDIV_B2B   ] & (~flushed_r) & (~mdv_nob2b);

  wire back2back_seq = i_b2b;

  wire mul_rs1_sign = (i_mulhu)            ? 1'b0 : muldiv_i_rs1[`E203_XLEN-1];
  wire mul_rs2_sign = (i_mulhsu | i_mulhu) ? 1'b0 : muldiv_i_rs2[`E203_XLEN-1];

  wire [32:0] mul_op1 = {mul_rs1_sign, muldiv_i_rs1};
  wire [32:0] mul_op2 = {mul_rs2_sign, muldiv_i_rs2};

  wire i_op_mul = i_mul | i_mulh | i_mulhsu | i_mulhu;
  wire i_op_div = i_div | i_divu | i_rem    | i_remu;


  /////////////////////////////////////////////////////////////////////////////////
  // Implement the state machine for 
  //    (1) The MUL instructions
  //    (2) The DIV instructions
  localparam MULDIV_STATE_WIDTH = 3;

  wire [MULDIV_STATE_WIDTH-1:0] muldiv_state_nxt;
  wire [MULDIV_STATE_WIDTH-1:0] muldiv_state_r;
  wire muldiv_state_ena;

  // State 0: The 0th state, means this is the 1 cycle see the operand inputs
  localparam MULDIV_STATE_0TH = 3'd0;
  // State 1: Executing the instructions
  localparam MULDIV_STATE_EXEC = 3'd1;
  // State 2: Div check if need correction
  localparam MULDIV_STATE_REMD_CHCK = 3'd2;
  // State 3: Quotient correction
  localparam MULDIV_STATE_QUOT_CORR = 3'd3;
  // State 4: Reminder correction
  localparam MULDIV_STATE_REMD_CORR = 3'd4;
  
 
  wire [MULDIV_STATE_WIDTH-1:0] state_0th_nxt;
  wire [MULDIV_STATE_WIDTH-1:0] state_exec_nxt;
  wire [MULDIV_STATE_WIDTH-1:0] state_remd_chck_nxt;
  wire [MULDIV_STATE_WIDTH-1:0] state_quot_corr_nxt;
  wire [MULDIV_STATE_WIDTH-1:0] state_remd_corr_nxt;
  wire state_0th_exit_ena;
  wire state_exec_exit_ena;
  wire state_remd_chck_exit_ena;
  wire state_quot_corr_exit_ena;
  wire state_remd_corr_exit_ena;

  wire special_cases;
  wire muldiv_i_valid_nb2b = muldiv_i_valid & (~back2back_seq) & (~special_cases);

  // Define some common signals and reused later to save gatecounts
  wire   muldiv_sta_is_0th       = (muldiv_state_r == MULDIV_STATE_0TH   );
  wire   muldiv_sta_is_exec      = (muldiv_state_r == MULDIV_STATE_EXEC   );
  wire   muldiv_sta_is_remd_chck  = (muldiv_state_r == MULDIV_STATE_REMD_CHCK   );
  wire   muldiv_sta_is_quot_corr = (muldiv_state_r == MULDIV_STATE_QUOT_CORR   );
  wire   muldiv_sta_is_remd_corr = (muldiv_state_r == MULDIV_STATE_REMD_CORR   );

      // **** If the current state is 0th,
          // If a new instruction come (non back2back), next state is MULDIV_STATE_EXEC
  assign state_0th_exit_ena = muldiv_sta_is_0th & muldiv_i_valid_nb2b & (~flush_pulse);
  assign state_0th_nxt      = MULDIV_STATE_EXEC;

      // **** If the current state is exec,
  wire div_need_corrct; 
  wire mul_exec_last_cycle; 
  wire div_exec_last_cycle; 
  wire exec_last_cycle; 
  assign state_exec_exit_ena =  muldiv_sta_is_exec & ((
          // If it is the last cycle (16th or 32rd cycles), 
                           exec_last_cycle 
              // If it is div op, then jump to DIV_CHECK state
                         & (i_op_div ? 1'b1
              // If it is not div-need-correction, then jump to 0th 
                                            : muldiv_o_hsked))
            | flush_pulse);
  assign state_exec_nxt      = 
                (
                         flush_pulse ? MULDIV_STATE_0TH :
              // If it is div op, then jump to DIV_CHECK state
                         i_op_div ? MULDIV_STATE_REMD_CHCK
              // If it is not div-need-correction, then jump to 0th 
                                         : MULDIV_STATE_0TH
                );

      // **** If the current state is REMD_CHCK,
          // If it is div-need-correction, then jump to QUOT_CORR state
          //   otherwise jump to the 0th
  assign state_remd_chck_exit_ena = (muldiv_sta_is_remd_chck & ( 
              // If it is div op, then jump to DIV_CHECK state
                                              (div_need_corrct ? 1'b1
              // If it is not div-need-correction, then jump to 0th 
                                                         : muldiv_o_hsked) 
                                              | flush_pulse )) ;
  assign state_remd_chck_nxt      = flush_pulse ? MULDIV_STATE_0TH :
              // If it is div-need-correction, then jump to QUOT_CORR state
                         div_need_corrct ? MULDIV_STATE_QUOT_CORR
              // If it is not div-need-correction, then jump to 0th 
                                         : MULDIV_STATE_0TH;

      // **** If the current state is QUOT_CORR,
          // Always jump to REMD_CORR state
  assign state_quot_corr_exit_ena = (muldiv_sta_is_quot_corr & (flush_pulse | 1'b1));
  assign state_quot_corr_nxt      = flush_pulse ? MULDIV_STATE_0TH : MULDIV_STATE_REMD_CORR;

                
      // **** If the current state is REMD_CORR,
              // Then jump to 0th 
  assign state_remd_corr_exit_ena = (muldiv_sta_is_remd_corr & (flush_pulse | muldiv_o_hsked));
  assign state_remd_corr_nxt      = flush_pulse ? MULDIV_STATE_0TH : MULDIV_STATE_0TH;

  // The state will only toggle when each state is meeting the condition to exit 
  assign muldiv_state_ena = state_0th_exit_ena 
                          | state_exec_exit_ena  
                          | state_remd_chck_exit_ena  
                          | state_quot_corr_exit_ena  
                          | state_remd_corr_exit_ena;  

  // The next-state is onehot mux to select different entries
  assign muldiv_state_nxt = 
              ({MULDIV_STATE_WIDTH{state_0th_exit_ena      }} & state_0th_nxt      )
            | ({MULDIV_STATE_WIDTH{state_exec_exit_ena     }} & state_exec_nxt     )
            | ({MULDIV_STATE_WIDTH{state_remd_chck_exit_ena}} & state_remd_chck_nxt)
            | ({MULDIV_STATE_WIDTH{state_quot_corr_exit_ena}} & state_quot_corr_nxt)
            | ({MULDIV_STATE_WIDTH{state_remd_corr_exit_ena}} & state_remd_corr_nxt)
              ;

  sirv_gnrl_dfflr #(MULDIV_STATE_WIDTH) muldiv_state_dfflr (muldiv_state_ena, muldiv_state_nxt, muldiv_state_r, clk, rst_n);

  wire state_exec_enter_ena = muldiv_state_ena & (muldiv_state_nxt == MULDIV_STATE_EXEC);

  localparam EXEC_CNT_W  = 6;
  localparam EXEC_CNT_1  = 6'd1 ;
  localparam EXEC_CNT_16 = 6'd16;
  localparam EXEC_CNT_32 = 6'd32;

  wire[EXEC_CNT_W-1:0] exec_cnt_r;
  wire exec_cnt_set = state_exec_enter_ena;
  wire exec_cnt_inc = muldiv_sta_is_exec & (~exec_last_cycle); 
  wire exec_cnt_ena = exec_cnt_inc | exec_cnt_set; 
    // When set, the counter is set to 1, because the 0th state also counted as 0th cycle
  wire[EXEC_CNT_W-1:0] exec_cnt_nxt = exec_cnt_set ? EXEC_CNT_1 : (exec_cnt_r + 1'b1);
  sirv_gnrl_dfflr #(EXEC_CNT_W) exec_cnt_dfflr (exec_cnt_ena, exec_cnt_nxt, exec_cnt_r, clk, rst_n);
  // The exec state is the last cycle when the exec_cnt_r is reaching the last cycle (16 or 32cycles)

  wire cycle_0th  = muldiv_sta_is_0th;
  wire cycle_16th = (exec_cnt_r == EXEC_CNT_16);
  wire cycle_32nd = (exec_cnt_r == EXEC_CNT_32);
  assign mul_exec_last_cycle = cycle_16th;
  assign div_exec_last_cycle = cycle_32nd;
  assign exec_last_cycle = i_op_mul ? mul_exec_last_cycle : div_exec_last_cycle;



///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
// Use booth-4 algorithm to conduct the multiplication

  wire [32:0] part_prdt_hi_r;
  wire [32:0] part_prdt_lo_r;
  wire [32:0] part_prdt_hi_nxt;
  wire [32:0] part_prdt_lo_nxt;

  wire part_prdt_sft1_r;
  wire [2:0] booth_code = cycle_0th  ? {muldiv_i_rs1[1:0],1'b0}
                        : cycle_16th ? {mul_rs1_sign,part_prdt_lo_r[0],part_prdt_sft1_r}
                        : {part_prdt_lo_r[1:0],part_prdt_sft1_r};
      //booth_code == 3'b000 =  0
      //booth_code == 3'b001 =  1
      //booth_code == 3'b010 =  1
      //booth_code == 3'b011 =  2
      //booth_code == 3'b100 = -2
      //booth_code == 3'b101 = -1
      //booth_code == 3'b110 = -1
      //booth_code == 3'b111 = -0
  wire booth_sel_zero = (booth_code == 3'b000) | (booth_code == 3'b111);
  wire booth_sel_two  = (booth_code == 3'b011) | (booth_code == 3'b100);
  wire booth_sel_one  = (~booth_sel_zero) & (~booth_sel_two);
  wire booth_sel_sub  = booth_code[2];  

  // 35 bits adder needed
  wire [`E203_MULDIV_ADDER_WIDTH-1:0] mul_exe_alu_res = muldiv_req_alu_res;
  wire [`E203_MULDIV_ADDER_WIDTH-1:0] mul_exe_alu_op2 = 
      ({`E203_MULDIV_ADDER_WIDTH{booth_sel_zero}} & `E203_MULDIV_ADDER_WIDTH'b0) 
    | ({`E203_MULDIV_ADDER_WIDTH{booth_sel_one }} & {mul_rs2_sign,mul_rs2_sign,mul_rs2_sign,muldiv_i_rs2}) 
    | ({`E203_MULDIV_ADDER_WIDTH{booth_sel_two }} & {mul_rs2_sign,mul_rs2_sign,muldiv_i_rs2,1'b0}) 
      ;
  wire [`E203_MULDIV_ADDER_WIDTH-1:0] mul_exe_alu_op1 =
       cycle_0th ? `E203_MULDIV_ADDER_WIDTH'b0 : {part_prdt_hi_r[32],part_prdt_hi_r[32],part_prdt_hi_r};  
  wire mul_exe_alu_add = (~booth_sel_sub);
  wire mul_exe_alu_sub = booth_sel_sub;

  assign part_prdt_hi_nxt = mul_exe_alu_res[34:2];
  assign part_prdt_lo_nxt = {mul_exe_alu_res[1:0],
                         (cycle_0th ? {mul_rs1_sign,muldiv_i_rs1[31:2]} : part_prdt_lo_r[32:2])
                         };
  wire part_prdt_sft1_nxt = cycle_0th ? muldiv_i_rs1[1] : part_prdt_lo_r[1];

  wire mul_exe_cnt_set = exec_cnt_set & i_op_mul;
  wire mul_exe_cnt_inc = exec_cnt_inc & i_op_mul; 

  wire part_prdt_hi_ena = mul_exe_cnt_set | mul_exe_cnt_inc | state_exec_exit_ena;
  wire part_prdt_lo_ena = part_prdt_hi_ena;

  sirv_gnrl_dfflr #(1) part_prdt_sft1_dfflr (part_prdt_lo_ena, part_prdt_sft1_nxt, part_prdt_sft1_r, clk, rst_n);

    // This mul_res is not back2back case, so directly from the adder result
  wire[`E203_XLEN-1:0] mul_res = i_mul ? part_prdt_lo_r[32:1] : mul_exe_alu_res[31:0];




///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
// The Divider Implementation, using the non-restoring signed division 
  wire [32:0] part_remd_r;
  wire [32:0] part_quot_r;

  wire div_rs1_sign = (i_divu | i_remu) ? 1'b0 : muldiv_i_rs1[`E203_XLEN-1];
  wire div_rs2_sign = (i_divu | i_remu) ? 1'b0 : muldiv_i_rs2[`E203_XLEN-1];

  wire [65:0] dividend = {{33{div_rs1_sign}}, div_rs1_sign, muldiv_i_rs1};
  wire [33:0] divisor  = {div_rs2_sign, div_rs2_sign, muldiv_i_rs2};

  wire quot_0cycl = (dividend[65] ^ divisor[33]) ? 1'b0 : 1'b1;// If the sign(s0)!=sign(d), then set q_1st = -1

  wire [66:0] dividend_lsft1 = {dividend[65:0],quot_0cycl};


  wire prev_quot = cycle_0th ? quot_0cycl : part_quot_r[0];

  wire part_remd_sft1_r;
  // 34 bits adder needed
  wire [33:0] div_exe_alu_res = muldiv_req_alu_res[33:0];
  wire [33:0] div_exe_alu_op1 = cycle_0th ? dividend_lsft1[66:33] : {part_remd_sft1_r, part_remd_r[32:0]};
  wire [33:0] div_exe_alu_op2 = divisor;
  wire div_exe_alu_add = (~prev_quot);
  wire div_exe_alu_sub =   prev_quot ;

  wire current_quot = (div_exe_alu_res[33] ^ divisor[33]) ? 1'b0 : 1'b1;

  wire [66:0] div_exe_part_remd;
  assign div_exe_part_remd[66:33] = div_exe_alu_res;
  assign div_exe_part_remd[32: 0] = cycle_0th ? dividend_lsft1[32:0] : part_quot_r[32:0];

  wire [67:0] div_exe_part_remd_lsft1 = {div_exe_part_remd[66:0],current_quot};

  wire part_remd_ena;
    // Since the part_remd_r is only save 33bits (after left shifted), so the adder result MSB bit we need to save
    //   it here, which will be used at next round
  sirv_gnrl_dfflr #(1) part_remd_sft1_dfflr (part_remd_ena, div_exe_alu_res[32], part_remd_sft1_r, clk, rst_n);
  
  wire div_exe_cnt_set = exec_cnt_set & i_op_div;
  wire div_exe_cnt_inc = exec_cnt_inc & i_op_div; 

  wire corrct_phase = muldiv_sta_is_remd_corr | muldiv_sta_is_quot_corr;
  wire check_phase  = muldiv_sta_is_remd_chck;

  wire [33:0] div_quot_corr_alu_res;
  wire [33:0] div_remd_corr_alu_res;
       // Note: in last cycle, the reminder value is the non-shifted value
       //   but the quotient value is the shifted value, and last bit of quotient value is shifted always by 1 
       // If need corrective, the correct quot first, and then reminder, so reminder output as comb logic directly to 
           // save a cycle
  wire [32:0] div_remd = check_phase  ? part_remd_r [32:0]:
                         corrct_phase ? div_remd_corr_alu_res[32:0] :
                                        div_exe_part_remd[65:33];
  wire [32:0] div_quot = check_phase  ? part_quot_r [32:0]:
                         corrct_phase ? part_quot_r [32:0]: 
                                        {div_exe_part_remd[31:0],1'b1};

  // The partial reminder and quotient   
  wire [32:0] part_remd_nxt = corrct_phase ? div_remd_corr_alu_res[32:0] :
                              (muldiv_sta_is_exec & div_exec_last_cycle) ? div_remd :
                                                          div_exe_part_remd_lsft1[65:33];
  wire [32:0] part_quot_nxt = corrct_phase ? div_quot_corr_alu_res[32:0] :
                              (muldiv_sta_is_exec & div_exec_last_cycle) ? div_quot :
                                                          div_exe_part_remd_lsft1[32: 0];

  wire [33:0] div_remd_chck_alu_res = muldiv_req_alu_res[33:0];
  wire [33:0] div_remd_chck_alu_op1 = {part_remd_r[32], part_remd_r};
  wire [33:0] div_remd_chck_alu_op2 = divisor;
  wire div_remd_chck_alu_add = 1'b1;
  wire div_remd_chck_alu_sub = 1'b0;

  wire remd_is_0 = ~(|part_remd_r);
  wire remd_is_neg_divs = ~(|div_remd_chck_alu_res); 
  wire remd_is_divs = (part_remd_r == divisor[32:0]);
  assign div_need_corrct = i_op_div & (
                                ((part_remd_r[32] ^ dividend[65]) & (~remd_is_0))
                              | remd_is_neg_divs
                              | remd_is_divs
                            );

  wire remd_inc_quot_dec = (part_remd_r[32] ^ divisor[33]);

  assign div_quot_corr_alu_res = muldiv_req_alu_res[33:0];
  wire [33:0] div_quot_corr_alu_op1 = {part_quot_r[32], part_quot_r};
  wire [33:0] div_quot_corr_alu_op2 = 34'b1;
  wire div_quot_corr_alu_add = (~remd_inc_quot_dec);
  wire div_quot_corr_alu_sub = remd_inc_quot_dec;

  assign div_remd_corr_alu_res = muldiv_req_alu_res[33:0];
  wire [33:0] div_remd_corr_alu_op1 = {part_remd_r[32], part_remd_r};
  wire [33:0] div_remd_corr_alu_op2 = divisor;
  wire div_remd_corr_alu_add = remd_inc_quot_dec;
  wire div_remd_corr_alu_sub = ~remd_inc_quot_dec;

  // The partial reminder register will be loaded in the exe state, and in reminder correction cycle
  assign part_remd_ena = div_exe_cnt_set | div_exe_cnt_inc | state_exec_exit_ena | state_remd_corr_exit_ena;
  // The partial quotient register will be loaded in the exe state, and in quotient correction cycle
  wire part_quot_ena = div_exe_cnt_set | div_exe_cnt_inc | state_exec_exit_ena | state_quot_corr_exit_ena;

  wire[`E203_XLEN-1:0] div_res = (i_div | i_divu) ? div_quot[`E203_XLEN-1:0] : div_remd[`E203_XLEN-1:0];



  wire div_by_0 = ~(|muldiv_i_rs2);// Divisor is all zeros
  wire div_ovf  = (i_div | i_rem) & (&muldiv_i_rs2)  // Divisor is all ones, means -1
                        //Dividend is 10000...000, means -(2^xlen -1)
                & muldiv_i_rs1[`E203_XLEN-1] & (~(|muldiv_i_rs1[`E203_XLEN-2:0]));

  wire[`E203_XLEN-1:0] div_by_0_res_quot = ~`E203_XLEN'b0;
  wire[`E203_XLEN-1:0] div_by_0_res_remd = dividend[`E203_XLEN-1:0];
  wire[`E203_XLEN-1:0] div_by_0_res = (i_div | i_divu) ? div_by_0_res_quot : div_by_0_res_remd;

  wire[`E203_XLEN-1:0] div_ovf_res_quot  = {1'b1,{`E203_XLEN-1{1'b0}}};
  wire[`E203_XLEN-1:0] div_ovf_res_remd  = `E203_XLEN'b0;
  wire[`E203_XLEN-1:0] div_ovf_res = (i_div | i_divu) ? div_ovf_res_quot : div_ovf_res_remd;

  wire div_special_cases = i_op_div & (div_by_0 | div_ovf);
  wire[`E203_XLEN-1:0] div_special_res = div_by_0 ? div_by_0_res : div_ovf_res;



///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
// Output generateion
  assign special_cases = div_special_cases;// Only divider have special cases
  wire[`E203_XLEN-1:0] special_res = div_special_res;// Only divider have special cases

  // To detect the sequence of MULH[[S]U] rdh, rs1, rs2;    MUL rdl, rs1, rs2
  // To detect the sequence of     DIV[U] rdq, rs1, rs2; REM[U] rdr, rs1, rs2  
  wire [`E203_XLEN-1:0] back2back_mul_res = {part_prdt_lo_r[`E203_XLEN-2:0],part_prdt_sft1_r};// Only the MUL will be treated as back2back
  wire [`E203_XLEN-1:0] back2back_mul_rem = part_remd_r[`E203_XLEN-1:0];
  wire [`E203_XLEN-1:0] back2back_mul_div = part_quot_r[`E203_XLEN-1:0];
  wire [`E203_XLEN-1:0] back2back_res = (
             ({`E203_XLEN{i_mul         }} & back2back_mul_res)
           | ({`E203_XLEN{i_rem | i_remu}} & back2back_mul_rem)
           | ({`E203_XLEN{i_div | i_divu}} & back2back_mul_div)
     );

    // The output will be valid:
    //   * If it is back2back and sepcial cases, just directly pass out from input
    //   * If it is not back2back sequence when it is the last cycle of exec state 
    //     (not div need correction) or last correct state;
  wire wbck_condi = (back2back_seq | special_cases) ? 1'b1 : 
                       (
                           (muldiv_sta_is_exec & exec_last_cycle & (~i_op_div))
                         | (muldiv_sta_is_remd_chck & (~div_need_corrct)) 
                         | muldiv_sta_is_remd_corr 
                       );
  assign muldiv_o_valid = wbck_condi & muldiv_i_valid;
  assign muldiv_i_ready = wbck_condi & muldiv_o_ready;
  wire res_sel_spl = special_cases;
  wire res_sel_b2b  = back2back_seq & (~special_cases);
  wire res_sel_div  = (~back2back_seq) & (~special_cases) & i_op_div;
  wire res_sel_mul  = (~back2back_seq) & (~special_cases) & i_op_mul;
  assign muldiv_o_wbck_wdat = 
               ({`E203_XLEN{res_sel_b2b}} & back2back_res)
             | ({`E203_XLEN{res_sel_spl}} & special_res)
             | ({`E203_XLEN{res_sel_div}} & div_res)
             | ({`E203_XLEN{res_sel_mul}} & mul_res);

  //   There is no exception cases for MULDIV, so no addtional cmt signals
  assign muldiv_o_wbck_err = 1'b0;

     // The operands and info to ALU
  wire req_alu_sel1 = i_op_mul;
  wire req_alu_sel2 = i_op_div & (muldiv_sta_is_0th | muldiv_sta_is_exec);
  wire req_alu_sel3 = i_op_div & muldiv_sta_is_quot_corr;
  wire req_alu_sel4 = i_op_div & muldiv_sta_is_remd_corr;
  wire req_alu_sel5 = i_op_div & muldiv_sta_is_remd_chck;

  assign muldiv_req_alu_op1 = 
             ({`E203_MULDIV_ADDER_WIDTH{req_alu_sel1}} & mul_exe_alu_op1      )
           | ({`E203_MULDIV_ADDER_WIDTH{req_alu_sel2}} & {{`E203_MULDIV_ADDER_WIDTH-34{1'b0}},div_exe_alu_op1      })
           | ({`E203_MULDIV_ADDER_WIDTH{req_alu_sel3}} & {{`E203_MULDIV_ADDER_WIDTH-34{1'b0}},div_quot_corr_alu_op1})
           | ({`E203_MULDIV_ADDER_WIDTH{req_alu_sel4}} & {{`E203_MULDIV_ADDER_WIDTH-34{1'b0}},div_remd_corr_alu_op1}) 
           | ({`E203_MULDIV_ADDER_WIDTH{req_alu_sel5}} & {{`E203_MULDIV_ADDER_WIDTH-34{1'b0}},div_remd_chck_alu_op1});

  assign muldiv_req_alu_op2 = 
             ({`E203_MULDIV_ADDER_WIDTH{req_alu_sel1}} & mul_exe_alu_op2      )
           | ({`E203_MULDIV_ADDER_WIDTH{req_alu_sel2}} & {{`E203_MULDIV_ADDER_WIDTH-34{1'b0}},div_exe_alu_op2      })
           | ({`E203_MULDIV_ADDER_WIDTH{req_alu_sel3}} & {{`E203_MULDIV_ADDER_WIDTH-34{1'b0}},div_quot_corr_alu_op2})
           | ({`E203_MULDIV_ADDER_WIDTH{req_alu_sel4}} & {{`E203_MULDIV_ADDER_WIDTH-34{1'b0}},div_remd_corr_alu_op2}) 
           | ({`E203_MULDIV_ADDER_WIDTH{req_alu_sel5}} & {{`E203_MULDIV_ADDER_WIDTH-34{1'b0}},div_remd_chck_alu_op2});

  assign muldiv_req_alu_add  = 
             (req_alu_sel1 & mul_exe_alu_add      )
           | (req_alu_sel2 & div_exe_alu_add      )
           | (req_alu_sel3 & div_quot_corr_alu_add)
           | (req_alu_sel4 & div_remd_corr_alu_add) 
           | (req_alu_sel5 & div_remd_chck_alu_add);

  assign muldiv_req_alu_sub  = 
             (req_alu_sel1 & mul_exe_alu_sub      )
           | (req_alu_sel2 & div_exe_alu_sub      )
           | (req_alu_sel3 & div_quot_corr_alu_sub)
           | (req_alu_sel4 & div_remd_corr_alu_sub) 
           | (req_alu_sel5 & div_remd_chck_alu_sub);

  assign muldiv_sbf_0_ena = part_remd_ena | part_prdt_hi_ena;
  assign muldiv_sbf_0_nxt = i_op_mul ? part_prdt_hi_nxt : part_remd_nxt;

  assign muldiv_sbf_1_ena = part_quot_ena | part_prdt_lo_ena;
  assign muldiv_sbf_1_nxt = i_op_mul ? part_prdt_lo_nxt : part_quot_nxt;

  assign part_remd_r = muldiv_sbf_0_r;
  assign part_quot_r = muldiv_sbf_1_r;
  assign part_prdt_hi_r = muldiv_sbf_0_r;
  assign part_prdt_lo_r = muldiv_sbf_1_r;

  assign muldiv_i_longpipe = 1'b0;





`ifndef FPGA_SOURCE//{
`ifndef DISABLE_SV_ASSERTION//{
//synopsys translate_off
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
// These below code are used for reference check with assertion
  wire [31:0] golden0_mul_op1 = mul_op1[32] ? (~mul_op1[31:0]+1) : mul_op1[31:0];
  wire [31:0] golden0_mul_op2 = mul_op2[32] ? (~mul_op2[31:0]+1) : mul_op2[31:0];
  wire [63:0] golden0_mul_res_pre = golden0_mul_op1 * golden0_mul_op2;
  wire [63:0] golden0_mul_res = (mul_op1[32]^mul_op2[32]) ? (~golden0_mul_res_pre + 1) : golden0_mul_res_pre;
  wire [63:0] golden1_mul_res = $signed(mul_op1) * $signed(mul_op2); 
  
  // To check the signed * operation is really get what we wanted
    CHECK_SIGNED_OP_CORRECT:
      assert property (@(posedge clk) disable iff ((~rst_n) | (~muldiv_o_valid))  ((golden0_mul_res == golden1_mul_res)))
      else $fatal ("\n Error: Oops, This should never happen. \n");

  wire [31:0] golden1_res_mul    = golden1_mul_res[31:0];
  wire [31:0] golden1_res_mulh   = golden1_mul_res[63:32];                       
  wire [31:0] golden1_res_mulhsu = golden1_mul_res[63:32];                                              
  wire [31:0] golden1_res_mulhu  = golden1_mul_res[63:32];                                                

  wire [63:0] golden2_res_mul_SxS = $signed(muldiv_i_rs1)   * $signed(muldiv_i_rs2);
  wire [63:0] golden2_res_mul_SxU = $signed(muldiv_i_rs1)   * $unsigned(muldiv_i_rs2);
  wire [63:0] golden2_res_mul_UxS = $unsigned(muldiv_i_rs1) * $signed(muldiv_i_rs2);
  wire [63:0] golden2_res_mul_UxU = $unsigned(muldiv_i_rs1) * $unsigned(muldiv_i_rs2);
  
  wire [31:0] golden2_res_mul    = golden2_res_mul_SxS[31:0];
  wire [31:0] golden2_res_mulh   = golden2_res_mul_SxS[63:32];                       
  wire [31:0] golden2_res_mulhsu = golden2_res_mul_SxU[63:32];                                              
  wire [31:0] golden2_res_mulhu  = golden2_res_mul_UxU[63:32];                                                

  // To check four different combination will all generate same lower 32bits result
    CHECK_FOUR_COMB_SAME_RES:
      assert property (@(posedge clk) disable iff ((~rst_n) | (~muldiv_o_valid))
          (golden2_res_mul_SxS[31:0] == golden2_res_mul_SxU[31:0])
        & (golden2_res_mul_UxS[31:0] == golden2_res_mul_UxU[31:0])
        & (golden2_res_mul_SxU[31:0] == golden2_res_mul_UxS[31:0])
       )
      else $fatal ("\n Error: Oops, This should never happen. \n");

      // Seems the golden2 result is not correct in case of mulhsu, so have to comment it out
 // // To check golden1 and golden2 result are same
 //   CHECK_GOLD1_AND_GOLD2_SAME:
 //     assert property (@(posedge clk) disable iff ((~rst_n) | (~muldiv_o_valid))
 //         (i_mul    ? (golden1_res_mul    == golden2_res_mul   ) : 1'b1)
 //        &(i_mulh   ? (golden1_res_mulh   == golden2_res_mulh  ) : 1'b1)
 //        &(i_mulhsu ? (golden1_res_mulhsu == golden2_res_mulhsu) : 1'b1)
 //        &(i_mulhu  ? (golden1_res_mulhu  == golden2_res_mulhu ) : 1'b1)
 //      )
 //     else $fatal ("\n Error: Oops, This should never happen. \n");
      
     // The special case will need to be handled specially
  wire [32:0] golden_res_div  = div_special_cases ? div_special_res : 
     (  $signed({div_rs1_sign,muldiv_i_rs1})   / ((div_by_0 | div_ovf) ? 1 :   $signed({div_rs2_sign,muldiv_i_rs2})));
  wire [32:0] golden_res_divu  = div_special_cases ? div_special_res : 
     ($unsigned({div_rs1_sign,muldiv_i_rs1})   / ((div_by_0 | div_ovf) ? 1 : $unsigned({div_rs2_sign,muldiv_i_rs2})));
  wire [32:0] golden_res_rem  = div_special_cases ? div_special_res : 
     (  $signed({div_rs1_sign,muldiv_i_rs1})   % ((div_by_0 | div_ovf) ? 1 :   $signed({div_rs2_sign,muldiv_i_rs2})));
  wire [32:0] golden_res_remu  = div_special_cases ? div_special_res : 
     ($unsigned({div_rs1_sign,muldiv_i_rs1})   % ((div_by_0 | div_ovf) ? 1 : $unsigned({div_rs2_sign,muldiv_i_rs2})));
 
  // To check golden and actual result are same
  wire [`E203_XLEN-1:0] golden_res = 
         i_mul    ? golden1_res_mul    :
         i_mulh   ? golden1_res_mulh   :
         i_mulhsu ? golden1_res_mulhsu :
         i_mulhu  ? golden1_res_mulhu  :
         i_div    ? golden_res_div [31:0]    :
         i_divu   ? golden_res_divu[31:0]    :
         i_rem    ? golden_res_rem [31:0]    :
         i_remu   ? golden_res_remu[31:0]    :
                    `E203_XLEN'b0;

  CHECK_GOLD_AND_ACTUAL_SAME:
        // Since the printed value is not aligned with posedge clock, so change it to negetive
    assert property (@(negedge clk) disable iff ((~rst_n) | flush_pulse)
        (muldiv_o_valid ? (golden_res == muldiv_o_wbck_wdat   ) : 1'b1)
     )
    else begin
        $display("??????????????????????????????????????????");
        $display("??????????????????????????????????????????");
        $display("{i_mul,i_mulh,i_mulhsu,i_mulhu,i_div,i_divu,i_rem,i_remu}=%d%d%d%d%d%d%d%d",i_mul,i_mulh,i_mulhsu,i_mulhu,i_div,i_divu,i_rem,i_remu);
        $display("muldiv_i_rs1=%h\nmuldiv_i_rs2=%h\n",muldiv_i_rs1,muldiv_i_rs2);     
        $display("golden_res=%h\nmuldiv_o_wbck_wdat=%h",golden_res,muldiv_o_wbck_wdat);     
        $display("??????????????????????????????????????????");
        $fatal ("\n Error: Oops, This should never happen. \n");
      end

//synopsys translate_on
`endif//}
`endif//}


endmodule                                      
`endif//}
                                               
                                               
                                               
