
# e203_ifu_litebpu 缺陷分析

## 未测试通过检测点分析


<FG-JALR-DEPENDENCY>

#### <FC-XN-DEPENDENCY>
- <CK-XN-READY-NO-WAIT> JALR rs1=xN 无依赖时已经发起 rs1 读请求，但 bpu_wait 仍被拉高，导致 ready no-wait 规格失败
  - <BG-XN-READ-WAIT-85> Bug 置信度 85%
    - <TC-unity_test/tests/test_e203_ifu_litebpu_jalr_dependency.py::test_xn_ready_no_wait> JALR rs1=xN 无依赖时已经发起 rs1 读请求，但 bpu_wait 仍被拉高，导致 ready no-wait 规格失败

#### <FC-DEPENDENCY-BYPASS>
- <CK-IR-CLR-BYPASS> IR valid 清除旁路时 xN JALR 已允许读 rs1，但 bpu_wait 仍被 rs1xn_rdrf_set 强制拉高
  - <BG-XN-READ-WAIT-85> Bug 置信度 85%
    - <TC-unity_test/tests/test_e203_ifu_litebpu_jalr_dependency.py::test_ir_clr_bypass> IR valid 清除旁路时 xN JALR 已允许读 rs1，但 bpu_wait 仍被 rs1xn_rdrf_set 强制拉高
- <CK-IR-RS1-DISABLE-BYPASS> IR 不使用 rs1 时 xN JALR 应旁路依赖并读 rs1，但 bpu_wait 仍被错误拉高
  - <BG-XN-READ-WAIT-85> Bug 置信度 85%
    - <TC-unity_test/tests/test_e203_ifu_litebpu_jalr_dependency.py::test_ir_rs1_disable_bypass> IR 不使用 rs1 时 xN JALR 应旁路依赖并读 rs1，但 bpu_wait 仍被错误拉高
- <CK-DEPENDENCY-TRANSITION> xN JALR 依赖从 busy 解除到 ready 后仍等待一个读请求周期，状态转换不符合 no-wait 规格
  - <BG-XN-READ-WAIT-85> Bug 置信度 85%
    - <TC-unity_test/tests/test_e203_ifu_litebpu_jalr_dependency.py::test_dependency_transition> xN JALR 依赖从 busy 解除到 ready 后仍等待一个读请求周期，状态转换不符合 no-wait 规格

<FG-PREDICT>

#### <FC-NO-BRANCH>
- <CK-INVALID-INSTRUCTION-GATING> dec_i_valid=0 时 dec_jal 仍直接驱动 prdt_taken=1，预测输出未被指令有效位门控
  - <BG-PRDT-VALID-GATING-95> Bug 置信度 95%
    - <TC-unity_test/tests/test_e203_ifu_litebpu_predict.py::test_invalid_instruction_gating> dec_i_valid=0 时 dec_jal 仍直接驱动 prdt_taken=1，预测输出未被指令有效位门控

<FG-RESET-BOUNDARY>

#### <FC-RESET-BEHAVIOR>
- <CK-RESET-CLEARS-READ> rst_n=0 复位期间，JALR xN 输入仍可组合产生 bpu2rf_rs1_ena=1，复位未清除公开读请求输出
  - <BG-RESET-RS1ENA-GATING-90> Bug 置信度 90%
    - <TC-unity_test/tests/test_e203_ifu_litebpu_reset_boundary.py::test_reset_clears_read> rst_n=0 复位期间，JALR xN 输入仍可组合产生 bpu2rf_rs1_ena=1，复位未清除公开读请求输出
## 缺陷根因分析

### FG-JALR-DEPENDENCY / FC-XN-DEPENDENCY / CK-XN-READY-NO-WAIT
**Bug标签**: BG-XN-READ-WAIT-85
**测试用例**: test_e203_ifu_litebpu_jalr_dependency.py::test_xn_ready_no_wait
**问题描述**:JALR rs1=xN 无依赖时已经发起 rs1 读请求，但 bpu_wait 仍被拉高，导致 ready no-wait 规格失败
**根因分析**: 
RTL 中 rs1xn_rdrf_set 表示 xN JALR 已经满足无依赖或 IR 旁路条件并向寄存器堆发起读请求。该信号同时被并入 bpu_wait，导致正是可读寄存器的周期仍强制等待。对于 CK-XN-READY-NO-WAIT，输入满足 dec_i_valid=1、dec_jalr=1、rs1idx 非 0/1、oitf_empty=1、ir_empty=1，jalr_rs1xn_dep 为 0，rs1xn_rdrf_set 为 1，因此 bpu2rf_rs1_ena 正确为 1，但 bpu_wait 被错误置 1。
```verilog
// e203_ifu_litebpu_RTL/e203_ifu_litebpu.v:1190-1200
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
**修复建议**
wire rs1xn_rdrf_r;\nwire rs1xn_rdrf_set = (~rs1xn_rdrf_r) & dec_i_valid & dec_jalr & dec_jalr_rs1xn & ((~jalr_rs1xn_dep) | jalr_rs1xn_dep_ir_clr);\nwire rs1xn_rdrf_clr = rs1xn_rdrf_r;\nwire rs1xn_rdrf_ena = rs1xn_rdrf_set | rs1xn_rdrf_clr;\nwire rs1xn_rdrf_nxt = rs1xn_rdrf_set | (~rs1xn_rdrf_clr);\n\nsirv_gnrl_dfflr #(1) rs1xn_rdrf_dfflrs(rs1xn_rdrf_ena, rs1xn_rdrf_nxt, rs1xn_rdrf_r, clk, rst_n);\n\nassign bpu2rf_rs1_ena = rs1xn_rdrf_set;\n\nassign bpu_wait = jalr_rs1x1_dep | (jalr_rs1xn_dep & (~jalr_rs1xn_dep_ir_clr));
### FG-JALR-DEPENDENCY / FC-DEPENDENCY-BYPASS / CK-IR-CLR-BYPASS
**Bug标签**: BG-XN-READ-WAIT-85
**测试用例**: test_e203_ifu_litebpu_jalr_dependency.py::test_ir_clr_bypass
**问题描述**:IR valid 清除旁路时 xN JALR 已允许读 rs1，但 bpu_wait 仍被 rs1xn_rdrf_set 强制拉高
**根因分析**: 
RTL 将 rs1xn_rdrf_set 同时用作读寄存器请求和等待原因。IR valid 清除场景中 jalr_rs1xn_dep_ir_clr 为 1，说明 IR 依赖应被忽略，rs1xn_rdrf_set 合法置 1 发起读请求；但 bpu_wait 仍或上 rs1xn_rdrf_set，使旁路场景错误等待。
```verilog
// e203_ifu_litebpu_RTL/e203_ifu_litebpu.v:1190-1200
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
**修复建议**
wire rs1xn_rdrf_r;\nwire rs1xn_rdrf_set = (~rs1xn_rdrf_r) & dec_i_valid & dec_jalr & dec_jalr_rs1xn & ((~jalr_rs1xn_dep) | jalr_rs1xn_dep_ir_clr);\nwire rs1xn_rdrf_clr = rs1xn_rdrf_r;\nwire rs1xn_rdrf_ena = rs1xn_rdrf_set | rs1xn_rdrf_clr;\nwire rs1xn_rdrf_nxt = rs1xn_rdrf_set | (~rs1xn_rdrf_clr);\n\nsirv_gnrl_dfflr #(1) rs1xn_rdrf_dfflrs(rs1xn_rdrf_ena, rs1xn_rdrf_nxt, rs1xn_rdrf_r, clk, rst_n);\n\nassign bpu2rf_rs1_ena = rs1xn_rdrf_set;\n\nassign bpu_wait = jalr_rs1x1_dep | (jalr_rs1xn_dep & (~jalr_rs1xn_dep_ir_clr));
### FG-JALR-DEPENDENCY / FC-DEPENDENCY-BYPASS / CK-IR-RS1-DISABLE-BYPASS
**Bug标签**: BG-XN-READ-WAIT-85
**测试用例**: test_e203_ifu_litebpu_jalr_dependency.py::test_ir_rs1_disable_bypass
**问题描述**:IR 不使用 rs1 时 xN JALR 应旁路依赖并读 rs1，但 bpu_wait 仍被错误拉高
**根因分析**: 
当 ir_rs1en=0 时 jalr_rs1xn_dep_ir_clr 为 1，该 IR 依赖按设计注释应视为无依赖。rs1xn_rdrf_set 拉高代表读请求已经合法发出，但 bpu_wait 又包含 rs1xn_rdrf_set，导致 IR 不使用 rs1 的旁路条件仍被暂停。
```verilog
// e203_ifu_litebpu_RTL/e203_ifu_litebpu.v:1190-1200
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
**修复建议**
wire rs1xn_rdrf_r;\nwire rs1xn_rdrf_set = (~rs1xn_rdrf_r) & dec_i_valid & dec_jalr & dec_jalr_rs1xn & ((~jalr_rs1xn_dep) | jalr_rs1xn_dep_ir_clr);\nwire rs1xn_rdrf_clr = rs1xn_rdrf_r;\nwire rs1xn_rdrf_ena = rs1xn_rdrf_set | rs1xn_rdrf_clr;\nwire rs1xn_rdrf_nxt = rs1xn_rdrf_set | (~rs1xn_rdrf_clr);\n\nsirv_gnrl_dfflr #(1) rs1xn_rdrf_dfflrs(rs1xn_rdrf_ena, rs1xn_rdrf_nxt, rs1xn_rdrf_r, clk, rst_n);\n\nassign bpu2rf_rs1_ena = rs1xn_rdrf_set;\n\nassign bpu_wait = jalr_rs1x1_dep | (jalr_rs1xn_dep & (~jalr_rs1xn_dep_ir_clr));
### FG-JALR-DEPENDENCY / FC-DEPENDENCY-BYPASS / CK-DEPENDENCY-TRANSITION
**Bug标签**: BG-XN-READ-WAIT-85
**测试用例**: test_e203_ifu_litebpu_jalr_dependency.py::test_dependency_transition
**问题描述**:xN JALR 依赖从 busy 解除到 ready 后仍等待一个读请求周期，状态转换不符合 no-wait 规格
**根因分析**: 
依赖 busy 时 jalr_rs1xn_dep 正确导致 bpu_wait=1；下一周期 OITF/IR 解除后，rs1xn_rdrf_set 置 1 发起 rs1 读请求，但 RTL 仍把 rs1xn_rdrf_set 并入 bpu_wait，导致依赖解除后的 ready 周期仍报告等待。
```verilog
// e203_ifu_litebpu_RTL/e203_ifu_litebpu.v:1190-1200
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
**修复建议**
wire rs1xn_rdrf_r;\nwire rs1xn_rdrf_set = (~rs1xn_rdrf_r) & dec_i_valid & dec_jalr & dec_jalr_rs1xn & ((~jalr_rs1xn_dep) | jalr_rs1xn_dep_ir_clr);\nwire rs1xn_rdrf_clr = rs1xn_rdrf_r;\nwire rs1xn_rdrf_ena = rs1xn_rdrf_set | rs1xn_rdrf_clr;\nwire rs1xn_rdrf_nxt = rs1xn_rdrf_set | (~rs1xn_rdrf_clr);\n\nsirv_gnrl_dfflr #(1) rs1xn_rdrf_dfflrs(rs1xn_rdrf_ena, rs1xn_rdrf_nxt, rs1xn_rdrf_r, clk, rst_n);\n\nassign bpu2rf_rs1_ena = rs1xn_rdrf_set;\n\nassign bpu_wait = jalr_rs1x1_dep | (jalr_rs1xn_dep & (~jalr_rs1xn_dep_ir_clr));
### FG-PREDICT / FC-NO-BRANCH / CK-INVALID-INSTRUCTION-GATING
**Bug标签**: BG-PRDT-VALID-GATING-95
**测试用例**: test_e203_ifu_litebpu_predict.py::test_invalid_instruction_gating
**问题描述**:dec_i_valid=0 时 dec_jal 仍直接驱动 prdt_taken=1，预测输出未被指令有效位门控
**根因分析**: 
RTL 第1177行 prdt_taken 只由 dec_jal、dec_jalr、dec_bxx 和立即数符号组合产生，没有与 dec_i_valid 相与。当前测试驱动 dec_i_valid=0 且 dec_jal=1，按接口规格无效指令不应产生 taken，但 RTL 仍输出 prdt_taken=1。bpu_wait 和 bpu2rf_rs1_ena 因其他逻辑带 dec_i_valid 门控保持 0，说明问题集中在 prdt_taken 生成逻辑。
```verilog
// e203_ifu_litebpu_RTL/e203_ifu_litebpu.v:1176-1177
1176:    // The JAL and JALR is always jump, bxxx backward is predicted as taken
1177:    assign prdt_taken   = (dec_jal | dec_jalr | (dec_bxx & dec_bjp_imm[`E203_XLEN-1]));
```
**修复建议**
assign prdt_taken = dec_i_valid & (dec_jal | dec_jalr | (dec_bxx & dec_bjp_imm[`E203_XLEN-1]));
### FG-RESET-BOUNDARY / FC-RESET-BEHAVIOR / CK-RESET-CLEARS-READ
**Bug标签**: BG-RESET-RS1ENA-GATING-90
**测试用例**: test_e203_ifu_litebpu_reset_boundary.py::test_reset_clears_read
**问题描述**:rst_n=0 复位期间，JALR xN 输入仍可组合产生 bpu2rf_rs1_ena=1，复位未清除公开读请求输出
**根因分析**: 
bpu2rf_rs1_ena 直接等于 rs1xn_rdrf_set，而 rs1xn_rdrf_set 是组合逻辑，只依赖 rs1xn_rdrf_r、dec_i_valid、dec_jalr、rs1idx 和依赖状态，没有 rst_n 门控。sirv_gnrl_dfflr 可在复位时清除 rs1xn_rdrf_r，但无法阻止复位期间输入仍满足 xN JALR ready 条件时 rs1xn_rdrf_set 重新组合为 1，导致公开输出 bpu2rf_rs1_ena 在 rst_n=0 时仍为 1。
```verilog
// e203_ifu_litebpu_RTL/e203_ifu_litebpu.v:1190-1198
1190:    wire rs1xn_rdrf_r;
1191:    wire rs1xn_rdrf_set = (~rs1xn_rdrf_r) & dec_i_valid & dec_jalr & dec_jalr_rs1xn & ((~jalr_rs1xn_dep) | jalr_rs1xn_dep_ir_clr);
1192:    wire rs1xn_rdrf_clr = rs1xn_rdrf_r;
1193:    wire rs1xn_rdrf_ena = rs1xn_rdrf_set |   rs1xn_rdrf_clr;
1194:    wire rs1xn_rdrf_nxt = rs1xn_rdrf_set | (~rs1xn_rdrf_clr);
1195:  
1196:    sirv_gnrl_dfflr #(1) rs1xn_rdrf_dfflrs(rs1xn_rdrf_ena, rs1xn_rdrf_nxt, rs1xn_rdrf_r, clk, rst_n);
1197:  
1198:    assign bpu2rf_rs1_ena = rs1xn_rdrf_set;
```
**修复建议**
wire rs1xn_rdrf_r;\nwire rs1xn_rdrf_set_raw = (~rs1xn_rdrf_r) & dec_i_valid & dec_jalr & dec_jalr_rs1xn & ((~jalr_rs1xn_dep) | jalr_rs1xn_dep_ir_clr);\nwire rs1xn_rdrf_set = rst_n & rs1xn_rdrf_set_raw;\nwire rs1xn_rdrf_clr = rs1xn_rdrf_r;\nwire rs1xn_rdrf_ena = rs1xn_rdrf_set | rs1xn_rdrf_clr;\nwire rs1xn_rdrf_nxt = rs1xn_rdrf_set | (~rs1xn_rdrf_clr);\n\nsirv_gnrl_dfflr #(1) rs1xn_rdrf_dfflrs(rs1xn_rdrf_ena, rs1xn_rdrf_nxt, rs1xn_rdrf_r, clk, rst_n);\n\nassign bpu2rf_rs1_ena = rs1xn_rdrf_set;
