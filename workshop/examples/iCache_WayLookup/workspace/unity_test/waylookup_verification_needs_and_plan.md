# WayLookup Verification Needs and Plan

## 1. Verification Goals

Verify the correctness of the WayLookup module implementation, focusing on the following aspects:

### 1.1 Core Functional Verification

1.  **FIFO Circular Queue Basic Operations**
    *   Read/Write operations for a queue depth of 32.
    *   Empty/Full status determination logic.
    *   R/W pointer management (5-bit value + 1-bit flag).

2.  **Flush Operation**
    *   Resetting R/W pointers and GPF information.

3.  **Write Operation (IPrefetchPipe)**
    *   Normal data writing.
    *   Storage of GPF exception information.
    *   Stall handling when the queue is full.
    *   GPF stop mechanism (blocking writes when GPF is unconsumed).

4.  **Read Operation (MainPipe)**
    *   Normal reading from the queue.
    *   Bypass read (direct path from write to read when queue is empty).
    *   Reading and clearing of GPF information.

5.  **Update Operation (MissUnit)**
    *   Hit update (miss -> hit).
    *   Mismatch/Overwrite update (hit -> miss).
    *   Handling of corrupted entries.

### 1.2 Interface Signal Verification

| Interface | Source | Verification Content |
|-----------|--------|----------------------|
| flush | FTQ | Effectiveness of global flush signal |
| write | IPrefetchPipe | Write data, GPF info insertion |
| read | MainPipe | Read data, GPF info extraction |
| update | MissUnit | Match logic and hit information update |

### 1.3 Boundary Condition Verification

1.  **Queue Boundaries**
    *   Reading from an empty queue.
    *   Writing to a full queue.
    *   Pointer wraparound (value returning to 0 from 31, flag toggling).

2.  **GPF Boundaries**
    *   Pairing of GPF storage and reading.
    *   GPF storage rules for dual-row requests.
    *   Handling exceptions across page boundaries.

3.  **Update Conflicts**
    *   Matching vSetIdx with mismatched ptag.
    *   Update handling when `corrupt=1`.

## 2. Input/Output Analysis

### 2.1 Input Ports

| Port Name | Width | Description |
|-----------|-------|-------------|
| flush | 1 | Global flush signal |
| write_valid | 1 | Write valid signal |
| write_bits.vSetIdx | 8 | Virtual address cache set index |
| write_bits.waymask | 4 | waymask from MSHR |
| write_bits.ptag | 36 | Physical address tag |
| write_bits.itlb_exception | 2 | ITLB exception indicator |
| write_bits.itlb_pbmt | 2 | ITLB PBMT indicator |
| write_bits.meta_codes | 1 | meta ECC check code |
| write_bits.gpf.gpaddr | 56 | Guest physical address |
| write_bits.gpf.isForVSnonLeafPTE | 1 | Non-leaf PTE indicator |
| read_ready | 1 | Read ready signal |
| update_valid | 1 | Update valid signal |
| update_bits.blkPaddr | 36 | Cache line physical address |
| update_bits.vSetIdx | 8 | Virtual address cache set index |
| update_bits.waymask | 4 | Way selection |
| update_bits.corrupt | 1 | Data corruption indicator |

### 2.2 Output Ports

| Port Name | Width | Description |
|-----------|-------|-------------|
| write_ready | 1 | Write ready signal |
| read_valid | 1 | Read valid signal |
| read_bits.waymask | 4 | Read waymask |
| read_bits.ptag | 36 | Read ptag |
| read_bits.itlb_exception | 2 | Read ITLB exception |
| read_bits.itlb_pbmt | 2 | Read ITLB PBMT |
| read_bits.meta_codes | 1 | Read meta check code |
| read_bits.gpf.gpaddr | 56 | Read guest physical address |
| read_bits.gpf.isForVSnonLeafPTE | 1 | Read non-leaf PTE indicator |

## 3. Risk Identification

### 3.1 High-Risk Points

| Risk Point | Description | Potential Issues |
|------------|-------------|------------------|
| Empty/Full Determination | `readPtr === writePtr` with flag check | Incorrect boundary logic |
| Bypass Logic | Direct bypass when queue is empty | Data ordering or timing errors |
| GPF Storage | Comparison logic between `gpfPtr` and `readPtr` | False GPF hits or misses |
| Hit Update | miss -> hit state transition | Incorrect state machine logic |
| Pointer Wraparound | Value overflow handling at 31 | Edge case errors at wraparound |

### 3.2 Medium-Risk Points

| Risk Point | Description | Potential Issues |
|------------|-------------|------------------|
| GPF Stop | Blocking writes when GPF is unread | Deadlock or overwrite |
| Dual-Row Requests | Storing only the first GPF's address | Latching incorrect address |
| Corrupt Handling | No update when `corrupt=1` | Logic leak or incorrect update |

## 4. Verification Strategy

### 4.1 Verification Methodology

1.  **Functional Point Coverage**: Create coverage points based on the functional spec.
2.  **Boundary Testing**: Cover empty/full states and pointer wraparound.
3.  **Randomized Testing**: Use random data to verify consistency and hit corner cases.
4.  **Coverage Storming**: Use brute-force randomized signal injection to maximize line coverage.

### 4.2 Verification Phases

| Phase | Content |
|-------|---------|
| Phases 1-3 | Needs analysis, functional understanding, spec analysis |
| Phase 4 | Static Bug analysis |
| Phases 5-6 | DUT encapsulation and coverage model |
| Phases 7-9 | Test environment and API implementation |
| Phases 10-11 | Test case execution and bug analysis |
| Phase 12 | Static analysis verification |
| Phases 13-15 | Coverage enhancement and final summary |

### 4.3 Test Case Design Principles

1.  At least one test case for every functional point.
2.  Boundary conditions must be covered.
3.  GPF-related logic requires focused verification.
4.  Update operations must verify both hit and miss scenarios.
5.  Brute-force randomization is required for high-standard line coverage.

## 5. Verification Plan

### 5.1 Test Case Categories

| Category | Description |
|----------|-------------|
| test_flush | Flush operation tests |
| test_fifo_basic | FIFO basic operation tests |
| test_write | Write operation tests |
| test_read | Read operation tests |
| test_update | Update operation tests |
| test_bypass | Bypass read tests |
| test_gpf | GPF handling tests |
| test_edge | Boundary condition tests |
| test_coverage_storm | Line coverage maximization tests |

### 5.2 Expected Number of Test Cases

-   Basic Functional Tests: ~20-30
-   Boundary Tests: ~10-15
-   GPF Special Tests: ~10
-   Randomized Tests: ~5-10
-   Coverage Booster Tests: 5

## 6. Notes

1.  WayLookup is a sequential module; use the `Step` interface to drive simulation.
2.  In case of test failure, prioritize investigating chip design issues over test code.
3.  Do not modify DUT code; record and analyze found bugs.
4.  Documentation and comments should be provided in both English and Chinese.
