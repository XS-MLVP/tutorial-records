# WayLookup Functional Points and Checkpoints Description

## Overall DUT Functional Description

WayLookup is a FIFO circular queue module in the RISC-V processor front-end, used to cache metadata obtained by IPrefetchPipe querying MetaArray and ITLB for use by MainPipe. Simultaneously, it listens to cachelines written to SRAM by the MSHR and updates hit information accordingly.

### Key Parameters

-   **Queue Depth**: 32
-   **R/W Pointers**: 5-bit value + 1-bit flag
-   **Module Type**: Sequential Circuit (requires clock drive)

### Port Interface Description

**System Signals:**
-   `clock`: Clock signal
-   `reset`: Reset signal
-   `io_flush`: Global flush signal (from FTQ)

**Write Interface (IPrefetchPipe):**
-   `io_write_valid`: Write valid signal
-   `io_write_ready`: Write ready signal
-   `io_write_bits_*`: Written data fields

**Read Interface (MainPipe):**
-   `io_read_ready`: Read ready signal
-   `io_read_valid`: Read valid signal
-   `io_read_bits_*`: Read data fields

**Update Interface (MissUnit):**
-   `io_update_valid`: Update valid signal
-   `io_update_bits_*`: Hit update information fields

---

## Functional Grouping and Checkpoints

### DUT Testing API

<FG-API>

#### Write Operation API

<FC-API-WRITE>

Provides the API interface for writing data to WayLookup.

**Checkpoints:**
-   <CK-WRITE-BASIC> Basic Write: Verify normal data writing to the FIFO queue.
-   <CK-WRITE-FULL> Full Queue Write: Verify that writing is correctly blocked when the queue is full.

#### Read Operation API

<FC-API-READ>

Provides the API interface for reading data from WayLookup.

**Checkpoints:**
-   <CK-READ-BASIC> Basic Read: Verify normal data reading from the FIFO queue.
-   <CK-READ-EMPTY> Empty Queue Read: Verify that reading returns invalid when the queue is empty.

#### Update Operation API

<FC-API-UPDATE>

Provides the API interface for updating hit information in WayLookup.

**Checkpoints:**
-   <CK-UPDATE-BASIC> Basic Update: Verify the hit information update functionality.

#### Flush Operation API

<FC-API-FLUSH>

Provides the API interface for flushing WayLookup.

**Checkpoints:**
-   <CK-FLUSH-BASIC> Basic Flush: Verify that the flush signal correctly resets all states.

---

### Flush Operation

<FG-FLUSH>

#### Read Pointer Flush

<FC-FLUSH-READ-PTR>

Resets the read pointer when `io_flush` is high.

**Checkpoints:**
-   <CK-FLUSH-RP-VALUE> Read Pointer Value Reset: Verify that `readPtr.value` resets to 0.
-   <CK-FLUSH-RP-FLAG> Read Pointer Flag Reset: Verify that `readPtr.flag` resets to false.

#### Write Pointer Flush

<FC-FLUSH-WRITE-PTR>

Resets the write pointer when `io_flush` is high.

**Checkpoints:**
-   <CK-FLUSH-WP-VALUE> Write Pointer Value Reset: Verify that `writePtr.value` resets to 0.
-   <CK-FLUSH-WP-FLAG> Write Pointer Flag Reset: Verify that `writePtr.flag` resets to false.

#### GPF Information Flush

<FC-FLUSH-GPF>

Resets GPF information when `io_flush` is high.

**Checkpoints:**
-   <CK-FLUSH-GPF-VALID> GPF Valid Bit Reset: Verify that `gpf_entry.valid` resets to 0.
-   <CK-FLUSH-GPF-BITS> GPF Data Reset: Verify that `gpf_entry.bits` resets to 0.

---

### FIFO Basic Operations

<FG-FIFO>

#### Queue Empty Status

<FC-FIFO-EMPTY>

Judgment and handling of an empty queue.

**Checkpoints:**
-   <CK-EMPTY-TRUE> Empty Queue Judgment: Verify that the queue is empty when `readPtr === writePtr`.
-   <CK-EMPTY-READ-INVALID> Empty Queue Read Invalid: Verify that `read_valid` is low when the queue is empty.

#### Queue Full Status

<FC-FIFO-FULL>

Judgment and handling of a full queue.

**Checkpoints:**
-   <CK-FULL-TRUE> Full Queue Judgment: Verify that the queue is full when R/W pointer values are equal but flags are different.
-   <CK-FULL-WRITE-BLOCK> Full Queue Write Block: Verify that `write_ready` is low when the queue is full.

#### Pointer Wraparound

<FC-FIFO-PTR-WRAP>

Wraparound handling of read and write pointers.

**Checkpoints:**
-   <CK-WRAP-READ> Read Pointer Wraparound: Verify that the read pointer returns to 0 and toggles the flag after exceeding 31.
-   <CK-WRAP-WRITE> Write Pointer Wraparound: Verify that the write pointer returns to 0 and toggles the flag after exceeding 31.

#### R/W Pointer Update

<FC-FIFO-PTR-UPDATE>

Pointer updates after handshake of read/write signals.

**Checkpoints:**
-   <CK-READ-PTR-INCREMENT> Read Pointer Increment: Verify that the read pointer increments when `io.read.fire` is high.
-   <CK-WRITE-PTR-INCREMENT> Write Pointer Increment: Verify that the write pointer increments when `io.write.fire` is high.

---

### Write Operation

<FG-WRITE>

#### Normal Write

<FC-WRITE-NORMAL>

Standard write operations.

**Checkpoints:**
-   <CK-WRITE-FIRE> Write Handshake Success: Verify successful writing when `io.write.fire` is high.
-   <CK-WRITE-DATA> Correct Write Data: Verify that written data is correctly stored in the queue.

#### GPF Stall

<FC-WRITE-GPF-STALL>

Blocking writes when GPF information exists and has not been read.

**Checkpoints:**
-   <CK-GPF-STALL-ACTIVE> GPF Stall Activation: Verify that writes are blocked when GPF is unread.
-   <CK-GPF-STALL-RELEASE> GPF Stall Release: Verify that writes resume after GPF is read.

#### Full Queue Write

<FC-WRITE-QUEUE-FULL>

Handling writes when the queue is full.

**Checkpoints:**
-   <CK-WRITE-NOT-READY> Write Not Ready: Verify that `io_write_ready` is low when the queue is full.

#### GPF Storage - Bypassed

<FC-WRITE-GPF-BYPASS>

GPF information does not need storage when a write is bypassed.

**Checkpoints:**
-   <CK-GPF-BYPASS-NOT-STORE> No Storage on Bypass: Verify that GPF info is not stored in `gpf_entry` when bypassed.

#### GPF Storage - Normal

<FC-WRITE-GPF-STORE>

Storing GPF information during normal writes.

**Checkpoints:**
-   <CK-GPF-STORE-VALID> GPF Valid Bit Set: Verify `gpf_entry.valid` becomes true on GPF write.
-   <CK-GPF-STORE-DATA> GPF Data Storage: Verify GPF data is correctly stored in `gpf_entry.bits`.
-   <CK-GPF-STORE-PTR> GPF Pointer Update: Verify `gpfPtr` updates to the current write pointer.

---

### Read Operation

<FG-READ>

#### Bypass Read

<FC-READ-BYPASS>

Direct path to read port when queue is empty but a write request is present.

**Checkpoints:**
-   <CK-BYPASS-CONDITION> Bypass Condition: Verify Bypass triggers when queue is empty and write is valid.
-   <CK-BYPASS-DATA> Bypass Data: Verify read data equals written data during Bypass.

#### Invalid Read Signal

<FC-READ-INVALID>

Read signal is invalid when the queue is empty and no write request exists.

**Checkpoints:**
-   <CK-READ-NOT-VALID> Read Invalid: Verify `io_read_valid` is low on an empty queue with no write.

#### Normal Read

<FC-READ-NORMAL>

Standard reading from the queue.

**Checkpoints:**
-   <CK-READ-FROM-QUEUE> Read from Queue: Verify data reading from the queue in non-bypass scenarios.
-   <CK-READ-DATA-CORRECT> Correct Read Data: Verify consistency between read and written data.

#### GPF Hit

<FC-READ-GPF-HIT>

Hitting GPF information during a read.

**Checkpoints:**
-   <CK-GPF-HIT-ACTIVE> GPF Hit Activation: Verify hit when `gpfPtr === readPtr` and GPF is valid.
-   <CK-GPF-HIT-DATA> GPF Hit Data: Verify correct output of the hit GPF data.

#### GPF Hit and Read

<FC-READ-GPF-HIT-READ>

Side effects after hitting and reading GPF information.

**Checkpoints:**
-   <CK-GPF-READ-CLEAR> GPF Clear: Verify `gpf_entry.valid` becomes 0 when `io.read.fire` is high.

#### GPF Miss

<FC-READ-GPF-MISS>

Mising GPF information during a read.

**Checkpoints:**
-   <CK-GPF-MISS-ZERO> GPF Output Zero: Verify GPF-related outputs are 0 on a miss.

---

### Update Operation

<FG-UPDATE>

#### Hit Update

<FC-UPDATE-HIT>

Updating hit information when both vSetIdx and ptag match.

**Checkpoints:**
-   <CK-UPDATE-HIT-WAYMASK> waymask Hit Update: Verify `waymask` and `meta_codes` update on a hit.
-   <CK-UPDATE-HIT-HITS> Hit Flags: Verify corresponding `hits` bits are high on a hit.

#### Miss Update

<FC-UPDATE-MISS>

Scenario where vSetIdx matches but ptag does not (conflict/overwrite).

**Checkpoints:**
-   <CK-UPDATE-MISS-WAYMASK> Miss Clearing: Verify `waymask` is cleared on a conflict.
-   <CK-UPDATE-MISS-HIT> Miss Flags: Verify corresponding `hit` bits are high on a miss.

#### Corrupt Handling

<FC-UPDATE-CORRUPT>

No update is performed when `corrupt=1`.

**Checkpoints:**
-   <CK-CORRUPT-NO-UPDATE> Corrupt No Update: Verify no updates occur when `corrupt=1`.

---

### Boundary Conditions

<FG-EDGE>

#### Queue Boundaries

<FC-EDGE-QUEUE-BOUNDARY>

Boundary condition testing for the queue.

**Checkpoints:**
-   <CK-EDGE-QUEUE-EMPTY> Queue Empty Boundary: Test the scenario where the queue just becomes empty.
-   <CK-EDGE-QUEUE-FULL> Queue Full Boundary: Test the scenario where the queue just becomes full.
-   <CK-EDGE-QUEUE-WRAP> Queue Wraparound Boundary: Test the boundary conditions of pointer wraparound.

#### GPF Boundaries

<FC-EDGE-GPF-BOUNDARY>

Boundary condition testing for GPF handling.

**Checkpoints:**
-   <CK-EDGE-GPF-FIRST> First GPF: Test the first GPF storage after reset/flush.
-   <CK-EDGE-GPF-DOUBLE> Dual-Row GPF: Test that only the first GPF's address is stored in dual-row requests.
-   <CK-EDGE-GPF-OVERLAP> GPF Pointer Overlap: Test the boundary condition where `readPtr === gpfPtr`.

#### Update Conflict Boundaries

<FC-EDGE-UPDATE-BOUNDARY>

Boundary condition testing for update operations.

**Checkpoints:**
-   <CK-EDGE-UPDATE-VSET-MATCH> vSetIdx Match Boundary: Test boundary cases of vSetIdx matching.
-   <CK-EDGE-UPDATE-PTAG-MATCH> ptag Match Boundary: Test boundary cases of ptag matching.

---

### Coverage Storming

<FG-STORM>

#### Brute-Force Randomization

<FC-STORM-RANDOM>

Maximizing coverage through randomized signal injection.

**Checkpoints:**
-   <CK-STORM-BRUTE-FORCE> Brute-Force Storm: Execute 5,000 cycles of randomized inputs to hit deep RTL paths.

#### Systematic Logic Exploration

<FC-STORM-LOGIC>

Exhaustive toggling of all hardware logic branches.

**Checkpoints:**
-   <CK-STORM-LOGIC-SYSTEMATIC> Systematic Logic Toggling: Iterate through all sub-entry update paths and GPF variants.
