# e203_exu_alu 功能点与检测点描述

## DUT 整体功能描述

`e203_exu_alu` 是 E203 处理器执行单元中的统一执行顶层，负责接收译码后的指令上下文，根据 `i_info` 指示在常规 ALU、分支跳转、CSR、AGU、可选 MUL/DIV 和 NICE 路径之间分流，并最终向外输出写回、提交、访存与扩展接口交互结果。

该模块属于带 `clk` 和低有效 `rst_n` 的复杂时序电路，除算术结果外，还需要验证 `valid/ready` 握手、长流水标记、异常上报、flush 协同以及多下游接口之间的仲裁行为。

### 端口接口说明

**输入端口：**

- 指令发射与上下文：`i_valid`、`i_itag`、`i_rs1`、`i_rs2`、`i_imm`、`i_info`、`i_pc`、`i_instr`、`i_pc_vld`
- 目的寄存器与异常输入：`i_rdidx`、`i_rdwen`、`i_ilegl`、`i_buserr`、`i_misalgn`
- 流水控制与协同：`flush_req`、`flush_pulse`、`oitf_empty`、`mdv_nob2b`、`nonflush_cmt_ena`
- 下游反馈输入：`cmt_o_ready`、`wbck_o_ready`、`csr_access_ilgl`、`read_csr_dat`、`agu_icb_rsp_*`
- 可选 NICE 相关输入：`nice_xs_off`、`nice_req_ready`、`nice_rsp_multicyc_valid`、`nice_longp_wbck_ready`、`i_nice_cmt_off_ilgl`

**输出端口：**

- 发射反馈：`i_ready`、`i_longpipe`、`amo_wait`
- 提交通道：`cmt_o_valid` 及其携带的 PC、指令、分支、异常、访存类提交信息
- 写回通道：`wbck_o_valid`、`wbck_o_wdat`、`wbck_o_rdidx`
- CSR 通道：`csr_ena`、`csr_wr_en`、`csr_rd_en`、`csr_idx`、`wbck_csr_dat`
- AGU/LSU 通道：`agu_icb_cmd_*`、`agu_icb_rsp_ready`
- 可选 NICE/CSR_NICE 通道：`nice_req_*`、`nice_rsp_multicyc_ready`、`nice_longp_wbck_valid`、`nice_o_itag`、`nice_csr_*`

## 功能分组与检测点

### 测试接口与驱动约定

<FG-API>

覆盖验证 `e203_exu_alu` 时必须使用的标准测试接口、时钟推进方式以及顶层端口交互约定，为后续 API、Env 和测试用例提供统一操作语义。

#### 复位与初始驱动

<FC-RESET>

定义验证环境对 `rst_n`、默认输入和时钟推进的基础驱动方式，确保 DUT 在统一初始状态下开始测试。

**检测点：**

- <CK-RESET-ASSERT> 复位拉低期间：验证通过 Step 驱动时 DUT 对外输出保持复位态，不产生错误的提交、写回或访存请求。
- <CK-RESET-RELEASE> 复位释放后首个有效周期：验证 DUT 能恢复正常握手能力，关键输出不残留复位前脏状态。
- <CK-RESET-DEFAULT-INPUT> 默认输入场景：验证未发射指令时输入默认值不会诱发伪 valid、伪异常或伪访存命令。

#### 指令发射与步进接口

<FC-ISSUE-STEP>

定义测试中如何通过顶层输入组织一次指令发射、背压等待和 Step 推进，以便统一驱动时序行为。

**检测点：**

- <CK-ISSUE-HANDSHAKE> 标准发射流程：验证 `i_valid` 与 `i_ready` 同时为 1 时一次指令事务被正确接收。
- <CK-STEP-BACKPRESSURE-WAIT> 下游背压流程：验证目标路径未 ready 时多次 Step 仅等待握手完成，不应提前改变结果可见性。
- <CK-SINGLE-TRANSACTION-CAPTURE> 单事务驱动：验证一次发射只对应一次预期结果采样，避免重复采样或漏采样。

#### 输出采样与结果观测

<FC-OBSERVE-OUTPUT>

定义测试中对提交、写回、CSR、AGU/NICE 输出的采样与封装方式，保证后续检查点可仅通过顶层端口观测。

**检测点：**

- <CK-WBCK-SNAPSHOT> 写回采样：验证 `wbck_o_*` 可被统一封装并准确反映当前周期写回有效性、数据和 rdidx。
- <CK-COMMIT-SNAPSHOT> 提交采样：验证 `cmt_o_*` 上下文、分支、异常和访存属性可在顶层端口上被完整观测。
- <CK-SIDEBAND-SNAPSHOT> 旁路接口采样：验证 CSR、AGU、NICE 等侧带接口输出可被独立采样而不依赖内部信号。

### 指令接收与功能分流

<FG-DISPATCH>

覆盖顶层根据 `i_valid`、`i_info`、上下文与就绪条件对 ALU、BJP、CSR、AGU、MUL/DIV、NICE 等路径进行发射、分流和接收反馈的行为。

#### 译码分流

<FC-DECODE-ROUTE>

根据 `i_info` 指定的功能组将指令分配到 ALU、BJP、CSR、AGU、MUL/DIV 或 NICE 路径，并屏蔽不相关路径输出。

**检测点：**

- <CK-ROUTE-ALU> ALU 类译码：验证当 `i_info` 指向规则 ALU 路径时，仅 ALU 相关输出活动，其他子路径保持静默。
- <CK-ROUTE-SUBMODULE> 子模块译码：验证 BJP、CSR、AGU、MUL/DIV、NICE 等不同功能组能被正确分流到对应路径。
- <CK-ROUTE-MUTEX> 互斥分流：验证单条指令不会同时触发多个互斥执行路径的对外有效输出。

#### 发射就绪与背压

<FC-READY-BACKPRESSURE>

根据当前目标子路径的 ready 状态向上游反馈 `i_ready`，在下游背压时阻止新的发射握手完成。

**检测点：**

- <CK-READY-PROPAGATE> 就绪反馈传播：验证顶层 `i_ready` 能正确反映当前选中子路径的 ready 状态。
- <CK-STALL-HOLD> 阻塞保持：验证下游不 ready 时输入事务不会被误接收，相关输出保持等待语义。
- <CK-VALID-READY-COMPLETE> 握手完成瞬间：验证 valid-ready 成功握手后事务推进与结果可见性时序一致。

#### 长流水分类标记

<FC-LONGPIPE-CLASSIFY>

针对 AGU、MUL/DIV、NICE 等多周期路径生成 `i_longpipe` 标记，并与单周期路径正确区分。

**检测点：**

- <CK-LONGPIPE-SHORTPATH> 单周期路径：验证规则 ALU、部分 BJP/CSR 等短路径指令不会错误拉高 `i_longpipe`。
- <CK-LONGPIPE-AGU> AGU 长流水路径：验证需要等待 LSU 返回的访存类指令正确拉高 `i_longpipe`。
- <CK-LONGPIPE-MDV-NICE> MUL/DIV 与 NICE 长流水路径：验证多周期扩展指令的长流水分类与实际完成行为一致。

### 常规 ALU 运算

<FG-ALU>

覆盖规则 ALU 数据通路承担的算术、逻辑、比较、移位以及立即数相关计算行为，关注共享运算结果与单周期写回语义。

#### 算术运算

<FC-ARITHMETIC>

执行常规整数加减与相关加法器共享结果路径，覆盖寄存器操作数和立即数操作数参与的算术计算。

**检测点：**

- <CK-ARITH-ADD> 加法场景：验证寄存器-寄存器或相关共享加法路径的结果与预期一致。
- <CK-ARITH-SUB> 减法场景：验证减法或等价加法器反码路径产生的结果正确。
- <CK-ARITH-IMM> 立即数算术：验证带 `i_imm` 的算术类操作在操作数选择和结果生成上正确。

#### 逻辑与移位运算

<FC-LOGIC-SHIFT>

执行按位逻辑运算与移位类运算，关注不同操作码下结果数据的正确性。

**检测点：**

- <CK-LOGIC-BITWISE> 按位逻辑：验证 AND/OR/XOR 等逻辑运算结果与输入位模式一致。
- <CK-SHIFT-LEFT-RIGHT> 左右移位：验证左移、逻辑右移和算术右移等移位结果正确。
- <CK-SHIFT-AMOUNT-BOUND> 移位边界：验证零移位、大移位量和边界位移不会产生越界错误结果。

#### 比较结果生成

<FC-COMPARE>

执行等于、不等、小于、大于及有符号/无符号比较，供分支和规则写回路径复用。

**检测点：**

- <CK-CMP-EQ-NE> 相等与不等比较：验证比较结果能正确区分相等与不等输入组合。
- <CK-CMP-SIGNED> 有符号比较：验证负数、正数及符号位差异场景下的大小比较结果正确。
- <CK-CMP-UNSIGNED> 无符号比较：验证高位为 1 的操作数在无符号语义下得到正确大小关系。

### 分支跳转与控制转移

<FG-BRANCH-JUMP>

覆盖 BJP 路径对条件分支、无条件跳转及相关提交信息的生成，重点关注比较结果、跳转返回值和提交属性的一致性。

#### 条件分支解析

<FC-COND-BRANCH>

根据比较结果解析 BEQ/BNE/BLT/BGE/BLTU/BGEU 等条件分支是否成立，并生成对应提交结果。

**检测点：**

- <CK-BRANCH-TAKEN> 分支成立：验证条件满足时 `cmt_o_bjp_rslv` 等相关提交结果反映为跳转成立。
- <CK-BRANCH-NOTTAKEN> 分支不成立：验证条件不满足时分支解析结果为不跳转，且不误写回异常结果。
- <CK-BRANCH-SIGNED-UNSIGNED> 分支比较语义：验证有符号和无符号分支在同一输入下能给出不同且正确的解析结论。

#### 跳转与链接返回值

<FC-JUMP-LINK>

处理 JAL/JALR 等无条件跳转，生成目标相关结果以及写回返回地址。

**检测点：**

- <CK-JAL-WBCK> JAL 返回地址写回：验证无条件跳转时写回数据为返回地址且 rdidx 保持正确。
- <CK-JALR-WBCK> JALR 返回地址写回：验证寄存器间接跳转同样能生成正确返回地址写回。
- <CK-JUMP-PC-CONTEXT> 跳转上下文：验证跳转类指令提交时 `cmt_o_pc`、`cmt_o_instr`、`cmt_o_imm` 与输入上下文一致。

#### 分支类提交属性

<FC-BJP-COMMIT>

为分支、跳转、`mret`、`dret`、`fencei` 等控制转移类指令生成对应提交属性与预测/解析标记。

**检测点：**

- <CK-BJP-COMMIT-FLAGS> 提交类型标记：验证分支/跳转/`mret`/`dret`/`fencei` 等指令的 `cmt_o_*` 类型标记互斥且正确。
- <CK-BJP-PRDT-RSLV> 预测与解析：验证 `cmt_o_bjp_prdt` 与 `cmt_o_bjp_rslv` 在不同分支场景下能被正确区分和输出。
- <CK-SYSRET-FENCEI> 系统返回与 fencei：验证 `mret`、`dret`、`fencei` 指令的专用提交标记不会遗漏或串扰。

### CSR 访问控制

<FG-CSR>

覆盖 CSR 指令触发的读写使能、索引生成、写回数据形成及非法访问反馈处理，包含与 NICE CSR 扩展相关的协同行为。

#### CSR 读取路径

<FC-CSR-READ>

对 CSR 读类指令生成索引和读使能，并形成写回所需的 CSR 读出数据路径。

**检测点：**

- <CK-CSR-RD-ENABLE> CSR 读使能：验证 CSR 读类指令会拉高 `csr_ena` 与 `csr_rd_en`，并给出正确 `csr_idx`。
- <CK-CSR-RD-DATA> CSR 读数据写回：验证 `read_csr_dat` 能通过 CSR 路径形成正确的 `wbck_csr_dat` 或写回结果。
- <CK-CSR-RD-NORD> 无目的寄存器读场景：验证不需要寄存器写回的 CSR 访问不会错误产生普通写回有效。

#### CSR 写入路径

<FC-CSR-WRITE>

对 CSR 写或读改写类指令生成写使能、写入数据和必要的读改写控制。

**检测点：**

- <CK-CSR-WR-ENABLE> CSR 写使能：验证写类 CSR 指令会拉高 `csr_wr_en` 并保持正确索引。
- <CK-CSR-WDATA-FORM> CSR 写数据形成：验证由 `i_rs1` 或立即数字段形成的写入值与 `wbck_csr_dat` 一致。
- <CK-CSR-RMW> 读改写场景：验证同时需要读旧值和写新值的 CSR 指令对读写使能组合处理正确。

#### CSR 非法访问反馈

<FC-CSR-ILLEGAL>

在非法 CSR 访问或权限不允许时，产生错误反馈并抑制错误的正常结果传播。

**检测点：**

- <CK-CSR-ILLEGAL-ERR> 非法 CSR 访问：验证 `csr_access_ilgl` 触发时错误结果被正确上报。
- <CK-CSR-ILLEGAL-SUPPRESS> 非法访问抑制：验证非法 CSR 访问不会继续产生看似正常的写回或提交成功语义。
- <CK-CSR-ILLEGAL-COMMIT> 非法访问提交属性：验证非法 CSR 场景下提交输出中的异常属性与上下文保持一致。

#### NICE CSR 协同

<FC-CSR-NICE>

在启用 NICE CSR 扩展时，对 NICE CSR 请求/响应接口进行选择和协同。

**检测点：**

- <CK-NICE-CSR-REQ> NICE CSR 请求：验证启用 NICE CSR 扩展时请求 valid、地址和写控制信号生成正确。
- <CK-NICE-CSR-RSP> NICE CSR 响应：验证 NICE CSR 读返回值能被正确接收并形成后续结果。
- <CK-NICE-CSR-BYPASS> 普通 CSR 与 NICE CSR 选择：验证非 NICE CSR 场景不会误驱动 `nice_csr_*` 接口。

### 访存地址生成与 LSU 协同

<FG-AGU-LSU>

覆盖 AGU 对 load/store/AMO 指令的地址生成、命令属性拼装、ICB 握手、返回处理、原子等待和异常信息上报行为。

#### Load 地址与返回处理

<FC-LOAD>

为 Load 指令生成访存地址、读命令属性，并在返回后形成写回与提交相关结果。

**检测点：**

- <CK-LOAD-CMD> Load 命令生成：验证读类访存会产生正确地址、read 标记和 size/usign 属性。
- <CK-LOAD-RSP-WBCK> Load 返回写回：验证 LSU 返回数据后 `wbck_o_valid`、`wbck_o_wdat` 和 rdidx 正确。
- <CK-LOAD-USIGN-SIZE> Load 扩展语义：验证不同宽度和有符号/无符号 load 的命令属性与结果扩展规则一致。

#### Store 命令生成

<FC-STORE>

为 Store 指令生成访存地址、写数据、写掩码和提交属性，并处理无寄存器写回场景。

**检测点：**

- <CK-STORE-CMD> Store 命令生成：验证写类访存会产生正确地址、写数据和 `agu_icb_cmd_read=0`。
- <CK-STORE-WMASK> 字节写掩码：验证 byte/half/word store 的 `agu_icb_cmd_wmask` 与地址低位组合正确。
- <CK-STORE-NO-WBCK> 无寄存器写回：验证纯 store 指令不会错误产生普通寄存器写回数据。

#### 原子访存操作

<FC-AMO>

为 AMO 指令生成独占/原子访问属性、共享 ALU 计算结果和等待状态控制。

**检测点：**

- <CK-AMO-EXCL-CMD> AMO 命令属性：验证原子访存会拉高独占/原子相关控制并携带正确命令属性。
- <CK-AMO-ALU-RESULT> AMO 共享 ALU 结果：验证 AMO 运算类指令返回值和写回数据符合相应原子运算语义。
- <CK-AMO-WAIT-CLEAR> AMO 等待状态：验证 `amo_wait` 在等待 LSU/原子完成期间拉高，并在事务完成后清除。

#### ICB 命令响应握手

<FC-ICB-HANDSHAKE>

处理 AGU 与 LSU ICB 命令/响应通道的 valid-ready 交互、itag 透传和 back2agu 控制。

**检测点：**

- <CK-ICB-CMD-HOLD> 命令背压保持：验证 `agu_icb_cmd_valid=1` 且 `ready=0` 时命令属性稳定保持到握手完成。
- <CK-ICB-RSP-READY> 响应接收握手：验证 DUT 在需要接收 LSU 返回时正确驱动 `agu_icb_rsp_ready`。
- <CK-ITAG-BACK2AGU> itag 与 back2agu：验证需要返回 AGU 的事务保持正确 `itag` 与 `back2agu` 标记。

#### 访存异常与坏地址上报

<FC-AGU-EXCEPTION>

对错位访问、总线错误和独占访问失败等场景形成异常提交信息和 badaddr。

**检测点：**

- <CK-AGU-MISALIGN> 错位异常：验证不对齐访存会在提交口正确拉高 `cmt_o_misalgn` 并给出 `cmt_o_badaddr`。
- <CK-AGU-BUSERR> 总线错误：验证 LSU 返回错误时 `cmt_o_buserr` 与相关提交属性正确。
- <CK-AGU-BADADDR> 坏地址上报：验证异常场景下 `cmt_o_badaddr` 精确反映触发异常的访存地址。

### 写回与提交仲裁

<FG-WBCK-COMMIT>

覆盖顶层对各子路径结果的写回与提交输出，包括 valid/ready 握手、目标寄存器信息、上下文透传以及不同指令类别的提交属性。

#### 写回数据输出

<FC-WBCK-DATA>

将不同子路径生成的结果以统一 `wbck_o_*` 接口输出，并保持目标寄存器索引和数据对应关系。

**检测点：**

- <CK-WBCK-VALID-DATA> 写回有效与数据一致性：验证 `wbck_o_valid` 为 1 时 `wbck_o_wdat` 与当前事务预期结果一致。
- <CK-WBCK-RDIDX> 写回目标寄存器：验证 `wbck_o_rdidx` 与输入 `i_rdidx` 或指令语义一致，不发生串扰。
- <CK-WBCK-BACKPRESSURE-HOLD> 写回背压保持：验证 `wbck_o_valid=1` 且 `wbck_o_ready=0` 时写回数据和 rdidx 稳定保持。

#### 提交信息输出

<FC-COMMIT-INFO>

通过 `cmt_o_*` 输出提交上下文、异常类别、访存属性和控制转移属性。

**检测点：**

- <CK-COMMIT-CONTEXT> 提交上下文透传：验证 `cmt_o_pc`、`cmt_o_instr`、`cmt_o_imm`、`cmt_o_pc_vld` 与输入事务一致。
- <CK-COMMIT-MEM-ATTR> 访存提交属性：验证 load/store/AMO 指令能正确区分 `cmt_o_ld` 与 `cmt_o_stamo`。
- <CK-COMMIT-EXCP-ATTR> 异常提交属性：验证提交口上的异常类型位与实际触发场景一致。

#### 多路径结果仲裁

<FC-RESULT-ARBITRATION>

当不同子路径共享顶层写回或提交出口时，保证 valid、ready、数据和错误属性的仲裁顺序正确。

**检测点：**

- <CK-ARBIT-UNIQUE-SOURCE> 唯一结果源：验证同一周期顶层写回/提交结果只来自一个有效子路径，不出现多源混叠。
- <CK-ARBIT-READY-GATING> 仲裁 ready 门控：验证上游/下游 ready 变化时，不同子路径的结果仲裁不会破坏握手协议。
- <CK-ARBIT-DATA-CONSISTENCY> 仲裁数据一致性：验证被选中的 valid 源与对应数据、异常和属性位严格匹配。

### 异常上报与流水冲刷

<FG-EXCEPTION-FLUSH>

覆盖非法指令、取指异常、访存错位、总线错误等异常路径，以及 `flush_req`、`flush_pulse`、`nonflush_cmt_ena` 对在途事务和输出结果的影响。

#### 取指异常透传

<FC-IFU-EXCEPTION>

对输入侧给出的 `i_ilegl`、`i_buserr` 等取指异常上下文形成对应的提交异常输出。

**检测点：**

- <CK-IFU-ILEGL> 取指非法指令：验证输入 `i_ilegl` 触发时 `cmt_o_ifu_ilegl` 正确上报。
- <CK-IFU-BUSERR> 取指总线错误：验证输入 `i_buserr` 触发时 `cmt_o_ifu_buserr` 正确上报。
- <CK-IFU-MISALIGN> 取指错位：验证与控制转移相关的取指错位场景会正确体现为 `cmt_o_ifu_misalgn`。

#### 执行期异常上报

<FC-EXEC-EXCEPTION>

对访存错位、总线错误、CSR 非法访问和 NICE 非法提交等执行期异常进行统一上报。

**检测点：**

- <CK-EXEC-MISALIGN> 执行期错位：验证数据访存错位等执行期异常通过执行异常路径上报。
- <CK-EXEC-BUSERR> 执行期总线错误：验证数据访存返回错误时执行异常路径能正确反映。
- <CK-EXEC-CSR-NICE> CSR/NICE 非法执行：验证 CSR 非法访问和 NICE 非法提交能通过执行异常类结果体现。

#### Flush 冲刷处理

<FC-FLUSH-KILL>

在 `flush_req` 或 `flush_pulse` 作用下阻止无效的提交、写回或在途长流水结果继续向外可见。

**检测点：**

- <CK-FLUSH-ISSUE-KILL> 发射中 flush：验证握手尚未完成或刚进入执行的事务在 flush 下不会错误向外提交。
- <CK-FLUSH-LONGPIPE-KILL> 长流水 flush：验证等待 LSU/NICE/MUL/DIV 返回的在途事务在 flush 后不会错误写回或提交。
- <CK-FLUSH-PULSE-TRANSIENT> flush_pulse 瞬态影响：验证单拍 flush 脉冲不会留下持续性的错误 valid 或状态残留。

#### 非 Flush 提交控制

<FC-NONFLUSH-COMMIT>

处理 `nonflush_cmt_ena` 对提交时机和异常路径可见性的约束。

**检测点：**

- <CK-NONFLUSH-CMT-ALLOW> 允许提交：验证 `nonflush_cmt_ena` 允许时合法事务能正常对外提交。
- <CK-NONFLUSH-CMT-BLOCK> 禁止提交：验证 `nonflush_cmt_ena` 禁止时提交口不会错误放行事务。
- <CK-NONFLUSH-EXCP-INTERLOCK> 异常与非 flush 提交联动：验证异常场景下 `nonflush_cmt_ena` 的约束不会导致错误的提交属性泄露。

### 长流水 MUL/DIV 协同

<FG-MULDIV>

覆盖共享 MUL/DIV 路径的发射限制、长流水标记、与 `mdv_nob2b` 及写回提交通道之间的协同行为。

#### MUL/DIV 发射路径

<FC-MULDIV-ISSUE>

对共享 MUL/DIV 指令进行发射与接收 ready 反馈，区分其与单周期路径的入口行为。

**检测点：**

- <CK-MDV-ISSUE-READY> MUL/DIV 发射 ready：验证共享 MUL/DIV 路径的 ready 反馈能够正确控制上游握手。
- <CK-MDV-DECODE-ROUTE> MUL/DIV 指令分流：验证对应译码输入时事务被正确导向 MUL/DIV 路径。
- <CK-MDV-NONMDV-MUTE> 非 MUL/DIV 静默：验证非 MUL/DIV 指令不会错误激活 MUL/DIV 路径的外部可见行为。

#### 背靠背发射限制

<FC-MULDIV-B2B-LIMIT>

在 `mdv_nob2b` 约束下限制连续 MUL/DIV 指令的接收行为，避免违反设计约束。

**检测点：**

- <CK-MDV-NOB2B-BLOCK> 背靠背禁止：验证 `mdv_nob2b=1` 且前一条 MUL/DIV 未完全消化时，后一条 MUL/DIV 不会被立即接收。
- <CK-MDV-NOB2B-ALLOW> 背靠背允许：验证约束关闭或条件满足时连续 MUL/DIV 可正常接收。
- <CK-MDV-BUSY-HOLD> 忙状态保持：验证受限期间不会出现 `i_ready` 或长流水标记的瞬态错误抖动。

#### MUL/DIV 长流水结果

<FC-MULDIV-LONGPIPE>

对 MUL/DIV 多周期执行产生的长流水标记、完成写回和提交协同行为进行定义。

**检测点：**

- <CK-MDV-LONGPIPE-FLAG> 长流水标记：验证 MUL/DIV 指令发射后 `i_longpipe` 与其多周期属性一致。
- <CK-MDV-WBCK-COMPLETE> 完成写回：验证 MUL/DIV 结果完成时写回通道给出正确 valid、数据和 rdidx。
- <CK-MDV-CMT-COHERENCE> 提交协同：验证 MUL/DIV 完成后的提交信息与写回结果在时序和属性上保持一致。

### NICE 扩展协同

<FG-NICE>

覆盖可选 NICE 指令请求、响应、多周期完成、长流水写回以及扩展关闭或非法提交条件下的顶层对外行为。

#### NICE 请求发送

<FC-NICE-REQUEST>

对 NICE 指令生成请求握手、指令字和源操作数输出，并在 ready 背压下保持请求语义正确。

**检测点：**

- <CK-NICE-REQ-VALID> NICE 请求有效：验证 NICE 指令会拉高 `nice_req_valid` 并在握手成功前保持请求。
- <CK-NICE-REQ-PAYLOAD> NICE 请求载荷：验证 `nice_req_instr`、`nice_req_rs1`、`nice_req_rs2` 与输入事务一致。
- <CK-NICE-REQ-BACKPRESSURE> NICE 请求背压：验证 `nice_req_ready=0` 时请求载荷保持稳定且不重复接收新事务。

#### NICE 多周期完成

<FC-NICE-MULTICYCLE>

处理 NICE 多周期完成通知、长流水写回握手及 itag 相关输出。

**检测点：**

- <CK-NICE-MCYC-READY> 多周期完成握手：验证 `nice_rsp_multicyc_valid` 与 `nice_rsp_multicyc_ready` 的交互符合预期。
- <CK-NICE-ITAG-WBCK> itag 与长流水写回：验证 `nice_o_itag`、`nice_longp_wbck_valid` 和完成事务标签保持一致。
- <CK-NICE-LONGPIPE-FLAG> NICE 长流水分类：验证 NICE 多周期事务发射后 `i_longpipe` 与其执行阶段一致。

#### NICE 关闭与非法提交

<FC-NICE-OFF-ILLEGAL>

在 NICE 扩展关闭或 `i_nice_cmt_off_ilgl` 触发时，处理非法路径反馈并避免错误的正常提交。

**检测点：**

- <CK-NICE-OFF-BLOCK> 扩展关闭：验证 `nice_xs_off=1` 时 NICE 指令不会被当作正常扩展请求发出。
- <CK-NICE-ILLEGAL-ERR> 非法提交反馈：验证 `i_nice_cmt_off_ilgl` 触发时错误语义能通过异常/错误路径被观测到。
- <CK-NICE-NORMAL-BYPASS> 正常旁路：验证非 NICE 指令或 NICE 合法场景不会错误触发非法关闭路径。
