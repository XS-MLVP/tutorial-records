# e203_exu_alu 基础信息

## 1. 模块定位

`e203_exu_alu` 是 E203 处理器执行单元中的核心执行模块，顶层统一接收已译码指令及上下文，按指令类型分发到不同子功能路径，并对外提供写回、提交、CSR、LSU/AGU 以及可选 NICE/MUL/DIV 相关接口。

从 `README.md` 和 Python DUT 封装可知，该模块并不是单一“算术器件”，而是一个带多路握手、异常上报和结果仲裁的执行顶层。

## 2. Python 接口封装理解

`e203_exu_alu/__init__.py` 中定义了 `DUTe203_exu_alu` 类，其特点如下：

- 使用 `DutUnifiedBase` 创建底层仿真实例
- 为所有顶层端口创建 `XPin`
- 将端口自动绑定到 native signal address
- 通过 `XPort.NewSubPort()` 构造了若干按前缀分组的子端口视图，例如 `i`、`cmt_o`、`agu_icb_cmd`、`agu_icb_rsp`、`wbck_o`、`nice_req`
- 暴露了 `InitClock()`、`Step()`、`StepRis()`、`StepFal()`、`SetWaveform()`、`SetCoverage()`、`Finish()` 等标准 DUT API

这说明后续验证应以 `DUTe203_exu_alu` 作为唯一底层对象，通过 Step 机制推进时钟，并尽量在上层 Env/API 中按前缀对子接口进行封装。

## 3. 电路类型判断

该模块属于**时序电路**，不是纯组合逻辑，依据如下：

- 顶层存在 `clk` 与低有效复位 `rst_n`
- Python DUT 封装提供 `InitClock("clk")` 和 `Step()` 接口，说明预期按时钟推进
- 规格文档明确包含长流水、提交、写回、flush、LSU 响应等待等跨周期行为

因此后续所有验证都必须以 Step 驱动，不能把它当作单拍组合单元处理。

## 4. 顶层输入输出端口分类与作用

## 4.1 指令输入与发射握手

- `i_valid` / `i_ready`：上游发射握手
- `i_itag`：指令标识，用于长流水和 LSU/NICE 跟踪
- `i_rs1` / `i_rs2` / `i_imm`：源操作数与立即数
- `i_info`：译码信息总线，决定功能分发
- `i_pc` / `i_instr` / `i_pc_vld`：提交所需上下文
- `i_rdidx` / `i_rdwen`：目的寄存器写回元信息

## 4.2 异常与控制输入

- `i_ilegl`：非法指令输入异常
- `i_buserr`：总线错误输入异常
- `i_misalgn`：错位异常输入
- `flush_req` / `flush_pulse`：流水冲刷相关控制
- `oitf_empty`：Outstanding 指令跟踪表是否为空
- `mdv_nob2b`：限制 MUL/DIV 背靠背发射
- `nonflush_cmt_ena`：非 flush 提交使能

## 4.3 提交通道输出

- `cmt_o_valid` / `cmt_o_ready`：提交握手
- `cmt_o_pc_vld` / `cmt_o_pc` / `cmt_o_instr` / `cmt_o_imm`：提交上下文
- `cmt_o_bjp` / `cmt_o_mret` / `cmt_o_dret` / `cmt_o_ecall` / `cmt_o_ebreak` / `cmt_o_fencei` / `cmt_o_wfi`：提交类型
- `cmt_o_bjp_prdt` / `cmt_o_bjp_rslv`：分支预测与解析结果
- `cmt_o_misalgn` / `cmt_o_ld` / `cmt_o_stamo` / `cmt_o_buserr` / `cmt_o_badaddr`：访存与异常相关提交信息
- `cmt_o_ifu_misalgn` / `cmt_o_ifu_buserr` / `cmt_o_ifu_ilegl`：取指异常信息

## 4.4 写回通道输出

- `wbck_o_valid` / `wbck_o_ready`：写回握手
- `wbck_o_wdat`：写回数据
- `wbck_o_rdidx`：写回目标寄存器

## 4.5 CSR 接口

- `csr_ena` / `csr_wr_en` / `csr_rd_en` / `csr_idx`：CSR 请求控制
- `csr_access_ilgl`：CSR 非法访问反馈
- `read_csr_dat`：CSR 读回数据
- `wbck_csr_dat`：CSR 路径生成的写回数据

## 4.6 AGU/LSU 接口

- `agu_icb_cmd_valid` / `agu_icb_cmd_ready`：访存命令握手
- `agu_icb_cmd_addr` / `read` / `wdata` / `wmask` / `lock` / `excl` / `size` / `back2agu` / `usign` / `itag`：访存命令属性
- `agu_icb_rsp_valid` / `agu_icb_rsp_ready` / `err` / `excl_ok` / `rdata`：访存返回信息
- `amo_wait`：AMO 等待状态指示
- `i_longpipe`：当前指令是否属于长流水

## 4.7 NICE 接口

- `nice_req_*`：向 NICE 扩展发送请求
- `nice_rsp_multicyc_*`：接收多周期完成信息
- `nice_longp_wbck_*`：长流水 NICE 写回握手
- `nice_o_itag`：NICE 指令标签输出
- `nice_xs_off` / `i_nice_cmt_off_ilgl`：NICE 关闭/非法控制

## 5. 主要功能类别

结合 README 中对子模块和顶层职责的描述，可将功能划分为以下几大类：

1. 常规 ALU 运算
2. 分支/跳转处理
3. CSR 访问控制
4. Load/Store/AMO 地址生成与访存协同
5. 写回与提交仲裁
6. 异常上报与 flush 协同
7. 可选 MUL/DIV 长流水处理
8. 可选 NICE 扩展处理

## 6. 功能点规模预估

从验证角度估算，后续需要拆出的**可测试功能点数量约在 35 到 55 个之间**，原因如下：

- 常规 ALU 指令种类多，至少会拆出十余个功能点
- BJP/CSR/AGU/异常路径各自都包含若干独立可测行为
- 握手、背压、flush、长流水、可选接口还需要额外功能点

如果进一步把边界条件和异常路径拆细，最终检测点数量会明显高于功能点数量，预计在 80 个以上更合理。

## 7. 后续验证的关键关注点

- `i_info` 译码驱动的功能分流是否正确
- 提交和写回结果是否与指令类别一致
- 分支比较中的有符号/无符号语义是否正确
- CSR 读写与非法访问反馈是否一致
- AGU 访存地址、掩码、返回握手和异常上报是否正确
- `flush_req` / `flush_pulse` 下是否存在错误提交或错误写回
- `i_longpipe`、`amo_wait` 与 LSU/NICE/MUL/DIV 路径协同是否正确

## 8. 当前阶段结论

`e203_exu_alu` 是一个面向处理器执行顶层的复杂时序模块，具备明显的“多功能子单元汇聚 + 共享数据通路 + 多下游握手 + 异常/提交协同”特征。后续验证不应只关注算术结果，而必须同时覆盖协议、状态推进、异常路径和多周期协同。
