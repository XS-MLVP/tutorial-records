module WayLookup_top;

  wire  clock;
  wire  reset;
  wire  io_flush;
  wire  io_read_ready;
  wire  io_read_valid;
  wire [7:0] io_read_bits_entry_vSetIdx_0;
  wire [7:0] io_read_bits_entry_vSetIdx_1;
  wire [3:0] io_read_bits_entry_waymask_0;
  wire [3:0] io_read_bits_entry_waymask_1;
  wire [35:0] io_read_bits_entry_ptag_0;
  wire [35:0] io_read_bits_entry_ptag_1;
  wire [1:0] io_read_bits_entry_itlb_exception_0;
  wire [1:0] io_read_bits_entry_itlb_exception_1;
  wire [1:0] io_read_bits_entry_itlb_pbmt_0;
  wire [1:0] io_read_bits_entry_itlb_pbmt_1;
  wire  io_read_bits_entry_meta_codes_0;
  wire  io_read_bits_entry_meta_codes_1;
  wire [55:0] io_read_bits_gpf_gpaddr;
  wire  io_read_bits_gpf_isForVSnonLeafPTE;
  wire  io_write_ready;
  wire  io_write_valid;
  wire [7:0] io_write_bits_entry_vSetIdx_0;
  wire [7:0] io_write_bits_entry_vSetIdx_1;
  wire [3:0] io_write_bits_entry_waymask_0;
  wire [3:0] io_write_bits_entry_waymask_1;
  wire [35:0] io_write_bits_entry_ptag_0;
  wire [35:0] io_write_bits_entry_ptag_1;
  wire [1:0] io_write_bits_entry_itlb_exception_0;
  wire [1:0] io_write_bits_entry_itlb_exception_1;
  wire [1:0] io_write_bits_entry_itlb_pbmt_0;
  wire [1:0] io_write_bits_entry_itlb_pbmt_1;
  wire  io_write_bits_entry_meta_codes_0;
  wire  io_write_bits_entry_meta_codes_1;
  wire [55:0] io_write_bits_gpf_gpaddr;
  wire  io_write_bits_gpf_isForVSnonLeafPTE;
  wire  io_update_valid;
  wire [41:0] io_update_bits_blkPaddr;
  wire [7:0] io_update_bits_vSetIdx;
  wire [3:0] io_update_bits_waymask;
  wire  io_update_bits_corrupt;


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


endmodule
