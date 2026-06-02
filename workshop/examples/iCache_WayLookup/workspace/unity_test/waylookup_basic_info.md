# WayLookup Basic Information

## 1. Module Overview

WayLookup is a FIFO circular queue module in the RISC-V processor front-end, used to cache metadata obtained by IPrefetchPipe querying MetaArray and ITLB.

### 1.1 Basic Parameters

| Parameter | Value | Description |
|-----------|-------|-------------|
| Queue Depth | 32 | FIFO circular queue depth |
| R/W Pointers | 5-bit value + 1-bit flag | Pointer management method |
| Module Type | Sequential Circuit | Requires clock drive |

### 1.2 Circuit Type

- **Sequential Circuit**: Driven by clock and reset signals.
- Drive Method: Use the `Step()` interface to advance the simulation.

## 2. Interface Definition

### 2.1 System Signals

| Signal Name | Direction | Width | Description |
|-------------|-----------|-------|-------------|
| clock | Input | 1 | Clock signal |
| reset | Input | 1 | Reset signal |
| io_flush | Input | 1 | Global flush signal, from FTQ |

### 2.2 Read Interface (MainPipe)

| Signal Name | Direction | Width | Description |
|-------------|-----------|-------|-------------|
| io_read_ready | Input | 1 | Read ready signal |
| io_read_valid | Output | 1 | Read valid signal |
| io_read_bits_entry_vSetIdx_0 | Output | 8 | Virtual address cache set index (Row 0) |
| io_read_bits_entry_vSetIdx_1 | Output | 8 | Virtual address cache set index (Row 1) |
| io_read_bits_entry_waymask_0 | Output | 4 | Way mask (Row 0) |
| io_read_bits_entry_waymask_1 | Output | 4 | Way mask (Row 1) |
| io_read_bits_entry_ptag_0 | Output | 36 | Physical address tag (Row 0) |
| io_read_bits_entry_ptag_1 | Output | 36 | Physical address tag (Row 1) |
| io_read_bits_entry_itlb_exception_0 | Output | 2 | ITLB exception indicator (Row 0) |
| io_read_bits_entry_itlb_exception_1 | Output | 2 | ITLB exception indicator (Row 1) |
| io_read_bits_entry_itlb_pbmt_0 | Output | 2 | ITLB PBMT indicator (Row 0) |
| io_read_bits_entry_itlb_pbmt_1 | Output | 2 | ITLB PBMT indicator (Row 1) |
| io_read_bits_entry_meta_codes_0 | Output | 1 | Meta ECC check code (Row 0) |
| io_read_bits_entry_meta_codes_1 | Output | 1 | Meta ECC check code (Row 1) |
| io_read_bits_gpf_gpaddr | Output | 56 | Guest physical address |
| io_read_bits_gpf_isForVSnonLeafPTE | Output | 1 | Non-leaf PTE indicator |

### 2.3 Write Interface (IPrefetchPipe)

| Signal Name | Direction | Width | Description |
|-------------|-----------|-------|-------------|
| io_write_ready | Output | 1 | Write ready signal |
| io_write_valid | Input | 1 | Write valid signal |
| io_write_bits_entry_vSetIdx_0 | Input | 8 | Virtual address cache set index (Row 0) |
| io_write_bits_entry_vSetIdx_1 | Input | 8 | Virtual address cache set index (Row 1) |
| io_write_bits_entry_waymask_0 | Input | 4 | Way mask (Row 0) |
| io_write_bits_entry_waymask_1 | Input | 4 | Way mask (Row 1) |
| io_write_bits_entry_ptag_0 | Input | 36 | Physical address tag (Row 0) |
| io_write_bits_entry_ptag_1 | Input | 36 | Physical address tag (Row 1) |
| io_write_bits_entry_itlb_exception_0 | Input | 2 | ITLB exception indicator (Row 0) |
| io_write_bits_entry_itlb_exception_1 | Input | 2 | ITLB exception indicator (Row 1) |
| io_write_bits_entry_itlb_pbmt_0 | Input | 2 | ITLB PBMT indicator (Row 0) |
| io_write_bits_entry_itlb_pbmt_1 | Input | 2 | ITLB PBMT indicator (Row 1) |
| io_write_bits_entry_meta_codes_0 | Input | 1 | Meta ECC check code (Row 0) |
| io_write_bits_entry_meta_codes_1 | Input | 1 | Meta ECC check code (Row 1) |
| io_write_bits_gpf_gpaddr | Input | 56 | Guest physical address |
| io_write_bits_gpf_isForVSnonLeafPTE | Input | 1 | Non-leaf PTE indicator |

### 2.4 Update Interface (MissUnit)

| Signal Name | Direction | Width | Description |
|-------------|-----------|-------|-------------|
| io_update_valid | Input | 1 | Update valid signal |
| io_update_bits_blkPaddr | Input | 42 | Cache line physical address (bits [41:6] compared with ptag) |
| io_update_bits_vSetIdx | Input | 8 | Virtual address cache set index |
| io_update_bits_waymask | Input | 4 | Way selection |
| io_update_bits_corrupt | Input | 1 | Data corruption indicator |

## 3. Function Classification

### 3.1 Main Functions

| Function Category | Description | Number of Function Points |
|-------------------|-------------|--------------------------|
| Flush Operation | Reset R/W pointers and GPF info | 3 |
| Pointer Update | Update pointers based on handshake | 2 |
| Write Operation | IPrefetchPipe write data | 5 |
| Read Operation | MainPipe read data | 6 |
| Update Operation | MissUnit update hit information | 3 |
| GPF Handling | Guest Page Fault handling | 5 |

**Total**: Approximately 24 function points.

## 4. Data Structure

### 4.1 WayLookupEntry

Used to store metadata for a single row request:

| Field | Width | Description |
|-------|-------|-------------|
| vSetIdx | 8 | Virtual address cache set index |
| waymask | 4 | Way mask from MSHR |
| ptag | 36 | Physical address tag |
| itlb_exception | 2 | ITLB exception indicator |
| itlb_pbmt | 2 | ITLB PBMT indicator |
| meta_codes | 1 | Meta ECC check code |

### 4.2 WayLookupGPFEntry

Used to store GPF-related information:

| Field | Width | Description |
|-------|-------|-------------|
| gpaddr | 56 | Guest physical address |
| isForVSnonLeafPTE | 1 | Non-leaf PTE indicator |

## 5. Key States

### 5.1 Empty/Full Determination

- **Empty**: readPtr === writePtr (both value and flag are equal)
- **Full**: readPtr === writePtr (values are equal but flags are different)

### 5.2 Pointer Wraparound

- When the value exceeds 31 (0x1F), it returns to 0, and the flag toggles.
- The flag is used to distinguish between empty and full boundary conditions.

## 6. Special Mechanisms

### 6.1 Bypass Read

When the queue is empty (readPtr === writePtr) but there is a write request, the write data can be bypassed directly to the read port.

### 6.2 GPF Stop Mechanism

When GPF information exists and has not been read, write operations will be blocked to prevent overwriting GPF information.

### 6.3 Hit Information Update

After MissUnit completes a Cache miss, it updates waymask and meta_codes based on the match of vSetIdx and ptag.
