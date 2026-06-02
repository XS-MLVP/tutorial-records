module WayLookup_top();

/*verilator public_flat_rw_on*/
  logic  clock;
  logic  reset;
  logic  io_flush;
  logic  io_read_ready;
  logic  io_read_valid;
  logic [7:0] io_read_bits_entry_vSetIdx_0;
  logic [7:0] io_read_bits_entry_vSetIdx_1;
  logic [3:0] io_read_bits_entry_waymask_0;
  logic [3:0] io_read_bits_entry_waymask_1;
  logic [35:0] io_read_bits_entry_ptag_0;
  logic [35:0] io_read_bits_entry_ptag_1;
  logic [1:0] io_read_bits_entry_itlb_exception_0;
  logic [1:0] io_read_bits_entry_itlb_exception_1;
  logic [1:0] io_read_bits_entry_itlb_pbmt_0;
  logic [1:0] io_read_bits_entry_itlb_pbmt_1;
  logic  io_read_bits_entry_meta_codes_0;
  logic  io_read_bits_entry_meta_codes_1;
  logic [55:0] io_read_bits_gpf_gpaddr;
  logic  io_read_bits_gpf_isForVSnonLeafPTE;
  logic  io_write_ready;
  logic  io_write_valid;
  logic [7:0] io_write_bits_entry_vSetIdx_0;
  logic [7:0] io_write_bits_entry_vSetIdx_1;
  logic [3:0] io_write_bits_entry_waymask_0;
  logic [3:0] io_write_bits_entry_waymask_1;
  logic [35:0] io_write_bits_entry_ptag_0;
  logic [35:0] io_write_bits_entry_ptag_1;
  logic [1:0] io_write_bits_entry_itlb_exception_0;
  logic [1:0] io_write_bits_entry_itlb_exception_1;
  logic [1:0] io_write_bits_entry_itlb_pbmt_0;
  logic [1:0] io_write_bits_entry_itlb_pbmt_1;
  logic  io_write_bits_entry_meta_codes_0;
  logic  io_write_bits_entry_meta_codes_1;
  logic [55:0] io_write_bits_gpf_gpaddr;
  logic  io_write_bits_gpf_isForVSnonLeafPTE;
  logic  io_update_valid;
  logic [41:0] io_update_bits_blkPaddr;
  logic [7:0] io_update_bits_vSetIdx;
  logic [3:0] io_update_bits_waymask;
  logic  io_update_bits_corrupt;
/*verilator public_off*/


 WayLookup WayLookup(
    .clock(clock),
    .reset(reset),
    .io_flush(io_flush),
    .io_read_ready(io_read_ready),
    .io_read_valid(io_read_valid),
    .io_read_bits_entry_vSetIdx_0(io_read_bits_entry_vSetIdx_0),
    .io_read_bits_entry_vSetIdx_1(io_read_bits_entry_vSetIdx_1),
    .io_read_bits_entry_waymask_0(io_read_bits_entry_waymask_0),
    .io_read_bits_entry_waymask_1(io_read_bits_entry_waymask_1),
    .io_read_bits_entry_ptag_0(io_read_bits_entry_ptag_0),
    .io_read_bits_entry_ptag_1(io_read_bits_entry_ptag_1),
    .io_read_bits_entry_itlb_exception_0(io_read_bits_entry_itlb_exception_0),
    .io_read_bits_entry_itlb_exception_1(io_read_bits_entry_itlb_exception_1),
    .io_read_bits_entry_itlb_pbmt_0(io_read_bits_entry_itlb_pbmt_0),
    .io_read_bits_entry_itlb_pbmt_1(io_read_bits_entry_itlb_pbmt_1),
    .io_read_bits_entry_meta_codes_0(io_read_bits_entry_meta_codes_0),
    .io_read_bits_entry_meta_codes_1(io_read_bits_entry_meta_codes_1),
    .io_read_bits_gpf_gpaddr(io_read_bits_gpf_gpaddr),
    .io_read_bits_gpf_isForVSnonLeafPTE(io_read_bits_gpf_isForVSnonLeafPTE),
    .io_write_ready(io_write_ready),
    .io_write_valid(io_write_valid),
    .io_write_bits_entry_vSetIdx_0(io_write_bits_entry_vSetIdx_0),
    .io_write_bits_entry_vSetIdx_1(io_write_bits_entry_vSetIdx_1),
    .io_write_bits_entry_waymask_0(io_write_bits_entry_waymask_0),
    .io_write_bits_entry_waymask_1(io_write_bits_entry_waymask_1),
    .io_write_bits_entry_ptag_0(io_write_bits_entry_ptag_0),
    .io_write_bits_entry_ptag_1(io_write_bits_entry_ptag_1),
    .io_write_bits_entry_itlb_exception_0(io_write_bits_entry_itlb_exception_0),
    .io_write_bits_entry_itlb_exception_1(io_write_bits_entry_itlb_exception_1),
    .io_write_bits_entry_itlb_pbmt_0(io_write_bits_entry_itlb_pbmt_0),
    .io_write_bits_entry_itlb_pbmt_1(io_write_bits_entry_itlb_pbmt_1),
    .io_write_bits_entry_meta_codes_0(io_write_bits_entry_meta_codes_0),
    .io_write_bits_entry_meta_codes_1(io_write_bits_entry_meta_codes_1),
    .io_write_bits_gpf_gpaddr(io_write_bits_gpf_gpaddr),
    .io_write_bits_gpf_isForVSnonLeafPTE(io_write_bits_gpf_isForVSnonLeafPTE),
    .io_update_valid(io_update_valid),
    .io_update_bits_blkPaddr(io_update_bits_blkPaddr),
    .io_update_bits_vSetIdx(io_update_bits_vSetIdx),
    .io_update_bits_waymask(io_update_bits_waymask),
    .io_update_bits_corrupt(io_update_bits_corrupt)
 );


  export "DPI-C" function get_clockxxFugHA0Uxpda;
  export "DPI-C" function set_clockxxFugHA0Uxpda;
  export "DPI-C" function get_resetxxFugHA0Uxpda;
  export "DPI-C" function set_resetxxFugHA0Uxpda;
  export "DPI-C" function get_io_flushxxFugHA0Uxpda;
  export "DPI-C" function set_io_flushxxFugHA0Uxpda;
  export "DPI-C" function get_io_read_readyxxFugHA0Uxpda;
  export "DPI-C" function set_io_read_readyxxFugHA0Uxpda;
  export "DPI-C" function get_io_read_validxxFugHA0Uxpda;
  export "DPI-C" function get_io_read_bits_entry_vSetIdx_0xxFugHA0Uxpda;
  export "DPI-C" function get_io_read_bits_entry_vSetIdx_1xxFugHA0Uxpda;
  export "DPI-C" function get_io_read_bits_entry_waymask_0xxFugHA0Uxpda;
  export "DPI-C" function get_io_read_bits_entry_waymask_1xxFugHA0Uxpda;
  export "DPI-C" function get_io_read_bits_entry_ptag_0xxFugHA0Uxpda;
  export "DPI-C" function get_io_read_bits_entry_ptag_1xxFugHA0Uxpda;
  export "DPI-C" function get_io_read_bits_entry_itlb_exception_0xxFugHA0Uxpda;
  export "DPI-C" function get_io_read_bits_entry_itlb_exception_1xxFugHA0Uxpda;
  export "DPI-C" function get_io_read_bits_entry_itlb_pbmt_0xxFugHA0Uxpda;
  export "DPI-C" function get_io_read_bits_entry_itlb_pbmt_1xxFugHA0Uxpda;
  export "DPI-C" function get_io_read_bits_entry_meta_codes_0xxFugHA0Uxpda;
  export "DPI-C" function get_io_read_bits_entry_meta_codes_1xxFugHA0Uxpda;
  export "DPI-C" function get_io_read_bits_gpf_gpaddrxxFugHA0Uxpda;
  export "DPI-C" function get_io_read_bits_gpf_isForVSnonLeafPTExxFugHA0Uxpda;
  export "DPI-C" function get_io_write_readyxxFugHA0Uxpda;
  export "DPI-C" function get_io_write_validxxFugHA0Uxpda;
  export "DPI-C" function set_io_write_validxxFugHA0Uxpda;
  export "DPI-C" function get_io_write_bits_entry_vSetIdx_0xxFugHA0Uxpda;
  export "DPI-C" function set_io_write_bits_entry_vSetIdx_0xxFugHA0Uxpda;
  export "DPI-C" function get_io_write_bits_entry_vSetIdx_1xxFugHA0Uxpda;
  export "DPI-C" function set_io_write_bits_entry_vSetIdx_1xxFugHA0Uxpda;
  export "DPI-C" function get_io_write_bits_entry_waymask_0xxFugHA0Uxpda;
  export "DPI-C" function set_io_write_bits_entry_waymask_0xxFugHA0Uxpda;
  export "DPI-C" function get_io_write_bits_entry_waymask_1xxFugHA0Uxpda;
  export "DPI-C" function set_io_write_bits_entry_waymask_1xxFugHA0Uxpda;
  export "DPI-C" function get_io_write_bits_entry_ptag_0xxFugHA0Uxpda;
  export "DPI-C" function set_io_write_bits_entry_ptag_0xxFugHA0Uxpda;
  export "DPI-C" function get_io_write_bits_entry_ptag_1xxFugHA0Uxpda;
  export "DPI-C" function set_io_write_bits_entry_ptag_1xxFugHA0Uxpda;
  export "DPI-C" function get_io_write_bits_entry_itlb_exception_0xxFugHA0Uxpda;
  export "DPI-C" function set_io_write_bits_entry_itlb_exception_0xxFugHA0Uxpda;
  export "DPI-C" function get_io_write_bits_entry_itlb_exception_1xxFugHA0Uxpda;
  export "DPI-C" function set_io_write_bits_entry_itlb_exception_1xxFugHA0Uxpda;
  export "DPI-C" function get_io_write_bits_entry_itlb_pbmt_0xxFugHA0Uxpda;
  export "DPI-C" function set_io_write_bits_entry_itlb_pbmt_0xxFugHA0Uxpda;
  export "DPI-C" function get_io_write_bits_entry_itlb_pbmt_1xxFugHA0Uxpda;
  export "DPI-C" function set_io_write_bits_entry_itlb_pbmt_1xxFugHA0Uxpda;
  export "DPI-C" function get_io_write_bits_entry_meta_codes_0xxFugHA0Uxpda;
  export "DPI-C" function set_io_write_bits_entry_meta_codes_0xxFugHA0Uxpda;
  export "DPI-C" function get_io_write_bits_entry_meta_codes_1xxFugHA0Uxpda;
  export "DPI-C" function set_io_write_bits_entry_meta_codes_1xxFugHA0Uxpda;
  export "DPI-C" function get_io_write_bits_gpf_gpaddrxxFugHA0Uxpda;
  export "DPI-C" function set_io_write_bits_gpf_gpaddrxxFugHA0Uxpda;
  export "DPI-C" function get_io_write_bits_gpf_isForVSnonLeafPTExxFugHA0Uxpda;
  export "DPI-C" function set_io_write_bits_gpf_isForVSnonLeafPTExxFugHA0Uxpda;
  export "DPI-C" function get_io_update_validxxFugHA0Uxpda;
  export "DPI-C" function set_io_update_validxxFugHA0Uxpda;
  export "DPI-C" function get_io_update_bits_blkPaddrxxFugHA0Uxpda;
  export "DPI-C" function set_io_update_bits_blkPaddrxxFugHA0Uxpda;
  export "DPI-C" function get_io_update_bits_vSetIdxxxFugHA0Uxpda;
  export "DPI-C" function set_io_update_bits_vSetIdxxxFugHA0Uxpda;
  export "DPI-C" function get_io_update_bits_waymaskxxFugHA0Uxpda;
  export "DPI-C" function set_io_update_bits_waymaskxxFugHA0Uxpda;
  export "DPI-C" function get_io_update_bits_corruptxxFugHA0Uxpda;
  export "DPI-C" function set_io_update_bits_corruptxxFugHA0Uxpda;


  function void get_clockxxFugHA0Uxpda;
    output logic  value;
    value=clock;
  endfunction

  function void set_clockxxFugHA0Uxpda;
    input logic  value;
    clock=value;
  endfunction

  function void get_resetxxFugHA0Uxpda;
    output logic  value;
    value=reset;
  endfunction

  function void set_resetxxFugHA0Uxpda;
    input logic  value;
    reset=value;
  endfunction

  function void get_io_flushxxFugHA0Uxpda;
    output logic  value;
    value=io_flush;
  endfunction

  function void set_io_flushxxFugHA0Uxpda;
    input logic  value;
    io_flush=value;
  endfunction

  function void get_io_read_readyxxFugHA0Uxpda;
    output logic  value;
    value=io_read_ready;
  endfunction

  function void set_io_read_readyxxFugHA0Uxpda;
    input logic  value;
    io_read_ready=value;
  endfunction

  function void get_io_read_validxxFugHA0Uxpda;
    output logic  value;
    value=io_read_valid;
  endfunction

  function void get_io_read_bits_entry_vSetIdx_0xxFugHA0Uxpda;
    output logic [7:0] value;
    value=io_read_bits_entry_vSetIdx_0;
  endfunction

  function void get_io_read_bits_entry_vSetIdx_1xxFugHA0Uxpda;
    output logic [7:0] value;
    value=io_read_bits_entry_vSetIdx_1;
  endfunction

  function void get_io_read_bits_entry_waymask_0xxFugHA0Uxpda;
    output logic [3:0] value;
    value=io_read_bits_entry_waymask_0;
  endfunction

  function void get_io_read_bits_entry_waymask_1xxFugHA0Uxpda;
    output logic [3:0] value;
    value=io_read_bits_entry_waymask_1;
  endfunction

  function void get_io_read_bits_entry_ptag_0xxFugHA0Uxpda;
    output logic [35:0] value;
    value=io_read_bits_entry_ptag_0;
  endfunction

  function void get_io_read_bits_entry_ptag_1xxFugHA0Uxpda;
    output logic [35:0] value;
    value=io_read_bits_entry_ptag_1;
  endfunction

  function void get_io_read_bits_entry_itlb_exception_0xxFugHA0Uxpda;
    output logic [1:0] value;
    value=io_read_bits_entry_itlb_exception_0;
  endfunction

  function void get_io_read_bits_entry_itlb_exception_1xxFugHA0Uxpda;
    output logic [1:0] value;
    value=io_read_bits_entry_itlb_exception_1;
  endfunction

  function void get_io_read_bits_entry_itlb_pbmt_0xxFugHA0Uxpda;
    output logic [1:0] value;
    value=io_read_bits_entry_itlb_pbmt_0;
  endfunction

  function void get_io_read_bits_entry_itlb_pbmt_1xxFugHA0Uxpda;
    output logic [1:0] value;
    value=io_read_bits_entry_itlb_pbmt_1;
  endfunction

  function void get_io_read_bits_entry_meta_codes_0xxFugHA0Uxpda;
    output logic  value;
    value=io_read_bits_entry_meta_codes_0;
  endfunction

  function void get_io_read_bits_entry_meta_codes_1xxFugHA0Uxpda;
    output logic  value;
    value=io_read_bits_entry_meta_codes_1;
  endfunction

  function void get_io_read_bits_gpf_gpaddrxxFugHA0Uxpda;
    output logic [55:0] value;
    value=io_read_bits_gpf_gpaddr;
  endfunction

  function void get_io_read_bits_gpf_isForVSnonLeafPTExxFugHA0Uxpda;
    output logic  value;
    value=io_read_bits_gpf_isForVSnonLeafPTE;
  endfunction

  function void get_io_write_readyxxFugHA0Uxpda;
    output logic  value;
    value=io_write_ready;
  endfunction

  function void get_io_write_validxxFugHA0Uxpda;
    output logic  value;
    value=io_write_valid;
  endfunction

  function void set_io_write_validxxFugHA0Uxpda;
    input logic  value;
    io_write_valid=value;
  endfunction

  function void get_io_write_bits_entry_vSetIdx_0xxFugHA0Uxpda;
    output logic [7:0] value;
    value=io_write_bits_entry_vSetIdx_0;
  endfunction

  function void set_io_write_bits_entry_vSetIdx_0xxFugHA0Uxpda;
    input logic [7:0] value;
    io_write_bits_entry_vSetIdx_0=value;
  endfunction

  function void get_io_write_bits_entry_vSetIdx_1xxFugHA0Uxpda;
    output logic [7:0] value;
    value=io_write_bits_entry_vSetIdx_1;
  endfunction

  function void set_io_write_bits_entry_vSetIdx_1xxFugHA0Uxpda;
    input logic [7:0] value;
    io_write_bits_entry_vSetIdx_1=value;
  endfunction

  function void get_io_write_bits_entry_waymask_0xxFugHA0Uxpda;
    output logic [3:0] value;
    value=io_write_bits_entry_waymask_0;
  endfunction

  function void set_io_write_bits_entry_waymask_0xxFugHA0Uxpda;
    input logic [3:0] value;
    io_write_bits_entry_waymask_0=value;
  endfunction

  function void get_io_write_bits_entry_waymask_1xxFugHA0Uxpda;
    output logic [3:0] value;
    value=io_write_bits_entry_waymask_1;
  endfunction

  function void set_io_write_bits_entry_waymask_1xxFugHA0Uxpda;
    input logic [3:0] value;
    io_write_bits_entry_waymask_1=value;
  endfunction

  function void get_io_write_bits_entry_ptag_0xxFugHA0Uxpda;
    output logic [35:0] value;
    value=io_write_bits_entry_ptag_0;
  endfunction

  function void set_io_write_bits_entry_ptag_0xxFugHA0Uxpda;
    input logic [35:0] value;
    io_write_bits_entry_ptag_0=value;
  endfunction

  function void get_io_write_bits_entry_ptag_1xxFugHA0Uxpda;
    output logic [35:0] value;
    value=io_write_bits_entry_ptag_1;
  endfunction

  function void set_io_write_bits_entry_ptag_1xxFugHA0Uxpda;
    input logic [35:0] value;
    io_write_bits_entry_ptag_1=value;
  endfunction

  function void get_io_write_bits_entry_itlb_exception_0xxFugHA0Uxpda;
    output logic [1:0] value;
    value=io_write_bits_entry_itlb_exception_0;
  endfunction

  function void set_io_write_bits_entry_itlb_exception_0xxFugHA0Uxpda;
    input logic [1:0] value;
    io_write_bits_entry_itlb_exception_0=value;
  endfunction

  function void get_io_write_bits_entry_itlb_exception_1xxFugHA0Uxpda;
    output logic [1:0] value;
    value=io_write_bits_entry_itlb_exception_1;
  endfunction

  function void set_io_write_bits_entry_itlb_exception_1xxFugHA0Uxpda;
    input logic [1:0] value;
    io_write_bits_entry_itlb_exception_1=value;
  endfunction

  function void get_io_write_bits_entry_itlb_pbmt_0xxFugHA0Uxpda;
    output logic [1:0] value;
    value=io_write_bits_entry_itlb_pbmt_0;
  endfunction

  function void set_io_write_bits_entry_itlb_pbmt_0xxFugHA0Uxpda;
    input logic [1:0] value;
    io_write_bits_entry_itlb_pbmt_0=value;
  endfunction

  function void get_io_write_bits_entry_itlb_pbmt_1xxFugHA0Uxpda;
    output logic [1:0] value;
    value=io_write_bits_entry_itlb_pbmt_1;
  endfunction

  function void set_io_write_bits_entry_itlb_pbmt_1xxFugHA0Uxpda;
    input logic [1:0] value;
    io_write_bits_entry_itlb_pbmt_1=value;
  endfunction

  function void get_io_write_bits_entry_meta_codes_0xxFugHA0Uxpda;
    output logic  value;
    value=io_write_bits_entry_meta_codes_0;
  endfunction

  function void set_io_write_bits_entry_meta_codes_0xxFugHA0Uxpda;
    input logic  value;
    io_write_bits_entry_meta_codes_0=value;
  endfunction

  function void get_io_write_bits_entry_meta_codes_1xxFugHA0Uxpda;
    output logic  value;
    value=io_write_bits_entry_meta_codes_1;
  endfunction

  function void set_io_write_bits_entry_meta_codes_1xxFugHA0Uxpda;
    input logic  value;
    io_write_bits_entry_meta_codes_1=value;
  endfunction

  function void get_io_write_bits_gpf_gpaddrxxFugHA0Uxpda;
    output logic [55:0] value;
    value=io_write_bits_gpf_gpaddr;
  endfunction

  function void set_io_write_bits_gpf_gpaddrxxFugHA0Uxpda;
    input logic [55:0] value;
    io_write_bits_gpf_gpaddr=value;
  endfunction

  function void get_io_write_bits_gpf_isForVSnonLeafPTExxFugHA0Uxpda;
    output logic  value;
    value=io_write_bits_gpf_isForVSnonLeafPTE;
  endfunction

  function void set_io_write_bits_gpf_isForVSnonLeafPTExxFugHA0Uxpda;
    input logic  value;
    io_write_bits_gpf_isForVSnonLeafPTE=value;
  endfunction

  function void get_io_update_validxxFugHA0Uxpda;
    output logic  value;
    value=io_update_valid;
  endfunction

  function void set_io_update_validxxFugHA0Uxpda;
    input logic  value;
    io_update_valid=value;
  endfunction

  function void get_io_update_bits_blkPaddrxxFugHA0Uxpda;
    output logic [41:0] value;
    value=io_update_bits_blkPaddr;
  endfunction

  function void set_io_update_bits_blkPaddrxxFugHA0Uxpda;
    input logic [41:0] value;
    io_update_bits_blkPaddr=value;
  endfunction

  function void get_io_update_bits_vSetIdxxxFugHA0Uxpda;
    output logic [7:0] value;
    value=io_update_bits_vSetIdx;
  endfunction

  function void set_io_update_bits_vSetIdxxxFugHA0Uxpda;
    input logic [7:0] value;
    io_update_bits_vSetIdx=value;
  endfunction

  function void get_io_update_bits_waymaskxxFugHA0Uxpda;
    output logic [3:0] value;
    value=io_update_bits_waymask;
  endfunction

  function void set_io_update_bits_waymaskxxFugHA0Uxpda;
    input logic [3:0] value;
    io_update_bits_waymask=value;
  endfunction

  function void get_io_update_bits_corruptxxFugHA0Uxpda;
    output logic  value;
    value=io_update_bits_corrupt;
  endfunction

  function void set_io_update_bits_corruptxxFugHA0Uxpda;
    input logic  value;
    io_update_bits_corrupt=value;
  endfunction



  initial begin
    $dumpfile("output/workspace_WayLookup/WayLookup/WayLookup.vcd");
    $dumpvars(0, WayLookup_top);
  end

  export "DPI-C" function finish_FugHA0Uxpda;
  function void finish_FugHA0Uxpda;
    $finish;
  endfunction


endmodule
