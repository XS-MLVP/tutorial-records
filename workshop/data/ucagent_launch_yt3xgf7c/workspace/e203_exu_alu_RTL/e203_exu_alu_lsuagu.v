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
//  This module to implement the AGU (address generation unit for load/store 
//  and AMO instructions), which is mostly share the datapath with ALU module
//  to save gatecount to mininum
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



module e203_exu_alu_lsuagu(

  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The Issue Handshake Interface to AGU 
  //
  input  agu_i_valid, // Handshake valid
  output agu_i_ready, // Handshake ready

  input  [31:0] agu_i_rs1,
  input  [31:0] agu_i_rs2,
  input  [31:0] agu_i_imm,
  input  [20:0] agu_i_info,
  input  [0:0] agu_i_itag,

  output agu_i_longpipe,

  input  flush_req,
  input  flush_pulse,

  output amo_wait,
  input  oitf_empty,

  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The AGU Write-Back/Commit Interface
  output agu_o_valid, // Handshake valid
  input  agu_o_ready, // Handshake ready
  output [31:0] agu_o_wbck_wdat,
  output agu_o_wbck_err,   
  //   The Commit Interface for all ldst and amo instructions
  output agu_o_cmt_misalgn, // The misalign exception generated
  output agu_o_cmt_ld, 
  output agu_o_cmt_stamo,
  output agu_o_cmt_buserr, // The bus-error exception generated
  output [31:0] agu_o_cmt_badaddr,

  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // The ICB Interface to LSU-ctrl
  //    * Bus cmd channel
  output                       agu_icb_cmd_valid, // Handshake valid
  input                        agu_icb_cmd_ready, // Handshake ready
        // Note: The data on rdata or wdata channel must be naturally
        //       aligned, this is in line with the AXI definition
  output [31:0] agu_icb_cmd_addr, // Bus transaction start addr 
  output                       agu_icb_cmd_read,   // Read or write
  output [31:0]      agu_icb_cmd_wdata, 
  output [3:0]    agu_icb_cmd_wmask, 
  output                       agu_icb_cmd_back2agu, 
  output                       agu_icb_cmd_lock,
  output                       agu_icb_cmd_excl,
  output [1:0]                 agu_icb_cmd_size,
  output [0:0]agu_icb_cmd_itag,
  output                       agu_icb_cmd_usign,

  //    * Bus RSP channel
  input                        agu_icb_rsp_valid, // Response valid 
  output                       agu_icb_rsp_ready, // Response ready
  input                        agu_icb_rsp_err  , // Response error
  input                        agu_icb_rsp_excl_ok,
        // Note: the RSP rdata is inline with AXI definition
  input  [31:0]      agu_icb_rsp_rdata,


  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // To share the ALU datapath, generate interface to ALU
  //   for single-issue machine, seems the AGU must be shared with ALU, otherwise
  //   it wasted the area for no points 
  // 
    // The operands and info to ALU
  output [31:0] agu_req_alu_op1,
  output [31:0] agu_req_alu_op2,
  output agu_req_alu_swap,
  output agu_req_alu_add ,
  output agu_req_alu_and ,
  output agu_req_alu_or  ,
  output agu_req_alu_xor ,
  output agu_req_alu_max ,
  output agu_req_alu_min ,
  output agu_req_alu_maxu,
  output agu_req_alu_minu,
  input  [31:0] agu_req_alu_res,

    // The Shared-Buffer interface to ALU-Shared-Buffer
  output agu_sbf_0_ena,
  output [31:0] agu_sbf_0_nxt,
  input  [31:0] agu_sbf_0_r,

  output agu_sbf_1_ena,
  output [31:0] agu_sbf_1_nxt,
  input  [31:0] agu_sbf_1_r,

  input  clk,
  input  rst_n
  );

  //

      // When there is a nonalu_flush which is going to flush the ALU, then we need to mask off it
  wire       icb_sta_is_idle;
  wire       flush_block = flush_req & icb_sta_is_idle; 

  wire       agu_i_load    = agu_i_info [`E203_DECINFO_AGU_LOAD   ] & (~flush_block);
  wire       agu_i_store   = agu_i_info [`E203_DECINFO_AGU_STORE  ] & (~flush_block);
  wire       agu_i_amo     = agu_i_info [`E203_DECINFO_AGU_AMO    ] & (~flush_block);

  wire [1:0] agu_i_size    = agu_i_info [`E203_DECINFO_AGU_SIZE   ];
  wire       agu_i_usign   = agu_i_info [`E203_DECINFO_AGU_USIGN  ];
  wire       agu_i_excl    = agu_i_info [`E203_DECINFO_AGU_EXCL   ];
  wire       agu_i_amoswap = agu_i_info [`E203_DECINFO_AGU_AMOSWAP];
  wire       agu_i_amoadd  = agu_i_info [`E203_DECINFO_AGU_AMOADD ];
  wire       agu_i_amoand  = agu_i_info [`E203_DECINFO_AGU_AMOAND ];
  wire       agu_i_amoor   = agu_i_info [`E203_DECINFO_AGU_AMOOR  ];
  wire       agu_i_amoxor  = agu_i_info [`E203_DECINFO_AGU_AMOXOR ];
  wire       agu_i_amomax  = agu_i_info [`E203_DECINFO_AGU_AMOMAX ];
  wire       agu_i_amomin  = agu_i_info [`E203_DECINFO_AGU_AMOMIN ];
  wire       agu_i_amomaxu = agu_i_info [`E203_DECINFO_AGU_AMOMAXU];
  wire       agu_i_amominu = agu_i_info [`E203_DECINFO_AGU_AMOMINU];


  wire agu_icb_cmd_hsked = agu_icb_cmd_valid & agu_icb_cmd_ready; 
  `ifdef E203_SUPPORT_AMO//{
  wire agu_icb_rsp_hsked = agu_icb_rsp_valid & agu_icb_rsp_ready; 
  `endif//E203_SUPPORT_AMO}
    // These strange ifdef/ifndef rather than the ifdef-else, because of 
    //   our internal text processing scripts need this style
  `ifndef E203_SUPPORT_AMO//{
    `ifndef E203_SUPPORT_UNALGNLDST//{
  wire agu_icb_rsp_hsked = 1'b0;
    `endif//}
  `endif//}

  wire agu_i_size_b  = (agu_i_size == 2'b00);
  wire agu_i_size_hw = (agu_i_size == 2'b01);
  wire agu_i_size_w  = (agu_i_size == 2'b10);

  wire agu_i_addr_unalgn = 
            (agu_i_size_hw &  agu_icb_cmd_addr[0])
          | (agu_i_size_w  &  (|agu_icb_cmd_addr[1:0]));

  wire state_last_exit_ena;
  `ifdef E203_SUPPORT_AMO//{
  wire state_idle_exit_ena;
  wire unalgn_flg_r;
  // Set when the ICB state is starting and it is unalign
  wire unalgn_flg_set = agu_i_addr_unalgn & state_idle_exit_ena;
  // Clear when the ICB state is entering
  wire unalgn_flg_clr = unalgn_flg_r & state_last_exit_ena;
  wire unalgn_flg_ena = unalgn_flg_set | unalgn_flg_clr;
  wire unalgn_flg_nxt = unalgn_flg_set | (~unalgn_flg_clr);
  sirv_gnrl_dfflr #(1) unalgn_flg_dffl (unalgn_flg_ena, unalgn_flg_nxt, unalgn_flg_r, clk, rst_n);
  `endif//E203_SUPPORT_AMO}

  wire agu_addr_unalgn = 
  `ifndef E203_SUPPORT_UNALGNLDST//{
      `ifdef E203_SUPPORT_AMO//{
      icb_sta_is_idle ? agu_i_addr_unalgn : unalgn_flg_r;
      `endif//E203_SUPPORT_AMO}
      `ifndef E203_SUPPORT_AMO//{
      agu_i_addr_unalgn;
      `endif//}
  `endif//}

 
  wire agu_i_unalgnld = (agu_addr_unalgn & agu_i_load)
                      ;
  wire agu_i_unalgnst = (agu_addr_unalgn & agu_i_store) 
                      ;
  wire agu_i_unalgnldst = (agu_i_unalgnld | agu_i_unalgnst)
                      ;
  wire agu_i_algnld = (~agu_addr_unalgn) & agu_i_load
                      ;
  wire agu_i_algnst = (~agu_addr_unalgn) & agu_i_store
                      ;
  wire agu_i_algnldst = (agu_i_algnld | agu_i_algnst)
                      ;

  `ifdef E203_SUPPORT_AMO//{
  wire agu_i_unalgnamo = (agu_addr_unalgn & agu_i_amo) 
                        ;
  wire agu_i_algnamo = ((~agu_addr_unalgn) & agu_i_amo) 
                        ;
  `endif//E203_SUPPORT_AMO}

  wire agu_i_ofst0  = agu_i_amo | ((agu_i_load | agu_i_store) & agu_i_excl); 


  localparam ICB_STATE_WIDTH = 4;

  wire icb_state_ena;
  wire [ICB_STATE_WIDTH-1:0] icb_state_nxt;
  wire [ICB_STATE_WIDTH-1:0] icb_state_r;

  // State 0: The idle state, means there is no any oustanding ifetch request
  localparam ICB_STATE_IDLE = 4'd0;
  `ifdef E203_SUPPORT_AMO//{
  // State  : Issued first request and wait response
  localparam ICB_STATE_1ST  = 4'd1;
  // State  : Wait to issue second request 
  localparam ICB_STATE_WAIT2ND  = 4'd2;
  // State  : Issued second request and wait response
  localparam ICB_STATE_2ND  = 4'd3;
  // State  : For AMO instructions, in this state, read-data was in leftover
  //            buffer for ALU calculation 
  localparam ICB_STATE_AMOALU  = 4'd4;
  // State  : For AMO instructions, in this state, ALU have caculated the new
  //            result and put into leftover buffer again 
  localparam ICB_STATE_AMORDY  = 4'd5;
  // State  : For AMO instructions, in this state, the response data have been returned
  //            and the write back result to commit/wback interface
  localparam ICB_STATE_WBCK  = 4'd6;
  `endif//E203_SUPPORT_AMO}
  
   
  
 
  `ifdef E203_SUPPORT_AMO//{
  wire [ICB_STATE_WIDTH-1:0] state_idle_nxt   ;
  wire [ICB_STATE_WIDTH-1:0] state_1st_nxt    ;
  wire [ICB_STATE_WIDTH-1:0] state_wait2nd_nxt;
  wire [ICB_STATE_WIDTH-1:0] state_2nd_nxt    ;
  wire [ICB_STATE_WIDTH-1:0] state_amoalu_nxt ;
  wire [ICB_STATE_WIDTH-1:0] state_amordy_nxt ;
  wire [ICB_STATE_WIDTH-1:0] state_wbck_nxt ;
  `endif//E203_SUPPORT_AMO}
  `ifdef E203_SUPPORT_AMO//{
  wire state_1st_exit_ena      ;
  wire state_wait2nd_exit_ena  ;
  wire state_2nd_exit_ena      ;
  wire state_amoalu_exit_ena   ;
  wire state_amordy_exit_ena   ;
  wire state_wbck_exit_ena   ;
  `endif//E203_SUPPORT_AMO}

  // Define some common signals and reused later to save gatecounts
  assign icb_sta_is_idle    = (icb_state_r == ICB_STATE_IDLE   );
  `ifdef E203_SUPPORT_AMO//{
  wire   icb_sta_is_1st     = (icb_state_r == ICB_STATE_1ST    );
  wire   icb_sta_is_amoalu  = (icb_state_r == ICB_STATE_AMOALU );
  wire   icb_sta_is_amordy  = (icb_state_r == ICB_STATE_AMORDY );
  wire   icb_sta_is_wait2nd = (icb_state_r == ICB_STATE_WAIT2ND);
  wire   icb_sta_is_2nd     = (icb_state_r == ICB_STATE_2ND    );
  wire   icb_sta_is_wbck    = (icb_state_r == ICB_STATE_WBCK    );
  `endif//E203_SUPPORT_AMO}


  `ifdef E203_SUPPORT_AMO//{
      // **** If the current state is idle,
          // If a new load-store come and the ICB cmd channel is handshaked, next
          //   state is ICB_STATE_1ST
  wire state_idle_to_exit =    (( agu_i_algnamo
                                  // Why do we add an oitf empty signal here? because
                                  //   it is better to start AMO state-machine when the 
                                  //   long-pipes are completed, to avoid the long-pipes 
                                  //   have error-return which need to flush the pipeline
                                  //   and which also need to wait the AMO state-machine
                                  //   to complete first, in corner cases it may end 
                                  //   up with deadlock.
                                  // Force to wait oitf empty before doing amo state-machine
                                  //   may hurt performance, but we dont care it. In e203 implementation
                                  //   the AMO was not target for performance.
                                  & oitf_empty)
                                 );
  assign state_idle_exit_ena = icb_sta_is_idle & state_idle_to_exit 
                               & agu_icb_cmd_hsked & (~flush_pulse);
  assign state_idle_nxt      = ICB_STATE_1ST;

      // **** If the current state is 1st,
          // If a response come, exit this state
  assign state_1st_exit_ena = icb_sta_is_1st & (agu_icb_rsp_hsked | flush_pulse);
  assign state_1st_nxt      = flush_pulse ? ICB_STATE_IDLE : 
                (
                 // (agu_i_algnamo) ?  // No need this condition, because it will be either
                                       // amo or unalgn load-store in this state
                  ICB_STATE_AMOALU
                );
            
      // **** If the current state is AMOALU 
              // Since the ALU is must be holdoff now, it can always be
              //   served and then enter into next state
  assign state_amoalu_exit_ena = icb_sta_is_amoalu & ( 1'b1 | flush_pulse);
  assign state_amoalu_nxt      = flush_pulse ? ICB_STATE_IDLE : ICB_STATE_AMORDY;
            
      // **** If the current state is AMORDY
              // It always enter into next state
  assign state_amordy_exit_ena = icb_sta_is_amordy & ( 1'b1 | flush_pulse);
  assign state_amordy_nxt      = flush_pulse ? ICB_STATE_IDLE : 
            (
              // AMO after caculated read-modify-result, need to issue 2nd uop as store
              //   back to memory, hence two ICB needed and we dont care the performance,
              //   so always let it jump to wait2nd state
                                       ICB_STATE_WAIT2ND
            );

      // **** If the current state is wait-2nd,
  assign state_wait2nd_exit_ena = icb_sta_is_wait2nd & (agu_icb_cmd_ready | flush_pulse);
              // If the ICB CMD is ready, then next state is ICB_STATE_2ND
  assign state_wait2nd_nxt      = flush_pulse ? ICB_STATE_IDLE : ICB_STATE_2ND;
  
      // **** If the current state is 2nd,
          // If a response come, exit this state
  assign state_2nd_exit_ena = icb_sta_is_2nd & (agu_icb_rsp_hsked | flush_pulse);
  assign state_2nd_nxt      = flush_pulse ? ICB_STATE_IDLE : 
                (
                  ICB_STATE_WBCK 
                );

       // **** If the current state is wbck,
          // If it can be write back, exit this state
  assign state_wbck_exit_ena = icb_sta_is_wbck & (agu_o_ready | flush_pulse);
  assign state_wbck_nxt      = flush_pulse ? ICB_STATE_IDLE : 
                (
                  ICB_STATE_IDLE 
                );
  `endif//E203_SUPPORT_AMO}

    // The state will only toggle when each state is meeting the condition to exit:
  assign icb_state_ena = 1'b0 
         `ifdef E203_SUPPORT_AMO//{
            | state_idle_exit_ena | state_1st_exit_ena  
            | state_amoalu_exit_ena  | state_amordy_exit_ena  
            | state_wait2nd_exit_ena | state_2nd_exit_ena   
            | state_wbck_exit_ena 
          `endif//E203_SUPPORT_AMO}
          ;

  // The next-state is onehot mux to select different entries
  assign icb_state_nxt = 
              ({ICB_STATE_WIDTH{1'b0}})
         `ifdef E203_SUPPORT_AMO//{
            | ({ICB_STATE_WIDTH{state_idle_exit_ena   }} & state_idle_nxt   )
            | ({ICB_STATE_WIDTH{state_1st_exit_ena    }} & state_1st_nxt    )
            | ({ICB_STATE_WIDTH{state_amoalu_exit_ena }} & state_amoalu_nxt )
            | ({ICB_STATE_WIDTH{state_amordy_exit_ena }} & state_amordy_nxt )
            | ({ICB_STATE_WIDTH{state_wait2nd_exit_ena}} & state_wait2nd_nxt)
            | ({ICB_STATE_WIDTH{state_2nd_exit_ena    }} & state_2nd_nxt    )
            | ({ICB_STATE_WIDTH{state_wbck_exit_ena   }} & state_wbck_nxt   )
          `endif//E203_SUPPORT_AMO}
              ;


  sirv_gnrl_dfflr #(ICB_STATE_WIDTH) icb_state_dfflr (icb_state_ena, icb_state_nxt, icb_state_r, clk, rst_n);


  `ifdef E203_SUPPORT_AMO//{
  wire  icb_sta_is_last = icb_sta_is_wbck;
  `endif//E203_SUPPORT_AMO}
  `ifndef E203_SUPPORT_AMO//{
  wire  icb_sta_is_last = 1'b0; 
  `endif//}

  `ifdef E203_SUPPORT_AMO//{
  assign state_last_exit_ena = state_wbck_exit_ena;
  `endif//E203_SUPPORT_AMO}
  `ifndef E203_SUPPORT_AMO//{
  assign state_last_exit_ena = 1'b0;
  `endif//}

  `ifndef E203_SUPPORT_UNALGNLDST//{
  `else//}{
      `ifndef E203_SUPPORT_AMO 
  !!!! ERROR: This config is not supported, must be something wrong 
      `endif//}
  `endif//


      // Indicate there is no oustanding memory transactions
  `ifdef E203_SUPPORT_AMO//{
                    // As long as the statemachine started, we must wait it to be empty
                    // We cannot really kill this instruction when IRQ comes, becuase
                    // the AMO uop alreay write data into the memory, and we must commit
                    // this instructions
  assign amo_wait = ~icb_sta_is_idle;
  `endif//E203_SUPPORT_AMO}
  `ifndef E203_SUPPORT_AMO//{
  assign amo_wait = 1'b0;// If no AMO or UNaligned supported, then always 0
  `endif//}
  //
  /////////////////////////////////////////////////////////////////////////////////
  // Implement the leftover 0 buffer
  wire leftover_ena;
  wire [`E203_XLEN-1:0] leftover_nxt;
  wire [`E203_XLEN-1:0] leftover_r;
  wire leftover_err_nxt;
  wire leftover_err_r;

  wire [`E203_XLEN-1:0] leftover_1_r;
  wire leftover_1_ena;
  wire [`E203_XLEN-1:0] leftover_1_nxt;
  //
 `ifdef E203_SUPPORT_AMO//{
  wire amo_1stuop = icb_sta_is_1st & agu_i_algnamo;
  wire amo_2nduop = icb_sta_is_2nd & agu_i_algnamo;
 `endif//E203_SUPPORT_AMO}
  assign leftover_ena = agu_icb_rsp_hsked & (
                   1'b0
                   `ifdef E203_SUPPORT_AMO//{
                   | amo_1stuop 
                   | amo_2nduop 
                   `endif//E203_SUPPORT_AMO}
                   );
  assign leftover_nxt = 
              {`E203_XLEN{1'b0}}
         `ifdef E203_SUPPORT_AMO//{
            | ({`E203_XLEN{amo_1stuop        }} & agu_icb_rsp_rdata)// Load the data from bus
            | ({`E203_XLEN{amo_2nduop        }} & leftover_r)// Unchange the value of leftover_r
         `endif//E203_SUPPORT_AMO}
            ;
                                   
  assign leftover_err_nxt = 1'b0 
         `ifdef E203_SUPPORT_AMO//{
            | ({{amo_1stuop        }} & agu_icb_rsp_err)// 1st error from the bus
            | ({{amo_2nduop        }} & (agu_icb_rsp_err | leftover_err_r))// second error merged
         `endif//E203_SUPPORT_AMO}
         ;
  //
  // The instantiation of leftover buffer is actually shared with the ALU SBF-0 Buffer
  assign agu_sbf_0_ena = leftover_ena;
  assign agu_sbf_0_nxt = leftover_nxt;
  assign leftover_r    = agu_sbf_0_r;

  // The error bit is implemented here
  sirv_gnrl_dfflr #(1) icb_leftover_err_dfflr (leftover_ena, leftover_err_nxt, leftover_err_r, clk, rst_n);
  
  assign leftover_1_ena = 1'b0 
         `ifdef E203_SUPPORT_AMO//{
           | icb_sta_is_amoalu 
         `endif//E203_SUPPORT_AMO}
         ;
  assign leftover_1_nxt = agu_req_alu_res;
  //
  // The instantiation of last_icb_addr buffer is actually shared with the ALU SBF-1 Buffer
  assign agu_sbf_1_ena   = leftover_1_ena;
  assign agu_sbf_1_nxt   = leftover_1_nxt;
  assign leftover_1_r = agu_sbf_1_r;


  assign agu_req_alu_add  = 1'b0
                     `ifdef E203_SUPPORT_AMO//{
                           | (icb_sta_is_amoalu & agu_i_amoadd)
                             // In order to let AMO 2nd uop have correct address
                           | (agu_i_amo & (icb_sta_is_wait2nd | icb_sta_is_2nd | icb_sta_is_wbck))
                     `endif//E203_SUPPORT_AMO}
                           // To cut down the timing loop from agu_i_valid // | (icb_sta_is_idle & agu_i_valid)
                           //   we dont need this signal at all
                           | icb_sta_is_idle
                           ;

  assign agu_req_alu_op1 =  icb_sta_is_idle   ? agu_i_rs1
                     `ifdef E203_SUPPORT_AMO//{
                          : icb_sta_is_amoalu ? leftover_r
                             // In order to let AMO 2nd uop have correct address
                          : (agu_i_amo & (icb_sta_is_wait2nd | icb_sta_is_2nd | icb_sta_is_wbck)) ? agu_i_rs1
                     `endif//E203_SUPPORT_AMO}
                     `ifndef E203_SUPPORT_UNALGNLDST//{
                          : `E203_XLEN'd0 
                     `endif//}
                     ;

  wire [`E203_XLEN-1:0] agu_addr_gen_op2 = agu_i_ofst0 ? `E203_XLEN'b0 : agu_i_imm;
  assign agu_req_alu_op2 =  icb_sta_is_idle   ? agu_addr_gen_op2 
                     `ifdef E203_SUPPORT_AMO//{
                          : icb_sta_is_amoalu ? agu_i_rs2
                             // In order to let AMO 2nd uop have correct address
                          : (agu_i_amo & (icb_sta_is_wait2nd | icb_sta_is_2nd | icb_sta_is_wbck)) ? agu_addr_gen_op2
                     `endif//E203_SUPPORT_AMO}
                     `ifndef E203_SUPPORT_UNALGNLDST//{
                          : `E203_XLEN'd0 
                     `endif//}
                     ;

  `ifdef E203_SUPPORT_AMO//{
  assign agu_req_alu_swap = (icb_sta_is_amoalu & agu_i_amoswap );
  assign agu_req_alu_and  = (icb_sta_is_amoalu & agu_i_amoand  );
  assign agu_req_alu_or   = (icb_sta_is_amoalu & agu_i_amoor   );
  assign agu_req_alu_xor  = (icb_sta_is_amoalu & agu_i_amoxor  );
  assign agu_req_alu_max  = (icb_sta_is_amoalu & agu_i_amomax  );
  assign agu_req_alu_min  = (icb_sta_is_amoalu & agu_i_amomin  );
  assign agu_req_alu_maxu = (icb_sta_is_amoalu & agu_i_amomaxu );
  assign agu_req_alu_minu = (icb_sta_is_amoalu & agu_i_amominu );
  `endif//E203_SUPPORT_AMO}
  `ifndef E203_SUPPORT_AMO//{
  assign agu_req_alu_swap = 1'b0;
  assign agu_req_alu_and  = 1'b0;
  assign agu_req_alu_or   = 1'b0;
  assign agu_req_alu_xor  = 1'b0;
  assign agu_req_alu_max  = 1'b0;
  assign agu_req_alu_min  = 1'b0;
  assign agu_req_alu_maxu = 1'b0;
  assign agu_req_alu_minu = 1'b0;
  `endif//}


/////////////////////////////////////////////////////////////////////////////////
// Implement the AGU op handshake ready signal
//
// The AGU op handshakeke interface will be ready when
//   * If it is unaligned instructions, then it will just 
//       directly pass out the write-back interface, hence it will only be 
//       ready when the write-back interface is ready
//   * If it is not unaligned load/store instructions, then it will just 
//       directly pass out the instruction to LSU-ctrl interface, hence it need to check
//       the AGU ICB interface is ready, but it also need to ask write-back interface 
//       for commit, so, also need to check if write-back interfac is ready
//       
  `ifndef E203_SUPPORT_UNALGNLDST//{
  `else//}{
  !!!! ERROR: This UNALIGNED load/store is not supported, must be something wrong 
  `endif//}

  assign agu_i_ready =
      ( 1'b0
  `ifdef E203_SUPPORT_AMO//{
       | agu_i_algnamo 
  `endif//E203_SUPPORT_AMO}
       ) ? state_last_exit_ena :
      (agu_icb_cmd_ready & agu_o_ready) ;
  
  // The aligned load/store instruction will be dispatched to LSU as long pipeline
  //   instructions
  assign agu_i_longpipe = agu_i_algnldst;
  

  //
  /////////////////////////////////////////////////////////////////////////////////
  // Implement the Write-back interfaces (unaligned and AMO instructions) 

  // The AGU write-back will be valid when:
  //   * For the aligned load/store
  //       Directly passed to ICB interface, but also need to pass 
  //       to write-back interface asking for commit
  assign agu_o_valid = 
        `ifdef E203_SUPPORT_AMO//{
      // For the unaligned load/store and aligned AMO, it will enter 
      //   into the state machine and let the last state to send back
      //   to the commit stage
      icb_sta_is_last 
        `endif//E203_SUPPORT_AMO}
      // For the aligned load/store and unaligned AMO, it will be send
      //   to the commit stage right the same cycle of agu_i_valid
      |(
         agu_i_valid & ( agu_i_algnldst 
        `ifndef E203_SUPPORT_UNALGNLDST//{
           // If not support the unaligned load/store by hardware, then 
               // the unaligned load/store will be treated as exception
               // and it will also be send to the commit stage right the
               // same cycle of agu_i_valid
           | agu_i_unalgnldst
        `endif//}
        `ifdef E203_SUPPORT_AMO//{
           | agu_i_unalgnamo 
        `endif//E203_SUPPORT_AMO}
         )
          ////  // Since it is issuing to commit stage and 
          ////  // LSU at same cycle, so we must qualify the icb_cmd_ready signal from LSU
          ////  // to make sure it is out to commit/LSU at same cycle
               // To cut the critical timing  path from longpipe signal
               // we always assume the AGU will need icb_cmd_ready
          & agu_icb_cmd_ready
      );

  assign agu_o_wbck_wdat = {`E203_XLEN{1'b0 }}
       `ifdef E203_SUPPORT_AMO//{
                    | ({`E203_XLEN{agu_i_algnamo  }} & leftover_r) 
                    | ({`E203_XLEN{agu_i_unalgnamo}} & `E203_XLEN'b0) 
       `endif//E203_SUPPORT_AMO}
       ;

  assign agu_o_cmt_buserr = (1'b0 
                `ifdef E203_SUPPORT_AMO//{
                      | (agu_i_algnamo    & leftover_err_r) 
                      | (agu_i_unalgnamo  & 1'b0) 
                `endif//E203_SUPPORT_AMO}
                      )
                ;
  assign agu_o_cmt_badaddr = agu_icb_cmd_addr;


  assign agu_o_cmt_misalgn = (1'b0
                `ifdef E203_SUPPORT_AMO//{
                       | agu_i_unalgnamo 
                `endif//E203_SUPPORT_AMO}
                       | (agu_i_unalgnldst) //& agu_i_excl) We dont support unaligned load/store regardless it is AMO or not
                       )
                       ;
  assign agu_o_cmt_ld      = agu_i_load & (~agu_i_excl); 
  assign agu_o_cmt_stamo   = agu_i_store | agu_i_amo | agu_i_excl;

  
  // The exception or error result cannot write-back
  assign agu_o_wbck_err = agu_o_cmt_buserr | agu_o_cmt_misalgn
                          ;


  assign agu_icb_rsp_ready = 1'b1;


  

  assign agu_icb_cmd_valid = 
            ((agu_i_algnldst & agu_i_valid)
              // We must qualify the agu_o_ready signal from commit stage
              // to make sure it is out to commit/LSU at same cycle
              & (agu_o_ready)
            )
          `ifdef E203_SUPPORT_AMO//{
            | (agu_i_algnamo & (
                         (icb_sta_is_idle & agu_i_valid 
                             // We must qualify the agu_o_ready signal from commit stage
                             // to make sure it is out to commit/LSU at same cycle
                             & agu_o_ready)
                       | (icb_sta_is_wait2nd)))
            | (agu_i_unalgnamo & 1'b0) 
          `endif//E203_SUPPORT_AMO}
            ;
  assign agu_icb_cmd_addr = agu_req_alu_res[`E203_ADDR_SIZE-1:0];

  assign agu_icb_cmd_read = 
            (agu_i_algnldst & agu_i_load) 
          `ifdef E203_SUPPORT_AMO//{
          | (agu_i_algnamo & icb_sta_is_idle & 1'b1)
          | (agu_i_algnamo & icb_sta_is_wait2nd & 1'b0) 
          `endif//E203_SUPPORT_AMO}
          ;
     // The AGU ICB CMD Wdata sources:
     //   * For the aligned store instructions
     //       Directly passed to AGU ICB, wdata is op2 repetitive form, 
     //       wmask is generated according to the LSB and size


  wire [`E203_XLEN-1:0] algnst_wdata = 
            ({`E203_XLEN{agu_i_size_b }} & {4{agu_i_rs2[ 7:0]}})
          | ({`E203_XLEN{agu_i_size_hw}} & {2{agu_i_rs2[15:0]}})
          | ({`E203_XLEN{agu_i_size_w }} & {1{agu_i_rs2[31:0]}});
  wire [`E203_XLEN/8-1:0] algnst_wmask = 
            ({`E203_XLEN/8{agu_i_size_b }} & (4'b0001 << agu_icb_cmd_addr[1:0]))
          | ({`E203_XLEN/8{agu_i_size_hw}} & (4'b0011 << {agu_icb_cmd_addr[1],1'b0}))
          | ({`E203_XLEN/8{agu_i_size_w }} & (4'b1111));

          
  assign agu_icb_cmd_wdata = 
  `ifdef E203_SUPPORT_AMO//{
      agu_i_amo ? leftover_1_r :
  `endif//E203_SUPPORT_AMO}
      algnst_wdata;

  assign agu_icb_cmd_wmask =
  `ifdef E203_SUPPORT_AMO//{
         // If the 1st uop have bus-error, then not write the data for 2nd uop
      agu_i_amo ? (leftover_err_r ? 4'h0 : 4'hF) :
  `endif//E203_SUPPORT_AMO}
      algnst_wmask; 

  assign agu_icb_cmd_back2agu = 1'b0 
             `ifdef E203_SUPPORT_AMO//{
                | agu_i_algnamo  
             `endif//E203_SUPPORT_AMO}
             ;
  //We dont support lock and exclusive in such 2 stage simple implementation
  assign agu_icb_cmd_lock     = 1'b0 
             `ifdef E203_SUPPORT_AMO//{
                 | (agu_i_algnamo & icb_sta_is_idle)
             `endif//E203_SUPPORT_AMO}
                 ;
  assign agu_icb_cmd_excl     = 1'b0
             `ifdef E203_SUPPORT_AMO//{
                 | agu_i_excl
             `endif//E203_SUPPORT_AMO}
                 ;

  assign agu_icb_cmd_itag     = agu_i_itag;
  assign agu_icb_cmd_usign    = agu_i_usign;
  assign agu_icb_cmd_size     = 
                agu_i_size;


endmodule                                      
                                               
                                               
                                               
