# e203_exu_alu Verification Needs and Plan

## 1. Verification Objective

The goal is to verify `e203_exu_alu` as the top-level execution block of the E203 EXU. The suite must cover instruction issue, functional routing, ALU/BJP/CSR/AGU behavior, writeback and commit arbitration, exception reporting, flush handling, and optional MUL/DIV and NICE long-pipeline coordination.

The DUT is sequential and must be verified through clocked steps. Pass/fail criteria should be based on public ports rather than internal implementation details.

## 2. Main Interfaces and Observation Points

### 2.1 Input Side

- Issue handshake: `i_valid`, `i_ready`.
- Instruction metadata: `i_info`, `i_itag`, `i_rdidx`, `i_rdwen`, `i_pc`, `i_instr`, `i_pc_vld`.
- Operands: `i_rs1`, `i_rs2`, `i_imm`.
- Exception/control inputs: `i_ilegl`, `i_buserr`, `i_misalgn`, `flush_req`, `flush_pulse`, `oitf_empty`, `mdv_nob2b`, `nonflush_cmt_ena`.
- Downstream readiness and responses: writeback ready, commit ready, CSR feedback, AGU/LSU response, NICE response.

### 2.2 Output Side

- Writeback: `wbck_o_valid`, `wbck_o_ready`, `wbck_o_wdat`, `wbck_o_rdidx`.
- Commit: `cmt_o_*` context, type, memory, exception, and branch-resolution fields.
- AGU/LSU command and response handshake outputs.
- CSR control outputs and CSR writeback data.
- NICE request and long-pipeline writeback outputs.
- Long-pipeline and wait indicators such as `i_longpipe` and `amo_wait`.

### 2.3 Observation Principle

Tests should observe only public DUT ports. Internal signals can guide analysis, but final checks should be expressed through visible protocol, data, and exception behavior.

## 3. Functional Scope

### 3.1 Basic Functionality

- Reset, default input driving, clock stepping, waveform and coverage setup.
- Instruction issue handshake and backpressure behavior.
- ALU arithmetic, logic, shift, and compare behavior.
- Branch and jump resolution.
- CSR read, write, read-modify-write, and illegal-access handling.

### 3.2 Control and Coordination

- Load/store/AMO command generation and LSU response handling.
- Writeback and commit arbitration across multiple result sources.
- Long-pipeline tagging and completion for MUL/DIV, NICE, and AGU paths.
- Back-to-back MUL/DIV issue restriction through `mdv_nob2b`.
- NICE request, response, disabled-extension, and illegal-commit behavior.

### 3.3 Exceptions and Boundaries

- IFU exceptions, execution exceptions, AGU misalignment, bus errors, and bad-address reporting.
- Flush and non-flush commit interactions.
- Boundary operands, shift amounts, signed/unsigned comparisons, masks, and register indices.

## 4. Main Risks

### 4.1 Protocol Risks

- Handshake data may not remain stable under backpressure.
- Arbitration can mix data or attributes from different sources.
- Long-pipeline completion can become visible after a flush.

### 4.2 Functional Risks

- Misalignment, bad-address, and bus-error signals can be routed to the wrong exception class.
- CSR illegal access can be reported as the wrong commit attribute.
- Load response data can be dropped if the DUT commits too early.
- MUL/DIV and NICE paths can be partially stubbed or incompletely integrated.

### 4.3 Timing and Control Risks

- `i_ready` can glitch during busy or backpressure conditions.
- `i_longpipe` and `amo_wait` can be asserted or cleared at the wrong time.
- `flush_req`, `flush_pulse`, and `nonflush_cmt_ena` can expose stale transactions.

## 5. Verification Method Plan

### 5.1 Documentation and Source Analysis

Derive feature groups, feature points, and check points from the README, wrapper, and RTL. Map each check point to public DUT behavior.

### 5.2 Verification Infrastructure

Create reusable Python helpers for reset, issue driving, sub-interface defaulting, LSU/CSR/NICE response driving, output sampling, and coverage tagging.

### 5.3 Directed Tests

Implement targeted tests for each feature group, with one or more check points per scenario. Keep bug-reproduction tests explicit and documented.

### 5.4 Convergence

Run all tests, collect coverage, classify failures into RTL bugs or invalid checks, and update the reports with bug confidence and root-cause evidence.

## 6. Delivery Strategy

1. Establish the API and environment smoke tests.
2. Implement directed tests for single-cycle ALU, BJP, CSR, and AGU paths.
3. Add multi-cycle, backpressure, flush, and long-pipeline scenarios.
4. Add random examples around stable helper APIs.
5. Produce English reports for feature coverage, bug analysis, static analysis, line coverage, and summary.

## 7. Expected Outputs

- `e203_exu_alu_functions_and_checks.md`
- `e203_exu_alu_bug_analysis.md`
- `e203_exu_alu_static_bug_analysis.md`
- `e203_exu_alu_line_coverage_analysis.md`
- `e203_exu_alu_test_summary.md`
- Directed and random pytest tests with waveform and coverage artifacts.

## 8. Current Conclusion

The verification plan should treat `e203_exu_alu` as a protocol-heavy execution top level rather than a pure ALU. The highest-value tests are those that combine data results with handshake, exception, commit, and long-pipeline visibility.
