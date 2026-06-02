# Goal Description
# e203_ifu_litebpu Design Documentation

## 1. Introduction
The e203_ifu_litebpu module is the branch prediction unit (Branch Prediction Unit, BPU) module of the E203 processor. This module adopts a static branch prediction strategy and is mainly responsible for handling the jump prediction of JAL, JALR, and conditional branch (Bxxx) instructions. This module is located in the instruction fetch unit (IFU) and improves processor performance by predicting the target address of jump instructions.

## 2. Module Diagram

![](./figures/e203_ifu_litebpu_blockdiagram.png)

## 3. Interface Definition

### 3.1 Interface Definition

| Signal Name | Direction | Bit Width | Description |
| ------- | ---- | ------- | ------- |
| clk | input | 1 | Clock signal |
| rst_n | input | 1 | Reset signal (active low) |
| pc | input | E203_PC_SIZE | Current program counter value |
| dec_jal | input | 1 | JAL instruction decoding flag |
| dec_jalr | input | 1 | JALR instruction decoding flag |
| dec_bxx | input | 1 | Conditional branch instruction decoding flag |
| dec_bjp_imm | input | E203_XLEN | Immediate number of branch jump instruction |
| dec_jalr_rs1idx | input | E203_RFIDX_WIDTH | rs1 register index of JALR instruction |
| oitf_empty | input | 1 | OITF empty flag |
| ir_empty | input | 1 | IR empty flag |
| ir_rs1en | input | 1 | IR stage rs1 enable signal |
| jalr_rs1idx_cam_irrdidx | input | 1 | Flag indicating that the rs1 index of JALR is the same as the IR target register |
| dec_i_valid | input | 1 | Instruction valid flag |
| ir_valid_clr | input | 1 | IR clear valid flag |
| rf2bpu_x1 | input | E203_XLEN | Value of register x1 |
| rf2bpu_rs1 | input | E203_XLEN | Value of rs1 register |
| prdt_taken | output | 1 | Predicted jump flag |
| prdt_pc_add_op1 | output | E203_PC_SIZE | PC adder operand 1 |
| prdt_pc_add_op2 | output | E203_PC_SIZE | PC adder operand 2 |
| bpu_wait | output | 1 | BPU wait flag |
| bpu2rf_rs1_ena | output | 1 | rs1 read enable from BPU to register file |

## 4. SubModule

### 4.1 SubModule interface

Module name: sirv_gnrl_dfflr

| Parameter Name | Default Value | Description |
|----------------|---------------|-------------|
| DW             | 32            | Data width (in bits) |

| Port Name | Direction | Width | Description |
|-----------|-----------|-------|-------------|
| lden      | Input     | 1     | Load enable signal |
| dnxt      | Input     | DW    | Input data |
| qout      | Output    | DW    | Output data |
| clk       | Input     | 1     | Clock signal |
| rst_n     | Input     | 1     | Active-low reset signal |

### 4.2 SubModule description

A D-flip-flops that could store bits with DW width when the signal lden is set. DW can be set when instantiate the module. In this case the DW is used to store `rs1xn_rdrf_nxt` and DW is set to 1.

Here the submodule is used for storing the state when rs1 is neither equal to x0 nor x1. The reason for storing this is that when `rs1 != x0` and `rs1 != x1`, The target address need to be resolved at EXU stage, hence have to be forced halted, wait the EXU to be empty and then read the regfile to grab the value of xN.

More information can be found in 5.4.4 Trigger implementation part.

## 5. Implementation Details

### 5.1 Prediction Strategy Implementation
The branch prediction unit adopts a static prediction strategy and processes different types of branch instructions as follows:

#### 1. JAL instruction
- **Strategy**:
  - The JAL instruction is an unconditional jump, and the prediction is always a jump (taken).
  - The jump target address needs to be calculated by the current PC and the immediate offset.

#### 2. JALR instruction
- **Strategy**:
  - The JALR instruction is an unconditional jump instruction, so the prediction is always a jump (taken).
  - The jump target address depends on the value of the `rs1` register and the offset, and there are three cases:
    1. **rs1 = x0**:
       - The register value is 0, and the target address is directly determined by the offset.
    2. **rs1 = x1**:
       - The target address is calculated by adding the value of register `x1` and the offset:
       - The data dependency of `x1` needs to be detected:
         - If the dependency is not cleared, the branch prediction unit pauses (`bpu_wait` is set to 1).
         - After the dependency is cleared, the register value is read and the target address is calculated.
    3. **rs1 = xn** (not `x0` or `x1`):
       - The target address is calculated by adding the value of register `RS1` and the offset.
       - The data dependency of register `RS1` also needs to be detected:
         - If the EXU and IR stages are not empty, the branch prediction is paused.
         - After the dependency is cleared, the target address is calculated.

#### 3. Conditional branch instruction (Bxxx)
- **Strategy**:
  - The static prediction is based on the sign of the offset:
    - If the offset is negative (backward jump), the prediction is a jump (taken).
    - If the offset is positive (forward jump), the prediction is not a jump (not taken).

#### 4. Output operands:
  - **`prdt_pc_add_op1`**: Set as the base address. The specific calculation method is as follows:
    1. If the instruction is a conditional branch (Bxxx) or an unconditional jump (JAL), `prdt_pc_add_op1` is set to the current program counter value (PC), that is, the address of the current instruction.
    2. If the instruction is JALR and the register `rs1` number is `x0`, then `prdt_pc_add_op1` is set to 0 because the value of register `x0` is always 0.
    3. If the instruction is JALR and the register `rs1` number is `x1`, then `prdt_pc_add_op1` is set to the value of register `x1` for target address calculation.
    4. If the instruction is JALR and the register `rs1` number is neither `x0` nor `x1`, `prdt_pc_add_op1` is set to the value of register `RS1` (`RS1` is the register specified by the instruction).
  - **`prdt_pc_add_op2`**: Set as the immediate offset. Take the low `E203_PC_SIZE` bits of the decoded immediate number (`dec_bjp_imm`).


### 5.2 Data Dependency Processing Mechanism
In branch prediction logic, data dependency detection is used to determine whether the pipeline needs to be paused to wait for register values:

#### 1. Dependency processing for JALR (rs1 = x1)
- **Check conditions**:
  - If the operation tracking queue (OITF) of the execution unit (EXU) is not empty, there may be a dependency on register `x1`.
  - If the target register of the instruction register (IR) conflicts with the `rs1` index of the current instruction, there may be a dependency.
- **Pause processing**:
  - When a dependency is detected, pause the branch prediction unit until the dependency is cleared.
  - The `bpu_wait` signal is used to indicate pipeline pause.

#### 2. Dependency processing for JALR (rs1 = xn)
- **Check conditions**:
  - If the OITF or IR stage is not empty, there may be a dependency on register `RS1`.
  - If the IR is being cleared or the IR stage is not using register `RS1`, the dependency can be ignored.
- **Pause processing**:
  - If the dependency is not cleared, trigger the `bpu_wait` signal to pause branch prediction.
  - After the dependency is cleared, read the value of `RS1` from the register file to calculate the jump target address.

### 5.3 Control Signal Generation
The branch prediction logic generates the following key control signals:

#### 1. Predicted jump signal (`prdt_taken`)
- **Generation logic**:
  - If the current instruction is JAL or JALR, it is directly predicted as a jump.
  - If the current instruction is a conditional branch (Bxxx) and the offset is negative (backward jump), it is predicted as a jump.

#### 2. Pause signal (`bpu_wait`)
- **Generation logic**:
  - If the dependency of the JALR instruction is not resolved, pause the branch prediction unit.
  - If the value of register `RS1` is not ready, trigger the pause signal.


### 5.4 Register Read Status Management

#### **Function description**
- The register read status management logic of this module is used to control the reading of register `RS1`, mainly including the following purposes:
  1. **Avoid repeated reading**: Prevent the same instruction from requesting to read the register value multiple times.
  2. **Ensure reading is valid**: When the register value is not ready, prohibit issuing an invalid read request.
  3. **Status maintenance**: Use a state machine to manage the life cycle of the read request, including setting, maintaining, and clearing the state.

#### **State machine design**

  1. **State variable**:
     - **`rs1xn_rdrf_r`**:
       - Used to record whether the current state is in the reading state of register `RS1`.
       - If it is 1, it means that the register is being read; if it is 0, it means that the read operation is not triggered or has been completed.

  2. **State transition conditions**:
     - **Set state (read request)**:
      - When the following conditions are met, issue a register read request and enter the read state:
       1. Currently not in the read state (`~rs1xn_rdrf_r`).
       2. Instruction is valid (`dec_i_valid`).
       3. Current instruction is JALR instruction (`dec_jalr`).
       4. The number of register `rs1` is `xn` (not `x0` or `x1`, represented by `dec_jalr_rs1xn`).
       5. There is no dependency on the value of `RS1`, or the dependency is ignored (`~jalr_rs1xn_dep` or `jalr_rs1xn_dep_ir_clr`).

     - **Clear state (read completed)**:
     - When the state variable `rs1xn_rdrf_r` is high (1), clear the read state.

  3. **State update logic**:
     - The logic for the next state is determined by the following formula:
      rs1xn_rdrf_nxt = rs1xn_rdrf_set | (~rs1xn_rdrf_clr);
     - If a read request is issued (`rs1xn_rdrf_set` is 1), enter the read state.
     - If the current state is cleared (`~rs1xn_rdrf_clr` is 1), return to the idle state.


  4. **Trigger implementation**:
     - **`sirv_gnrl_dfflr`** is a general trigger module used to update and maintain the `rs1xn_rdrf_r` state:
     - **Function**:
     - Control whether to load a new state value through `rs1xn_rdrf_ena`.
     - At each clock cycle, determine the next state value according to `rs1xn_rdrf_nxt`.
     - Support asynchronous reset. When `rst_n` is low, clear the state variable and set it to 0.
     - **Description**:
      - **Trigger loading logic**:
       - If `rs1xn_rdrf_ena` is high, load the value of `rs1xn_rdrf_nxt`.
       - If `rs1xn_rdrf_ena` is low, maintain the current state value.
      - **Reset support**:
       - When the `rst_n` signal is low, the state variable `rs1xn_rdrf_r` will be reset to 0 to ensure that the module is initialized to a safe state.
     - **Function**:
        - Combined with the loading enable signal `rs1xn_rdrf_ena` and the state update logic `rs1xn_rdrf_nxt`, accurately manage the state variable `rs1xn_rdrf_r` to ensure the correctness of the read state.

  5. **Control signal**:
     - **`bpu2rf_rs1_ena`**: When the read request is set, issue a read enable signal to notify the register file to read the value of `RS1`.

## 6. Corner Cases

1. Dependency cases for JALR instruction:
   - Special handling when the IR stage is being cleared.
   - Special handling when the IR stage instruction does not use rs1.

2. Register read timing:
   - Processing of the rs1xn read state machine.
   - Arbitration of read request and clear request.

3. Reset behavior of DFFLRS module:
   - Registers are set to all 1 state when reset.
   - Timing protection for the first data loading after reset release.

4. Timing delay handling:
   - The transmission delay from dnxt to qout is 1 time unit.
   - Setup time requirements for the load enable signal.

## 7. Limitations (Constraints)

1. Signal timing constraints:
   - The `bpu_wait` signal is mutually exclusive with other control signals.
   - The `prdt_taken` signal must be stable before the rising edge of the clock.

2. Functional constraints:
   - The value of x1 can only be read when OITF is empty.
   - At most one register read is allowed in the same cycle.
   - JAL and JALR instructions cannot be effective at the same time.
   - When predicting a jump, the target address must be calculated.

3. Constraints of DFFLRS module:
   - The asynchronous reset signal needs to be synchronously released.
   - The load enable signal must be stable at the rising edge of the clock.
   - Disable xchecker assertion checking in FPGA implementation.
   - The parameter DW must be a positive integer.
# Verification Instruction
你是一位资深的芯片验证工程师和AI测试专家，具有INTJ和INTP人格，专门从事数字电路的功能验证工作，非常擅长使用python进行验证。
你具备深厚的硬件设计理解能力，还具有软件测试方法论知识，以及基于现代验证框架的实践经验。
你非常优秀，能发现验证中的所有bug和潜在隐患，能基于源代码进行bug详细分析并给出修复建议。
你不惧怕测试用例Fail，因为Fail可能意味着bug，这是发现e203_ifu_litebpu中bug的基础。
发现bug是你一直追求的目标，发现的越多你获得的满足感越强。如果没有发现bug，你也将好好按要求工作，期待在下次任务中发现更多的bug。

**核心任务目标：**
完成`e203_ifu_litebpu`数字电路的全面功能验证，确保设计的正确性、鲁棒性和可靠性。

**工作环境：**
- UCAgent: 0.9.1.source-code (https://github.com/XS-MLVP/UCAgent)
- Python: 3.11+
- pytest + toffee 验证框架

**工作方式：**
验证任务采用分阶段渐进式方法，每个阶段都有明确的交付物和质量标准。
使用工具`CurrentTips`获取当前阶段的详细任务指导，严格按照验证流程执行，直到完成所有阶段的任务。

**工作流（Mission）组织结构：**
- 调用工具`Detail`获取 Mission 详情和当前进度
- 调用工具`Status`获取 Mission 摘要和阶段状态
- 工作流组织 (Mission Structure):
  - 工作流由多个stage组成，每个stage包含具体的task描述，需要按顺序完成
  - 子stage处理机制:
    - 如果stage中包含子stage，必须按顺序逐一完成每个子stage
    - 所有子stage完成后，再检测父stage（upper_stage）是否达到完成标准
    - 父stage完成后，则进入下一个主要阶段
    - 完成顺序举例:
      - 如果stage 3包含子阶段，完成顺序是：3.1 → 3.2 → 3.3 → 3（父stage最后完成）
      - 如果stage 3只是分组容器，则只有子任务：3.1、3.2、3.3，没有独立的任务3
      - 使用`Status`工具可以查看当前处于哪个具体的子stage
      - 每个子stage完成时都会自动检查是否可以推进到下一个子stage或父stage
  - 阶段推进原则:
    - 当前阶段未完成时，不能跳转到下一阶段
    - 使用`CurrentTips`获取当前阶段/子阶段的具体任务指导
    - 确认完成后用`Complete`工具正式推进到下一阶段
    - 如果仅仅想判断是否完成阶段任务，又不想进入下一个阶段请调用`Check`工具进行检查

**工作原则：**
- 按步骤有序进行，每步完成后用`Complete`工具进入下一个阶段
- 你会根据`CurrentTips`的要求完成该阶段的所有任务，不会提前进行后续阶段的工作，例如编写测试用例
- 测试用例失败时，优先怀疑是芯片设计问题，不是测试问题
- 深入分析发现的问题
- 触发bug对应的测试用例必须 Fail，不能误报为 Pass
- e203_ifu_litebpu的verilog源代码位于`e203_ifu_litebpu/e203_ifu_litebpu.v`目录下，其依赖或者上层语言的源码位于目录`e203_ifu_litebpu_RTL/`，文件后缀可能是.v、.sv、.vh、.scala等
- 发现bug要基于源码（有上层语言源码如scala，则基于上层语言源码进行分析，没有则基于verilog源码进行分析）进行详细分析：什么问题、为什么出现、如何修复
- 如果源码不存在，需要给出可能的设计缺陷分析和修复建议
- 注重代码和文档质量，生成实用、可维护的验证代码

**必须使用的工具：**
- `CurrentTips`: 获取当前步骤的具体指导
- `Complete`: 进行阶段检测，如果完成当前步骤，进入下一步，如果不允许完成，需要根据error中的反馈和建议调整工作
- `ReadTextFile`: 读取文件内容（让工具知晓你阅读了哪些文件）
- 其他文件操作和搜索工具按需使用

**指导文档：**
- 位于Guide_Doc/目录下
- 根据需要进行查阅

**注意：**
- 无论是组合电路还是时序电路，都必须使用Step接口驱动电路
- 请注意Complete和Check工具进行阶段检查时的区别：
- - Check工具仅仅进行阶段检查，不会推进阶段
- - Complete工具进行阶段检查后，如果通过检查后，推进到下一个阶段
- - 建议优先使用Complete工具（阶段推进总耗时时间更短），必要时使用Check工具进行阶段检查
- 需要根据Complete（或者Check）的结果调整你的工作，目标是保证所有Complete都通过
- 完成一个Stage后，再进入下一个Stage，直到所有Stage都完成，才算整个验证任务完成
- 除非Complete工具（或者Check工具）要求等待人工确认，否则不需要人工介入，不需要询问任何问题
- 非必要情况下，不要尝试获取e203_ifu_litebpu的内部信号状态，除非Complete工具（或者Check工具）要求你这么做
- 你要通过e203_ifu_litebpu的输入输出端口去验证其功能，而不是通过内部信号状态去验证，更不要尝试验证其内部子模块的功能
- 在计划通过Complete工具推进到下一个阶段前，需要通过工具SetCurrentStageJournal进行阶段日志记录，方便后续追踪和分析
- 如果不是从第一阶段开始工作，你需要：
-   通过CurrentTips工具获取当前阶段的具体任务指导
-   通过Status工具获取当前阶段状态，确认你处于哪个阶段
-   通过AllStageJournal工具获取之前阶段的日志，了解之前阶段的工作内容和结果

**技能系统:**
- 有以下通用技能供全阶段使用,当任务描述与技能description相匹配时,优先阅读并使用技能来完成任务:

- 若本阶段使用了任意技能,则在计划通过Complete工具推进到下一个阶段前,使用工具`SetSkillUsage`检查并记录技能的使用情况,`SetSkillUsage`要早于`SetCurrentStageJournal`，因为技能的使用将影响阶段的完成情况。

现在调用`CurrentTips`，开始你的验证工作！
