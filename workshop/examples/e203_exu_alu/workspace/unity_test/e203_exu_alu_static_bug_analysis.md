# e203_exu_alu RTL Static Analysis Report

## 1. Potential Bug Summary

| No. | Bug Tag | Functional Path | Summary | Confidence | File | Dynamic Bug Link |
| --- | --- | --- | --- | --- | --- | --- |
| 001 | BG-STATIC-001-MISALIGN-ROUTE | FG-AGU-LSU/FC-AGU-EXCEPTION/CK-AGU-MISALIGN | `i_misalgn` is incorrectly merged into the IFU exception path, bypassing the AGU exception path. | High | e203_exu_alu_RTL/e203_exu_alu.v | LINK-BUG-[BG-AGU-MISALIGN-ROUTE-98] |
| 002 | BG-STATIC-002-CSR-ILEGL-MAP | FG-CSR/FC-CSR-ILLEGAL/CK-CSR-ILLEGAL-COMMIT | `csr_access_ilgl` is incorrectly mapped to `cmt_o_ifu_ilegl`. | High | e203_exu_alu_RTL/e203_exu_alu.v | LINK-BUG-[BG-CSR-ILEGL-IFU-MAP-96] |

## 2. Detailed Analysis

### <FG-AGU-LSU> Memory Coordination

#### <FC-AGU-EXCEPTION> Exception Reporting

##### <CK-AGU-MISALIGN> Misalignment Exception

- <BG-STATIC-001-MISALIGN-ROUTE> The RTL appears to route `i_misalgn` through IFU-style exception logic.
- Data-side AGU misalignment should report through the execution/memory exception path and expose `cmt_o_misalgn` and `cmt_o_badaddr`.
- Dynamic failures linked to `BG-AGU-MISALIGN-ROUTE-98` confirm that AGU misalignment and bad-address reporting are lost or misclassified.

### <FG-CSR> CSR Control

#### <FC-CSR-ILLEGAL> Illegal Access

##### <CK-CSR-ILLEGAL-COMMIT> Commit Attribute

- <BG-STATIC-002-CSR-ILEGL-MAP> The RTL maps `csr_access_ilgl` to the IFU illegal-instruction commit field.
- CSR illegal access should be reported as an execution-side illegal/exception condition, not as an instruction-fetch illegal input.
- Dynamic failures linked to `BG-CSR-ILEGL-IFU-MAP-96` confirm the incorrect commit classification.

## 3. Batch Analysis Progress

| Source File | Suspected Bugs | Status |
| --- | --- | --- |
| <file>e203_exu_alu_RTL/config.v</file> | 0 | Complete |
| <file>e203_exu_alu_RTL/e203_defines.v</file> | 0 | Complete |
| <file>e203_exu_alu_RTL/e203_exu_alu.v</file> | 2 | Complete |
| <file>e203_exu_alu_RTL/e203_exu_alu_bjp.v</file> | 0 | Complete |
| <file>e203_exu_alu_RTL/e203_exu_alu_csrctrl.v</file> | 0 | Complete |
| <file>e203_exu_alu_RTL/e203_exu_alu_dpath.v</file> | 0 | Complete |
| <file>e203_exu_alu_RTL/e203_exu_alu_lsuagu.v</file> | 0 | Complete |
| <file>e203_exu_alu_RTL/e203_exu_alu_muldiv.v</file> | 0 | Complete |
| <file>e203_exu_alu_RTL/e203_exu_alu_rglr.v</file> | 0 | Complete |
| <file>e203_exu_alu_RTL/e203_exu_nice.v</file> | 0 | Complete |
| <file>e203_exu_alu_RTL/sirv_gnrl_bufs.v</file> | 0 | Complete |
| <file>e203_exu_alu_RTL/sirv_gnrl_dffs.v</file> | 0 | Complete |
| <file>e203_exu_alu_RTL/sirv_gnrl_xchecker.v</file> | 0 | Complete |
