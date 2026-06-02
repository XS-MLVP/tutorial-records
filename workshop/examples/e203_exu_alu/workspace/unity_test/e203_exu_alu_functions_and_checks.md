# e203_exu_alu Feature Points and Check Points

## DUT Functional Overview

`e203_exu_alu` is the top-level execution block in the E203 EXU. It accepts decoded instruction information and source operands, routes the transaction to the selected execution path, coordinates downstream interfaces, and emits writeback, commit, exception, CSR, AGU/LSU, MUL/DIV, and NICE-visible behavior.

### Port Interface Summary

The primary input side includes issue handshake, operands, decoded information, instruction context, exception inputs, flush controls, and downstream response/ready signals. The primary output side includes writeback, commit, CSR control, AGU/LSU command and response readiness, NICE request/writeback signals, long-pipeline flags, and wait indicators.

## Feature Groups and Check Points

### Test Interface and Driving Conventions

#### Reset and Initial Driving

Reset must drive the DUT to a safe state and set all optional downstream inputs to deterministic defaults.

**Check points:**

- <CK-RESET-ASSERT> Verify safe output behavior while reset is asserted.
- <CK-RESET-RELEASE> Verify the DUT accepts valid transactions after reset release.
- <CK-RESET-DEFAULT-INPUT> Verify default inputs do not create unintended commit, writeback, AGU, CSR, or NICE activity.

#### Instruction Issue and Step API

Drive one instruction transaction at a time through `i_valid/i_ready` and advance the DUT through clocked steps.

**Check points:**

- <CK-ISSUE-HANDSHAKE> Verify a transaction is accepted only on a valid-ready handshake.
- <CK-READY-PROPAGATE> Verify downstream readiness affects `i_ready` consistently.
- <CK-STEP-BACKPRESSURE-WAIT> Verify the environment can wait for backpressure to clear.

#### Output Sampling and Result Observation

Sample writeback, commit, AGU/LSU, CSR, and NICE outputs through public ports.

**Check points:**

- <CK-SAMPLE-OUTPUTS> Verify the environment captures all observable output groups.
- <CK-SIDEBAND-SNAPSHOT> Verify sideband metadata is sampled consistently with data.
- <CK-SINGLE-TRANSACTION-CAPTURE> Verify one transaction's outputs are not mixed with another.

### Instruction Acceptance and Functional Routing

#### Decode Routing

Route transactions according to `i_info` into regular ALU, BJP, CSR, AGU/LSU, MUL/DIV, or NICE paths.

**Check points:**

- <CK-ROUTE-ALU> Verify ALU-class instructions select the regular ALU path.
- <CK-ROUTE-SUBMODULE> Verify BJP/CSR/AGU/NICE/MUL/DIV instruction classes reach their intended external behavior.
- <CK-ROUTE-MUTEX> Verify mutually exclusive route assumptions do not produce mixed visible outputs.

#### Issue Readiness and Backpressure

The DUT must honor upstream and downstream ready/valid protocols.

**Check points:**

- <CK-VALID-READY-COMPLETE> Verify valid-ready completion semantics.
- <CK-ARBIT-READY-GATING> Verify ready changes do not corrupt in-flight data.
- <CK-ARBIT-UNIQUE-SOURCE> Verify one visible result source is selected at a time.

#### Long-Pipeline Classification

Long-latency paths must assert and clear long-pipeline indicators correctly.

**Check points:**

- <CK-LONGPIPE-AGU> Verify AGU long-pipeline classification.
- <CK-LONGPIPE-MDV-NICE> Verify MUL/DIV and NICE long-pipeline classification.
- <CK-LONGPIPE-SHORTPATH> Verify single-cycle paths do not assert long-pipeline state.

### Regular ALU Operations

#### Arithmetic Operations

Verify add, subtract, and immediate arithmetic behavior.

**Check points:**

- <CK-ARITH-ADD> Verify addition result writeback.
- <CK-ARITH-SUB> Verify subtraction result writeback.
- <CK-ARITH-IMM> Verify immediate arithmetic operand selection.

#### Logic and Shift Operations

Verify bitwise and shift behavior.

**Check points:**

- <CK-LOGIC-BITWISE> Verify AND/OR/XOR-style bitwise results.
- <CK-SHIFT-LEFT-RIGHT> Verify left and right shift results.
- <CK-SHIFT-AMOUNT-BOUND> Verify shift amount masking and boundary behavior.

#### Compare Result Generation

Verify compare behavior that is actually exposed through the regular ALU path.

**Check points:**

- <CK-CMP-SIGNED> Verify signed less-than behavior.
- <CK-CMP-UNSIGNED> Verify unsigned less-than behavior.
- <CK-CMP-EQ-NE> Invalid as a regular ALU writeback check; EQ/NE belongs to BJP branch-resolution behavior.

### Branch, Jump, and Control Transfer

#### Conditional Branch Resolution

Resolve branch conditions and expose prediction-resolution metadata.

**Check points:**

- <CK-BRANCH-TAKEN> Verify taken branch resolution.
- <CK-BRANCH-NOTTAKEN> Verify not-taken branch resolution.
- <CK-BRANCH-SIGNED-UNSIGNED> Verify signed and unsigned branch comparisons.

#### Jump and Link Return Values

JAL/JALR should write back the link value and preserve PC context.

**Check points:**

- <CK-JAL-WBCK> Verify JAL link writeback.
- <CK-JALR-WBCK> Verify JALR link writeback.
- <CK-JUMP-PC-CONTEXT> Verify jump commit context.

#### Branch Commit Attributes

Commit output must reflect control-transfer class and resolution data.

**Check points:**

- <CK-BJP-COMMIT-FLAGS> Verify BJP commit type flags.
- <CK-BJP-PRDT-RSLV> Verify prediction and resolution fields.

### CSR Access Control

#### CSR Read Path

Generate CSR read controls and return CSR data through the writeback path.

**Check points:**

- <CK-CSR-RD-ENABLE> Verify CSR read enable and index.
- <CK-CSR-RD-DATA> Verify CSR read data writeback.
- <CK-CSR-RD-NORD> Verify non-read CSR instructions do not assert read enable.

#### CSR Write Path

Generate CSR write controls and write data.

**Check points:**

- <CK-CSR-WR-ENABLE> Verify CSR write enable and index.
- <CK-CSR-WDATA-FORM> Verify CSR write data formation.
- <CK-CSR-RMW> Verify read-modify-write CSR behavior.

#### CSR Illegal Access Feedback

Illegal CSR access must be reported through the correct commit/exception classification.

**Check points:**

- <CK-CSR-ILLEGAL-COMMIT> Verify illegal CSR access commit attributes.
- <CK-CSR-ILLEGAL-ERR> Verify illegal CSR feedback affects visible error behavior.
- <CK-CSR-ILLEGAL-SUPPRESS> Verify illegal CSR access suppresses normal writeback when required.

#### NICE CSR Coordination

Coordinate CSR and NICE-specific control conditions.

**Check points:**

- <CK-NICE-CSR-REQ> Verify NICE-related CSR request behavior.
- <CK-NICE-CSR-RSP> Verify NICE-related CSR response behavior.
- <CK-NICE-CSR-BYPASS> Verify non-NICE CSR paths are not polluted by NICE controls.

### Memory Address Generation and LSU Coordination

#### Load Address and Response Handling

Generate load commands and write back LSU response data.

**Check points:**

- <CK-LOAD-CMD> Verify load command address, read flag, size, and sign attributes.
- <CK-LOAD-RSP-WBCK> Verify LSU response data writes back to `wbck_o_wdat`.
- <CK-LOAD-USIGN-SIZE> Verify signed/unsigned and size attributes.

#### Store Command Generation

Generate store commands and avoid normal register writeback for pure stores.

**Check points:**

- <CK-STORE-CMD> Verify store address, data, and `agu_icb_cmd_read=0`.
- <CK-STORE-WMASK> Verify byte/half/word write masks.
- <CK-STORE-NO-WBCK> Verify stores do not produce regular register writeback.

#### Atomic Memory Operations

Generate AMO command attributes, ALU-shared results, and wait-state behavior.

**Check points:**

- <CK-AMO-EXCL-CMD> Verify exclusive/atomic command attributes.
- <CK-AMO-ALU-RESULT> Verify AMO ALU result and writeback semantics.
- <CK-AMO-WAIT-CLEAR> Verify `amo_wait` assertion and clearing.

#### ICB Command/Response Handshake

Handle valid-ready interactions, `itag` forwarding, and `back2agu` control.

**Check points:**

- <CK-ICB-CMD-HOLD> Verify command attributes remain stable under command backpressure.
- <CK-ICB-RSP-READY> Verify response-ready behavior.
- <CK-ITAG-BACK2AGU> Verify `itag` and `back2agu` attributes.

#### Memory Exceptions and Bad Address Reporting

Report misalignment, bus error, and bad address information through commit outputs.

**Check points:**

- <CK-AGU-MISALIGN> Verify data misalignment sets `cmt_o_misalgn`.
- <CK-AGU-BUSERR> Verify LSU response error sets `cmt_o_buserr`.
- <CK-AGU-BADADDR> Verify `cmt_o_badaddr` reflects the faulting data address.

### Writeback and Commit Arbitration

#### Writeback Data Output

Unify results from different execution paths through `wbck_o_*`.

**Check points:**

- <CK-WBCK-VALID-DATA> Verify valid writeback data.
- <CK-WBCK-RDIDX> Verify destination register index.
- <CK-WBCK-BACKPRESSURE-HOLD> Verify writeback data and index remain stable under backpressure.

#### Commit Information Output

Expose commit context, exception class, memory attributes, and control-transfer attributes.

**Check points:**

- <CK-COMMIT-CONTEXT> Verify PC, instruction, immediate, and PC-valid context.
- <CK-COMMIT-MEM-ATTR> Verify load/store/AMO commit attributes.
- <CK-COMMIT-EXCP-ATTR> Verify exception attributes match the triggering condition.

#### Multi-Path Result Arbitration

Ensure that shared output channels select one coherent source.

**Check points:**

- <CK-ARBIT-UNIQUE-SOURCE> Verify a single active result source.
- <CK-ARBIT-READY-GATING> Verify ready gating preserves protocol correctness.
- <CK-ARBIT-DATA-CONSISTENCY> Verify selected valid source matches data and attributes.

### Exception Reporting and Pipeline Flush

#### IFU Exception Forwarding

Forward input-side IFU exception context to commit outputs.

**Check points:**

- <CK-IFU-ILEGL> Verify `i_ilegl` maps to `cmt_o_ifu_ilegl`.
- <CK-IFU-BUSERR> Verify `i_buserr` maps to `cmt_o_ifu_buserr`.
- <CK-IFU-MISALIGN> Verify IFU misalignment is reported through the IFU exception path.

#### Execution-Time Exception Reporting

Report data-side and execution-side exceptions.

**Check points:**

- <CK-EXEC-MISALIGN> Verify execution/data misalignment is reported correctly.
- <CK-EXEC-BUSERR> Verify data bus error is reported correctly.
- <CK-EXEC-CSR-NICE> Verify CSR/NICE illegal execution conditions are visible.

#### Flush Handling

Flush controls should prevent invalid in-flight results from becoming externally visible.

**Check points:**

- <CK-FLUSH-ISSUE-KILL> Verify transactions in issue/early execution are killed by flush.
- <CK-FLUSH-LONGPIPE-KILL> Verify pending long-pipeline results do not write back or commit after flush.
- <CK-FLUSH-PULSE-TRANSIENT> Verify a one-cycle flush pulse leaves no stale valid state.

#### Non-Flush Commit Control

`nonflush_cmt_ena` constrains normal commit visibility.

**Check points:**

- <CK-NONFLUSH-CMT-ALLOW> Verify normal commit when enabled.
- <CK-NONFLUSH-CMT-BLOCK> Verify normal commit is blocked when disabled.
- <CK-NONFLUSH-EXCP-INTERLOCK> Verify exception behavior does not leak incorrect commit attributes.

### Long-Pipeline MUL/DIV Coordination

#### MUL/DIV Issue Path

Route shared MUL/DIV instructions and expose readiness.

**Check points:**

- <CK-MDV-ISSUE-READY> Verify MUL/DIV issue readiness.
- <CK-MDV-DECODE-ROUTE> Verify MUL/DIV decode routing.
- <CK-MDV-NONMDV-MUTE> Verify non-MUL/DIV instructions do not activate MUL/DIV behavior.

#### Back-to-Back Issue Restriction

Honor `mdv_nob2b` when consecutive MUL/DIV instructions are issued.

**Check points:**

- <CK-MDV-NOB2B-BLOCK> Verify back-to-back issue is blocked when required.
- <CK-MDV-NOB2B-ALLOW> Verify issue is allowed when constraints are clear.
- <CK-MDV-BUSY-HOLD> Verify busy/ready state does not glitch.

#### MUL/DIV Long-Pipeline Result

Verify completion, writeback, and commit coherence.

**Check points:**

- <CK-MDV-LONGPIPE-FLAG> Verify long-pipeline classification.
- <CK-MDV-WBCK-COMPLETE> Verify completion writeback.
- <CK-MDV-CMT-COHERENCE> Verify commit and writeback coherence.

### NICE Extension Coordination

#### NICE Request Send

Generate NICE requests with stable payload under backpressure.

**Check points:**

- <CK-NICE-REQ-VALID> Verify NICE request valid behavior.
- <CK-NICE-REQ-PAYLOAD> Verify NICE instruction and operand payload.
- <CK-NICE-REQ-BACKPRESSURE> Verify request payload remains stable under backpressure.

#### NICE Multi-Cycle Completion

Handle multi-cycle response, long-pipeline writeback, and `itag` consistency.

**Check points:**

- <CK-NICE-MCYC-READY> Verify multi-cycle response handshake.
- <CK-NICE-ITAG-WBCK> Verify `nice_o_itag` and long-pipeline writeback alignment.
- <CK-NICE-LONGPIPE-FLAG> Verify NICE long-pipeline classification.

#### NICE Disabled and Illegal Commit

Handle disabled extension and illegal NICE commit controls.

**Check points:**

- <CK-NICE-OFF-BLOCK> Verify NICE instructions are blocked when `nice_xs_off=1`.
- <CK-NICE-ILLEGAL-ERR> Verify illegal NICE commit feedback.
- <CK-NICE-NORMAL-BYPASS> Verify legal non-NICE paths do not trigger disabled-extension behavior.
