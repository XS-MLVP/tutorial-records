# e203_exu_alu RTL 源码静态分析报告

## 一、潜在Bug汇总

| 序号 | Bug标签 | 功能路径 | 描述摘要 | 置信度 | 涉及文件 | 动态Bug关联 |
|------|---------|----------|----------|--------|----------|-------------|
| 001 | BG-STATIC-001-MISALIGN-ROUTE | FG-AGU-LSU/FC-AGU-EXCEPTION/CK-AGU-MISALIGN | i_misalgn被错误并入ifu_excp_op导致AGU异常路径被旁路 | 高 | e203_exu_alu_RTL/e203_exu_alu.v | LINK-BUG-[BG-AGU-MISALIGN-ROUTE-98] |
| 002 | BG-STATIC-002-CSR-ILEGL-MAP | FG-CSR/FC-CSR-ILLEGAL/CK-CSR-ILLEGAL-COMMIT | csr_access_ilgl被错误映射到cmt_o_ifu_ilegl | 高 | e203_exu_alu_RTL/e203_exu_alu.v | LINK-BUG-[BG-CSR-ILEGL-IFU-MAP-96] |

## 二、详细分析

### <FG-AGU-LSU> 访存协同
#### <FC-AGU-EXCEPTION> 异常上报
##### <CK-AGU-MISALIGN> 错位异常
  - <BG-STATIC-001-MISALIGN-ROUTE> i_misalgn被错误并入ifu_excp_op导致AGU异常路径被旁路
    - <LINK-BUG-[BG-AGU-MISALIGN-ROUTE-98]>
      - <FILE-e203_exu_alu_RTL/e203_exu_alu.v:1274-1276>
        ```verilog
        1274:    wire ifu_excp_op = i_ilegl | i_buserr | i_misalgn;
        1275:    wire alu_op = (~ifu_excp_op) & (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_ALU);
        1276:    wire agu_op = (~ifu_excp_op) & (i_info[`E203_DECINFO_GRP] == `E203_DECINFO_GRP_AGU);
        ```
### <FG-CSR> CSR控制
#### <FC-CSR-ILLEGAL> 非法访问
##### <CK-CSR-ILLEGAL-COMMIT> 提交属性
  - <BG-STATIC-002-CSR-ILEGL-MAP> csr_access_ilgl被错误映射到cmt_o_ifu_ilegl
    - <LINK-BUG-[BG-CSR-ILEGL-IFU-MAP-96]>
      - <FILE-e203_exu_alu_RTL/e203_exu_alu.v:1988-1989>
        ```verilog
        1988:    assign cmt_o_ifu_ilegl   = i_ilegl
        1989:                             | (o_sel_csr & csr_access_ilgl)
        ```
## 三、批次分析进度

| 源文件 | 发现疑似Bug数 | 状态 |
|--------|---------------|------|
| <file>e203_exu_alu_RTL/config.v</file> | 0 | ✅ 完成 |
| <file>e203_exu_alu_RTL/e203_defines.v</file> | 0 | ✅ 完成 |
| <file>e203_exu_alu_RTL/e203_exu_alu.v</file> | 2 | ✅ 完成 |
| <file>e203_exu_alu_RTL/e203_exu_alu_bjp.v</file> | 0 | ✅ 完成 |
| <file>e203_exu_alu_RTL/e203_exu_alu_csrctrl.v</file> | 0 | ✅ 完成 |
| <file>e203_exu_alu_RTL/e203_exu_alu_dpath.v</file> | 0 | ✅ 完成 |
| <file>e203_exu_alu_RTL/e203_exu_alu_lsuagu.v</file> | 0 | ✅ 完成 |
| <file>e203_exu_alu_RTL/e203_exu_alu_muldiv.v</file> | 0 | ✅ 完成 |
| <file>e203_exu_alu_RTL/e203_exu_alu_rglr.v</file> | 0 | ✅ 完成 |
| <file>e203_exu_alu_RTL/e203_exu_nice.v</file> | 0 | ✅ 完成 |
| <file>e203_exu_alu_RTL/sirv_gnrl_bufs.v</file> | 0 | ✅ 完成 |
| <file>e203_exu_alu_RTL/sirv_gnrl_dffs.v</file> | 0 | ✅ 完成 |
| <file>e203_exu_alu_RTL/sirv_gnrl_xchecker.v</file> | 0 | ✅ 完成 |
