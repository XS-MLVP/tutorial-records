module e203_ifu_litebpu_top();

/*verilator public_flat_rw_on*/
  logic [31:0] pc;
  logic  dec_jal;
  logic  dec_jalr;
  logic  dec_bxx;
  logic [31:0] dec_bjp_imm;
  logic [4:0] dec_jalr_rs1idx;
  logic  oitf_empty;
  logic  ir_empty;
  logic  ir_rs1en;
  logic  jalr_rs1idx_cam_irrdidx;
  logic  bpu_wait;
  logic  prdt_taken;
  logic [31:0] prdt_pc_add_op1;
  logic [31:0] prdt_pc_add_op2;
  logic  dec_i_valid;
  logic  bpu2rf_rs1_ena;
  logic  ir_valid_clr;
  logic [31:0] rf2bpu_x1;
  logic [31:0] rf2bpu_rs1;
  logic  clk;
  logic  rst_n;
/*verilator public_off*/


 e203_ifu_litebpu e203_ifu_litebpu(
    .pc(pc),
    .dec_jal(dec_jal),
    .dec_jalr(dec_jalr),
    .dec_bxx(dec_bxx),
    .dec_bjp_imm(dec_bjp_imm),
    .dec_jalr_rs1idx(dec_jalr_rs1idx),
    .oitf_empty(oitf_empty),
    .ir_empty(ir_empty),
    .ir_rs1en(ir_rs1en),
    .jalr_rs1idx_cam_irrdidx(jalr_rs1idx_cam_irrdidx),
    .bpu_wait(bpu_wait),
    .prdt_taken(prdt_taken),
    .prdt_pc_add_op1(prdt_pc_add_op1),
    .prdt_pc_add_op2(prdt_pc_add_op2),
    .dec_i_valid(dec_i_valid),
    .bpu2rf_rs1_ena(bpu2rf_rs1_ena),
    .ir_valid_clr(ir_valid_clr),
    .rf2bpu_x1(rf2bpu_x1),
    .rf2bpu_rs1(rf2bpu_rs1),
    .clk(clk),
    .rst_n(rst_n)
 );


  export "DPI-C" function get_pcxxPfBDHPnOUuj;
  export "DPI-C" function set_pcxxPfBDHPnOUuj;
  export "DPI-C" function get_dec_jalxxPfBDHPnOUuj;
  export "DPI-C" function set_dec_jalxxPfBDHPnOUuj;
  export "DPI-C" function get_dec_jalrxxPfBDHPnOUuj;
  export "DPI-C" function set_dec_jalrxxPfBDHPnOUuj;
  export "DPI-C" function get_dec_bxxxxPfBDHPnOUuj;
  export "DPI-C" function set_dec_bxxxxPfBDHPnOUuj;
  export "DPI-C" function get_dec_bjp_immxxPfBDHPnOUuj;
  export "DPI-C" function set_dec_bjp_immxxPfBDHPnOUuj;
  export "DPI-C" function get_dec_jalr_rs1idxxxPfBDHPnOUuj;
  export "DPI-C" function set_dec_jalr_rs1idxxxPfBDHPnOUuj;
  export "DPI-C" function get_oitf_emptyxxPfBDHPnOUuj;
  export "DPI-C" function set_oitf_emptyxxPfBDHPnOUuj;
  export "DPI-C" function get_ir_emptyxxPfBDHPnOUuj;
  export "DPI-C" function set_ir_emptyxxPfBDHPnOUuj;
  export "DPI-C" function get_ir_rs1enxxPfBDHPnOUuj;
  export "DPI-C" function set_ir_rs1enxxPfBDHPnOUuj;
  export "DPI-C" function get_jalr_rs1idx_cam_irrdidxxxPfBDHPnOUuj;
  export "DPI-C" function set_jalr_rs1idx_cam_irrdidxxxPfBDHPnOUuj;
  export "DPI-C" function get_bpu_waitxxPfBDHPnOUuj;
  export "DPI-C" function get_prdt_takenxxPfBDHPnOUuj;
  export "DPI-C" function get_prdt_pc_add_op1xxPfBDHPnOUuj;
  export "DPI-C" function get_prdt_pc_add_op2xxPfBDHPnOUuj;
  export "DPI-C" function get_dec_i_validxxPfBDHPnOUuj;
  export "DPI-C" function set_dec_i_validxxPfBDHPnOUuj;
  export "DPI-C" function get_bpu2rf_rs1_enaxxPfBDHPnOUuj;
  export "DPI-C" function get_ir_valid_clrxxPfBDHPnOUuj;
  export "DPI-C" function set_ir_valid_clrxxPfBDHPnOUuj;
  export "DPI-C" function get_rf2bpu_x1xxPfBDHPnOUuj;
  export "DPI-C" function set_rf2bpu_x1xxPfBDHPnOUuj;
  export "DPI-C" function get_rf2bpu_rs1xxPfBDHPnOUuj;
  export "DPI-C" function set_rf2bpu_rs1xxPfBDHPnOUuj;
  export "DPI-C" function get_clkxxPfBDHPnOUuj;
  export "DPI-C" function set_clkxxPfBDHPnOUuj;
  export "DPI-C" function get_rst_nxxPfBDHPnOUuj;
  export "DPI-C" function set_rst_nxxPfBDHPnOUuj;


  function void get_pcxxPfBDHPnOUuj;
    output logic [31:0] value;
    value=pc;
  endfunction

  function void set_pcxxPfBDHPnOUuj;
    input logic [31:0] value;
    pc=value;
  endfunction

  function void get_dec_jalxxPfBDHPnOUuj;
    output logic  value;
    value=dec_jal;
  endfunction

  function void set_dec_jalxxPfBDHPnOUuj;
    input logic  value;
    dec_jal=value;
  endfunction

  function void get_dec_jalrxxPfBDHPnOUuj;
    output logic  value;
    value=dec_jalr;
  endfunction

  function void set_dec_jalrxxPfBDHPnOUuj;
    input logic  value;
    dec_jalr=value;
  endfunction

  function void get_dec_bxxxxPfBDHPnOUuj;
    output logic  value;
    value=dec_bxx;
  endfunction

  function void set_dec_bxxxxPfBDHPnOUuj;
    input logic  value;
    dec_bxx=value;
  endfunction

  function void get_dec_bjp_immxxPfBDHPnOUuj;
    output logic [31:0] value;
    value=dec_bjp_imm;
  endfunction

  function void set_dec_bjp_immxxPfBDHPnOUuj;
    input logic [31:0] value;
    dec_bjp_imm=value;
  endfunction

  function void get_dec_jalr_rs1idxxxPfBDHPnOUuj;
    output logic [4:0] value;
    value=dec_jalr_rs1idx;
  endfunction

  function void set_dec_jalr_rs1idxxxPfBDHPnOUuj;
    input logic [4:0] value;
    dec_jalr_rs1idx=value;
  endfunction

  function void get_oitf_emptyxxPfBDHPnOUuj;
    output logic  value;
    value=oitf_empty;
  endfunction

  function void set_oitf_emptyxxPfBDHPnOUuj;
    input logic  value;
    oitf_empty=value;
  endfunction

  function void get_ir_emptyxxPfBDHPnOUuj;
    output logic  value;
    value=ir_empty;
  endfunction

  function void set_ir_emptyxxPfBDHPnOUuj;
    input logic  value;
    ir_empty=value;
  endfunction

  function void get_ir_rs1enxxPfBDHPnOUuj;
    output logic  value;
    value=ir_rs1en;
  endfunction

  function void set_ir_rs1enxxPfBDHPnOUuj;
    input logic  value;
    ir_rs1en=value;
  endfunction

  function void get_jalr_rs1idx_cam_irrdidxxxPfBDHPnOUuj;
    output logic  value;
    value=jalr_rs1idx_cam_irrdidx;
  endfunction

  function void set_jalr_rs1idx_cam_irrdidxxxPfBDHPnOUuj;
    input logic  value;
    jalr_rs1idx_cam_irrdidx=value;
  endfunction

  function void get_bpu_waitxxPfBDHPnOUuj;
    output logic  value;
    value=bpu_wait;
  endfunction

  function void get_prdt_takenxxPfBDHPnOUuj;
    output logic  value;
    value=prdt_taken;
  endfunction

  function void get_prdt_pc_add_op1xxPfBDHPnOUuj;
    output logic [31:0] value;
    value=prdt_pc_add_op1;
  endfunction

  function void get_prdt_pc_add_op2xxPfBDHPnOUuj;
    output logic [31:0] value;
    value=prdt_pc_add_op2;
  endfunction

  function void get_dec_i_validxxPfBDHPnOUuj;
    output logic  value;
    value=dec_i_valid;
  endfunction

  function void set_dec_i_validxxPfBDHPnOUuj;
    input logic  value;
    dec_i_valid=value;
  endfunction

  function void get_bpu2rf_rs1_enaxxPfBDHPnOUuj;
    output logic  value;
    value=bpu2rf_rs1_ena;
  endfunction

  function void get_ir_valid_clrxxPfBDHPnOUuj;
    output logic  value;
    value=ir_valid_clr;
  endfunction

  function void set_ir_valid_clrxxPfBDHPnOUuj;
    input logic  value;
    ir_valid_clr=value;
  endfunction

  function void get_rf2bpu_x1xxPfBDHPnOUuj;
    output logic [31:0] value;
    value=rf2bpu_x1;
  endfunction

  function void set_rf2bpu_x1xxPfBDHPnOUuj;
    input logic [31:0] value;
    rf2bpu_x1=value;
  endfunction

  function void get_rf2bpu_rs1xxPfBDHPnOUuj;
    output logic [31:0] value;
    value=rf2bpu_rs1;
  endfunction

  function void set_rf2bpu_rs1xxPfBDHPnOUuj;
    input logic [31:0] value;
    rf2bpu_rs1=value;
  endfunction

  function void get_clkxxPfBDHPnOUuj;
    output logic  value;
    value=clk;
  endfunction

  function void set_clkxxPfBDHPnOUuj;
    input logic  value;
    clk=value;
  endfunction

  function void get_rst_nxxPfBDHPnOUuj;
    output logic  value;
    value=rst_n;
  endfunction

  function void set_rst_nxxPfBDHPnOUuj;
    input logic  value;
    rst_n=value;
  endfunction



  initial begin
    $dumpfile("output/workspace_e203_ifu_litebpu/e203_ifu_litebpu/e203_ifu_litebpu.fst");
    $dumpvars(0, e203_ifu_litebpu_top);
  end

  export "DPI-C" function finish_PfBDHPnOUuj;
  function void finish_PfBDHPnOUuj;
    $finish;
  endfunction


endmodule
