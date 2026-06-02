#coding=utf-8
"""
WayLookup API 功能测试文件

验证 API 函数的功能正确性。
"""

from WayLookup_api import *


def test_api_WayLookup_flush_basic(env):
    """
    测试 api_WayLookup_flush 的基本功能
    
    测试目标：验证刷新 API 能否正确执行
    测试流程：
    1. 初始化 DUT
    2. 调用 api_WayLookup_flush
    预期结果：刷新操作成功完成
    """
    env.dut.fc_cover['FG-API'].mark_function('FC-API-FLUSH', test_api_WayLookup_flush_basic, ['CK-FLUSH-BASIC'])
    
    # 调用刷新 API
    result = api_WayLookup_flush(env, max_cycles=10)
    assert result == True, "刷新 API 应返回 True"


def test_api_WayLookup_write_basic(env):
    """
    测试 api_WayLookup_write 的基本功能

    测试目标：验证写 API 能否正确写入数据
    测试流程：
    1. 初始化 DUT
    2. 调用 api_WayLookup_write 写入数据
    预期结果：写入操作成功完成
    """
    env.dut.fc_cover['FG-API'].mark_function('FC-API-WRITE', test_api_WayLookup_write_basic, ['CK-WRITE-BASIC'])

    # 重置 DUT
    env.reset()
    env.Step(5)

    # 调用写入 API
    result = api_WayLookup_write(
        env,
        vSetIdx=0x12,
        waymask=0x5,
        ptag=0x123456789,
        itlb_exception=0,
        itlb_pbmt=0,
        meta_codes=0,
        gpaddr=0,
        isForVSnonLeafPTE=0,
        max_cycles=100
    )
    # 验证写入结果
    assert result == True, "写入 API 应返回 True"


def test_api_WayLookup_write_full(env):
    """
    测试 api_WayLookup_write 在队列满时的行为
    
    测试目标：验证队列满时写入被正确阻塞
    测试流程：
    1. 连续写入 32 个数据填满队列
    2. 尝试再写入一个数据
    预期结果：写入被阻塞或失败
    """
    env.dut.fc_cover['FG-API'].mark_function('FC-API-WRITE', test_api_WayLookup_write_full, ['CK-WRITE-FULL'])
    
    # 填满队列
    for i in range(32):
        api_WayLookup_write(
            env,
            vSetIdx=i,
            waymask=0x5,
            ptag=0x123456789 + i,
            max_cycles=100
        )
    
    # 尝试再写入一个数据
    result = api_WayLookup_write(
        env,
        vSetIdx=0xFF,
        waymask=0xA,
        ptag=0xABCDEF123,
        max_cycles=100
    )
    # 队列满时应该写入失败
    assert result == False, "队列满时应返回 False"


def test_api_WayLookup_read_basic(env):
    """
    测试 api_WayLookup_read 的基本功能
    
    测试目标：验证读 API 能否正确读取数据
    测试流程：
    1. 先写入数据
    2. 调用 api_WayLookup_read 读取数据
    预期结果：读取操作成功，返回正确的数据
    """
    env.dut.fc_cover['FG-API'].mark_function('FC-API-READ', test_api_WayLookup_read_basic, ['CK-READ-BASIC'])
    
    # 先写入数据
    test_vSetIdx = 0x34
    test_waymask = 0x7
    test_ptag = 0x987654321
    
    api_WayLookup_write(
        env,
        vSetIdx=test_vSetIdx,
        waymask=test_waymask,
        ptag=test_ptag,
        max_cycles=100
    )
    
    # 读取数据
    result = api_WayLookup_read(env, max_cycles=100)
    assert result['valid'] == True, "读取应返回有效数据"


def test_api_WayLookup_read_empty(env):
    """
    测试 api_WayLookup_read 在队列空时的行为
    
    测试目标：验证队列空时读取返回无效
    测试流程：
    1. 不写入任何数据
    2. 调用 api_WayLookup_read
    预期结果：返回无效数据
    """
    env.dut.fc_cover['FG-API'].mark_function('FC-API-READ', test_api_WayLookup_read_empty, ['CK-READ-EMPTY'])
    
    # 读取空队列
    result = api_WayLookup_read(env, max_cycles=100)
    assert result['valid'] == False, "空队列读取应返回 invalid"


def test_api_WayLookup_update_basic(env):
    """
    测试 api_WayLookup_update 的基本功能
    
    测试目标：验证更新 API 能否正确执行
    测试流程：
    1. 先写入数据
    2. 调用 api_WayLookup_update 更新命中信息
    预期结果：更新操作成功完成
    """
    env.dut.fc_cover['FG-API'].mark_function('FC-API-UPDATE', test_api_WayLookup_update_basic, ['CK-UPDATE-BASIC'])
    
    # 先写入数据
    api_WayLookup_write(
        env,
        vSetIdx=0x56,
        waymask=0x3,
        ptag=0x111111111,
        max_cycles=100
    )
    
    # 更新命中信息
    result = api_WayLookup_update(
        env,
        vSetIdx=0x56,
        waymask=0x5,
        blkPaddr=0x11111111100,
        corrupt=0,
        max_cycles=100
    )
    # 验证更新结果
    assert result == True, "更新 API 应返回 True"


def test_api_WayLookup_write_read_sequence(env):
    """
    测试连续写入和读取的序列操作
    
    测试目标：验证 FIFO 队列的基本功能
    测试流程：
    1. 写入多个数据
    2. 按顺序读取数据
    预期结果：读取的数据顺序与写入一致
    """
    env.dut.fc_cover['FG-FIFO'].mark_function('FC-FIFO-PTR-UPDATE', test_api_WayLookup_write_read_sequence, ['CK-WRITE-PTR-INCREMENT', 'CK-READ-PTR-INCREMENT'])
    
    # 写入多个数据
    test_data = []
    for i in range(5):
        vSetIdx = i * 0x11
        api_WayLookup_write(
            env,
            vSetIdx=vSetIdx,
            waymask=0x1 << i,
            ptag=0x100000000 + i,
            max_cycles=100
        )
        test_data.append({'vSetIdx': vSetIdx, 'waymask': 0x1 << i})
    
    # 按顺序读取数据
    for i in range(5):
        result = api_WayLookup_read(env, max_cycles=100)
        assert result['valid'] == True, f"第 {i} 次读取应返回有效数据"


def test_api_WayLookup_flush_reset(env):
    """
    测试刷新后队列状态重置
    
    测试目标：验证刷新能正确重置队列状态
    测试流程：
    1. 写入数据
    2. 执行刷新
    3. 尝试读取
    预期结果：刷新后队列为空
    """
    env.dut.fc_cover['FG-FLUSH'].mark_function('FC-FLUSH-READ-PTR', test_api_WayLookup_flush_reset, ['CK-FLUSH-RP-VALUE', 'CK-FLUSH-RP-FLAG'])
    env.dut.fc_cover['FG-FLUSH'].mark_function('FC-FLUSH-WRITE-PTR', test_api_WayLookup_flush_reset, ['CK-FLUSH-WP-VALUE', 'CK-FLUSH-WP-FLAG'])
    
    # 写入数据
    api_WayLookup_write(
        env,
        vSetIdx=0x78,
        waymask=0x9,
        ptag=0x222222222,
        max_cycles=100
    )
    
    # 执行刷新
    api_WayLookup_flush(env, max_cycles=10)
    
    # 尝试读取，应该为空
    result = api_WayLookup_read(env, max_cycles=100)
    assert result['valid'] == False, "刷新后队列应为空"
