# e203_ifu_litebpu RTL 源码静态分析报告

## 一、潜在Bug汇总

| 序号 | Bug标签 | 功能路径 | 描述摘要 | 置信度 | 涉及文件 | 动态Bug关联 |
|------|---------|----------|----------|--------|----------|-------------|
| 001 | BG-STATIC-001-PRDT-VALID-GATING | FG-PREDICT/FC-NO-BRANCH/CK-INVALID-INSTRUCTION-GATING | prdt_taken未受dec_i_valid门控 | 高 | e203_ifu_litebpu_RTL/e203_ifu_litebpu.v | LINK-BUG-[BG-PRDT-VALID-GATING-95] |
| 002 | BG-STATIC-002-XN-READ-WAIT | FG-JALR-DEPENDENCY/FC-XN-DEPENDENCY/CK-XN-READY-NO-WAIT | rs1xn读请求周期bpu_wait被强制拉高 | 中 | e203_ifu_litebpu_RTL/e203_ifu_litebpu.v | LINK-BUG-[BG-XN-READ-WAIT-85] |

## 二、详细分析

### <FG-PREDICT> 静态预测
#### <FC-NO-BRANCH> 无分支输入
##### <CK-INVALID-INSTRUCTION-GATING> 无效门控
  - <BG-STATIC-001-PRDT-VALID-GATING> prdt_taken未受dec_i_valid门控
    - <LINK-BUG-[BG-PRDT-VALID-GATING-95]>
      - <FILE-e203_ifu_litebpu_RTL/e203_ifu_litebpu.v:1176-1177>
        ```verilog
        1176:    // The JAL and JALR is always jump, bxxx backward is predicted as taken
        1177:    assign prdt_taken   = (dec_jal | dec_jalr | (dec_bxx & dec_bjp_imm[`E203_XLEN-1]));
        ```
### <FG-JALR-DEPENDENCY> JALR等待
#### <FC-XN-DEPENDENCY> xn依赖
##### <CK-XN-READY-NO-WAIT> 就绪不等待
  - <BG-STATIC-002-XN-READ-WAIT> rs1xn读请求周期bpu_wait被强制拉高
    - <LINK-BUG-[BG-XN-READ-WAIT-85]>
      - <FILE-e203_ifu_litebpu_RTL/e203_ifu_litebpu.v:1190-1200>
        ```verilog
        1190:    wire rs1xn_rdrf_r;
        1191:    wire rs1xn_rdrf_set = (~rs1xn_rdrf_r) & dec_i_valid & dec_jalr & dec_jalr_rs1xn & ((~jalr_rs1xn_dep) | jalr_rs1xn_dep_ir_clr);
        1192:    wire rs1xn_rdrf_clr = rs1xn_rdrf_r;
        1193:    wire rs1xn_rdrf_ena = rs1xn_rdrf_set |   rs1xn_rdrf_clr;
        1194:    wire rs1xn_rdrf_nxt = rs1xn_rdrf_set | (~rs1xn_rdrf_clr);
        1195:  
        1196:    sirv_gnrl_dfflr #(1) rs1xn_rdrf_dfflrs(rs1xn_rdrf_ena, rs1xn_rdrf_nxt, rs1xn_rdrf_r, clk, rst_n);
        1197:  
        1198:    assign bpu2rf_rs1_ena = rs1xn_rdrf_set;
        1199:  
        1200:    assign bpu_wait = jalr_rs1x1_dep | jalr_rs1xn_dep | rs1xn_rdrf_set;
        ```
## 三、批次分析进度

| 源文件 | 发现疑似Bug数 | 状态 |
|--------|---------------|------|
| <file>e203_ifu_litebpu_RTL/config.v</file> | 0 | ✅ 完成 |
| <file>e203_ifu_litebpu_RTL/e203_defines.v</file> | 0 | ✅ 完成 |
| <file>e203_ifu_litebpu_RTL/e203_ifu_litebpu.v</file> | 2 | ✅ 完成 |
| <file>e203_ifu_litebpu_RTL/sirv_gnrl_dffs.v</file> | 0 | ✅ 完成 |
| <file>e203_ifu_litebpu_RTL/sirv_gnrl_xchecker.v</file> | 0 | ✅ 完成 |
