# e203_ifu_litebpu 基础信息

## 1. 模块定位

e203_ifu_litebpu 是 E203 处理器 IFU 中的轻量级分支预测单元，用于对 JAL、JALR 和条件分支 Bxx 指令生成静态预测结果。模块输出是否预测跳转、PC 加法器两个操作数、BPU 等待信号以及 JALR rs1=xn 时对寄存器堆的 rs1 读取请求。

## 2. 芯片类型

该模块包含 `clk` 与低有效复位 `rst_n`，并实例化触发器保存 rs1=xn 读寄存器状态，因此属于时序电路。验证环境必须调用 `InitClock("clk")` 绑定时钟，并通过 `Step` 接口推进电路，不应直接绕过时钟时序进行验证。

## 3. Python DUT 接口

Python 封装类为 `DUTe203_ifu_litebpu`。主要测试相关方法如下：

- `InitClock(name)`：将指定端口加入时钟驱动，当前模块应使用 `clk`。
- `Step(i=1)`：推进 i 个时钟步。
- `StepRis(callback)` 和 `StepFal(callback)`：注册上升沿/下降沿回调，可用于功能覆盖采样。
- `SetCoverage(filename)`：设置代码覆盖率输出文件。
- `SetWaveform(filename)`：设置波形输出文件。
- `Finish()`：结束 DUT 仿真。

## 4. 输入端口

| 端口 | 位宽 | 作用 |
| --- | --- | --- |
| `clk` | 1 | 时钟输入 |
| `rst_n` | 1 | 低有效复位 |
| `pc` | 32 | 当前指令 PC |
| `dec_jal` | 1 | 当前指令译码为 JAL |
| `dec_jalr` | 1 | 当前指令译码为 JALR |
| `dec_bxx` | 1 | 当前指令译码为条件分支 |
| `dec_bjp_imm` | 32 | 分支/跳转立即数 |
| `dec_jalr_rs1idx` | 5 | JALR 使用的 rs1 寄存器编号 |
| `oitf_empty` | 1 | OITF 是否为空，用于判断未完成执行依赖 |
| `ir_empty` | 1 | IR 阶段是否为空 |
| `ir_rs1en` | 1 | IR 阶段指令是否使用 rs1 |
| `jalr_rs1idx_cam_irrdidx` | 1 | 当前 JALR rs1 是否与 IR 目的寄存器冲突 |
| `dec_i_valid` | 1 | 当前译码指令是否有效 |
| `ir_valid_clr` | 1 | IR 有效位清除，表示相关依赖可忽略 |
| `rf2bpu_x1` | 32 | 寄存器 x1 的值 |
| `rf2bpu_rs1` | 32 | 通用 rs1 寄存器的值 |

## 5. 输出端口

| 端口 | 位宽 | 作用 |
| --- | --- | --- |
| `prdt_taken` | 1 | 预测跳转标志 |
| `prdt_pc_add_op1` | 32 | PC 加法器操作数 1，来自 PC、0、x1 或 rs1 |
| `prdt_pc_add_op2` | 32 | PC 加法器操作数 2，来自立即数低 32 位 |
| `bpu_wait` | 1 | BPU 等待流水线信号，用于 JALR 依赖未解除场景 |
| `bpu2rf_rs1_ena` | 1 | BPU 请求寄存器堆读取 rs1 的使能 |

## 6. 主要功能分类

预计可拆分为 6 个主要功能组，约 15 到 20 个可测试功能点：

- API 与环境基础功能：DUT 创建、复位、输入驱动、输出采样。
- 静态预测功能：JAL、JALR、Bxx 负偏移/非负偏移、无分支。
- 目标操作数选择：JAL/Bxx 使用 PC，JALR rs1=x0/x1/xn 分别选择 0、x1、rs1，立即数输出截断。
- JALR 依赖等待：x1 依赖、xn 依赖、OITF/IR 组合、IR 清除和 IR 不读 rs1 例外。
- rs1=xn 读寄存器控制：读请求产生、单周期/去重、状态清除、无效指令抑制。
- 复位与边界条件：复位期间输出安全、复位释放后首条指令、极值 PC/立即数/寄存器值。

## 7. 验证关注点

验证应以公开端口为边界，不直接验证内部子模块。重点关注 `dec_i_valid` 对所有控制输出的门控、JAL/JALR/Bxx 同时有效时 RTL 的实际优先级、JALR 依赖条件的过度等待或漏等待，以及 rs1=xn 读状态机是否会重复请求或卡死。
