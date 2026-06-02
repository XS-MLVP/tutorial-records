module e203_ifu_litebpu_top;

  wire [31:0] pc;
  wire  dec_jal;
  wire  dec_jalr;
  wire  dec_bxx;
  wire [31:0] dec_bjp_imm;
  wire [4:0] dec_jalr_rs1idx;
  wire  oitf_empty;
  wire  ir_empty;
  wire  ir_rs1en;
  wire  jalr_rs1idx_cam_irrdidx;
  wire  bpu_wait;
  wire  prdt_taken;
  wire [31:0] prdt_pc_add_op1;
  wire [31:0] prdt_pc_add_op2;
  wire  dec_i_valid;
  wire  bpu2rf_rs1_ena;
  wire  ir_valid_clr;
  wire [31:0] rf2bpu_x1;
  wire [31:0] rf2bpu_rs1;
  wire  clk;
  wire  rst_n;


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


endmodule
