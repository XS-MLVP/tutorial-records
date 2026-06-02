# e203_exu_alu Basic Information

## 1. Module Role

`e203_exu_alu` is the main execution block in the E203 processor execution unit. It receives decoded instruction information and context, routes transactions to different execution paths, and exposes writeback, commit, CSR, LSU/AGU, and optional NICE/MUL/DIV interfaces.

The module is not just a single arithmetic unit. Based on the README and Python DUT wrapper, it is a top-level execution component with multiple handshake paths, exception reporting, result arbitration, and long-pipeline coordination.

## 2. Python Interface Wrapper

`e203_exu_alu/__init__.py` defines the `DUTe203_exu_alu` class. The wrapper:

- Creates the underlying simulation instance through `DutUnifiedBase`.
- Creates `XPin` objects for all top-level ports.
- Binds ports to native signal addresses.
- Builds prefix-based sub-port views through `XPort.NewSubPort()`, such as `i`, `cmt_o`, `agu_icb_cmd`, `agu_icb_rsp`, `wbck_o`, and `nice_req`.
- Exposes standard DUT APIs including `InitClock()`, `Step()`, `StepRis()`, `StepFal()`, `SetWaveform()`, `SetCoverage()`, and `Finish()`.

Verification should use `DUTe203_exu_alu` as the single low-level object, advance time through the step API, and wrap grouped interfaces in higher-level environment helpers.

## 3. Circuit Type

The module is a sequential circuit:

- The top level has `clk` and active-low reset `rst_n`.
- The Python wrapper expects `InitClock("clk")` and clocked `Step()` execution.
- The specification includes long-pipeline behavior, commit, writeback, flush, and LSU response waiting across cycles.

All verification must be clock-driven. The DUT must not be treated as a single-cycle combinational unit.

## 4. Top-Level I/O Categories

### 4.1 Instruction Input and Issue Handshake

- `i_valid` / `i_ready`: upstream issue handshake.
- `i_itag`: instruction tag for long-pipeline and LSU/NICE tracking.
- `i_rs1` / `i_rs2` / `i_imm`: source operands and immediate.
- `i_info`: decoded information bus that selects the execution path.
- `i_pc` / `i_instr` / `i_pc_vld`: context required for commit.
- `i_rdidx` / `i_rdwen`: destination-register writeback metadata.

### 4.2 Exception and Control Inputs

- `i_ilegl`: illegal-instruction input exception.
- `i_buserr`: bus-error input exception.
- `i_misalgn`: misalignment exception input.
- `flush_req` / `flush_pulse`: pipeline flush controls.
- `oitf_empty`: whether the outstanding instruction tracking table is empty.
- `mdv_nob2b`: limits back-to-back MUL/DIV issue.
- `nonflush_cmt_ena`: non-flush commit enable.

### 4.3 Commit Output Channel

- `cmt_o_valid` / `cmt_o_ready`: commit handshake.
- `cmt_o_pc_vld` / `cmt_o_pc` / `cmt_o_instr` / `cmt_o_imm`: commit context.
- `cmt_o_bjp` / `cmt_o_mret` / `cmt_o_dret` / `cmt_o_ecall` / `cmt_o_ebreak` / `cmt_o_fencei` / `cmt_o_wfi`: commit type.
- `cmt_o_bjp_prdt` / `cmt_o_bjp_rslv`: branch prediction and resolution results.
- `cmt_o_misalgn` / `cmt_o_ld` / `cmt_o_stamo` / `cmt_o_buserr` / `cmt_o_badaddr`: memory and exception commit information.
- `cmt_o_ifu_misalgn` / `cmt_o_ifu_buserr` / `cmt_o_ifu_ilegl`: instruction-fetch exception information.

### 4.4 Writeback Output Channel

- `wbck_o_valid` / `wbck_o_ready`: writeback handshake.
- `wbck_o_wdat`: writeback data.
- `wbck_o_rdidx`: writeback destination register.

### 4.5 CSR Interface

- `csr_ena` / `csr_wr_en` / `csr_rd_en` / `csr_idx`: CSR request controls.
- `csr_access_ilgl`: illegal CSR access feedback.
- `read_csr_dat`: CSR read data.
- `wbck_csr_dat`: CSR-path writeback data.

### 4.6 AGU/LSU Interface

- `agu_icb_cmd_valid` / `agu_icb_cmd_ready`: memory-command handshake.
- `agu_icb_cmd_addr` / `read` / `wdata` / `wmask` / `lock` / `excl` / `size` / `back2agu` / `usign` / `itag`: memory-command attributes.
- `agu_icb_rsp_valid` / `agu_icb_rsp_ready` / `err` / `excl_ok` / `rdata`: memory-response information.
- `amo_wait`: AMO wait-state indicator.
- `i_longpipe`: indicates whether the current instruction uses a long-pipeline path.

### 4.7 NICE Interface

- `nice_req_*`: request to the NICE extension.
- `nice_rsp_multicyc_*`: multi-cycle completion response.
- `nice_longp_wbck_*`: long-pipeline NICE writeback handshake.
- `nice_o_itag`: NICE instruction tag output.
- `nice_xs_off` / `i_nice_cmt_off_ilgl`: NICE disabled/illegal controls.

## 5. Main Functional Categories

1. Regular ALU operations.
2. Branch and jump handling.
3. CSR access control.
4. Load/store/AMO address generation and LSU coordination.
5. Writeback and commit arbitration.
6. Exception reporting and flush coordination.
7. Optional MUL/DIV long-pipeline handling.
8. Optional NICE extension handling.

## 6. Estimated Feature Scale

From a verification perspective, this DUT should be decomposed into roughly 35 to 55 testable feature points. Detailed boundary and exception cases push the expected check-point count above 80.

## 7. Key Verification Focus

- Correct functional routing from `i_info`.
- Consistency between instruction class, commit result, and writeback result.
- Signed and unsigned semantics for branch and compare paths.
- CSR read/write behavior and illegal-access feedback.
- AGU address, mask, response handshake, and exception reporting.
- Absence of incorrect commit or writeback under `flush_req` / `flush_pulse`.
- Correct coordination among `i_longpipe`, `amo_wait`, LSU, NICE, and MUL/DIV paths.

## 8. Current Conclusion

`e203_exu_alu` is a complex sequential execution top level with multiple sub-units, shared data paths, downstream handshakes, exception handling, and commit coordination. Verification must cover protocols, state progress, exception paths, and multi-cycle interactions in addition to arithmetic results.
