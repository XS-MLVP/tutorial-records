# e203_exu_alu Bug Analysis

## Failed Check Point Analysis

The failing check points fall into two categories: confirmed RTL defects and checks that were later classified as invalid or over-constrained for this DUT.

#### <FC-AGU-EXCEPTION>

- <CK-AGU-MISALIGN> Data-side `i_misalgn` is treated like an IFU exception, so `cmt_o_misalgn` is not asserted.
- <CK-AGU-BADADDR> Data-side misalignment does not preserve the expected `cmt_o_badaddr`.
- <BG-AGU-MISALIGN-ROUTE-98> Bug confidence: 98%.

#### <FC-LOAD>

- <CK-LOAD-RSP-WBCK> An aligned load can complete commit/writeback arbitration at issue time, so LSU response data is not written to `wbck_o_wdat`.
- <BG-AGU-LOAD-RSP-DROP-97> Bug confidence: 97%.

#### <FC-AGU-EXCEPTION>

- <CK-AGU-BUSERR> An aligned load with LSU `err` response does not propagate the bus error to `cmt_o_buserr`.
- <BG-AGU-LOAD-RSP-DROP-97> Bug confidence: 97%.

#### <FC-COMPARE>

- <CK-CMP-EQ-NE> This check expected EQ/NE register writeback semantics on the regular ALU path. The DUT exposes SLT/SLTU-style compare writeback, while EQ/NE belongs to the BJP branch-resolution path.
- <BG-ALU-CMP-EQNE-0> Bug confidence: 0%. This is an invalid check, not an RTL bug.

#### <FC-EXEC-EXCEPTION>

- <CK-EXEC-MISALIGN> Execution-side misalignment is misclassified or not exposed through the expected execution exception path.
- <CK-EXEC-BUSERR> Execution-side bus error can be dropped or misclassified.
- These are linked to the AGU exception-routing and load-response-drop bug classes.

#### <FC-MULDIV-B2B-LIMIT>

- <CK-MDV-BUSY-HOLD> MUL/DIV busy and no-back-to-back behavior does not provide the expected stable `i_ready`/long-pipeline behavior.
- This may indicate incomplete MUL/DIV integration or an over-constrained expectation depending on configuration.

#### <FC-MULDIV-ISSUE>

- <CK-MDV-DECODE-ROUTE> MUL/DIV decode routing is not externally visible as expected.
- The observed behavior suggests the tested DUT configuration may not fully enable the MUL/DIV path.

#### <FC-MULDIV-LONGPIPE>

- <CK-MDV-LONGPIPE-FLAG> MUL/DIV issue does not assert the expected long-pipeline classification.
- <CK-MDV-WBCK-COMPLETE> MUL/DIV completion does not produce the expected writeback.
- <CK-MDV-CMT-COHERENCE> MUL/DIV completion does not show the expected commit/writeback coherence.

#### <FC-NICE-MULTICYCLE>

- <CK-NICE-ITAG-WBCK> NICE multi-cycle completion does not expose the expected `itag` and long-pipeline writeback behavior.
- This may be a configuration or integration limitation rather than a core ALU bug.

#### <FC-CSR-ILLEGAL>

- <CK-CSR-ILLEGAL-COMMIT> CSR illegal access is mapped to an IFU illegal-instruction commit field instead of an execution-side illegal/exception classification.
- <BG-CSR-ILEGL-IFU-MAP-96> Bug confidence: 96%.

## Root Cause Analysis

### FG-AGU-LSU / FC-AGU-EXCEPTION / CK-AGU-MISALIGN

The evidence indicates that `i_misalgn` is routed into an IFU-style exception condition. Data-side AGU misalignment should instead create memory/execution exception attributes and report the data bad address. The misrouting explains both the missing `cmt_o_misalgn` and the missing or incorrect `cmt_o_badaddr`.

### FG-AGU-LSU / FC-LOAD / CK-LOAD-RSP-WBCK

The DUT appears to allow aligned load transactions to reach commit/writeback arbitration before LSU response data is available. As a result, the later `agu_icb_rsp_*` data is not captured into `wbck_o_wdat`. The issue is a transaction-lifetime bug: the load should remain pending until the response phase completes.

### FG-AGU-LSU / FC-AGU-EXCEPTION / CK-AGU-BUSERR

This failure shares the same response-lifetime problem as the load writeback failure. If the response phase is not retained as the source of final load status, `agu_icb_rsp_err` cannot be propagated reliably to `cmt_o_buserr`.

### FG-ALU / FC-COMPARE / CK-CMP-EQ-NE

The check point assigned EQ/NE register writeback semantics to the regular ALU path. In this DUT, equality and inequality comparisons are part of BJP branch resolution, not regular ALU register writeback. The check should be removed or moved to the BJP feature group.

### FG-MULDIV / FC-MULDIV-* Checks

The MUL/DIV failures show that the tested configuration does not expose the expected long-pipeline issue, completion, and commit/writeback behavior. This can be caused by feature disablement, incomplete wrapper stimulus, or incomplete integration. These failures should remain documented but should not be mixed with confirmed core ALU bugs until the configuration is confirmed.

### FG-NICE / FC-NICE-MULTICYCLE / CK-NICE-ITAG-WBCK

The NICE long-pipeline behavior does not match the expected external protocol. Because NICE is optional, the first triage step is to confirm whether NICE is enabled and whether the external response sequence matches the DUT configuration.

### FG-CSR / FC-CSR-ILLEGAL / CK-CSR-ILLEGAL-COMMIT

Static analysis and dynamic evidence both indicate that `csr_access_ilgl` is mapped to `cmt_o_ifu_ilegl`. CSR illegal access is an execution-side condition and should not be reported as an instruction-fetch illegal exception.

## Bug Classification Summary

- Confirmed RTL bugs: AGU misalignment routing, load response drop, CSR illegal mapping.
- Configuration or integration risks: MUL/DIV and NICE long-pipeline visibility.
- Invalid check: EQ/NE regular ALU writeback expectation.
