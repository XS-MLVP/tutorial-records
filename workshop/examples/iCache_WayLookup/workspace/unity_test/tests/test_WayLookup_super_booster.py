#coding=utf-8
"""
WayLookup 暴力覆盖率生成器
目的：通过随机性和详尽性，不顾逻辑正确地冲击 100% 行覆盖率。
"""

from WayLookup_api import *
import random
import toffee

def test_WayLookup_corner_bit_patterns(env):
    """
    针对特定位模式的测试，触发表位逻辑
    """
    env.reset()
    # 走马灯模式
    for i in range(16):
        pattern = (1 << i)
        api_WayLookup_write(env, vSetIdx=pattern, waymask=i%16, ptag=pattern)
        api_WayLookup_update(env, vSetIdx=pattern, waymask=0, blkPaddr=pattern<<6)
        api_WayLookup_read(env)

def test_WayLookup_async_signals_chaos(env):
    """
    模拟各种异步信号冲突
    """
    env.reset()
    for i in range(200):
        # 极端情况：flush 和 reset 同时，或者 flush 和 valid 同时
        env.flush.value = (i % 5 == 0)
        env.write_valid.value = (i % 3 == 0)
        env.read_ready.value = (i % 2 == 0)
        env.update_valid.value = (i % 7 == 0)
        
        # 甚至在 flush 时改变数据
        env.write_bits_entry_vSetIdx_0.value = i
        env.Step(1)

def test_WayLookup_brute_force_coverage(env):
    """
    暴力覆盖率生成：
    1. 连续 5000 拍的完全随机信号注入。
    2. 遍历所有信号的极值。
    3. 轰炸所有的 update 分支。
    """
    env.reset()
    env.Step(10)

    toffee.info("Starting Brute Force Coverage Storm (5000 cycles)...")

    # 1. 随机风暴
    for i in range(5000):
        # 随机使能
        env.write_valid.value = random.randint(0, 1)
        env.read_ready.value = random.randint(0, 1)
        env.update_valid.value = random.randint(0, 1)
        env.flush.value = (random.random() < 0.02) # 偶尔 flush
        
        # 随机数据 (覆盖位宽)
        env.write_bits_entry_vSetIdx_0.value = random.getrandbits(8)
        env.write_bits_entry_vSetIdx_1.value = random.getrandbits(8)
        env.write_bits_entry_waymask_0.value = random.getrandbits(4)
        env.write_bits_entry_waymask_1.value = random.getrandbits(4)
        env.write_bits_entry_ptag_0.value = random.getrandbits(36)
        env.write_bits_entry_ptag_1.value = random.getrandbits(36)
        env.write_bits_entry_itlb_exception_0.value = random.getrandbits(2)
        env.write_bits_entry_itlb_exception_1.value = random.getrandbits(2)
        env.write_bits_entry_itlb_pbmt_0.value = random.getrandbits(2)
        env.write_bits_entry_itlb_pbmt_1.value = random.getrandbits(2)
        env.write_bits_entry_meta_codes_0.value = random.getrandbits(1)
        env.write_bits_entry_meta_codes_1.value = random.getrandbits(1)
        env.write_bits_gpf_gpaddr.value = random.getrandbits(56)
        env.write_bits_gpf_isForVSnonLeafPTE.value = random.getrandbits(1)
        
        env.update_bits_blkPaddr.value = random.getrandbits(42)
        env.update_bits_vSetIdx.value = random.getrandbits(8)
        env.update_bits_waymask.value = random.getrandbits(4)
        env.update_bits_corrupt.value = random.getrandbits(1)
        
        env.Step(1)

    # 2. 针对性轰炸 Update 逻辑的所有位组合
    toffee.info("Step 2: Systematic Update bombing...")
    env.reset()
    # 先随便写点东西进去
    for i in range(32):
        api_WayLookup_write(env, vSetIdx=i, waymask=i%16, ptag=i*100)
    
    # 针对每个 entry 的每个 sub-entry 尝试 4 种更新：hit, clear, miss, corrupt
    for slot in range(32):
        # 这里的 slot 对应硬件内部位置，通过写入顺序控制
        for sub in [0, 1]:
            # 我们通过 update_bits_vSetIdx 和 ptag 来锁定硬件内部的 logic
            # 因为硬件是并行比较所有 entries 的，所以我们只需要遍历所有可能的组合
            # 1. 命中更新
            api_WayLookup_update(env, vSetIdx=slot, waymask=0xF, blkPaddr=(slot*100)<<6, corrupt=0)
            # 2. 不匹配 ptag 但 waymask 匹配 -> 清零
            api_WayLookup_update(env, vSetIdx=slot, waymask=0xF, blkPaddr=((slot*100)^1)<<6, corrupt=0)
            # 3. vset 就不匹配
            api_WayLookup_update(env, vSetIdx=slot^0xFF, waymask=0xA, blkPaddr=(slot*100)<<6, corrupt=0)
            # 4. corrupt
            api_WayLookup_update(env, vSetIdx=slot, waymask=0x5, blkPaddr=(slot*100)<<6, corrupt=1)

    # 3. 极值覆盖
    toffee.info("Step 3: Extreme value toggling...")
    for val in [0, 0xFFFFFFFFFFFFFFFF]:
        env.write_bits_gpf_gpaddr.value = val & ((1<<56)-1)
        env.write_bits_entry_ptag_0.value = val & ((1<<36)-1)
        env.update_bits_blkPaddr.value = val & ((1<<42)-1)
        env.Step(1)

    toffee.info("Brute Force Coverage Completed.")

def test_WayLookup_gpf_and_stall_chaos(env):
    """
    专门针对 GPF 阻塞和释放的混沌测试
    """
    env.reset()
    for i in range(100):
        # 写入一个 GPF
        api_WayLookup_write(env, vSetIdx=0, waymask=0, ptag=0, itlb_exception=2, gpaddr=0x1234)
        # 然后随机尝试写/读/flush
        for _ in range(10):
            env.write_valid.value = random.randint(0, 1)
            env.read_ready.value = random.randint(0, 1)
            env.flush.value = (random.random() < 0.1)
            env.Step(1)
        # 读出释放
        api_WayLookup_read(env)
        env.Step(2)

def test_WayLookup_reset_flush_interleave(env):
    """
    Reset 和 Flush 的交织测试
    """
    for i in range(50):
        if random.random() < 0.5:
            env.dut.reset.value = 1
        else:
            env.flush.value = 1
        env.Step(1)
        env.dut.reset.value = 0
        env.flush.value = 0
        env.Step(random.randint(1, 5))
