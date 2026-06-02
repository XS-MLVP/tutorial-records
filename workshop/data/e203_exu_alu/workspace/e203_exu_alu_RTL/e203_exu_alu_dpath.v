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
//  This module to implement the datapath of ALU
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



module e203_exu_alu_dpath(

  //////////////////////////////////////////////////////
  // ALU request the datapath
  input  alu_req_alu,

  input  alu_req_alu_add ,
  input  alu_req_alu_sub ,
  input  alu_req_alu_xor ,
  input  alu_req_alu_sll ,
  input  alu_req_alu_srl ,
  input  alu_req_alu_sra ,
  input  alu_req_alu_or  ,
  input  alu_req_alu_and ,
  input  alu_req_alu_slt ,
  input  alu_req_alu_sltu,
  input  alu_req_alu_lui ,
  input  [31:0] alu_req_alu_op1,
  input  [31:0] alu_req_alu_op2,

  output [31:0] alu_req_alu_res,

  //////////////////////////////////////////////////////
  // BJP request the datapath
  input  bjp_req_alu,

  input  [31:0] bjp_req_alu_op1,
  input  [31:0] bjp_req_alu_op2,
  input  bjp_req_alu_cmp_eq ,
  input  bjp_req_alu_cmp_ne ,
  input  bjp_req_alu_cmp_lt ,
  input  bjp_req_alu_cmp_gt ,
  input  bjp_req_alu_cmp_ltu,
  input  bjp_req_alu_cmp_gtu,
  input  bjp_req_alu_add,

  output bjp_req_alu_cmp_res,
  output [31:0] bjp_req_alu_add_res,

  //////////////////////////////////////////////////////
  // AGU request the datapath
  input  agu_req_alu,

  input  [31:0] agu_req_alu_op1,
  input  [31:0] agu_req_alu_op2,
  input  agu_req_alu_swap,
  input  agu_req_alu_add ,
  input  agu_req_alu_and ,
  input  agu_req_alu_or  ,
  input  agu_req_alu_xor ,
  input  agu_req_alu_max ,
  input  agu_req_alu_min ,
  input  agu_req_alu_maxu,
  input  agu_req_alu_minu,

  output [31:0] agu_req_alu_res,

  input  agu_sbf_0_ena,
  input  [31:0] agu_sbf_0_nxt,
  output [31:0] agu_sbf_0_r,

  input  agu_sbf_1_ena,
  input  [31:0] agu_sbf_1_nxt,
  output [31:0] agu_sbf_1_r,

`ifdef E203_SUPPORT_SHARE_MULDIV //{
  //////////////////////////////////////////////////////
  // MULDIV request the datapath
  input  muldiv_req_alu,

  input  [34:0] muldiv_req_alu_op1,
  input  [34:0] muldiv_req_alu_op2,
  input                              muldiv_req_alu_add,
  input                              muldiv_req_alu_sub,
  output [34:0] muldiv_req_alu_res,

  input           muldiv_sbf_0_ena,
  input  [33-1:0] muldiv_sbf_0_nxt,
  output [33-1:0] muldiv_sbf_0_r,

  input           muldiv_sbf_1_ena,
  input  [33-1:0] muldiv_sbf_1_nxt,
  output [33-1:0] muldiv_sbf_1_r,
`endif//E203_SUPPORT_SHARE_MULDIV}

  input  clk,
  input  rst_n
  );

  `ifdef E203_XLEN_IS_32
      // This is the correct config since E200 is 32bits core
  `else
      !!! ERROR: There must be something wrong, our core must be 32bits wide !!!
  `endif

  wire [`E203_XLEN-1:0] mux_op1;
  wire [`E203_XLEN-1:0] mux_op2;

  wire [`E203_XLEN-1:0] misc_op1 = mux_op1[`E203_XLEN-1:0];
  wire [`E203_XLEN-1:0] misc_op2 = mux_op2[`E203_XLEN-1:0];

  // Only the regular ALU use shifter
  wire [`E203_XLEN-1:0] shifter_op1 = alu_req_alu_op1[`E203_XLEN-1:0];
  wire [`E203_XLEN-1:0] shifter_op2 = alu_req_alu_op2[`E203_XLEN-1:0];

  wire op_max;  
  wire op_min ; 
  wire op_maxu;
  wire op_minu;

  wire op_add;
  wire op_sub;
  wire op_addsub = op_add | op_sub; 

  wire op_or;
  wire op_xor;
  wire op_and;

  wire op_sll;
  wire op_srl;
  wire op_sra;

  wire op_slt;
  wire op_sltu;

  wire op_mvop2;


  wire op_cmp_eq ;
  wire op_cmp_ne ;
  wire op_cmp_lt ;
  wire op_cmp_gt ;
  wire op_cmp_ltu;
  wire op_cmp_gtu;

  wire cmp_res;

  wire sbf_0_ena;
  wire [33-1:0] sbf_0_nxt;
  wire [33-1:0] sbf_0_r;

  wire sbf_1_ena;
  wire [33-1:0] sbf_1_nxt;
  wire [33-1:0] sbf_1_r;


  //////////////////////////////////////////////////////////////
  // Impelment the Left-Shifter
  //
  // The Left-Shifter will be used to handle the shift op
  wire [`E203_XLEN-1:0] shifter_in1;
  wire [5-1:0] shifter_in2;
  wire [`E203_XLEN-1:0] shifter_res;


  wire op_shift = op_sra | op_sll | op_srl; 
  
     // Make sure to use logic-gating to gateoff the 
  assign shifter_in1 = {`E203_XLEN{op_shift}} &
          //   In order to save area and just use one left-shifter, we
          //   convert the right-shift op into left-shift operation
           (
               (op_sra | op_srl) ? 
                 {
    shifter_op1[00],shifter_op1[01],shifter_op1[02],shifter_op1[03],
    shifter_op1[04],shifter_op1[05],shifter_op1[06],shifter_op1[07],
    shifter_op1[08],shifter_op1[09],shifter_op1[10],shifter_op1[11],
    shifter_op1[12],shifter_op1[13],shifter_op1[14],shifter_op1[15],
    shifter_op1[16],shifter_op1[17],shifter_op1[18],shifter_op1[19],
    shifter_op1[20],shifter_op1[21],shifter_op1[22],shifter_op1[23],
    shifter_op1[24],shifter_op1[25],shifter_op1[26],shifter_op1[27],
    shifter_op1[28],shifter_op1[29],shifter_op1[30],shifter_op1[31]
                 } : shifter_op1
           );
  assign shifter_in2 = {5{op_shift}} & shifter_op2[4:0];

  assign shifter_res = (shifter_in1 << shifter_in2);

  wire [`E203_XLEN-1:0] sll_res = shifter_res;
  wire [`E203_XLEN-1:0] srl_res =  
                 {
    shifter_res[00],shifter_res[01],shifter_res[02],shifter_res[03],
    shifter_res[04],shifter_res[05],shifter_res[06],shifter_res[07],
    shifter_res[08],shifter_res[09],shifter_res[10],shifter_res[11],
    shifter_res[12],shifter_res[13],shifter_res[14],shifter_res[15],
    shifter_res[16],shifter_res[17],shifter_res[18],shifter_res[19],
    shifter_res[20],shifter_res[21],shifter_res[22],shifter_res[23],
    shifter_res[24],shifter_res[25],shifter_res[26],shifter_res[27],
    shifter_res[28],shifter_res[29],shifter_res[30],shifter_res[31]
                 };
  
  wire [`E203_XLEN-1:0] eff_mask = (~(`E203_XLEN'b0)) >> shifter_in2;
  wire [`E203_XLEN-1:0] sra_res =
               (srl_res & eff_mask) | ({32{shifter_op1[31]}} & (~eff_mask));



  //////////////////////////////////////////////////////////////
  // Impelment the Adder
  //
  // The Adder will be reused to handle the add/sub/compare op

     // Only the MULDIV request ALU-adder with 35bits operand with sign extended 
     // already, all other unit request ALU-adder with 32bits opereand without sign extended
     //   For non-MULDIV operands
  wire op_unsigned = op_sltu | op_cmp_ltu | op_cmp_gtu | op_maxu | op_minu;
  wire [`E203_ALU_ADDER_WIDTH-1:0] misc_adder_op1 =
      {{`E203_ALU_ADDER_WIDTH-`E203_XLEN{(~op_unsigned) & misc_op1[`E203_XLEN-1]}},misc_op1};
  wire [`E203_ALU_ADDER_WIDTH-1:0] misc_adder_op2 =
      {{`E203_ALU_ADDER_WIDTH-`E203_XLEN{(~op_unsigned) & misc_op2[`E203_XLEN-1]}},misc_op2};


  wire [`E203_ALU_ADDER_WIDTH-1:0] adder_op1 = 
`ifdef E203_SUPPORT_SHARE_MULDIV //{
      muldiv_req_alu ? muldiv_req_alu_op1 :
`endif//E203_SUPPORT_SHARE_MULDIV}
      misc_adder_op1;
  wire [`E203_ALU_ADDER_WIDTH-1:0] adder_op2 = 
`ifdef E203_SUPPORT_SHARE_MULDIV //{
      muldiv_req_alu ? muldiv_req_alu_op2 :
`endif//E203_SUPPORT_SHARE_MULDIV}
      misc_adder_op2;

  wire adder_cin;
  wire [`E203_ALU_ADDER_WIDTH-1:0] adder_in1;
  wire [`E203_ALU_ADDER_WIDTH-1:0] adder_in2;
  wire [`E203_ALU_ADDER_WIDTH-1:0] adder_res;

  wire adder_add;
  wire adder_sub;

  assign adder_add =
`ifdef E203_SUPPORT_SHARE_MULDIV //{
      muldiv_req_alu ? muldiv_req_alu_add :
`endif//E203_SUPPORT_SHARE_MULDIV}
      op_add; 
  assign adder_sub =
`ifdef E203_SUPPORT_SHARE_MULDIV //{
      muldiv_req_alu ? muldiv_req_alu_sub :
`endif//E203_SUPPORT_SHARE_MULDIV}
               (
                   // The original sub instruction
               (op_sub) 
                   // The compare lt or gt instruction
             | (op_cmp_lt | op_cmp_gt | 
                op_cmp_ltu | op_cmp_gtu |
                op_max | op_maxu |
                op_min | op_minu |
                op_slt | op_sltu 
               ));

  wire adder_addsub = adder_add | adder_sub; 
  

     // Make sure to use logic-gating to gateoff the 
  assign adder_in1 = {`E203_ALU_ADDER_WIDTH{adder_addsub}} & (adder_op1);
  assign adder_in2 = {`E203_ALU_ADDER_WIDTH{adder_addsub}} & (adder_sub ? (~adder_op2) : adder_op2);
  assign adder_cin = adder_addsub & adder_sub;

  assign adder_res = adder_in1 + adder_in2 + adder_cin;



  //////////////////////////////////////////////////////////////
  // Impelment the XOR-er
  //
  // The XOR-er will be reused to handle the XOR and compare op

  wire [`E203_XLEN-1:0] xorer_in1;
  wire [`E203_XLEN-1:0] xorer_in2;

  wire xorer_op = 
               op_xor
                   // The compare eq or ne instruction
             | (op_cmp_eq | op_cmp_ne); 

     // Make sure to use logic-gating to gateoff the 
  assign xorer_in1 = {`E203_XLEN{xorer_op}} & misc_op1;
  assign xorer_in2 = {`E203_XLEN{xorer_op}} & misc_op2;

  wire [`E203_XLEN-1:0] xorer_res = xorer_in1 ^ xorer_in2;
     // The OR and AND is too light-weight, so no need to gate off
  wire [`E203_XLEN-1:0] orer_res  = misc_op1 | misc_op2; 
  wire [`E203_XLEN-1:0] ander_res = misc_op1 & misc_op2; 


  //////////////////////////////////////////////////////////////
  // Generate the CMP operation result
       // It is Non-Equal if the XOR result have any bit non-zero
  wire neq  = (|xorer_res); 
  wire cmp_res_ne  = (op_cmp_ne  & neq);
       // It is Equal if it is not Non-Equal
  wire cmp_res_eq  = op_cmp_eq  & (~neq);
       // It is Less-Than if the adder result is negative
  wire cmp_res_lt  = op_cmp_lt  & adder_res[`E203_XLEN];
  wire cmp_res_ltu = op_cmp_ltu & adder_res[`E203_XLEN];
       // It is Greater-Than if the adder result is postive
  wire op1_gt_op2  = (~adder_res[`E203_XLEN]);
  wire cmp_res_gt  = op_cmp_gt  & op1_gt_op2;
  wire cmp_res_gtu = op_cmp_gtu & op1_gt_op2;

  assign cmp_res = cmp_res_eq 
                 | cmp_res_ne 
                 | cmp_res_lt 
                 | cmp_res_gt  
                 | cmp_res_ltu 
                 | cmp_res_gtu; 

  //////////////////////////////////////////////////////////////
  // Generate the mvop2 result
  //   Just directly use op2 since the op2 will be the immediate
  wire [`E203_XLEN-1:0] mvop2_res = misc_op2;

  //////////////////////////////////////////////////////////////
  // Generate the SLT and SLTU result
  //   Just directly use op2 since the op2 will be the immediate
  wire op_slttu = (op_slt | op_sltu);
  //   The SLT and SLTU is reusing the adder to do the comparasion
       // It is Less-Than if the adder result is negative
  wire slttu_cmp_lt = op_slttu & adder_res[`E203_XLEN];
  wire [`E203_XLEN-1:0] slttu_res = 
               slttu_cmp_lt ?
               `E203_XLEN'b1 : `E203_XLEN'b0;

  //////////////////////////////////////////////////////////////
  // Generate the Max/Min result
  wire maxmin_sel_op1 =  ((op_max | op_maxu) &   op1_gt_op2) 
                      |  ((op_min | op_minu) & (~op1_gt_op2));

  wire [`E203_XLEN-1:0] maxmin_res  = maxmin_sel_op1 ? misc_op1 : misc_op2;  

  //////////////////////////////////////////////////////////////
  // Generate the final result
  wire [`E203_XLEN-1:0] alu_dpath_res = 
        ({`E203_XLEN{op_or       }} & orer_res )
      | ({`E203_XLEN{op_and      }} & ander_res)
      | ({`E203_XLEN{op_xor      }} & xorer_res)
      | ({`E203_XLEN{op_addsub   }} & adder_res[`E203_XLEN-1:0])
      | ({`E203_XLEN{op_srl      }} & srl_res)
      | ({`E203_XLEN{op_sll      }} & sll_res)
      | ({`E203_XLEN{op_sra      }} & sra_res)
      | ({`E203_XLEN{op_mvop2    }} & mvop2_res)
      | ({`E203_XLEN{op_slttu    }} & slttu_res)
      | ({`E203_XLEN{op_max | op_maxu | op_min | op_minu}} & maxmin_res)
        ;

  //////////////////////////////////////////////////////////////
  // Implement the SBF: Shared Buffers
  sirv_gnrl_dffl #(33) sbf_0_dffl (sbf_0_ena, sbf_0_nxt, sbf_0_r, clk);
  sirv_gnrl_dffl #(33) sbf_1_dffl (sbf_1_ena, sbf_1_nxt, sbf_1_r, clk);

  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////
  //  The ALU-Datapath Mux for the requestors 

  localparam DPATH_MUX_WIDTH = ((`E203_XLEN*2)+21);

  assign  {
     mux_op1
    ,mux_op2
    ,op_max  
    ,op_min  
    ,op_maxu 
    ,op_minu 
    ,op_add
    ,op_sub
    ,op_or
    ,op_xor
    ,op_and
    ,op_sll
    ,op_srl
    ,op_sra
    ,op_slt
    ,op_sltu
    ,op_mvop2
    ,op_cmp_eq 
    ,op_cmp_ne 
    ,op_cmp_lt 
    ,op_cmp_gt 
    ,op_cmp_ltu
    ,op_cmp_gtu
    }
    = 
        ({DPATH_MUX_WIDTH{alu_req_alu}} & {
             alu_req_alu_op1
            ,alu_req_alu_op2
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
            ,alu_req_alu_add
            ,alu_req_alu_sub
            ,alu_req_alu_or
            ,alu_req_alu_xor
            ,alu_req_alu_and
            ,alu_req_alu_sll
            ,alu_req_alu_srl
            ,alu_req_alu_sra
            ,alu_req_alu_slt
            ,alu_req_alu_sltu
            ,alu_req_alu_lui// LUI just move-Op2 operation
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
        })
      | ({DPATH_MUX_WIDTH{bjp_req_alu}} & {
             bjp_req_alu_op1
            ,bjp_req_alu_op2
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
            ,bjp_req_alu_add
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
            ,bjp_req_alu_cmp_eq 
            ,bjp_req_alu_cmp_ne 
            ,bjp_req_alu_cmp_lt 
            ,bjp_req_alu_cmp_gt 
            ,bjp_req_alu_cmp_ltu
            ,bjp_req_alu_cmp_gtu

        })
      | ({DPATH_MUX_WIDTH{agu_req_alu}} & {
             agu_req_alu_op1
            ,agu_req_alu_op2
            ,agu_req_alu_max  
            ,agu_req_alu_min  
            ,agu_req_alu_maxu 
            ,agu_req_alu_minu 
            ,agu_req_alu_add
            ,1'b0
            ,agu_req_alu_or
            ,agu_req_alu_xor
            ,agu_req_alu_and
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
            ,agu_req_alu_swap// SWAP just move-Op2 operation
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
            ,1'b0
        })
        ;
  
  assign alu_req_alu_res     = alu_dpath_res[`E203_XLEN-1:0];
  assign agu_req_alu_res     = alu_dpath_res[`E203_XLEN-1:0];
  assign bjp_req_alu_add_res = alu_dpath_res[`E203_XLEN-1:0];
  assign bjp_req_alu_cmp_res = cmp_res;
`ifdef E203_SUPPORT_SHARE_MULDIV //{
  assign muldiv_req_alu_res  = adder_res;
`endif//E203_SUPPORT_SHARE_MULDIV}

  assign sbf_0_ena = 
`ifdef E203_SUPPORT_SHARE_MULDIV //{
      muldiv_req_alu ? muldiv_sbf_0_ena : 
`endif//E203_SUPPORT_SHARE_MULDIV}
                 agu_sbf_0_ena;
  assign sbf_1_ena = 
`ifdef E203_SUPPORT_SHARE_MULDIV //{
      muldiv_req_alu ? muldiv_sbf_1_ena : 
`endif//E203_SUPPORT_SHARE_MULDIV}
                 agu_sbf_1_ena;

  assign sbf_0_nxt = 
`ifdef E203_SUPPORT_SHARE_MULDIV //{
      muldiv_req_alu ? muldiv_sbf_0_nxt : 
`endif//E203_SUPPORT_SHARE_MULDIV}
                 {1'b0,agu_sbf_0_nxt};
  assign sbf_1_nxt = 
`ifdef E203_SUPPORT_SHARE_MULDIV //{
      muldiv_req_alu ? muldiv_sbf_1_nxt : 
`endif//E203_SUPPORT_SHARE_MULDIV}
                 {1'b0,agu_sbf_1_nxt};

  assign agu_sbf_0_r = sbf_0_r[`E203_XLEN-1:0];
  assign agu_sbf_1_r = sbf_1_r[`E203_XLEN-1:0];

`ifdef E203_SUPPORT_SHARE_MULDIV //{
  assign muldiv_sbf_0_r = sbf_0_r;
  assign muldiv_sbf_1_r = sbf_1_r;
`endif//E203_SUPPORT_SHARE_MULDIV}

endmodule                                      
                                               
                                               
                                               
