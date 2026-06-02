# e203_ifu_litebpu 功能点与检测点描述

## DUT 整体功能描述

e203_ifu_litebpu 是 E203 IFU 中的轻量级分支预测单元，负责根据译码输入对 JAL、JALR 和 Bxx 条件分支生成静态预测结果，并输出目标地址计算所需的两个操作数。模块还根据 OITF、IR 阶段状态和寄存器相关性，对 JALR 指令产生等待控制或 rs1 读寄存器请求。

### 端口接口说明

输入端口包括 `clk`、`rst_n`、`pc`、`dec_jal`、`dec_jalr`、`dec_bxx`、`dec_bjp_imm`、`dec_jalr_rs1idx`、`oitf_empty`、`ir_empty`、`ir_rs1en`、`jalr_rs1idx_cam_irrdidx`、`dec_i_valid`、`ir_valid_clr`、`rf2bpu_x1`、`rf2bpu_rs1`。

输出端口包括 `prdt_taken`、`prdt_pc_add_op1`、`prdt_pc_add_op2`、`bpu_wait`、`bpu2rf_rs1_ena`。

该 DUT 为带时钟和低有效复位的时序模块，所有测试必须使用 Step 接口推进。

## 功能分组与检测点

### DUT测试API

<FG-API>

提供验证 e203_ifu_litebpu 时需要使用的标准创建、复位、输入驱动、输出采样和单步推进接口。

#### DUT创建与生命周期

<FC-DUT-LIFECYCLE>

创建 DUT、配置时钟、设置覆盖率和波形路径，并在测试结束时正确清理。

**检测点：**

- <CK-CREATE-CLOCK> 创建 DUT 后调用 InitClock("clk")，Step 可推进时钟且测试结束 Finish 不报错。
- <CK-COVERAGE-WAVE> 创建 DUT 时覆盖率文件与波形文件路径被设置，fixture 清理阶段可提交覆盖率数据。

#### 复位API

<FC-RESET-API>

通过公开输入端口和 Step 时序完成低有效复位及释放流程。

**检测点：**

- <CK-RESET-ASSERT> rst_n=0 并 Step 后 DUT 处于复位流程，可通过公开输出确认无非法读请求。
- <CK-RESET-RELEASE> rst_n 从 0 释放到 1 后再 Step，首个有效输入可得到稳定预测输出。

#### 预测驱动采样API

<FC-PREDICT-API>

提供统一方法设置分支译码、PC、立即数、依赖输入和寄存器值，并采样预测输出。

**检测点：**

- <CK-DRIVE-DEFAULTS> API 能将所有输入初始化为确定默认值，避免历史输入污染当前测试。
- <CK-SAMPLE-OUTPUTS> API 驱动一组输入并 Step 后能返回 prdt_taken、两个操作数、bpu_wait 和 bpu2rf_rs1_ena。

### 静态分支预测

<FG-PREDICT>

覆盖 JAL、JALR、Bxx 和无分支输入下 prdt_taken 的静态预测规则。

#### JAL预测

<FC-JAL-PREDICT>

JAL 指令有效时应无条件预测跳转。

**检测点：**

- <CK-JAL-TAKEN> dec_i_valid=1 且 dec_jal=1 时 prdt_taken 应为 1。
- <CK-JAL-NO-WAIT> 普通 JAL 不依赖 rs1，依赖输入变化不应导致 bpu_wait 或 bpu2rf_rs1_ena。

#### JALR预测

<FC-JALR-PREDICT>

JALR 指令有效时应无条件预测跳转，但可能因依赖产生等待。

**检测点：**

- <CK-JALR-X0-TAKEN> dec_i_valid=1、dec_jalr=1 且 rs1idx=0 时 prdt_taken 应为 1 且不等待。
- <CK-JALR-X1-TAKEN-READY> rs1idx=1 且依赖解除时 prdt_taken 应为 1，bpu_wait 应为 0。
- <CK-JALR-XN-TAKEN-AFTER-READ> rs1idx 非 0/1 且读值可用时，JALR 应保持 taken 预测并使用 rs1 值。

#### Bxx条件分支预测

<FC-BXX-PREDICT>

条件分支按立即数符号进行静态预测，负偏移 taken，非负偏移 not taken。

**检测点：**

- <CK-BXX-BACKWARD-TAKEN> dec_bxx=1 且 dec_bjp_imm 最高位为 1 时 prdt_taken 应为 1。
- <CK-BXX-FORWARD-NOT-TAKEN> dec_bxx=1 且 dec_bjp_imm 为正数时 prdt_taken 应为 0。
- <CK-BXX-ZERO-NOT-TAKEN> dec_bxx=1 且 dec_bjp_imm=0 时作为非负偏移，prdt_taken 应为 0。

#### 无分支输入

<FC-NO-BRANCH>

无 JAL/JALR/Bxx 或指令无效时不应产生有效跳转预测和寄存器读请求。

**检测点：**

- <CK-NO-DECODE-NOT-TAKEN> dec_jal/dec_jalr/dec_bxx 全为 0 时 prdt_taken 应为 0。
- <CK-INVALID-INSTRUCTION-GATING> dec_i_valid=0 时不应产生 bpu_wait 或 bpu2rf_rs1_ena，预测输出应被视为无效。

### 目标地址操作数选择

<FG-OPERAND>

覆盖 prdt_pc_add_op1 和 prdt_pc_add_op2 的来源选择，包括 PC、x0、x1、rs1 和立即数低位。

#### PC基址选择

<FC-OP1-PC>

JAL 和 Bxx 目标地址操作数1应选择当前 PC。

**检测点：**

- <CK-JAL-OP1-PC> JAL 指令预测时 prdt_pc_add_op1 应等于 pc。
- <CK-BXX-OP1-PC> Bxx 条件分支输入下 prdt_pc_add_op1 应等于 pc。

#### JALR x0基址选择

<FC-OP1-JALR-X0>

JALR rs1=x0 时操作数1应选择 0。

**检测点：**

- <CK-X0-OP1-ZERO> JALR rs1idx=0 时 prdt_pc_add_op1 应为 0，rf2bpu_x1/rf2bpu_rs1 不应影响该输出。

#### JALR x1基址选择

<FC-OP1-JALR-X1>

JALR rs1=x1 且可预测时操作数1应选择 rf2bpu_x1。

**检测点：**

- <CK-X1-OP1-VALUE> JALR rs1idx=1 且无等待时 prdt_pc_add_op1 应等于 rf2bpu_x1。
- <CK-X1-VALUE-BOUNDARY> rf2bpu_x1 为 0、全 1 或最高位为 1 的值时，prdt_pc_add_op1 应逐位保持该值。

#### JALR xn基址选择

<FC-OP1-JALR-XN>

JALR rs1 非 x0/x1 且读值有效时操作数1应选择 rf2bpu_rs1。

**检测点：**

- <CK-XN-OP1-RS1> JALR rs1idx 非 0/1 且 rs1 读值有效时 prdt_pc_add_op1 应等于 rf2bpu_rs1。
- <CK-XN-VALUE-BOUNDARY> rf2bpu_rs1 为 0、全 1 或最高位为 1 的值时，prdt_pc_add_op1 应逐位保持该值。

#### 立即数操作数选择

<FC-OP2-IMM>

操作数2应输出 dec_bjp_imm 的 PC 宽度低位。

**检测点：**

- <CK-IMM-POSITIVE> dec_bjp_imm 为正数时 prdt_pc_add_op2 应等于其低 32 位。
- <CK-IMM-NEGATIVE> dec_bjp_imm 最高位为 1 时 prdt_pc_add_op2 应保留 32 位补码值。
- <CK-IMM-EXTREME> dec_bjp_imm 为 0、0xffffffff、0x80000000 等边界值时输出不应被错误扩展或清零。

### JALR依赖等待控制

<FG-JALR-DEPENDENCY>

覆盖 JALR 因 OITF、IR 阶段和寄存器相关性产生 bpu_wait 的条件，以及依赖可忽略或解除后的行为。

#### x1依赖等待

<FC-X1-DEPENDENCY>

JALR rs1=x1 时根据 OITF 和 IR 相关条件决定是否 bpu_wait。

**检测点：**

- <CK-X1-OITF-BUSY-WAIT> JALR rs1=x1 且 oitf_empty=0 时 bpu_wait 应为 1。
- <CK-X1-IR-CAM-WAIT> JALR rs1=x1、OITF 空但 IR 目的寄存器与 rs1 冲突时 bpu_wait 应为 1。
- <CK-X1-READY-NO-WAIT> OITF 空且无 IR 冲突时，JALR rs1=x1 的 bpu_wait 应为 0。

#### xn依赖等待

<FC-XN-DEPENDENCY>

JALR rs1=xn 时根据 OITF、IR 空闲、IR rs1 使用和寄存器 CAM 冲突决定是否等待。

**检测点：**

- <CK-XN-OITF-BUSY-WAIT> JALR rs1=xn 且 oitf_empty=0 时，应等待而不发起有效 rs1 读请求。
- <CK-XN-IR-BUSY-CAM-WAIT> JALR rs1=xn、IR 非空且 CAM 冲突时 bpu_wait 应为 1。
- <CK-XN-READY-NO-WAIT> OITF 和 IR 依赖均解除时，JALR rs1=xn 应取消等待并允许读取 rs1。

#### 依赖忽略与解除

<FC-DEPENDENCY-BYPASS>

IR 清除或 IR 不使用 rs1 等条件允许忽略依赖，依赖解除后应取消等待。

**检测点：**

- <CK-IR-CLR-BYPASS> IR 有效位清除 ir_valid_clr=1 时，相关 IR 依赖应被忽略，不应持续等待。
- <CK-IR-RS1-DISABLE-BYPASS> IR 非空但 ir_rs1en=0 时，rs1 相关依赖应被忽略。
- <CK-DEPENDENCY-TRANSITION> 同一 JALR 从依赖存在切换到依赖解除后，bpu_wait 应从 1 变为 0。

### rs1读寄存器请求状态

<FG-RS1-READ>

覆盖 JALR rs1=xn 场景下 bpu2rf_rs1_ena 的发起、保持抑制、清除和无效指令门控。

#### rs1读请求产生

<FC-RS1-READ-REQUEST>

JALR rs1=xn 且指令有效、无不可忽略依赖时应产生 bpu2rf_rs1_ena。

**检测点：**

- <CK-XN-READ-ENABLE> JALR rs1=xn、dec_i_valid=1 且无不可忽略依赖时 bpu2rf_rs1_ena 应拉高。
- <CK-READ-WITH-BYPASS> 依赖因 IR 清除或 IR 不使用 rs1 被忽略时，应允许产生 rs1 读请求。

#### rs1读状态保持与清除

<FC-RS1-READ-STATE>

读请求状态应防止重复读取，并在后续周期自动清除回到空闲。

**检测点：**

- <CK-NO-REPEAT-READ> rs1=xn 读请求发起后，下一周期同一状态不应重复产生 bpu2rf_rs1_ena。
- <CK-READ-STATE-CLEAR> 读状态清除后再次遇到新的合法 JALR xn 可重新产生读请求。

#### rs1读请求门控

<FC-RS1-READ-GATING>

指令无效、非 JALR、rs1=x0/x1 或依赖未解除时不应产生 rs1 读请求。

**检测点：**

- <CK-INVALID-NO-READ> dec_i_valid=0 时即使 dec_jalr=1 且 rs1=xn，也不应产生 bpu2rf_rs1_ena。
- <CK-NON-JALR-NO-READ> 非 JALR 指令不应产生 rs1 读请求。
- <CK-X0-X1-NO-XN-READ> JALR rs1=x0 或 x1 时不应走 xn 读请求通路。
- <CK-DEPENDENCY-NO-READ> 存在不可忽略依赖并等待时，不应产生 rs1 读请求。

### 复位与边界条件

<FG-RESET-BOUNDARY>

覆盖低有效复位、复位释放、极值 PC/立即数/寄存器值以及非法或互斥输入组合下的可观测行为。

#### 复位行为

<FC-RESET-BEHAVIOR>

低有效复位期间和复位释放后读状态、等待和预测输出应处于可预期状态。

**检测点：**

- <CK-RESET-CLEARS-READ> rst_n=0 后 rs1=xn 读状态应清除，复位期间 bpu2rf_rs1_ena 不应保持为 1。
- <CK-FIRST-AFTER-RESET> 复位释放后的第一条 JAL/JALR/Bxx 有效指令应按规格产生预测输出。

#### 边界数值

<FC-BOUNDARY-VALUES>

极值 PC、立即数、x1 和 rs1 值不应导致操作数位宽、符号或截断错误。

**检测点：**

- <CK-PC-BOUNDARY> pc 为 0、0xffffffff、0x80000000 等边界值时，JAL/Bxx 的 op1 应逐位等于 pc。
- <CK-REG-BOUNDARY> rf2bpu_x1 和 rf2bpu_rs1 为极值时，JALR op1 选择不应出现符号解释或截断错误。
- <CK-IMM-SIGN-BOUNDARY> 立即数 0x7fffffff 与 0x80000000 附近应正确区分 Bxx 正/负偏移预测。

#### 译码冲突输入

<FC-DECODE-CONFLICT>

JAL、JALR、Bxx 多个译码信号同时有效时应符合 RTL 优先级或规格约束，避免不可解释输出。

**检测点：**

- <CK-JAL-JALR-CONFLICT> dec_jal 与 dec_jalr 同时有效时记录并验证 RTL 可观测优先级，确保输出不为未知或自相矛盾。
- <CK-JAL-BXX-CONFLICT> dec_jal 与 dec_bxx 同时有效时记录并验证 prdt_taken 与操作数选择的实际优先级。
- <CK-JALR-BXX-CONFLICT> dec_jalr 与 dec_bxx 同时有效时验证等待、读请求和操作数输出不会违反互斥约束。
