module e203_exu_alu_top();

/*verilator public_flat_rw_on*/
  logic  i_valid;
  logic  i_ready;
  logic  i_longpipe;
  logic  nice_xs_off;
  logic  amo_wait;
  logic  oitf_empty;
  logic [0:0] i_itag;
  logic [31:0] i_rs1;
  logic [31:0] i_rs2;
  logic [31:0] i_imm;
  logic [31:0] i_info;
  logic [31:0] i_pc;
  logic [31:0] i_instr;
  logic  i_pc_vld;
  logic [4:0] i_rdidx;
  logic  i_rdwen;
  logic  i_ilegl;
  logic  i_buserr;
  logic  i_misalgn;
  logic  flush_req;
  logic  flush_pulse;
  logic  cmt_o_valid;
  logic  cmt_o_ready;
  logic  cmt_o_pc_vld;
  logic [31:0] cmt_o_pc;
  logic [31:0] cmt_o_instr;
  logic [31:0] cmt_o_imm;
  logic  cmt_o_rv32;
  logic  cmt_o_bjp;
  logic  cmt_o_mret;
  logic  cmt_o_dret;
  logic  cmt_o_ecall;
  logic  cmt_o_ebreak;
  logic  cmt_o_fencei;
  logic  cmt_o_wfi;
  logic  cmt_o_ifu_misalgn;
  logic  cmt_o_ifu_buserr;
  logic  cmt_o_ifu_ilegl;
  logic  cmt_o_bjp_prdt;
  logic  cmt_o_bjp_rslv;
  logic  cmt_o_misalgn;
  logic  cmt_o_ld;
  logic  cmt_o_stamo;
  logic  cmt_o_buserr;
  logic [31:0] cmt_o_badaddr;
  logic  wbck_o_valid;
  logic  wbck_o_ready;
  logic [31:0] wbck_o_wdat;
  logic [4:0] wbck_o_rdidx;
  logic  mdv_nob2b;
  logic  csr_ena;
  logic  csr_wr_en;
  logic  csr_rd_en;
  logic [11:0] csr_idx;
  logic  nonflush_cmt_ena;
  logic  csr_access_ilgl;
  logic [31:0] read_csr_dat;
  logic [31:0] wbck_csr_dat;
  logic  agu_icb_cmd_valid;
  logic  agu_icb_cmd_ready;
  logic [31:0] agu_icb_cmd_addr;
  logic  agu_icb_cmd_read;
  logic [31:0] agu_icb_cmd_wdata;
  logic [3:0] agu_icb_cmd_wmask;
  logic  agu_icb_cmd_lock;
  logic  agu_icb_cmd_excl;
  logic [1:0] agu_icb_cmd_size;
  logic  agu_icb_cmd_back2agu;
  logic  agu_icb_cmd_usign;
  logic [0:0] agu_icb_cmd_itag;
  logic  agu_icb_rsp_valid;
  logic  agu_icb_rsp_ready;
  logic  agu_icb_rsp_err;
  logic  agu_icb_rsp_excl_ok;
  logic [31:0] agu_icb_rsp_rdata;
  logic  nice_req_valid;
  logic  nice_req_ready;
  logic [31:0] nice_req_instr;
  logic [31:0] nice_req_rs1;
  logic [31:0] nice_req_rs2;
  logic  nice_rsp_multicyc_valid;
  logic  nice_rsp_multicyc_ready;
  logic  nice_longp_wbck_valid;
  logic  nice_longp_wbck_ready;
  logic [0:0] nice_o_itag;
  logic  i_nice_cmt_off_ilgl;
  logic  clk;
  logic  rst_n;
/*verilator public_off*/


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


  export "DPI-C" function get_i_validxxKBUVG1SkiKN;
  export "DPI-C" function set_i_validxxKBUVG1SkiKN;
  export "DPI-C" function get_i_readyxxKBUVG1SkiKN;
  export "DPI-C" function get_i_longpipexxKBUVG1SkiKN;
  export "DPI-C" function get_nice_xs_offxxKBUVG1SkiKN;
  export "DPI-C" function set_nice_xs_offxxKBUVG1SkiKN;
  export "DPI-C" function get_amo_waitxxKBUVG1SkiKN;
  export "DPI-C" function get_oitf_emptyxxKBUVG1SkiKN;
  export "DPI-C" function set_oitf_emptyxxKBUVG1SkiKN;
  export "DPI-C" function get_i_itagxxKBUVG1SkiKN;
  export "DPI-C" function set_i_itagxxKBUVG1SkiKN;
  export "DPI-C" function get_i_rs1xxKBUVG1SkiKN;
  export "DPI-C" function set_i_rs1xxKBUVG1SkiKN;
  export "DPI-C" function get_i_rs2xxKBUVG1SkiKN;
  export "DPI-C" function set_i_rs2xxKBUVG1SkiKN;
  export "DPI-C" function get_i_immxxKBUVG1SkiKN;
  export "DPI-C" function set_i_immxxKBUVG1SkiKN;
  export "DPI-C" function get_i_infoxxKBUVG1SkiKN;
  export "DPI-C" function set_i_infoxxKBUVG1SkiKN;
  export "DPI-C" function get_i_pcxxKBUVG1SkiKN;
  export "DPI-C" function set_i_pcxxKBUVG1SkiKN;
  export "DPI-C" function get_i_instrxxKBUVG1SkiKN;
  export "DPI-C" function set_i_instrxxKBUVG1SkiKN;
  export "DPI-C" function get_i_pc_vldxxKBUVG1SkiKN;
  export "DPI-C" function set_i_pc_vldxxKBUVG1SkiKN;
  export "DPI-C" function get_i_rdidxxxKBUVG1SkiKN;
  export "DPI-C" function set_i_rdidxxxKBUVG1SkiKN;
  export "DPI-C" function get_i_rdwenxxKBUVG1SkiKN;
  export "DPI-C" function set_i_rdwenxxKBUVG1SkiKN;
  export "DPI-C" function get_i_ileglxxKBUVG1SkiKN;
  export "DPI-C" function set_i_ileglxxKBUVG1SkiKN;
  export "DPI-C" function get_i_buserrxxKBUVG1SkiKN;
  export "DPI-C" function set_i_buserrxxKBUVG1SkiKN;
  export "DPI-C" function get_i_misalgnxxKBUVG1SkiKN;
  export "DPI-C" function set_i_misalgnxxKBUVG1SkiKN;
  export "DPI-C" function get_flush_reqxxKBUVG1SkiKN;
  export "DPI-C" function set_flush_reqxxKBUVG1SkiKN;
  export "DPI-C" function get_flush_pulsexxKBUVG1SkiKN;
  export "DPI-C" function set_flush_pulsexxKBUVG1SkiKN;
  export "DPI-C" function get_cmt_o_validxxKBUVG1SkiKN;
  export "DPI-C" function get_cmt_o_readyxxKBUVG1SkiKN;
  export "DPI-C" function set_cmt_o_readyxxKBUVG1SkiKN;
  export "DPI-C" function get_cmt_o_pc_vldxxKBUVG1SkiKN;
  export "DPI-C" function get_cmt_o_pcxxKBUVG1SkiKN;
  export "DPI-C" function get_cmt_o_instrxxKBUVG1SkiKN;
  export "DPI-C" function get_cmt_o_immxxKBUVG1SkiKN;
  export "DPI-C" function get_cmt_o_rv32xxKBUVG1SkiKN;
  export "DPI-C" function get_cmt_o_bjpxxKBUVG1SkiKN;
  export "DPI-C" function get_cmt_o_mretxxKBUVG1SkiKN;
  export "DPI-C" function get_cmt_o_dretxxKBUVG1SkiKN;
  export "DPI-C" function get_cmt_o_ecallxxKBUVG1SkiKN;
  export "DPI-C" function get_cmt_o_ebreakxxKBUVG1SkiKN;
  export "DPI-C" function get_cmt_o_fenceixxKBUVG1SkiKN;
  export "DPI-C" function get_cmt_o_wfixxKBUVG1SkiKN;
  export "DPI-C" function get_cmt_o_ifu_misalgnxxKBUVG1SkiKN;
  export "DPI-C" function get_cmt_o_ifu_buserrxxKBUVG1SkiKN;
  export "DPI-C" function get_cmt_o_ifu_ileglxxKBUVG1SkiKN;
  export "DPI-C" function get_cmt_o_bjp_prdtxxKBUVG1SkiKN;
  export "DPI-C" function get_cmt_o_bjp_rslvxxKBUVG1SkiKN;
  export "DPI-C" function get_cmt_o_misalgnxxKBUVG1SkiKN;
  export "DPI-C" function get_cmt_o_ldxxKBUVG1SkiKN;
  export "DPI-C" function get_cmt_o_stamoxxKBUVG1SkiKN;
  export "DPI-C" function get_cmt_o_buserrxxKBUVG1SkiKN;
  export "DPI-C" function get_cmt_o_badaddrxxKBUVG1SkiKN;
  export "DPI-C" function get_wbck_o_validxxKBUVG1SkiKN;
  export "DPI-C" function get_wbck_o_readyxxKBUVG1SkiKN;
  export "DPI-C" function set_wbck_o_readyxxKBUVG1SkiKN;
  export "DPI-C" function get_wbck_o_wdatxxKBUVG1SkiKN;
  export "DPI-C" function get_wbck_o_rdidxxxKBUVG1SkiKN;
  export "DPI-C" function get_mdv_nob2bxxKBUVG1SkiKN;
  export "DPI-C" function set_mdv_nob2bxxKBUVG1SkiKN;
  export "DPI-C" function get_csr_enaxxKBUVG1SkiKN;
  export "DPI-C" function get_csr_wr_enxxKBUVG1SkiKN;
  export "DPI-C" function get_csr_rd_enxxKBUVG1SkiKN;
  export "DPI-C" function get_csr_idxxxKBUVG1SkiKN;
  export "DPI-C" function get_nonflush_cmt_enaxxKBUVG1SkiKN;
  export "DPI-C" function set_nonflush_cmt_enaxxKBUVG1SkiKN;
  export "DPI-C" function get_csr_access_ilglxxKBUVG1SkiKN;
  export "DPI-C" function set_csr_access_ilglxxKBUVG1SkiKN;
  export "DPI-C" function get_read_csr_datxxKBUVG1SkiKN;
  export "DPI-C" function set_read_csr_datxxKBUVG1SkiKN;
  export "DPI-C" function get_wbck_csr_datxxKBUVG1SkiKN;
  export "DPI-C" function get_agu_icb_cmd_validxxKBUVG1SkiKN;
  export "DPI-C" function get_agu_icb_cmd_readyxxKBUVG1SkiKN;
  export "DPI-C" function set_agu_icb_cmd_readyxxKBUVG1SkiKN;
  export "DPI-C" function get_agu_icb_cmd_addrxxKBUVG1SkiKN;
  export "DPI-C" function get_agu_icb_cmd_readxxKBUVG1SkiKN;
  export "DPI-C" function get_agu_icb_cmd_wdataxxKBUVG1SkiKN;
  export "DPI-C" function get_agu_icb_cmd_wmaskxxKBUVG1SkiKN;
  export "DPI-C" function get_agu_icb_cmd_lockxxKBUVG1SkiKN;
  export "DPI-C" function get_agu_icb_cmd_exclxxKBUVG1SkiKN;
  export "DPI-C" function get_agu_icb_cmd_sizexxKBUVG1SkiKN;
  export "DPI-C" function get_agu_icb_cmd_back2aguxxKBUVG1SkiKN;
  export "DPI-C" function get_agu_icb_cmd_usignxxKBUVG1SkiKN;
  export "DPI-C" function get_agu_icb_cmd_itagxxKBUVG1SkiKN;
  export "DPI-C" function get_agu_icb_rsp_validxxKBUVG1SkiKN;
  export "DPI-C" function set_agu_icb_rsp_validxxKBUVG1SkiKN;
  export "DPI-C" function get_agu_icb_rsp_readyxxKBUVG1SkiKN;
  export "DPI-C" function get_agu_icb_rsp_errxxKBUVG1SkiKN;
  export "DPI-C" function set_agu_icb_rsp_errxxKBUVG1SkiKN;
  export "DPI-C" function get_agu_icb_rsp_excl_okxxKBUVG1SkiKN;
  export "DPI-C" function set_agu_icb_rsp_excl_okxxKBUVG1SkiKN;
  export "DPI-C" function get_agu_icb_rsp_rdataxxKBUVG1SkiKN;
  export "DPI-C" function set_agu_icb_rsp_rdataxxKBUVG1SkiKN;
  export "DPI-C" function get_nice_req_validxxKBUVG1SkiKN;
  export "DPI-C" function get_nice_req_readyxxKBUVG1SkiKN;
  export "DPI-C" function set_nice_req_readyxxKBUVG1SkiKN;
  export "DPI-C" function get_nice_req_instrxxKBUVG1SkiKN;
  export "DPI-C" function get_nice_req_rs1xxKBUVG1SkiKN;
  export "DPI-C" function get_nice_req_rs2xxKBUVG1SkiKN;
  export "DPI-C" function get_nice_rsp_multicyc_validxxKBUVG1SkiKN;
  export "DPI-C" function set_nice_rsp_multicyc_validxxKBUVG1SkiKN;
  export "DPI-C" function get_nice_rsp_multicyc_readyxxKBUVG1SkiKN;
  export "DPI-C" function get_nice_longp_wbck_validxxKBUVG1SkiKN;
  export "DPI-C" function get_nice_longp_wbck_readyxxKBUVG1SkiKN;
  export "DPI-C" function set_nice_longp_wbck_readyxxKBUVG1SkiKN;
  export "DPI-C" function get_nice_o_itagxxKBUVG1SkiKN;
  export "DPI-C" function get_i_nice_cmt_off_ilglxxKBUVG1SkiKN;
  export "DPI-C" function set_i_nice_cmt_off_ilglxxKBUVG1SkiKN;
  export "DPI-C" function get_clkxxKBUVG1SkiKN;
  export "DPI-C" function set_clkxxKBUVG1SkiKN;
  export "DPI-C" function get_rst_nxxKBUVG1SkiKN;
  export "DPI-C" function set_rst_nxxKBUVG1SkiKN;


  function void get_i_validxxKBUVG1SkiKN;
    output logic  value;
    value=i_valid;
  endfunction

  function void set_i_validxxKBUVG1SkiKN;
    input logic  value;
    i_valid=value;
  endfunction

  function void get_i_readyxxKBUVG1SkiKN;
    output logic  value;
    value=i_ready;
  endfunction

  function void get_i_longpipexxKBUVG1SkiKN;
    output logic  value;
    value=i_longpipe;
  endfunction

  function void get_nice_xs_offxxKBUVG1SkiKN;
    output logic  value;
    value=nice_xs_off;
  endfunction

  function void set_nice_xs_offxxKBUVG1SkiKN;
    input logic  value;
    nice_xs_off=value;
  endfunction

  function void get_amo_waitxxKBUVG1SkiKN;
    output logic  value;
    value=amo_wait;
  endfunction

  function void get_oitf_emptyxxKBUVG1SkiKN;
    output logic  value;
    value=oitf_empty;
  endfunction

  function void set_oitf_emptyxxKBUVG1SkiKN;
    input logic  value;
    oitf_empty=value;
  endfunction

  function void get_i_itagxxKBUVG1SkiKN;
    output logic [0:0] value;
    value=i_itag;
  endfunction

  function void set_i_itagxxKBUVG1SkiKN;
    input logic [0:0] value;
    i_itag=value;
  endfunction

  function void get_i_rs1xxKBUVG1SkiKN;
    output logic [31:0] value;
    value=i_rs1;
  endfunction

  function void set_i_rs1xxKBUVG1SkiKN;
    input logic [31:0] value;
    i_rs1=value;
  endfunction

  function void get_i_rs2xxKBUVG1SkiKN;
    output logic [31:0] value;
    value=i_rs2;
  endfunction

  function void set_i_rs2xxKBUVG1SkiKN;
    input logic [31:0] value;
    i_rs2=value;
  endfunction

  function void get_i_immxxKBUVG1SkiKN;
    output logic [31:0] value;
    value=i_imm;
  endfunction

  function void set_i_immxxKBUVG1SkiKN;
    input logic [31:0] value;
    i_imm=value;
  endfunction

  function void get_i_infoxxKBUVG1SkiKN;
    output logic [31:0] value;
    value=i_info;
  endfunction

  function void set_i_infoxxKBUVG1SkiKN;
    input logic [31:0] value;
    i_info=value;
  endfunction

  function void get_i_pcxxKBUVG1SkiKN;
    output logic [31:0] value;
    value=i_pc;
  endfunction

  function void set_i_pcxxKBUVG1SkiKN;
    input logic [31:0] value;
    i_pc=value;
  endfunction

  function void get_i_instrxxKBUVG1SkiKN;
    output logic [31:0] value;
    value=i_instr;
  endfunction

  function void set_i_instrxxKBUVG1SkiKN;
    input logic [31:0] value;
    i_instr=value;
  endfunction

  function void get_i_pc_vldxxKBUVG1SkiKN;
    output logic  value;
    value=i_pc_vld;
  endfunction

  function void set_i_pc_vldxxKBUVG1SkiKN;
    input logic  value;
    i_pc_vld=value;
  endfunction

  function void get_i_rdidxxxKBUVG1SkiKN;
    output logic [4:0] value;
    value=i_rdidx;
  endfunction

  function void set_i_rdidxxxKBUVG1SkiKN;
    input logic [4:0] value;
    i_rdidx=value;
  endfunction

  function void get_i_rdwenxxKBUVG1SkiKN;
    output logic  value;
    value=i_rdwen;
  endfunction

  function void set_i_rdwenxxKBUVG1SkiKN;
    input logic  value;
    i_rdwen=value;
  endfunction

  function void get_i_ileglxxKBUVG1SkiKN;
    output logic  value;
    value=i_ilegl;
  endfunction

  function void set_i_ileglxxKBUVG1SkiKN;
    input logic  value;
    i_ilegl=value;
  endfunction

  function void get_i_buserrxxKBUVG1SkiKN;
    output logic  value;
    value=i_buserr;
  endfunction

  function void set_i_buserrxxKBUVG1SkiKN;
    input logic  value;
    i_buserr=value;
  endfunction

  function void get_i_misalgnxxKBUVG1SkiKN;
    output logic  value;
    value=i_misalgn;
  endfunction

  function void set_i_misalgnxxKBUVG1SkiKN;
    input logic  value;
    i_misalgn=value;
  endfunction

  function void get_flush_reqxxKBUVG1SkiKN;
    output logic  value;
    value=flush_req;
  endfunction

  function void set_flush_reqxxKBUVG1SkiKN;
    input logic  value;
    flush_req=value;
  endfunction

  function void get_flush_pulsexxKBUVG1SkiKN;
    output logic  value;
    value=flush_pulse;
  endfunction

  function void set_flush_pulsexxKBUVG1SkiKN;
    input logic  value;
    flush_pulse=value;
  endfunction

  function void get_cmt_o_validxxKBUVG1SkiKN;
    output logic  value;
    value=cmt_o_valid;
  endfunction

  function void get_cmt_o_readyxxKBUVG1SkiKN;
    output logic  value;
    value=cmt_o_ready;
  endfunction

  function void set_cmt_o_readyxxKBUVG1SkiKN;
    input logic  value;
    cmt_o_ready=value;
  endfunction

  function void get_cmt_o_pc_vldxxKBUVG1SkiKN;
    output logic  value;
    value=cmt_o_pc_vld;
  endfunction

  function void get_cmt_o_pcxxKBUVG1SkiKN;
    output logic [31:0] value;
    value=cmt_o_pc;
  endfunction

  function void get_cmt_o_instrxxKBUVG1SkiKN;
    output logic [31:0] value;
    value=cmt_o_instr;
  endfunction

  function void get_cmt_o_immxxKBUVG1SkiKN;
    output logic [31:0] value;
    value=cmt_o_imm;
  endfunction

  function void get_cmt_o_rv32xxKBUVG1SkiKN;
    output logic  value;
    value=cmt_o_rv32;
  endfunction

  function void get_cmt_o_bjpxxKBUVG1SkiKN;
    output logic  value;
    value=cmt_o_bjp;
  endfunction

  function void get_cmt_o_mretxxKBUVG1SkiKN;
    output logic  value;
    value=cmt_o_mret;
  endfunction

  function void get_cmt_o_dretxxKBUVG1SkiKN;
    output logic  value;
    value=cmt_o_dret;
  endfunction

  function void get_cmt_o_ecallxxKBUVG1SkiKN;
    output logic  value;
    value=cmt_o_ecall;
  endfunction

  function void get_cmt_o_ebreakxxKBUVG1SkiKN;
    output logic  value;
    value=cmt_o_ebreak;
  endfunction

  function void get_cmt_o_fenceixxKBUVG1SkiKN;
    output logic  value;
    value=cmt_o_fencei;
  endfunction

  function void get_cmt_o_wfixxKBUVG1SkiKN;
    output logic  value;
    value=cmt_o_wfi;
  endfunction

  function void get_cmt_o_ifu_misalgnxxKBUVG1SkiKN;
    output logic  value;
    value=cmt_o_ifu_misalgn;
  endfunction

  function void get_cmt_o_ifu_buserrxxKBUVG1SkiKN;
    output logic  value;
    value=cmt_o_ifu_buserr;
  endfunction

  function void get_cmt_o_ifu_ileglxxKBUVG1SkiKN;
    output logic  value;
    value=cmt_o_ifu_ilegl;
  endfunction

  function void get_cmt_o_bjp_prdtxxKBUVG1SkiKN;
    output logic  value;
    value=cmt_o_bjp_prdt;
  endfunction

  function void get_cmt_o_bjp_rslvxxKBUVG1SkiKN;
    output logic  value;
    value=cmt_o_bjp_rslv;
  endfunction

  function void get_cmt_o_misalgnxxKBUVG1SkiKN;
    output logic  value;
    value=cmt_o_misalgn;
  endfunction

  function void get_cmt_o_ldxxKBUVG1SkiKN;
    output logic  value;
    value=cmt_o_ld;
  endfunction

  function void get_cmt_o_stamoxxKBUVG1SkiKN;
    output logic  value;
    value=cmt_o_stamo;
  endfunction

  function void get_cmt_o_buserrxxKBUVG1SkiKN;
    output logic  value;
    value=cmt_o_buserr;
  endfunction

  function void get_cmt_o_badaddrxxKBUVG1SkiKN;
    output logic [31:0] value;
    value=cmt_o_badaddr;
  endfunction

  function void get_wbck_o_validxxKBUVG1SkiKN;
    output logic  value;
    value=wbck_o_valid;
  endfunction

  function void get_wbck_o_readyxxKBUVG1SkiKN;
    output logic  value;
    value=wbck_o_ready;
  endfunction

  function void set_wbck_o_readyxxKBUVG1SkiKN;
    input logic  value;
    wbck_o_ready=value;
  endfunction

  function void get_wbck_o_wdatxxKBUVG1SkiKN;
    output logic [31:0] value;
    value=wbck_o_wdat;
  endfunction

  function void get_wbck_o_rdidxxxKBUVG1SkiKN;
    output logic [4:0] value;
    value=wbck_o_rdidx;
  endfunction

  function void get_mdv_nob2bxxKBUVG1SkiKN;
    output logic  value;
    value=mdv_nob2b;
  endfunction

  function void set_mdv_nob2bxxKBUVG1SkiKN;
    input logic  value;
    mdv_nob2b=value;
  endfunction

  function void get_csr_enaxxKBUVG1SkiKN;
    output logic  value;
    value=csr_ena;
  endfunction

  function void get_csr_wr_enxxKBUVG1SkiKN;
    output logic  value;
    value=csr_wr_en;
  endfunction

  function void get_csr_rd_enxxKBUVG1SkiKN;
    output logic  value;
    value=csr_rd_en;
  endfunction

  function void get_csr_idxxxKBUVG1SkiKN;
    output logic [11:0] value;
    value=csr_idx;
  endfunction

  function void get_nonflush_cmt_enaxxKBUVG1SkiKN;
    output logic  value;
    value=nonflush_cmt_ena;
  endfunction

  function void set_nonflush_cmt_enaxxKBUVG1SkiKN;
    input logic  value;
    nonflush_cmt_ena=value;
  endfunction

  function void get_csr_access_ilglxxKBUVG1SkiKN;
    output logic  value;
    value=csr_access_ilgl;
  endfunction

  function void set_csr_access_ilglxxKBUVG1SkiKN;
    input logic  value;
    csr_access_ilgl=value;
  endfunction

  function void get_read_csr_datxxKBUVG1SkiKN;
    output logic [31:0] value;
    value=read_csr_dat;
  endfunction

  function void set_read_csr_datxxKBUVG1SkiKN;
    input logic [31:0] value;
    read_csr_dat=value;
  endfunction

  function void get_wbck_csr_datxxKBUVG1SkiKN;
    output logic [31:0] value;
    value=wbck_csr_dat;
  endfunction

  function void get_agu_icb_cmd_validxxKBUVG1SkiKN;
    output logic  value;
    value=agu_icb_cmd_valid;
  endfunction

  function void get_agu_icb_cmd_readyxxKBUVG1SkiKN;
    output logic  value;
    value=agu_icb_cmd_ready;
  endfunction

  function void set_agu_icb_cmd_readyxxKBUVG1SkiKN;
    input logic  value;
    agu_icb_cmd_ready=value;
  endfunction

  function void get_agu_icb_cmd_addrxxKBUVG1SkiKN;
    output logic [31:0] value;
    value=agu_icb_cmd_addr;
  endfunction

  function void get_agu_icb_cmd_readxxKBUVG1SkiKN;
    output logic  value;
    value=agu_icb_cmd_read;
  endfunction

  function void get_agu_icb_cmd_wdataxxKBUVG1SkiKN;
    output logic [31:0] value;
    value=agu_icb_cmd_wdata;
  endfunction

  function void get_agu_icb_cmd_wmaskxxKBUVG1SkiKN;
    output logic [3:0] value;
    value=agu_icb_cmd_wmask;
  endfunction

  function void get_agu_icb_cmd_lockxxKBUVG1SkiKN;
    output logic  value;
    value=agu_icb_cmd_lock;
  endfunction

  function void get_agu_icb_cmd_exclxxKBUVG1SkiKN;
    output logic  value;
    value=agu_icb_cmd_excl;
  endfunction

  function void get_agu_icb_cmd_sizexxKBUVG1SkiKN;
    output logic [1:0] value;
    value=agu_icb_cmd_size;
  endfunction

  function void get_agu_icb_cmd_back2aguxxKBUVG1SkiKN;
    output logic  value;
    value=agu_icb_cmd_back2agu;
  endfunction

  function void get_agu_icb_cmd_usignxxKBUVG1SkiKN;
    output logic  value;
    value=agu_icb_cmd_usign;
  endfunction

  function void get_agu_icb_cmd_itagxxKBUVG1SkiKN;
    output logic [0:0] value;
    value=agu_icb_cmd_itag;
  endfunction

  function void get_agu_icb_rsp_validxxKBUVG1SkiKN;
    output logic  value;
    value=agu_icb_rsp_valid;
  endfunction

  function void set_agu_icb_rsp_validxxKBUVG1SkiKN;
    input logic  value;
    agu_icb_rsp_valid=value;
  endfunction

  function void get_agu_icb_rsp_readyxxKBUVG1SkiKN;
    output logic  value;
    value=agu_icb_rsp_ready;
  endfunction

  function void get_agu_icb_rsp_errxxKBUVG1SkiKN;
    output logic  value;
    value=agu_icb_rsp_err;
  endfunction

  function void set_agu_icb_rsp_errxxKBUVG1SkiKN;
    input logic  value;
    agu_icb_rsp_err=value;
  endfunction

  function void get_agu_icb_rsp_excl_okxxKBUVG1SkiKN;
    output logic  value;
    value=agu_icb_rsp_excl_ok;
  endfunction

  function void set_agu_icb_rsp_excl_okxxKBUVG1SkiKN;
    input logic  value;
    agu_icb_rsp_excl_ok=value;
  endfunction

  function void get_agu_icb_rsp_rdataxxKBUVG1SkiKN;
    output logic [31:0] value;
    value=agu_icb_rsp_rdata;
  endfunction

  function void set_agu_icb_rsp_rdataxxKBUVG1SkiKN;
    input logic [31:0] value;
    agu_icb_rsp_rdata=value;
  endfunction

  function void get_nice_req_validxxKBUVG1SkiKN;
    output logic  value;
    value=nice_req_valid;
  endfunction

  function void get_nice_req_readyxxKBUVG1SkiKN;
    output logic  value;
    value=nice_req_ready;
  endfunction

  function void set_nice_req_readyxxKBUVG1SkiKN;
    input logic  value;
    nice_req_ready=value;
  endfunction

  function void get_nice_req_instrxxKBUVG1SkiKN;
    output logic [31:0] value;
    value=nice_req_instr;
  endfunction

  function void get_nice_req_rs1xxKBUVG1SkiKN;
    output logic [31:0] value;
    value=nice_req_rs1;
  endfunction

  function void get_nice_req_rs2xxKBUVG1SkiKN;
    output logic [31:0] value;
    value=nice_req_rs2;
  endfunction

  function void get_nice_rsp_multicyc_validxxKBUVG1SkiKN;
    output logic  value;
    value=nice_rsp_multicyc_valid;
  endfunction

  function void set_nice_rsp_multicyc_validxxKBUVG1SkiKN;
    input logic  value;
    nice_rsp_multicyc_valid=value;
  endfunction

  function void get_nice_rsp_multicyc_readyxxKBUVG1SkiKN;
    output logic  value;
    value=nice_rsp_multicyc_ready;
  endfunction

  function void get_nice_longp_wbck_validxxKBUVG1SkiKN;
    output logic  value;
    value=nice_longp_wbck_valid;
  endfunction

  function void get_nice_longp_wbck_readyxxKBUVG1SkiKN;
    output logic  value;
    value=nice_longp_wbck_ready;
  endfunction

  function void set_nice_longp_wbck_readyxxKBUVG1SkiKN;
    input logic  value;
    nice_longp_wbck_ready=value;
  endfunction

  function void get_nice_o_itagxxKBUVG1SkiKN;
    output logic [0:0] value;
    value=nice_o_itag;
  endfunction

  function void get_i_nice_cmt_off_ilglxxKBUVG1SkiKN;
    output logic  value;
    value=i_nice_cmt_off_ilgl;
  endfunction

  function void set_i_nice_cmt_off_ilglxxKBUVG1SkiKN;
    input logic  value;
    i_nice_cmt_off_ilgl=value;
  endfunction

  function void get_clkxxKBUVG1SkiKN;
    output logic  value;
    value=clk;
  endfunction

  function void set_clkxxKBUVG1SkiKN;
    input logic  value;
    clk=value;
  endfunction

  function void get_rst_nxxKBUVG1SkiKN;
    output logic  value;
    value=rst_n;
  endfunction

  function void set_rst_nxxKBUVG1SkiKN;
    input logic  value;
    rst_n=value;
  endfunction



  initial begin
    $dumpfile("summit_examples/ucagent_launch_graxj042/workspace_e203_exu_alu/e203_exu_alu/e203_exu_alu.fst");
    $dumpvars(0, e203_exu_alu_top);
  end

  export "DPI-C" function finish_KBUVG1SkiKN;
  function void finish_KBUVG1SkiKN;
    $finish;
  endfunction


endmodule
