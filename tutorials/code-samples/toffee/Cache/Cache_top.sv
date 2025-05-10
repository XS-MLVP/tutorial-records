module Cache_top();

  logic  clock;
  logic  reset;
  logic  io_in_req_ready;
  logic  io_in_req_valid;
  logic [31:0] io_in_req_bits_addr;
  logic [2:0] io_in_req_bits_size;
  logic [3:0] io_in_req_bits_cmd;
  logic [7:0] io_in_req_bits_wmask;
  logic [63:0] io_in_req_bits_wdata;
  logic [15:0] io_in_req_bits_user;
  logic  io_in_resp_ready;
  logic  io_in_resp_valid;
  logic [3:0] io_in_resp_bits_cmd;
  logic [63:0] io_in_resp_bits_rdata;
  logic [15:0] io_in_resp_bits_user;
  logic [1:0] io_flush;
  logic  io_out_mem_req_ready;
  logic  io_out_mem_req_valid;
  logic [31:0] io_out_mem_req_bits_addr;
  logic [2:0] io_out_mem_req_bits_size;
  logic [3:0] io_out_mem_req_bits_cmd;
  logic [7:0] io_out_mem_req_bits_wmask;
  logic [63:0] io_out_mem_req_bits_wdata;
  logic  io_out_mem_resp_ready;
  logic  io_out_mem_resp_valid;
  logic [3:0] io_out_mem_resp_bits_cmd;
  logic [63:0] io_out_mem_resp_bits_rdata;
  logic  io_out_coh_req_ready;
  logic  io_out_coh_req_valid;
  logic [31:0] io_out_coh_req_bits_addr;
  logic [2:0] io_out_coh_req_bits_size;
  logic [3:0] io_out_coh_req_bits_cmd;
  logic [7:0] io_out_coh_req_bits_wmask;
  logic [63:0] io_out_coh_req_bits_wdata;
  logic  io_out_coh_resp_ready;
  logic  io_out_coh_resp_valid;
  logic [3:0] io_out_coh_resp_bits_cmd;
  logic [63:0] io_out_coh_resp_bits_rdata;
  logic  io_mmio_req_ready;
  logic  io_mmio_req_valid;
  logic [31:0] io_mmio_req_bits_addr;
  logic [2:0] io_mmio_req_bits_size;
  logic [3:0] io_mmio_req_bits_cmd;
  logic [7:0] io_mmio_req_bits_wmask;
  logic [63:0] io_mmio_req_bits_wdata;
  logic  io_mmio_resp_ready;
  logic  io_mmio_resp_valid;
  logic [3:0] io_mmio_resp_bits_cmd;
  logic [63:0] io_mmio_resp_bits_rdata;
  logic  io_empty;
  logic  victim_way_mask_valid;
  logic [3:0] victim_way_mask;


 Cache Cache(
    .clock(clock),
    .reset(reset),
    .io_in_req_ready(io_in_req_ready),
    .io_in_req_valid(io_in_req_valid),
    .io_in_req_bits_addr(io_in_req_bits_addr),
    .io_in_req_bits_size(io_in_req_bits_size),
    .io_in_req_bits_cmd(io_in_req_bits_cmd),
    .io_in_req_bits_wmask(io_in_req_bits_wmask),
    .io_in_req_bits_wdata(io_in_req_bits_wdata),
    .io_in_req_bits_user(io_in_req_bits_user),
    .io_in_resp_ready(io_in_resp_ready),
    .io_in_resp_valid(io_in_resp_valid),
    .io_in_resp_bits_cmd(io_in_resp_bits_cmd),
    .io_in_resp_bits_rdata(io_in_resp_bits_rdata),
    .io_in_resp_bits_user(io_in_resp_bits_user),
    .io_flush(io_flush),
    .io_out_mem_req_ready(io_out_mem_req_ready),
    .io_out_mem_req_valid(io_out_mem_req_valid),
    .io_out_mem_req_bits_addr(io_out_mem_req_bits_addr),
    .io_out_mem_req_bits_size(io_out_mem_req_bits_size),
    .io_out_mem_req_bits_cmd(io_out_mem_req_bits_cmd),
    .io_out_mem_req_bits_wmask(io_out_mem_req_bits_wmask),
    .io_out_mem_req_bits_wdata(io_out_mem_req_bits_wdata),
    .io_out_mem_resp_ready(io_out_mem_resp_ready),
    .io_out_mem_resp_valid(io_out_mem_resp_valid),
    .io_out_mem_resp_bits_cmd(io_out_mem_resp_bits_cmd),
    .io_out_mem_resp_bits_rdata(io_out_mem_resp_bits_rdata),
    .io_out_coh_req_ready(io_out_coh_req_ready),
    .io_out_coh_req_valid(io_out_coh_req_valid),
    .io_out_coh_req_bits_addr(io_out_coh_req_bits_addr),
    .io_out_coh_req_bits_size(io_out_coh_req_bits_size),
    .io_out_coh_req_bits_cmd(io_out_coh_req_bits_cmd),
    .io_out_coh_req_bits_wmask(io_out_coh_req_bits_wmask),
    .io_out_coh_req_bits_wdata(io_out_coh_req_bits_wdata),
    .io_out_coh_resp_ready(io_out_coh_resp_ready),
    .io_out_coh_resp_valid(io_out_coh_resp_valid),
    .io_out_coh_resp_bits_cmd(io_out_coh_resp_bits_cmd),
    .io_out_coh_resp_bits_rdata(io_out_coh_resp_bits_rdata),
    .io_mmio_req_ready(io_mmio_req_ready),
    .io_mmio_req_valid(io_mmio_req_valid),
    .io_mmio_req_bits_addr(io_mmio_req_bits_addr),
    .io_mmio_req_bits_size(io_mmio_req_bits_size),
    .io_mmio_req_bits_cmd(io_mmio_req_bits_cmd),
    .io_mmio_req_bits_wmask(io_mmio_req_bits_wmask),
    .io_mmio_req_bits_wdata(io_mmio_req_bits_wdata),
    .io_mmio_resp_ready(io_mmio_resp_ready),
    .io_mmio_resp_valid(io_mmio_resp_valid),
    .io_mmio_resp_bits_cmd(io_mmio_resp_bits_cmd),
    .io_mmio_resp_bits_rdata(io_mmio_resp_bits_rdata),
    .io_empty(io_empty),
    .victim_way_mask_valid(victim_way_mask_valid),
    .victim_way_mask(victim_way_mask)
 );


  export "DPI-C" function get_clockxxPfBDHPiF4Xd;
  export "DPI-C" function set_clockxxPfBDHPiF4Xd;
  export "DPI-C" function get_resetxxPfBDHPiF4Xd;
  export "DPI-C" function set_resetxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_in_req_readyxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_in_req_validxxPfBDHPiF4Xd;
  export "DPI-C" function set_io_in_req_validxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_in_req_bits_addrxxPfBDHPiF4Xd;
  export "DPI-C" function set_io_in_req_bits_addrxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_in_req_bits_sizexxPfBDHPiF4Xd;
  export "DPI-C" function set_io_in_req_bits_sizexxPfBDHPiF4Xd;
  export "DPI-C" function get_io_in_req_bits_cmdxxPfBDHPiF4Xd;
  export "DPI-C" function set_io_in_req_bits_cmdxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_in_req_bits_wmaskxxPfBDHPiF4Xd;
  export "DPI-C" function set_io_in_req_bits_wmaskxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_in_req_bits_wdataxxPfBDHPiF4Xd;
  export "DPI-C" function set_io_in_req_bits_wdataxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_in_req_bits_userxxPfBDHPiF4Xd;
  export "DPI-C" function set_io_in_req_bits_userxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_in_resp_readyxxPfBDHPiF4Xd;
  export "DPI-C" function set_io_in_resp_readyxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_in_resp_validxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_in_resp_bits_cmdxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_in_resp_bits_rdataxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_in_resp_bits_userxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_flushxxPfBDHPiF4Xd;
  export "DPI-C" function set_io_flushxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_out_mem_req_readyxxPfBDHPiF4Xd;
  export "DPI-C" function set_io_out_mem_req_readyxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_out_mem_req_validxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_out_mem_req_bits_addrxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_out_mem_req_bits_sizexxPfBDHPiF4Xd;
  export "DPI-C" function get_io_out_mem_req_bits_cmdxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_out_mem_req_bits_wmaskxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_out_mem_req_bits_wdataxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_out_mem_resp_readyxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_out_mem_resp_validxxPfBDHPiF4Xd;
  export "DPI-C" function set_io_out_mem_resp_validxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_out_mem_resp_bits_cmdxxPfBDHPiF4Xd;
  export "DPI-C" function set_io_out_mem_resp_bits_cmdxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_out_mem_resp_bits_rdataxxPfBDHPiF4Xd;
  export "DPI-C" function set_io_out_mem_resp_bits_rdataxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_out_coh_req_readyxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_out_coh_req_validxxPfBDHPiF4Xd;
  export "DPI-C" function set_io_out_coh_req_validxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_out_coh_req_bits_addrxxPfBDHPiF4Xd;
  export "DPI-C" function set_io_out_coh_req_bits_addrxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_out_coh_req_bits_sizexxPfBDHPiF4Xd;
  export "DPI-C" function set_io_out_coh_req_bits_sizexxPfBDHPiF4Xd;
  export "DPI-C" function get_io_out_coh_req_bits_cmdxxPfBDHPiF4Xd;
  export "DPI-C" function set_io_out_coh_req_bits_cmdxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_out_coh_req_bits_wmaskxxPfBDHPiF4Xd;
  export "DPI-C" function set_io_out_coh_req_bits_wmaskxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_out_coh_req_bits_wdataxxPfBDHPiF4Xd;
  export "DPI-C" function set_io_out_coh_req_bits_wdataxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_out_coh_resp_readyxxPfBDHPiF4Xd;
  export "DPI-C" function set_io_out_coh_resp_readyxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_out_coh_resp_validxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_out_coh_resp_bits_cmdxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_out_coh_resp_bits_rdataxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_mmio_req_readyxxPfBDHPiF4Xd;
  export "DPI-C" function set_io_mmio_req_readyxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_mmio_req_validxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_mmio_req_bits_addrxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_mmio_req_bits_sizexxPfBDHPiF4Xd;
  export "DPI-C" function get_io_mmio_req_bits_cmdxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_mmio_req_bits_wmaskxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_mmio_req_bits_wdataxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_mmio_resp_readyxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_mmio_resp_validxxPfBDHPiF4Xd;
  export "DPI-C" function set_io_mmio_resp_validxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_mmio_resp_bits_cmdxxPfBDHPiF4Xd;
  export "DPI-C" function set_io_mmio_resp_bits_cmdxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_mmio_resp_bits_rdataxxPfBDHPiF4Xd;
  export "DPI-C" function set_io_mmio_resp_bits_rdataxxPfBDHPiF4Xd;
  export "DPI-C" function get_io_emptyxxPfBDHPiF4Xd;
  export "DPI-C" function get_victim_way_mask_validxxPfBDHPiF4Xd;
  export "DPI-C" function get_victim_way_maskxxPfBDHPiF4Xd;


  function void get_clockxxPfBDHPiF4Xd;
    output logic  value;
    value=clock;
  endfunction

  function void set_clockxxPfBDHPiF4Xd;
    input logic  value;
    clock=value;
  endfunction

  function void get_resetxxPfBDHPiF4Xd;
    output logic  value;
    value=reset;
  endfunction

  function void set_resetxxPfBDHPiF4Xd;
    input logic  value;
    reset=value;
  endfunction

  function void get_io_in_req_readyxxPfBDHPiF4Xd;
    output logic  value;
    value=io_in_req_ready;
  endfunction

  function void get_io_in_req_validxxPfBDHPiF4Xd;
    output logic  value;
    value=io_in_req_valid;
  endfunction

  function void set_io_in_req_validxxPfBDHPiF4Xd;
    input logic  value;
    io_in_req_valid=value;
  endfunction

  function void get_io_in_req_bits_addrxxPfBDHPiF4Xd;
    output logic [31:0] value;
    value=io_in_req_bits_addr;
  endfunction

  function void set_io_in_req_bits_addrxxPfBDHPiF4Xd;
    input logic [31:0] value;
    io_in_req_bits_addr=value;
  endfunction

  function void get_io_in_req_bits_sizexxPfBDHPiF4Xd;
    output logic [2:0] value;
    value=io_in_req_bits_size;
  endfunction

  function void set_io_in_req_bits_sizexxPfBDHPiF4Xd;
    input logic [2:0] value;
    io_in_req_bits_size=value;
  endfunction

  function void get_io_in_req_bits_cmdxxPfBDHPiF4Xd;
    output logic [3:0] value;
    value=io_in_req_bits_cmd;
  endfunction

  function void set_io_in_req_bits_cmdxxPfBDHPiF4Xd;
    input logic [3:0] value;
    io_in_req_bits_cmd=value;
  endfunction

  function void get_io_in_req_bits_wmaskxxPfBDHPiF4Xd;
    output logic [7:0] value;
    value=io_in_req_bits_wmask;
  endfunction

  function void set_io_in_req_bits_wmaskxxPfBDHPiF4Xd;
    input logic [7:0] value;
    io_in_req_bits_wmask=value;
  endfunction

  function void get_io_in_req_bits_wdataxxPfBDHPiF4Xd;
    output logic [63:0] value;
    value=io_in_req_bits_wdata;
  endfunction

  function void set_io_in_req_bits_wdataxxPfBDHPiF4Xd;
    input logic [63:0] value;
    io_in_req_bits_wdata=value;
  endfunction

  function void get_io_in_req_bits_userxxPfBDHPiF4Xd;
    output logic [15:0] value;
    value=io_in_req_bits_user;
  endfunction

  function void set_io_in_req_bits_userxxPfBDHPiF4Xd;
    input logic [15:0] value;
    io_in_req_bits_user=value;
  endfunction

  function void get_io_in_resp_readyxxPfBDHPiF4Xd;
    output logic  value;
    value=io_in_resp_ready;
  endfunction

  function void set_io_in_resp_readyxxPfBDHPiF4Xd;
    input logic  value;
    io_in_resp_ready=value;
  endfunction

  function void get_io_in_resp_validxxPfBDHPiF4Xd;
    output logic  value;
    value=io_in_resp_valid;
  endfunction

  function void get_io_in_resp_bits_cmdxxPfBDHPiF4Xd;
    output logic [3:0] value;
    value=io_in_resp_bits_cmd;
  endfunction

  function void get_io_in_resp_bits_rdataxxPfBDHPiF4Xd;
    output logic [63:0] value;
    value=io_in_resp_bits_rdata;
  endfunction

  function void get_io_in_resp_bits_userxxPfBDHPiF4Xd;
    output logic [15:0] value;
    value=io_in_resp_bits_user;
  endfunction

  function void get_io_flushxxPfBDHPiF4Xd;
    output logic [1:0] value;
    value=io_flush;
  endfunction

  function void set_io_flushxxPfBDHPiF4Xd;
    input logic [1:0] value;
    io_flush=value;
  endfunction

  function void get_io_out_mem_req_readyxxPfBDHPiF4Xd;
    output logic  value;
    value=io_out_mem_req_ready;
  endfunction

  function void set_io_out_mem_req_readyxxPfBDHPiF4Xd;
    input logic  value;
    io_out_mem_req_ready=value;
  endfunction

  function void get_io_out_mem_req_validxxPfBDHPiF4Xd;
    output logic  value;
    value=io_out_mem_req_valid;
  endfunction

  function void get_io_out_mem_req_bits_addrxxPfBDHPiF4Xd;
    output logic [31:0] value;
    value=io_out_mem_req_bits_addr;
  endfunction

  function void get_io_out_mem_req_bits_sizexxPfBDHPiF4Xd;
    output logic [2:0] value;
    value=io_out_mem_req_bits_size;
  endfunction

  function void get_io_out_mem_req_bits_cmdxxPfBDHPiF4Xd;
    output logic [3:0] value;
    value=io_out_mem_req_bits_cmd;
  endfunction

  function void get_io_out_mem_req_bits_wmaskxxPfBDHPiF4Xd;
    output logic [7:0] value;
    value=io_out_mem_req_bits_wmask;
  endfunction

  function void get_io_out_mem_req_bits_wdataxxPfBDHPiF4Xd;
    output logic [63:0] value;
    value=io_out_mem_req_bits_wdata;
  endfunction

  function void get_io_out_mem_resp_readyxxPfBDHPiF4Xd;
    output logic  value;
    value=io_out_mem_resp_ready;
  endfunction

  function void get_io_out_mem_resp_validxxPfBDHPiF4Xd;
    output logic  value;
    value=io_out_mem_resp_valid;
  endfunction

  function void set_io_out_mem_resp_validxxPfBDHPiF4Xd;
    input logic  value;
    io_out_mem_resp_valid=value;
  endfunction

  function void get_io_out_mem_resp_bits_cmdxxPfBDHPiF4Xd;
    output logic [3:0] value;
    value=io_out_mem_resp_bits_cmd;
  endfunction

  function void set_io_out_mem_resp_bits_cmdxxPfBDHPiF4Xd;
    input logic [3:0] value;
    io_out_mem_resp_bits_cmd=value;
  endfunction

  function void get_io_out_mem_resp_bits_rdataxxPfBDHPiF4Xd;
    output logic [63:0] value;
    value=io_out_mem_resp_bits_rdata;
  endfunction

  function void set_io_out_mem_resp_bits_rdataxxPfBDHPiF4Xd;
    input logic [63:0] value;
    io_out_mem_resp_bits_rdata=value;
  endfunction

  function void get_io_out_coh_req_readyxxPfBDHPiF4Xd;
    output logic  value;
    value=io_out_coh_req_ready;
  endfunction

  function void get_io_out_coh_req_validxxPfBDHPiF4Xd;
    output logic  value;
    value=io_out_coh_req_valid;
  endfunction

  function void set_io_out_coh_req_validxxPfBDHPiF4Xd;
    input logic  value;
    io_out_coh_req_valid=value;
  endfunction

  function void get_io_out_coh_req_bits_addrxxPfBDHPiF4Xd;
    output logic [31:0] value;
    value=io_out_coh_req_bits_addr;
  endfunction

  function void set_io_out_coh_req_bits_addrxxPfBDHPiF4Xd;
    input logic [31:0] value;
    io_out_coh_req_bits_addr=value;
  endfunction

  function void get_io_out_coh_req_bits_sizexxPfBDHPiF4Xd;
    output logic [2:0] value;
    value=io_out_coh_req_bits_size;
  endfunction

  function void set_io_out_coh_req_bits_sizexxPfBDHPiF4Xd;
    input logic [2:0] value;
    io_out_coh_req_bits_size=value;
  endfunction

  function void get_io_out_coh_req_bits_cmdxxPfBDHPiF4Xd;
    output logic [3:0] value;
    value=io_out_coh_req_bits_cmd;
  endfunction

  function void set_io_out_coh_req_bits_cmdxxPfBDHPiF4Xd;
    input logic [3:0] value;
    io_out_coh_req_bits_cmd=value;
  endfunction

  function void get_io_out_coh_req_bits_wmaskxxPfBDHPiF4Xd;
    output logic [7:0] value;
    value=io_out_coh_req_bits_wmask;
  endfunction

  function void set_io_out_coh_req_bits_wmaskxxPfBDHPiF4Xd;
    input logic [7:0] value;
    io_out_coh_req_bits_wmask=value;
  endfunction

  function void get_io_out_coh_req_bits_wdataxxPfBDHPiF4Xd;
    output logic [63:0] value;
    value=io_out_coh_req_bits_wdata;
  endfunction

  function void set_io_out_coh_req_bits_wdataxxPfBDHPiF4Xd;
    input logic [63:0] value;
    io_out_coh_req_bits_wdata=value;
  endfunction

  function void get_io_out_coh_resp_readyxxPfBDHPiF4Xd;
    output logic  value;
    value=io_out_coh_resp_ready;
  endfunction

  function void set_io_out_coh_resp_readyxxPfBDHPiF4Xd;
    input logic  value;
    io_out_coh_resp_ready=value;
  endfunction

  function void get_io_out_coh_resp_validxxPfBDHPiF4Xd;
    output logic  value;
    value=io_out_coh_resp_valid;
  endfunction

  function void get_io_out_coh_resp_bits_cmdxxPfBDHPiF4Xd;
    output logic [3:0] value;
    value=io_out_coh_resp_bits_cmd;
  endfunction

  function void get_io_out_coh_resp_bits_rdataxxPfBDHPiF4Xd;
    output logic [63:0] value;
    value=io_out_coh_resp_bits_rdata;
  endfunction

  function void get_io_mmio_req_readyxxPfBDHPiF4Xd;
    output logic  value;
    value=io_mmio_req_ready;
  endfunction

  function void set_io_mmio_req_readyxxPfBDHPiF4Xd;
    input logic  value;
    io_mmio_req_ready=value;
  endfunction

  function void get_io_mmio_req_validxxPfBDHPiF4Xd;
    output logic  value;
    value=io_mmio_req_valid;
  endfunction

  function void get_io_mmio_req_bits_addrxxPfBDHPiF4Xd;
    output logic [31:0] value;
    value=io_mmio_req_bits_addr;
  endfunction

  function void get_io_mmio_req_bits_sizexxPfBDHPiF4Xd;
    output logic [2:0] value;
    value=io_mmio_req_bits_size;
  endfunction

  function void get_io_mmio_req_bits_cmdxxPfBDHPiF4Xd;
    output logic [3:0] value;
    value=io_mmio_req_bits_cmd;
  endfunction

  function void get_io_mmio_req_bits_wmaskxxPfBDHPiF4Xd;
    output logic [7:0] value;
    value=io_mmio_req_bits_wmask;
  endfunction

  function void get_io_mmio_req_bits_wdataxxPfBDHPiF4Xd;
    output logic [63:0] value;
    value=io_mmio_req_bits_wdata;
  endfunction

  function void get_io_mmio_resp_readyxxPfBDHPiF4Xd;
    output logic  value;
    value=io_mmio_resp_ready;
  endfunction

  function void get_io_mmio_resp_validxxPfBDHPiF4Xd;
    output logic  value;
    value=io_mmio_resp_valid;
  endfunction

  function void set_io_mmio_resp_validxxPfBDHPiF4Xd;
    input logic  value;
    io_mmio_resp_valid=value;
  endfunction

  function void get_io_mmio_resp_bits_cmdxxPfBDHPiF4Xd;
    output logic [3:0] value;
    value=io_mmio_resp_bits_cmd;
  endfunction

  function void set_io_mmio_resp_bits_cmdxxPfBDHPiF4Xd;
    input logic [3:0] value;
    io_mmio_resp_bits_cmd=value;
  endfunction

  function void get_io_mmio_resp_bits_rdataxxPfBDHPiF4Xd;
    output logic [63:0] value;
    value=io_mmio_resp_bits_rdata;
  endfunction

  function void set_io_mmio_resp_bits_rdataxxPfBDHPiF4Xd;
    input logic [63:0] value;
    io_mmio_resp_bits_rdata=value;
  endfunction

  function void get_io_emptyxxPfBDHPiF4Xd;
    output logic  value;
    value=io_empty;
  endfunction

  function void get_victim_way_mask_validxxPfBDHPiF4Xd;
    output logic  value;
    value=victim_way_mask_valid;
  endfunction

  function void get_victim_way_maskxxPfBDHPiF4Xd;
    output logic [3:0] value;
    value=victim_way_mask;
  endfunction



  initial begin
    $dumpfile("Cache.fst");
    $dumpvars(0, Cache_top);
  end

  export "DPI-C" function finish_PfBDHPiF4Xd;
  function void finish_PfBDHPiF4Xd;
    $finish;
  endfunction


endmodule
