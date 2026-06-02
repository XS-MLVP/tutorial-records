# e203_ifu_litebpu 测试总结报告

## 项目概述

### DUT 基本信息

- DUT 名称：e203_ifu_litebpu
- 测试时间：2026-06-02
- 测试环境：UCAgent 0.9.1.source-code，Python 3.11+，pytest + toffee
- 验证方法：基于功能覆盖率驱动的端口级动态验证，结合 RTL 静态审查和随机回归
- DUT 类型：带 `clk` 和低有效 `rst_n` 的时序模块，所有测试均通过 Step 接口推进

### 验证概述

本次验证围绕 E203 IFU 轻量级 BPU 的静态分支预测、目标地址操作数选择、JALR 依赖等待、rs1=xN 读寄存器请求状态、复位和边界输入行为展开。验证过程中建立了 6 个功能组、21 个功能点和 51 个检查点，覆盖 API、预测、操作数、JALR 依赖、rs1 读请求、复位边界与译码冲突输入。

验证环境已实现 DUT 创建、时钟绑定、功能覆盖率采样、env Bundle 封装、基础预测 API 和完整测试用例集。定向测试用于精确覆盖每个检查点和复现静态审查发现的问题，随机测试用于对 PC、立即数、寄存器值和依赖输入组合进行可重复扰动验证。

## 测试执行汇总

### 测试用例统计

| 指标 | 数值 | 说明 |
|------|------|------|
| 定向功能测试 | 51 | 对应 51 个检查点的主功能验证用例 |
| API/Env 测试 | 9 | API 基础功能 6 个，env fixture 评估 3 个 |
| 随机测试 | 3 | 固定种子并使用 `ucagent.repeat_count()` 的随机回归用例 |
| 已确认 Fail 用例 | 6 | 用于证明已记录 RTL Bug，按任务要求保留失败 |
| 已确认动态 Bug | 3 类 | `BG-XN-READ-WAIT-85`、`BG-PRDT-VALID-GATING-95`、`BG-RESET-RS1ENA-GATING-90` |

说明：综合检查器在前序阶段确认已执行 60 个测试用例，所有 51 个检查点实现与文档一致，并记录 6 个由 RTL Bug 导致的 Fail 用例。阶段 16 新增随机用例后，`RunTestCases('test_e203_ifu_litebpu_random_core.py')` 结果为 3/3 通过。

### 测试文件组织

- `unity_test/tests/test_e203_ifu_litebpu_api.py`：DUT 生命周期、复位 API 和预测 API 基础检查。
- `unity_test/tests/test_e203_ifu_litebpu_api_basic.py`：基础 API 参数检查与上层 JAL/JALR/Bxx API 行为验证。
- `unity_test/tests/test_e203_ifu_litebpu_env_fixture.py`：env Bundle 绑定、reset 方法、drive/sample 方法验证。
- `unity_test/tests/test_e203_ifu_litebpu_predict.py`：JAL、JALR、Bxx、无分支和无效指令预测检查。
- `unity_test/tests/test_e203_ifu_litebpu_operand.py`：PC、x0、x1、xN 和立即数操作数选择检查。
- `unity_test/tests/test_e203_ifu_litebpu_jalr_dependency.py`：JALR x1/xN 依赖等待、旁路和状态转换检查。
- `unity_test/tests/test_e203_ifu_litebpu_rs1_read.py`：xN rs1 读请求产生、保持、清除和门控检查。
- `unity_test/tests/test_e203_ifu_litebpu_reset_boundary.py`：复位、边界值和译码冲突输入检查。
- `unity_test/tests/test_e203_ifu_litebpu_random_core.py`：随机预测、随机 x1 依赖、随机 rs1 读状态和门控回归。

## 功能覆盖率分析

### 覆盖率总览

| 覆盖率类型 | 目标值 | 实际状态 | 说明 |
|------------|--------|----------|------|
| 功能组覆盖率 | 100% | 已完成 | 6 个 FG 均已建立并被测试关联 |
| 功能点覆盖率 | 100% | 已完成 | 21 个 FC 均有覆盖定义和测试标记 |
| 检查点覆盖率 | 100% | 已完成 | 51 个 CK 均已实现覆盖检查并由测试关联 |
| 边界值覆盖率 | 100% | 已完成 | PC、立即数、x1、xN、符号边界和复位边界均已覆盖 |
| 异常/冲突覆盖率 | 100% | 已完成 | 无效指令、依赖未解除、译码冲突、复位期间输入均已覆盖 |

### 功能组覆盖详情

| 功能组 | 覆盖结论 | 重点检查内容 |
|--------|----------|--------------|
| FG-API | 完成 | DUT 创建、时钟绑定、复位、输入默认化、输出采样 |
| FG-PREDICT | 完成 | JAL/JALR taken、Bxx 符号预测、无分支和无效指令门控 |
| FG-OPERAND | 完成 | JAL/Bxx PC、JALR x0/x1/xN、立即数低 32 位透传 |
| FG-JALR-DEPENDENCY | 完成 | x1 OITF/CAM 等待、xN OITF/IR 等待、IR 清除与 rs1 禁用旁路 |
| FG-RS1-READ | 完成 | xN 读请求、重复读抑制、状态清除和门控 |
| FG-RESET-BOUNDARY | 完成 | 复位读请求清除、首条有效指令、边界值、译码冲突 |

### 已知未通过检查点

以下检查点未通过是由确认 RTL Bug 导致，均有对应 Fail 用例和源码根因分析：

- FG-PREDICT/FC-NO-BRANCH/CK-INVALID-INSTRUCTION-GATING：无效指令下 `prdt_taken` 未被 `dec_i_valid` 门控。
- FG-JALR-DEPENDENCY/FC-XN-DEPENDENCY/CK-XN-READY-NO-WAIT：xN ready 读请求周期 `bpu_wait` 错误拉高。
- FG-JALR-DEPENDENCY/FC-DEPENDENCY-BYPASS/CK-IR-CLR-BYPASS：IR valid 清除旁路时 `bpu_wait` 错误拉高。
- FG-JALR-DEPENDENCY/FC-DEPENDENCY-BYPASS/CK-IR-RS1-DISABLE-BYPASS：IR 不使用 rs1 旁路时 `bpu_wait` 错误拉高。
- FG-JALR-DEPENDENCY/FC-DEPENDENCY-BYPASS/CK-DEPENDENCY-TRANSITION：依赖解除后读请求周期仍等待。
- FG-RESET-BOUNDARY/FC-RESET-BEHAVIOR/CK-RESET-CLEARS-READ：复位期间仍可组合产生 `bpu2rf_rs1_ena`。

## 缺陷分析

### 缺陷统计概览

| Bug 标签 | 置信度 | 严重程度 | 影响范围 | 状态 |
|----------|--------|----------|----------|------|
| BG-PRDT-VALID-GATING-95 | 95% | 严重 | 无效指令门控和预测控制 | 动态测试确认 |
| BG-RESET-RS1ENA-GATING-90 | 90% | 严重 | 复位期间读请求输出 | 动态测试确认 |
| BG-XN-READ-WAIT-85 | 85% | 重要 | JALR xN ready/旁路依赖等待 | 动态测试确认 |

### 主要缺陷详细分析

#### 1. prdt_taken 未受 dec_i_valid 门控

影响路径：FG-PREDICT/FC-NO-BRANCH/CK-INVALID-INSTRUCTION-GATING。  
触发用例：`unity_test/tests/test_e203_ifu_litebpu_predict.py::test_invalid_instruction_gating`。

RTL 中 `prdt_taken` 由 `dec_jal | dec_jalr | (dec_bxx & dec_bjp_imm[31])` 直接组合生成，没有与 `dec_i_valid` 相与。因此当 `dec_i_valid=0` 且 `dec_jal=1` 时，DUT 仍输出 taken。该行为违反无效指令不应产生有效预测的接口规格。修复建议是在 `prdt_taken` 生成逻辑中增加 `dec_i_valid` 门控。

#### 2. xN rs1 读请求周期错误触发 bpu_wait

影响路径：FG-JALR-DEPENDENCY/FC-XN-DEPENDENCY 和 FC-DEPENDENCY-BYPASS。  
触发用例：`test_xn_ready_no_wait`、`test_ir_clr_bypass`、`test_ir_rs1_disable_bypass`、`test_dependency_transition`。

RTL 中 `rs1xn_rdrf_set` 表示已经满足 xN JALR 发起读寄存器请求的条件，但 `bpu_wait` 又将该信号作为等待原因之一。结果是在依赖已解除或可旁路、且读请求已经合法发出的周期，DUT 同时拉高 `bpu2rf_rs1_ena` 和 `bpu_wait`。该行为破坏 ready no-wait 和旁路不等待的规格。修复建议是将 `bpu_wait` 限定为真实未解除依赖，不应包含 `rs1xn_rdrf_set` 本身。

#### 3. 复位期间 bpu2rf_rs1_ena 未受 rst_n 门控

影响路径：FG-RESET-BOUNDARY/FC-RESET-BEHAVIOR/CK-RESET-CLEARS-READ。  
触发用例：`unity_test/tests/test_e203_ifu_litebpu_reset_boundary.py::test_reset_clears_read`。

RTL 中 `bpu2rf_rs1_ena` 直接等于组合信号 `rs1xn_rdrf_set`，而 `rs1xn_rdrf_set` 未包含 `rst_n` 门控。虽然 `sirv_gnrl_dfflr` 能在复位时清除 `rs1xn_rdrf_r`，但若复位期间输入仍满足 xN JALR ready 条件，组合读请求会被重新拉高。修复建议是在 `rs1xn_rdrf_set` 或 `bpu2rf_rs1_ena` 输出路径增加 `rst_n` 门控。

### 静态 Bug 验证闭环

静态分析报告中的两个静态 Bug 均已完成动态关联，没有 `LINK-BUG-[BG-TBD]` 残留：

- `BG-STATIC-001-PRDT-VALID-GATING` 已链接到动态 Bug `BG-PRDT-VALID-GATING-95`。
- `BG-STATIC-002-XN-READ-WAIT` 已链接到动态 Bug `BG-XN-READ-WAIT-85`。

复位期间读请求门控问题是在后续动态验证中补充发现的独立 Bug，已在动态缺陷文档中记录。

## 测试质量评估

### 完整性

- 功能点覆盖完整性：良好。功能文档覆盖 6 个功能组、21 个功能点、51 个检查点，覆盖模型与测试用例保持一致。
- 边界条件完整性：良好。已覆盖 PC、立即数、寄存器值、复位释放、立即数符号边界和译码冲突输入。
- 异常情况完整性：良好。已覆盖无效指令、复位期间输入、依赖 busy、IR 清除旁路和 IR 不使用 rs1 旁路。
- 回归完整性：良好。定向用例用于定位，随机用例使用固定种子和 `ucagent.repeat_count()`，可重复执行。

### 有效性

- 缺陷检出能力：高。静态审查发现的两个关键问题均由动态 Fail 用例确认，动态测试进一步发现复位门控缺陷。
- 误报率：低。静态 Bug 均已动态证实；未保留 `BG-*-0` 占位缺陷。
- 断言质量：良好。测试用例使用输出值与期望值的直接比较，避免只检查非空或类型的弱断言。
- 端口级验证约束：已遵守。功能测试均通过公开输入输出端口进行验证，未依赖 DUT 内部信号状态。

### 代码质量

- API 设计：良好。`api_e203_ifu_litebpu_predict` 作为统一底层操作接口，JAL/JALR/Bxx 上层 API 复用该接口，均通过 Step 推进。
- Env 封装：良好。按控制、译码、依赖、寄存器输入和预测输出分组 Bundle，便于测试维护。
- 覆盖率定义：良好。覆盖组、功能点和检查点与文档标签一致，检查函数基于 DUT 引用采样公开端口。
- 随机测试：良好。每个随机用例使用独立固定种子，随机数据经 Python 计算期望输出后断言。

## 改进建议

### 设计修复建议

1. 修复 `prdt_taken`：增加 `dec_i_valid` 门控，避免无效指令污染 IFU 预测控制。
2. 修复 `bpu_wait`：去除 `rs1xn_rdrf_set` 对等待信号的直接贡献，或者重新定义读请求周期是否应等待，并同步更新规格与测试。
3. 修复 `bpu2rf_rs1_ena`：增加 `rst_n` 门控或在复位期间强制输出为 0，保证复位安全状态。
4. 补充设计注释：明确 JAL/JALR/Bxx 冲突输入的优先级是 RTL 约束还是非法输入，以减少后续集成歧义。

### 测试策略建议

1. 在修复 RTL 后重新运行全部定向 Fail 用例，确认对应 Bug 用例转为 Pass。
2. 保留随机用例并扩大 repeat_count，用于覆盖更多 pc/imm/rs1idx/依赖组合。
3. 若设计决定 xN JALR 读请求周期必须等待一个周期，应更新功能规格、覆盖检查和 Bug 结论；当前验证按用户提供规格判定为不应等待。
4. 对译码冲突输入建议在系统级增加约束检查，明确是否禁止多个译码信号同时有效。

## 经验教训总结

### 成功经验

- 先建立功能标签和覆盖模型，再实现测试用例，使 51 个检查点可追踪、可审计。
- 静态源码审查与动态测试结合能提高缺陷定位效率，尤其适用于组合控制逻辑和状态机边界。
- 对已知 Bug 保留确定性 Fail 用例，而随机测试避开非定位型失败，有利于回归稳定性和 Bug 归因清晰。
- API 层统一 Step 驱动和输出采样，减少测试用例直接操作底层引脚造成的时序不一致。

### 遇到的挑战

- DUT 核心逻辑较短，但组合输出与时序状态混合，`rs1xn_rdrf_set` 同时参与读请求和等待控制，容易出现语义混淆。
- `dec_i_valid` 对不同输出信号的门控不一致，必须逐个输出检查，不能只依据部分信号推断整体有效性。
- 复位问题不是内部寄存器未复位，而是组合输出未被复位门控，需要通过复位期间仍驱动输入的场景才能暴露。

### 最佳实践

- 对控制类 DUT，应分别检查“输出值正确”和“输出有效性门控正确”。
- 对状态机辅助信号，应区分“动作请求信号”和“等待/阻塞信号”，避免同一条件被错误复用。
- 随机测试应有固定种子、明确期望模型和可复现断言；触发 Bug 的随机用例应尽快固化为定向 Fail 用例。
- Bug 文档必须包含源码片段、根因、修复建议和 Fail 测试用例，便于设计修复后回归验证。

## 结论

### 验证结论

本次验证已完成 e203_ifu_litebpu 的功能分解、覆盖率模型、API/env 封装、定向测试、静态 Bug 验证、随机测试和总结审查。验证计划中列出的静态预测、操作数选择、JALR 依赖等待、rs1 读寄存器状态、复位和边界行为均已通过端口级测试覆盖。

当前 DUT 存在 3 类已确认设计缺陷，其中 2 类严重、1 类重要。除这些已记录缺陷外，未在最终源码复查和测试回顾中发现新的可确认 Bug。

### DUT 质量评估

- 整体质量等级：需修复后再发布。
- 功能正确性：主体静态预测和操作数选择基本正确，但无效指令门控、xN ready 等待和复位读请求存在明确缺陷。
- 设计鲁棒性：中等偏低，主要风险集中在控制信号门控和复位安全输出。
- 接口规范性：大部分端口行为清晰，但译码冲突输入优先级建议进一步文档化。

### 发布建议

不建议在未修复上述 3 类缺陷前进入集成发布。建议设计侧优先修复 `BG-PRDT-VALID-GATING-95` 和 `BG-RESET-RS1ENA-GATING-90` 两个高置信度严重问题，再修复 `BG-XN-READ-WAIT-85` 或明确规格变更。修复后应重新运行全部测试，重点确认 6 个 Fail 用例转为 Pass，并保持随机回归通过。

### 后续工作建议

1. 基于 bug 分析文档中的修复建议修改 RTL。
2. 重新执行 `RunTestCases('')` 和阶段综合检查，确认功能覆盖与缺陷回归闭环。
3. 对译码互斥约束添加上游断言或接口协议说明。
4. 在系统级 IFU 验证中加入真实指令流场景，确认 BPU 输出与取指重定向控制集成后行为一致。

---

报告生成信息：

- 报告生成时间：2026-06-02
- UCAgent 框架版本：0.9.1.source-code
- 验证配置：pytest + toffee，功能覆盖率驱动，端口级 Step 驱动，未启用参考模型
