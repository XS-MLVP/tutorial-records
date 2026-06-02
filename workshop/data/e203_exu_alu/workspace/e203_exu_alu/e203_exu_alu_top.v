module e203_exu_alu_top;

  wire  i_valid;
  wire  i_ready;
  wire  i_longpipe;
  wire  nice_xs_off;
  wire  amo_wait;
  wire  oitf_empty;
  wire [0:0] i_itag;
  wire [31:0] i_rs1;
  wire [31:0] i_rs2;
  wire [31:0] i_imm;
  wire [31:0] i_info;
  wire [31:0] i_pc;
  wire [31:0] i_instr;
  wire  i_pc_vld;
  wire [4:0] i_rdidx;
  wire  i_rdwen;
  wire  i_ilegl;
  wire  i_buserr;
  wire  i_misalgn;
  wire  flush_req;
  wire  flush_pulse;
  wire  cmt_o_valid;
  wire  cmt_o_ready;
  wire  cmt_o_pc_vld;
  wire [31:0] cmt_o_pc;
  wire [31:0] cmt_o_instr;
  wire [31:0] cmt_o_imm;
  wire  cmt_o_rv32;
  wire  cmt_o_bjp;
  wire  cmt_o_mret;
  wire  cmt_o_dret;
  wire  cmt_o_ecall;
  wire  cmt_o_ebreak;
  wire  cmt_o_fencei;
  wire  cmt_o_wfi;
  wire  cmt_o_ifu_misalgn;
  wire  cmt_o_ifu_buserr;
  wire  cmt_o_ifu_ilegl;
  wire  cmt_o_bjp_prdt;
  wire  cmt_o_bjp_rslv;
  wire  cmt_o_misalgn;
  wire  cmt_o_ld;
  wire  cmt_o_stamo;
  wire  cmt_o_buserr;
  wire [31:0] cmt_o_badaddr;
  wire  wbck_o_valid;
  wire  wbck_o_ready;
  wire [31:0] wbck_o_wdat;
  wire [4:0] wbck_o_rdidx;
  wire  mdv_nob2b;
  wire  csr_ena;
  wire  csr_wr_en;
  wire  csr_rd_en;
  wire [11:0] csr_idx;
  wire  nonflush_cmt_ena;
  wire  csr_access_ilgl;
  wire [31:0] read_csr_dat;
  wire [31:0] wbck_csr_dat;
  wire  agu_icb_cmd_valid;
  wire  agu_icb_cmd_ready;
  wire [31:0] agu_icb_cmd_addr;
  wire  agu_icb_cmd_read;
  wire [31:0] agu_icb_cmd_wdata;
  wire [3:0] agu_icb_cmd_wmask;
  wire  agu_icb_cmd_lock;
  wire  agu_icb_cmd_excl;
  wire [1:0] agu_icb_cmd_size;
  wire  agu_icb_cmd_back2agu;
  wire  agu_icb_cmd_usign;
  wire [0:0] agu_icb_cmd_itag;
  wire  agu_icb_rsp_valid;
  wire  agu_icb_rsp_ready;
  wire  agu_icb_rsp_err;
  wire  agu_icb_rsp_excl_ok;
  wire [31:0] agu_icb_rsp_rdata;
  wire  nice_req_valid;
  wire  nice_req_ready;
  wire [31:0] nice_req_instr;
  wire [31:0] nice_req_rs1;
  wire [31:0] nice_req_rs2;
  wire  nice_rsp_multicyc_valid;
  wire  nice_rsp_multicyc_ready;
  wire  nice_longp_wbck_valid;
  wire  nice_longp_wbck_ready;
  wire [0:0] nice_o_itag;
  wire  i_nice_cmt_off_ilgl;
  wire  clk;
  wire  rst_n;


 e203_exu_alu e203_exu_alu(
    .i_valid(i_valid),
    .i_ready(i_ready),
    .i_longpipe(i_longpipe),
    .nice_xs_off(nice_xs_off),
    .amo_wait(amo_wait),
    .oitf_empty(oitf_empty),
    .i_itag(i_itag),
    .i_rs1(i_rs1),
    .i_rs2(i_rs2),
    .i_imm(i_imm),
    .i_info(i_info),
    .i_pc(i_pc),
    .i_instr(i_instr),
    .i_pc_vld(i_pc_vld),
    .i_rdidx(i_rdidx),
    .i_rdwen(i_rdwen),
    .i_ilegl(i_ilegl),
    .i_buserr(i_buserr),
    .i_misalgn(i_misalgn),
    .flush_req(flush_req),
    .flush_pulse(flush_pulse),
    .cmt_o_valid(cmt_o_valid),
    .cmt_o_ready(cmt_o_ready),
    .cmt_o_pc_vld(cmt_o_pc_vld),
    .cmt_o_pc(cmt_o_pc),
    .cmt_o_instr(cmt_o_instr),
    .cmt_o_imm(cmt_o_imm),
    .cmt_o_rv32(cmt_o_rv32),
    .cmt_o_bjp(cmt_o_bjp),
    .cmt_o_mret(cmt_o_mret),
    .cmt_o_dret(cmt_o_dret),
    .cmt_o_ecall(cmt_o_ecall),
    .cmt_o_ebreak(cmt_o_ebreak),
    .cmt_o_fencei(cmt_o_fencei),
    .cmt_o_wfi(cmt_o_wfi),
    .cmt_o_ifu_misalgn(cmt_o_ifu_misalgn),
    .cmt_o_ifu_buserr(cmt_o_ifu_buserr),
    .cmt_o_ifu_ilegl(cmt_o_ifu_ilegl),
    .cmt_o_bjp_prdt(cmt_o_bjp_prdt),
    .cmt_o_bjp_rslv(cmt_o_bjp_rslv),
    .cmt_o_misalgn(cmt_o_misalgn),
    .cmt_o_ld(cmt_o_ld),
    .cmt_o_stamo(cmt_o_stamo),
    .cmt_o_buserr(cmt_o_buserr),
    .cmt_o_badaddr(cmt_o_badaddr),
    .wbck_o_valid(wbck_o_valid),
    .wbck_o_ready(wbck_o_ready),
    .wbck_o_wdat(wbck_o_wdat),
    .wbck_o_rdidx(wbck_o_rdidx),
    .mdv_nob2b(mdv_nob2b),
    .csr_ena(csr_ena),
    .csr_wr_en(csr_wr_en),
    .csr_rd_en(csr_rd_en),
    .csr_idx(csr_idx),
    .nonflush_cmt_ena(nonflush_cmt_ena),
    .csr_access_ilgl(csr_access_ilgl),
    .read_csr_dat(read_csr_dat),
    .wbck_csr_dat(wbck_csr_dat),
    .agu_icb_cmd_valid(agu_icb_cmd_valid),
    .agu_icb_cmd_ready(agu_icb_cmd_ready),
    .agu_icb_cmd_addr(agu_icb_cmd_addr),
    .agu_icb_cmd_read(agu_icb_cmd_read),
    .agu_icb_cmd_wdata(agu_icb_cmd_wdata),
    .agu_icb_cmd_wmask(agu_icb_cmd_wmask),
    .agu_icb_cmd_lock(agu_icb_cmd_lock),
    .agu_icb_cmd_excl(agu_icb_cmd_excl),
    .agu_icb_cmd_size(agu_icb_cmd_size),
    .agu_icb_cmd_back2agu(agu_icb_cmd_back2agu),
    .agu_icb_cmd_usign(agu_icb_cmd_usign),
    .agu_icb_cmd_itag(agu_icb_cmd_itag),
    .agu_icb_rsp_valid(agu_icb_rsp_valid),
    .agu_icb_rsp_ready(agu_icb_rsp_ready),
    .agu_icb_rsp_err(agu_icb_rsp_err),
    .agu_icb_rsp_excl_ok(agu_icb_rsp_excl_ok),
    .agu_icb_rsp_rdata(agu_icb_rsp_rdata),
    .nice_req_valid(nice_req_valid),
    .nice_req_ready(nice_req_ready),
    .nice_req_instr(nice_req_instr),
    .nice_req_rs1(nice_req_rs1),
    .nice_req_rs2(nice_req_rs2),
    .nice_rsp_multicyc_valid(nice_rsp_multicyc_valid),
    .nice_rsp_multicyc_ready(nice_rsp_multicyc_ready),
    .nice_longp_wbck_valid(nice_longp_wbck_valid),
    .nice_longp_wbck_ready(nice_longp_wbck_ready),
    .nice_o_itag(nice_o_itag),
    .i_nice_cmt_off_ilgl(i_nice_cmt_off_ilgl),
    .clk(clk),
    .rst_n(rst_n)
 );


endmodule
