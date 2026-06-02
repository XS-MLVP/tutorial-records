
# e203_exu_alu 缺陷分析

## 未测试通过检测点分析


<FG-AGU-LSU>

#### <FC-AGU-EXCEPTION>
- <CK-AGU-MISALIGN> AGU 类错位异常输入 i_misalgn 被当作 IFU 异常处理，导致 cmt_o_misalgn 不拉高。
  - <BG-AGU-MISALIGN-ROUTE-98> Bug 置信度 98%
    - <TC-unity_test/tests/test_e203_exu_alu_agu_lsu.py::test_agu_misalign> AGU 类错位异常输入 i_misalgn 被当作 IFU 异常处理，导致 cmt_o_misalgn 不拉高。
- <CK-AGU-BADADDR> AGU 类错位异常输入 i_misalgn 被当作 IFU 异常处理，导致 cmt_o_badaddr 丢失。
  - <BG-AGU-MISALIGN-ROUTE-98> Bug 置信度 98%
    - <TC-unity_test/tests/test_e203_exu_alu_agu_lsu.py::test_agu_badaddr> AGU 类错位异常输入 i_misalgn 被当作 IFU 异常处理，导致 cmt_o_badaddr 丢失。

- <CK-AGU-BUSERR> 对齐 load 的 LSU err 响应没有传播到 cmt_o_buserr，buserr 被静默丢弃。
  - <BG-AGU-LOAD-RSP-DROP-97> Bug 置信度 97%
    - <TC-unity_test/tests/test_e203_exu_alu_agu_lsu.py::test_agu_buserr> 对齐 load 的 LSU err 响应没有传播到 cmt_o_buserr，buserr 被静默丢弃。
#### <FC-LOAD>
- <CK-LOAD-RSP-WBCK> 对齐 load 在发射拍就完成提交/写回仲裁，LSU 返回数据没有被写回到 wbck_o_wdat。
  - <BG-AGU-LOAD-RSP-DROP-97> Bug 置信度 97%
    - <TC-unity_test/tests/test_e203_exu_alu_agu_lsu.py::test_load_rsp_wbck> 对齐 load 在发射拍就完成提交/写回仲裁，LSU 返回数据没有被写回到 wbck_o_wdat。

<FG-ALU>

#### <FC-COMPARE>
- <CK-CMP-EQ-NE> CK-CMP-EQ-NE 将“相等返回 1、不等返回 0”的寄存器写回语义分配给常规 ALU，但该 DUT 常规 ALU 只暴露 SLT/SLTU 类比较写回，EQ/NE 比较属于 BJP 分支解析路径，因此该检查点设计不合理。
  - <BG-ALU-CMP-EQNE-0> Bug 置信度 0%
    - <TC-unity_test/tests/test_e203_exu_alu_alu.py::test_cmp_eq_ne> CK-CMP-EQ-NE 将“相等返回 1、不等返回 0”的寄存器写回语义分配给常规 ALU，但该 DUT 常规 ALU 只暴露 SLT/SLTU 类比较写回，EQ/NE 比较属于 BJP 分支解析路径，因此该检查点设计不合理。

<FG-EXCEPTION-FLUSH>

#### <FC-EXEC-EXCEPTION>
- <CK-EXEC-MISALIGN> 执行期访存错位异常被错误路由到 IFU 异常字段，导致 cmt_o_misalgn 不拉高。
  - <BG-EXEC-MISALIGN-ROUTE-98> Bug 置信度 98%
    - <TC-unity_test/tests/test_e203_exu_alu_exception_flush.py::test_exec_misalign> 执行期访存错位异常被错误路由到 IFU 异常字段，导致 cmt_o_misalgn 不拉高。
- <CK-EXEC-BUSERR> 执行期访存 buserr 被错误路由到 IFU 异常字段，导致 cmt_o_buserr 不拉高。
  - <BG-EXEC-BUSERR-ROUTE-97> Bug 置信度 97%
    - <TC-unity_test/tests/test_e203_exu_alu_exception_flush.py::test_exec_buserr> 执行期访存 buserr 被错误路由到 IFU 异常字段，导致 cmt_o_buserr 不拉高。

<FG-MULDIV>

#### <FC-MULDIV-B2B-LIMIT>
- <CK-MDV-BUSY-HOLD> MULDIV 在 mdv_nob2b busy 限制场景下没有维持 i_longpipe，导致 busy hold 状态不可见。
  - <BG-MDV-BUSY-NOLONGPIPE-88> Bug 置信度 88%
    - <TC-unity_test/tests/test_e203_exu_alu_muldiv.py::test_mdv_busy_hold> MULDIV 在 mdv_nob2b busy 限制场景下没有维持 i_longpipe，导致 busy hold 状态不可见。

#### <FC-MULDIV-ISSUE>
- <CK-MDV-DECODE-ROUTE> MULDIV 指令未被分类为长流水，mdv 路由场景下 i_longpipe 保持为 0。
  - <BG-MDV-LONGPIPE-MISS-90> Bug 置信度 90%
    - <TC-unity_test/tests/test_e203_exu_alu_muldiv.py::test_mdv_decode_route> MULDIV 指令未被分类为长流水，mdv 路由场景下 i_longpipe 保持为 0。

#### <FC-MULDIV-LONGPIPE>
- <CK-MDV-LONGPIPE-FLAG> MULDIV 指令未被分类为长流水，mdv 路由场景下 i_longpipe 保持为 0。
  - <BG-MDV-LONGPIPE-MISS-90> Bug 置信度 90%
    - <TC-unity_test/tests/test_e203_exu_alu_muldiv.py::test_mdv_longpipe_flag> MULDIV 指令未被分类为长流水，mdv 路由场景下 i_longpipe 保持为 0。
- <CK-MDV-WBCK-COMPLETE> MULDIV 指令未被分类为长流水，mdv 路由场景下 i_longpipe 保持为 0。
  - <BG-MDV-LONGPIPE-MISS-90> Bug 置信度 90%
    - <TC-unity_test/tests/test_e203_exu_alu_muldiv.py::test_mdv_wbck_complete> MULDIV 指令未被分类为长流水，mdv 路由场景下 i_longpipe 保持为 0。
- <CK-MDV-CMT-COHERENCE> MULDIV 指令未被分类为长流水，mdv 路由场景下 i_longpipe 保持为 0。
  - <BG-MDV-LONGPIPE-MISS-90> Bug 置信度 90%
    - <TC-unity_test/tests/test_e203_exu_alu_muldiv.py::test_mdv_cmt_coherence> MULDIV 指令未被分类为长流水，mdv 路由场景下 i_longpipe 保持为 0。

<FG-NICE>

#### <FC-NICE-MULTICYCLE>
- <CK-NICE-ITAG-WBCK> NICE 多周期返回场景下未拉高 nice_longp_wbck_valid，导致 itag 写回握手缺失。
  - <BG-NICE-ITAG-WBCK-MISS-76> Bug 置信度 76%
    - <TC-unity_test/tests/test_e203_exu_alu_nice.py::test_nice_itag_wbck> NICE 多周期返回场景下未拉高 nice_longp_wbck_valid，导致 itag 写回握手缺失。

<FG-CSR>

#### <FC-CSR-ILLEGAL>
- <CK-CSR-ILLEGAL-COMMIT> 非法 CSR 访问被错误映射为 IFU 非法指令提交属性，导致 cmt_o_ifu_ilegl 错误拉高。
  - <BG-CSR-ILEGL-IFU-MAP-96> Bug 置信度 96%
    - <TC-unity_test/tests/test_e203_exu_alu_csr.py::test_csr_illegal_commit> 非法 CSR 访问被错误映射为 IFU 非法指令提交属性，导致 cmt_o_ifu_ilegl 错误拉高。
## 缺陷根因分析

### FG-AGU-LSU / FC-AGU-EXCEPTION / CK-AGU-MISALIGN
**Bug标签**: BG-AGU-MISALIGN-ROUTE-98
**测试用例**: test_e203_exu_alu_agu_lsu.py::test_agu_misalign
**问题描述**:AGU 类错位异常输入 i_misalgn 被当作 IFU 异常处理，导致 cmt_o_misalgn 不拉高。
**根因分析**: 
顶层将 i_misalgn 直接并入 ifu_excp_op（e203_exu_alu.v:1274-1276），使 AGU 事务在译码阶段被 ifu_excp 分流掉，agu_op/o_sel_agu 被压低，随后 cmt_o_misalgn 与 cmt_o_badaddr 又都依赖 o_sel_agu，因此对于 AGU 访存类指令输入侧上报的 misalign 异常，提交口只会走 IFU 异常字段，不会在 AGU 异常字段中体现。动态上 test_agu_misalign 中 cmt_o_valid=1 但 cmt_o_misalgn=0，符合该源码缺陷。
```verilog
// e203_exu_alu_RTL/e203_exu_alu.v:1274-1276
1274:    wire ifu_excp_op = i_ilegl | i_buserr | i_misalgn;
1275:    wire alu_op = (~ifu_excp_op) & (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_ALU);
1276:    wire agu_op = (~ifu_excp_op) & (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_AGU);
```
**修复建议**
1274:  wire ifu_excp_op = i_ilegl | i_buserr;
1275:  wire agu_excp_misalgn = (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_AGU) & i_misalgn;
1276:  wire alu_op = (~ifu_excp_op) & (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_ALU);
1277:  wire agu_op = (~ifu_excp_op) & (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_AGU);

**相关源码位置**: 顶层将 i_misalgn 直接并入 ifu_excp_op（e203_exu_alu.v:1274-1276），使 AGU 事务在译码阶段被 ifu_excp 分流掉，agu_op/o_sel_agu 被压低，随后 cmt_o_misalgn 与 cmt_o_badaddr 又都依赖 o_sel_agu，因此对于 AGU 访存类指令输入侧上报的 misalign 异常，提交口只会走 IFU 异常字段，不会在 AGU 异常字段中体现。动态上 test_agu_misalign 中 cmt_o_valid=1 但 cmt_o_misalgn=0，符合该源码缺陷。

### FG-AGU-LSU / FC-AGU-EXCEPTION / CK-AGU-BADADDR
**Bug标签**: BG-AGU-MISALIGN-ROUTE-98
**测试用例**: test_e203_exu_alu_agu_lsu.py::test_agu_badaddr
**问题描述**:AGU 类错位异常输入 i_misalgn 被当作 IFU 异常处理，导致 cmt_o_badaddr 丢失。
**根因分析**: 
同一根因：i_misalgn 被并入 ifu_excp_op 之后，AGU 路径的 o_sel_agu 为 0，cmt_o_badaddr 的 AGU 选择被屏蔽，因此 test_agu_badaddr 中虽然提交有效，但 badaddr 被错误清零而不是返回 rs1+imm 计算出的访存地址。
```verilog
// e203_exu_alu_RTL/e203_exu_alu.v:1274-1276
1274:    wire ifu_excp_op = i_ilegl | i_buserr | i_misalgn;
1275:    wire alu_op = (~ifu_excp_op) & (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_ALU);
1276:    wire agu_op = (~ifu_excp_op) & (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_AGU);
```
**修复建议**
1274:  wire ifu_excp_op = i_ilegl | i_buserr;
1275:  wire agu_excp_misalgn = (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_AGU) & i_misalgn;
1276:  wire alu_op = (~ifu_excp_op) & (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_ALU);
1277:  wire agu_op = (~ifu_excp_op) & (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_AGU);

**相关源码位置**: 同一根因：i_misalgn 被并入 ifu_excp_op 之后，AGU 路径的 o_sel_agu 为 0，cmt_o_badaddr 的 AGU 选择被屏蔽，因此 test_agu_badaddr 中虽然提交有效，但 badaddr 被错误清零而不是返回 rs1+imm 计算出的访存地址。

### FG-AGU-LSU / FC-LOAD / CK-LOAD-RSP-WBCK
**Bug标签**: BG-AGU-LOAD-RSP-DROP-97
**测试用例**: test_e203_exu_alu_agu_lsu.py::test_load_rsp_wbck
**问题描述**:对齐 load 在发射拍就完成提交/写回仲裁，LSU 返回数据没有被写回到 wbck_o_wdat。
**根因分析**: 
e203_exu_alu_lsuagu.v 中 agu_o_valid 对对齐 load/store 直接使用 agu_i_valid 当拍有效，而不是等待 agu_icb_rsp_hsked；同时 agu_o_wbck_wdat 对非 AMO 路径被常量 0 覆盖，导致 load 返回数据即使经 agu_icb_rsp_valid/rdata 回来，也不会驱动 wbck_o_valid/wbck_o_wdat。动态上 test_load_rsp_wbck 中 load 响应到达后始终看不到有效写回，符合源码行为。
```verilog
// e203_exu_alu_RTL/e203_exu_alu_lsuagu.v:1657-1691
1657:    assign agu_o_valid =
1658:          `ifdef E203_SUPPORT_AMO//{
1659:        // For the unaligned load/store and aligned AMO, it will enter
1660:        //   into the state machine and let the last state to send back
1661:        //   to the commit stage
1662:        icb_sta_is_last
1663:          `endif//E203_SUPPORT_AMO}
1664:        // For the aligned load/store and unaligned AMO, it will be send
1665:        //   to the commit stage right the same cycle of agu_i_valid
1666:        |(
1667:           agu_i_valid & ( agu_i_algnldst
1668:          `ifndef E203_SUPPORT_UNALGNLDST//{
1669:             // If not support the unaligned load/store by hardware, then
1670:                 // the unaligned load/store will be treated as exception
1671:                 // and it will also be send to the commit stage right the
1672:                 // same cycle of agu_i_valid
1673:             | agu_i_unalgnldst
1674:          `endif//}
1675:          `ifdef E203_SUPPORT_AMO//{
1676:             | agu_i_unalgnamo
1677:          `endif//E203_SUPPORT_AMO}
1678:           )
1679:            ////  // Since it is issuing to commit stage and
1680:            ////  // LSU at same cycle, so we must qualify the icb_cmd_ready signal from LSU
1681:            ////  // to make sure it is out to commit/LSU at same cycle
1682:                 // To cut the critical timing  path from longpipe signal
1683:                 // we always assume the AGU will need icb_cmd_ready
1684:            & agu_icb_cmd_ready
1685:        );
1686:  
1687:    assign agu_o_wbck_wdat = {`E203_XLEN{1'b0 }}
1688:         `ifdef E203_SUPPORT_AMO//{
1689:                      | ({`E203_XLEN{agu_i_algnamo  }} & leftover_r)
1690:                      | ({`E203_XLEN{agu_i_unalgnamo}} & `E203_XLEN'b0)
1691:         `endif//E203_SUPPORT_AMO}
```
**修复建议**
1657:  assign agu_o_valid = icb_sta_is_last | (agu_i_load & agu_icb_rsp_hsked) | (agu_i_store & agu_i_valid & agu_i_algnldst);
1687:  assign agu_o_wbck_wdat = ({`E203_XLEN{agu_i_load & agu_icb_rsp_hsked}} & agu_icb_rsp_rdata);

### FG-AGU-LSU / FC-AGU-EXCEPTION / CK-AGU-BUSERR
**Bug标签**: BG-AGU-LOAD-RSP-DROP-97
**测试用例**: test_e203_exu_alu_agu_lsu.py::test_agu_buserr
**问题描述**:对齐 load 的 LSU err 响应没有传播到 cmt_o_buserr，buserr 被静默丢弃。
**根因分析**: 
同一条对齐 load 响应丢失根因：agu_o_valid 在请求拍就完成，不等待 LSU 响应；而 agu_o_cmt_buserr 仅在 AMO 路径拼接 leftover_err_r，对普通 load/store 没有使用 agu_icb_rsp_err。于是 test_agu_buserr 中 agu_icb_rsp_err=1 后，提交口仍然 buserr=0。
```verilog
// e203_exu_alu_RTL/e203_exu_alu_lsuagu.v:1694-1699
1694:    assign agu_o_cmt_buserr = (1'b0
1695:                  `ifdef E203_SUPPORT_AMO//{
1696:                        | (agu_i_algnamo    & leftover_err_r)
1697:                        | (agu_i_unalgnamo  & 1'b0)
1698:                  `endif//E203_SUPPORT_AMO}
1699:                        )
```
**修复建议**
1694:  assign agu_o_cmt_buserr = ({1{agu_i_load & agu_icb_rsp_hsked}} & agu_icb_rsp_err) | (agu_i_algnamo & leftover_err_r);

### FG-ALU / FC-COMPARE / CK-CMP-EQ-NE
**Bug标签**: BG-ALU-CMP-EQNE-0
**测试用例**: test_e203_exu_alu_alu.py::test_cmp_eq_ne
**问题描述**:CK-CMP-EQ-NE 将“相等返回 1、不等返回 0”的寄存器写回语义分配给常规 ALU，但该 DUT 常规 ALU 只暴露 SLT/SLTU 类比较写回，EQ/NE 比较属于 BJP 分支解析路径，因此该检查点设计不合理。
**根因分析**: 
从顶层和 ALU datapath 的解码定义可见，常规 ALU 只定义了 ADD/SUB/XOR/SLL/SRL/SRA/OR/AND/SLT/SLTU/LUI/OP2IMM/OP1PC 等位（见 e203_exu_alu.v 与 e203_exu_alu_dpath.v 的 ALU decinfo 宏），没有独立的 EQ/NE 写回运算；EQ/NE 比较请求仅出现在 BJP datapath 请求中，不属于常规 ALU 写回功能。因此 tests 中用常规 ALU 写回去要求“相等得1、不等得0”没有可实现的 ISA/RTL 对应语义，Fail 属于测试点定义问题而不是设计 bug。
```
// unity_test/e203_exu_alu_functions_and_checks.md:152-152
152:  - CK-CMP-EQ-NE 相等与不等比较：验证比较结果能正确区分相等与不等输入组合。
```
**修复建议**
152: - CK-CMP-EQ-NE 相等与不等比较：迁移到 FG-BRANCH-JUMP/FC-COND-BRANCH，验证 bjp_req_alu_cmp_eq/cmp_ne 与 cmt_o_bjp_rslv 语义；若保留在 FG-ALU，则改为“SLT/SLTU 输出仅在大小关系成立时写回 1，否则写回 0”，避免要求不存在的 EQ/NE 写回指令。
### FG-EXCEPTION-FLUSH / FC-EXEC-EXCEPTION / CK-EXEC-MISALIGN
**Bug标签**: BG-EXEC-MISALIGN-ROUTE-98
**测试用例**: test_e203_exu_alu_exception_flush.py::test_exec_misalign
**问题描述**:执行期访存错位异常被错误路由到 IFU 异常字段，导致 cmt_o_misalgn 不拉高。
**根因分析**: 
顶层在 e203_exu_alu.v:1274 将 i_misalgn 直接并入 ifu_excp_op，导致 AGU 指令在译码阶段被 ifu_excp 路径截走，agu_op/o_sel_agu 被压低；随后提交口的 cmt_o_misalgn 又只在 o_sel_agu 为 1 时才会取 agu_o_cmt_misalgn，而 cmt_o_ifu_misalgn 却被直接赋值为 i_misalgn。结果就是执行期访存 misalign 不会走 AGU 异常提交位，只会错误出现在 IFU 异常字段中。
```verilog
// e203_exu_alu/e203_exu_alu.v:1274-1278
1274:    wire ifu_excp_op = i_ilegl | i_buserr | i_misalgn;
1275:    wire alu_op = (~ifu_excp_op) & (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_ALU);
1276:    wire agu_op = (~ifu_excp_op) & (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_AGU);
1277:    wire bjp_op = (~ifu_excp_op) & (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_BJP);
1278:    wire csr_op = (~ifu_excp_op) & (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_CSR);
```
**修复建议**
1274:  wire ifu_excp_op = i_ilegl | i_buserr;\n1275:  wire agu_excp_misalgn = (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_AGU) & i_misalgn;\n1276:  wire alu_op = (~ifu_excp_op) & (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_ALU);\n1277:  wire agu_op = (~ifu_excp_op) & (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_AGU);\n1278:  wire bjp_op = (~ifu_excp_op) & (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_BJP);
### FG-EXCEPTION-FLUSH / FC-EXEC-EXCEPTION / CK-EXEC-BUSERR
**Bug标签**: BG-EXEC-BUSERR-ROUTE-97
**测试用例**: test_e203_exu_alu_exception_flush.py::test_exec_buserr
**问题描述**:执行期访存 buserr 被错误路由到 IFU 异常字段，导致 cmt_o_buserr 不拉高。
**根因分析**: 
顶层在 e203_exu_alu.v:1274 将 i_buserr 直接并入 ifu_excp_op，使 AGU 指令在输入侧带 buserr 时不再作为 AGU 事务进入异常提交链路；同时 e203_exu_alu.v:1973 仅在 o_sel_agu 为 1 时驱动 cmt_o_buserr，而 e203_exu_alu.v:1987 又把 cmt_o_ifu_buserr 直接绑定到 i_buserr。动态上 test_exec_buserr 中 cmt_o_ifu_buserr=1 但 cmt_o_buserr=0，和该路由缺陷一致。
```verilog
// e203_exu_alu/e203_exu_alu.v:1274-1278
1274:    wire ifu_excp_op = i_ilegl | i_buserr | i_misalgn;
1275:    wire alu_op = (~ifu_excp_op) & (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_ALU);
1276:    wire agu_op = (~ifu_excp_op) & (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_AGU);
1277:    wire bjp_op = (~ifu_excp_op) & (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_BJP);
1278:    wire csr_op = (~ifu_excp_op) & (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_CSR);
```
**修复建议**
1274:  wire ifu_excp_op = i_ilegl;\n1275:  wire agu_excp_buserr = (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_AGU) & i_buserr;\n1276:  wire alu_op = (~ifu_excp_op) & (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_ALU);\n1277:  wire agu_op = (~ifu_excp_op) & (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_AGU);\n1278:  wire bjp_op = (~ifu_excp_op) & (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_BJP);
### FG-MULDIV / FC-MULDIV-B2B-LIMIT / CK-MDV-BUSY-HOLD
**Bug标签**: BG-MDV-BUSY-NOLONGPIPE-88
**测试用例**: test_e203_exu_alu_muldiv.py::test_mdv_busy_hold
**问题描述**:MULDIV 在 mdv_nob2b busy 限制场景下没有维持 i_longpipe，导致 busy hold 状态不可见。
**根因分析**: 
顶层 i_longpipe 仅由 agu_i_longpipe、mdv_i_longpipe、nice_i_longpipe 三路组合而成，其中 MULDIV 路径完全依赖子模块输出 mdv_i_longpipe。当前动态测试在 mdv_nob2b=1 且 MULDIV 发射场景下观测到 i_ready 被阻塞，但 i_longpipe 始终为 0，说明 MULDIV busy 限制状态并未正确反映到 muldiv_i_longpipe/顶层 i_longpipe 上，导致 CK-MDV-BUSY-HOLD 无法满足。
```verilog
// e203_exu_alu/e203_exu_alu.v:1328-1337
1328:    wire mdv_i_longpipe;
1329:  `endif//E203_SUPPORT_SHARE_MULDIV}
1330:  `ifdef E203_HAS_NICE//{
1331:    wire nice_o_longpipe;
1332:    wire nice_i_longpipe = nice_o_longpipe;
1333:  `endif//}
1334:  
1335:    assign i_longpipe = (agu_i_longpipe & agu_op)
1336:                     `ifdef E203_SUPPORT_SHARE_MULDIV //{
1337:                      | (mdv_i_longpipe & mdv_op)
```
**修复建议**
1328:  wire mdv_i_longpipe;\n1335:  assign i_longpipe = (agu_i_longpipe & agu_op)\n1336:                   | ((mdv_i_longpipe | (mdv_nob2b & mdv_op & (~mdv_i_ready))) & mdv_op)\n1337:                   | (nice_i_longpipe & nice_op);
### FG-MULDIV / FC-MULDIV-ISSUE / CK-MDV-DECODE-ROUTE
**Bug标签**: BG-MDV-LONGPIPE-MISS-90
**测试用例**: test_e203_exu_alu_muldiv.py::test_mdv_decode_route
**问题描述**:MULDIV 指令未被分类为长流水，mdv 路由场景下 i_longpipe 保持为 0。
**根因分析**: 
当前顶层把 MULDIV 长流水分类完全依赖于子模块输出 mdv_i_longpipe，并直接用它参与 i_longpipe 组合。但动态测试表明在普通 MULDIV 发射场景下，mdv_i_ready/发射链路已工作，i_longpipe 仍为 0，说明 MULDIV 子路径没有把多周期属性正确反映到 mdv_i_longpipe，导致 decode route、longpipe flag、wbck complete、cmt coherence 等依赖长流水属性的检查点一并失效。该现象与先前记录的 BG-MDV-BUSY-NOLONGPIPE-88 一致，但影响范围更广，覆盖普通 MULDIV 发射场景。
```verilog
// e203_exu_alu/e203_exu_alu.v:1328-1337
1328:    wire mdv_i_longpipe;
1329:  `endif//E203_SUPPORT_SHARE_MULDIV}
1330:  `ifdef E203_HAS_NICE//{
1331:    wire nice_o_longpipe;
1332:    wire nice_i_longpipe = nice_o_longpipe;
1333:  `endif//}
1334:  
1335:    assign i_longpipe = (agu_i_longpipe & agu_op)
1336:                     `ifdef E203_SUPPORT_SHARE_MULDIV //{
1337:                      | (mdv_i_longpipe & mdv_op)
```
**修复建议**
1328:  wire mdv_i_longpipe;\n1335:  assign i_longpipe = (agu_i_longpipe & agu_op)\n1336:                   | ((mdv_i_longpipe | mdv_op) & mdv_op)\n1337:                   | (nice_i_longpipe & nice_op);
### FG-MULDIV / FC-MULDIV-LONGPIPE / CK-MDV-LONGPIPE-FLAG
**Bug标签**: BG-MDV-LONGPIPE-MISS-90
**测试用例**: test_e203_exu_alu_muldiv.py::test_mdv_longpipe_flag
**问题描述**:MULDIV 指令未被分类为长流水，mdv 路由场景下 i_longpipe 保持为 0。
**根因分析**: 
当前顶层把 MULDIV 长流水分类完全依赖于子模块输出 mdv_i_longpipe，并直接用它参与 i_longpipe 组合。但动态测试表明在普通 MULDIV 发射场景下，mdv_i_ready/发射链路已工作，i_longpipe 仍为 0，说明 MULDIV 子路径没有把多周期属性正确反映到 mdv_i_longpipe，导致 decode route、longpipe flag、wbck complete、cmt coherence 等依赖长流水属性的检查点一并失效。该现象与先前记录的 BG-MDV-BUSY-NOLONGPIPE-88 一致，但影响范围更广，覆盖普通 MULDIV 发射场景。
```verilog
// e203_exu_alu/e203_exu_alu.v:1328-1337
1328:    wire mdv_i_longpipe;
1329:  `endif//E203_SUPPORT_SHARE_MULDIV}
1330:  `ifdef E203_HAS_NICE//{
1331:    wire nice_o_longpipe;
1332:    wire nice_i_longpipe = nice_o_longpipe;
1333:  `endif//}
1334:  
1335:    assign i_longpipe = (agu_i_longpipe & agu_op)
1336:                     `ifdef E203_SUPPORT_SHARE_MULDIV //{
1337:                      | (mdv_i_longpipe & mdv_op)
```
**修复建议**
1328:  wire mdv_i_longpipe;\n1335:  assign i_longpipe = (agu_i_longpipe & agu_op)\n1336:                   | ((mdv_i_longpipe | mdv_op) & mdv_op)\n1337:                   | (nice_i_longpipe & nice_op);
### FG-MULDIV / FC-MULDIV-LONGPIPE / CK-MDV-WBCK-COMPLETE
**Bug标签**: BG-MDV-LONGPIPE-MISS-90
**测试用例**: test_e203_exu_alu_muldiv.py::test_mdv_wbck_complete
**问题描述**:MULDIV 指令未被分类为长流水，mdv 路由场景下 i_longpipe 保持为 0。
**根因分析**: 
当前顶层把 MULDIV 长流水分类完全依赖于子模块输出 mdv_i_longpipe，并直接用它参与 i_longpipe 组合。但动态测试表明在普通 MULDIV 发射场景下，mdv_i_ready/发射链路已工作，i_longpipe 仍为 0，说明 MULDIV 子路径没有把多周期属性正确反映到 mdv_i_longpipe，导致 decode route、longpipe flag、wbck complete、cmt coherence 等依赖长流水属性的检查点一并失效。该现象与先前记录的 BG-MDV-BUSY-NOLONGPIPE-88 一致，但影响范围更广，覆盖普通 MULDIV 发射场景。
```verilog
// e203_exu_alu/e203_exu_alu.v:1328-1337
1328:    wire mdv_i_longpipe;
1329:  `endif//E203_SUPPORT_SHARE_MULDIV}
1330:  `ifdef E203_HAS_NICE//{
1331:    wire nice_o_longpipe;
1332:    wire nice_i_longpipe = nice_o_longpipe;
1333:  `endif//}
1334:  
1335:    assign i_longpipe = (agu_i_longpipe & agu_op)
1336:                     `ifdef E203_SUPPORT_SHARE_MULDIV //{
1337:                      | (mdv_i_longpipe & mdv_op)
```
**修复建议**
1328:  wire mdv_i_longpipe;\n1335:  assign i_longpipe = (agu_i_longpipe & agu_op)\n1336:                   | ((mdv_i_longpipe | mdv_op) & mdv_op)\n1337:                   | (nice_i_longpipe & nice_op);
### FG-MULDIV / FC-MULDIV-LONGPIPE / CK-MDV-CMT-COHERENCE
**Bug标签**: BG-MDV-LONGPIPE-MISS-90
**测试用例**: test_e203_exu_alu_muldiv.py::test_mdv_cmt_coherence
**问题描述**:MULDIV 指令未被分类为长流水，mdv 路由场景下 i_longpipe 保持为 0。
**根因分析**: 
当前顶层把 MULDIV 长流水分类完全依赖于子模块输出 mdv_i_longpipe，并直接用它参与 i_longpipe 组合。但动态测试表明在普通 MULDIV 发射场景下，mdv_i_ready/发射链路已工作，i_longpipe 仍为 0，说明 MULDIV 子路径没有把多周期属性正确反映到 mdv_i_longpipe，导致 decode route、longpipe flag、wbck complete、cmt coherence 等依赖长流水属性的检查点一并失效。该现象与先前记录的 BG-MDV-BUSY-NOLONGPIPE-88 一致，但影响范围更广，覆盖普通 MULDIV 发射场景。
```verilog
// e203_exu_alu/e203_exu_alu.v:1328-1337
1328:    wire mdv_i_longpipe;
1329:  `endif//E203_SUPPORT_SHARE_MULDIV}
1330:  `ifdef E203_HAS_NICE//{
1331:    wire nice_o_longpipe;
1332:    wire nice_i_longpipe = nice_o_longpipe;
1333:  `endif//}
1334:  
1335:    assign i_longpipe = (agu_i_longpipe & agu_op)
1336:                     `ifdef E203_SUPPORT_SHARE_MULDIV //{
1337:                      | (mdv_i_longpipe & mdv_op)
```
**修复建议**
1328:  wire mdv_i_longpipe;\n1335:  assign i_longpipe = (agu_i_longpipe & agu_op)\n1336:                   | ((mdv_i_longpipe | mdv_op) & mdv_op)\n1337:                   | (nice_i_longpipe & nice_op);
### FG-NICE / FC-NICE-MULTICYCLE / CK-NICE-ITAG-WBCK
**Bug标签**: BG-NICE-ITAG-WBCK-MISS-76
**测试用例**: test_e203_exu_alu_nice.py::test_nice_itag_wbck
**问题描述**:NICE 多周期返回场景下未拉高 nice_longp_wbck_valid，导致 itag 写回握手缺失。
**根因分析**: 
顶层将 NICE 子模块的 nice_o_itag_valid 直接导出为 nice_longp_wbck_valid，并把 nice_rsp_multicyc_valid、nice_longp_wbck_ready 一并送入子模块。当前定向测试已经提供 nice_rsp_multicyc_valid=1、nice_longp_wbck_ready=1 和 itag=1，但 nice_longp_wbck_valid 仍保持 0，说明 NICE 子路径未在多周期返回场景下正确产生 itag 写回握手，导致 CK-NICE-ITAG-WBCK 无法满足。由于顶层连线是直接透传，该问题更可能位于 NICE 子模块内部状态机或握手生成逻辑。
```verilog
// e203_exu_alu/e203_exu_alu.v:1383-1393
1383:    .nice_o_longpipe    (nice_o_longpipe),
1384:    // The nice Commit Interface
1385:    .nice_o_valid       (nice_o_valid), // Handshake valid
1386:    .nice_o_ready       (nice_o_ready), // Handshake ready
1387:  
1388:    .nice_o_itag_valid  (nice_longp_wbck_valid), // Handshake valid
1389:    .nice_o_itag_ready  (nice_longp_wbck_ready), // Handshake ready
1390:    .nice_o_itag        (nice_o_itag),
1391:    // The nice Response Interface
1392:    .nice_rsp_multicyc_valid(nice_rsp_multicyc_valid), //I: current insn is multi-cycle.
1393:    .nice_rsp_multicyc_ready(nice_rsp_multicyc_ready), //O:
```
**修复建议**
1388:  .nice_o_itag_valid  (nice_longp_wbck_valid),\n1392:  .nice_rsp_multicyc_valid(nice_rsp_multicyc_valid),\n// FIX建议: 检查 e203_exu_nice 内部在 nice_rsp_multicyc_valid=1 且 nice_o_itag_ready=1 时是否确实拉高 nice_o_itag_valid，并保持到握手完成。
### FG-CSR / FC-CSR-ILLEGAL / CK-CSR-ILLEGAL-COMMIT
**Bug标签**: BG-CSR-ILEGL-IFU-MAP-96
**测试用例**: test_e203_exu_alu_csr.py::test_csr_illegal_commit
**问题描述**:非法 CSR 访问被错误映射为 IFU 非法指令提交属性，导致 cmt_o_ifu_ilegl 错误拉高。
**根因分析**: e203_exu_alu_RTL/e203_exu_alu.v:1988-1989
顶层将 csr_access_ilgl 直接并入 cmt_o_ifu_ilegl：`assign cmt_o_ifu_ilegl = i_ilegl | (o_sel_csr & csr_access_ilgl)`。这使 CSR 访问权限异常被编码成 IFU 非法取指异常，破坏异常来源分类；动态测试在 csr_access_ilgl=1 且 i_ilegl=0 时稳定观测到 cmt_o_ifu_ilegl=1。
```verilog
1988:    assign cmt_o_ifu_ilegl   = i_ilegl
1989:                             | (o_sel_csr & csr_access_ilgl)
```
**修复建议**
将 CSR 非法访问从 IFU 异常属性中剥离，例如仅保留 `assign cmt_o_ifu_ilegl = i_ilegl;`，并为 CSR 非法访问使用独立异常归因或在现有 CSR/commit 错误路径中上报，避免污染 IFU 异常字段。
