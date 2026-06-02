#coding=utf-8
"""
WayLookup API 测试用例模板
这些模板用于覆盖 FG-API 分组的检测点
"""

from WayLookup_api import *


def test_WayLookup_api_flush(env):
    """
    测试 API 刷新功能

    测试内容：
    1. 刷新 API 基本功能
    2. 刷新后队列状态验证
    """
    env.dut.fc_cover['FG-API'].mark_function('FC-API-FLUSH', test_WayLookup_api_flush, ['CK-FLUSH-BASIC'])

    # 测试流程：
    # 1. 重置 DUT
    # 2. 写入一些数据
    # 3. 调用刷新 API
    # 4. 验证队列被清空

    # 重置 DUT
    env.reset()
    env.Step(5)

    # 写入数据
    test_vSetIdx = 0x12
    test_waymask = 0x5
    test_ptag = 0x123456789

    write_result = api_WayLookup_write(
        env,
        vSetIdx=test_vSetIdx,
        waymask=test_waymask,
        ptag=test_ptag,
        max_cycles=100
    )

    # 调用刷新 API
    flush_result = api_WayLookup_flush(env, max_cycles=10)
    assert flush_result == True, "刷新操作应该成功"

    # 验证刷新后队列为空
    read_result = api_WayLookup_read(env, max_cycles=100)
    assert read_result['valid'] == False, "刷新后队列应该为空"


def test_WayLookup_api_write(env):
    """
    测试 API 写入功能

    测试内容：
    1. 基本写入功能
    2. 队列满时写入阻塞
    """
    env.dut.fc_cover['FG-API'].mark_function('FC-API-WRITE', test_WayLookup_api_write, ['CK-WRITE-BASIC', 'CK-WRITE-FULL'])

    # 重置 DUT
    env.reset()
    env.Step(5)

    # 测试队列满时写入
    # 先填满队列
    for i in range(32):
        api_WayLookup_write(
            env,
            vSetIdx=i,
            waymask=0x5,
            ptag=0x100000000 + i,
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


def test_WayLookup_api_read(env):
    """
    测试 API 读取功能

    测试内容：
    1. 基本读取功能
    2. 空队列时读取无效
    """
    env.dut.fc_cover['FG-API'].mark_function('FC-API-READ', test_WayLookup_api_read, ['CK-READ-BASIC', 'CK-READ-EMPTY'])

    # 重置 DUT
    env.reset()
    env.Step(5)

    # 测试空队列读取
    empty_result = api_WayLookup_read(env, max_cycles=100)
    assert empty_result['valid'] == False, "空队列读取应返回 invalid"

    # 测试基本读取
    test_vSetIdx = 0x56
    test_waymask = 0x3
    test_ptag = 0x111111111

    api_WayLookup_write(
        env,
        vSetIdx=test_vSetIdx,
        waymask=test_waymask,
        ptag=test_ptag,
        max_cycles=100
    )

    read_result = api_WayLookup_read(env, max_cycles=100)
    assert read_result['valid'] == True, "读取应返回有效数据"


def test_WayLookup_api_update(env):
    """
    测试 API 更新功能

    测试内容：
    1. 基本更新功能
    2. 更新参数验证
    """
    env.dut.fc_cover['FG-API'].mark_function('FC-API-UPDATE', test_WayLookup_api_update, ['CK-UPDATE-BASIC'])

    # 重置 DUT
    env.reset()
    env.Step(5)

    # 先写入数据
    test_vSetIdx = 0x78
    test_waymask = 0x9
    test_ptag = 0x222222222

    api_WayLookup_write(
        env,
        vSetIdx=test_vSetIdx,
        waymask=test_waymask,
        ptag=test_ptag,
        max_cycles=100
    )

    # 执行更新操作
    update_result = api_WayLookup_update(
        env,
        vSetIdx=test_vSetIdx,
        waymask=test_waymask,
        blkPaddr=test_ptag << 6,
        corrupt=0,
        max_cycles=100
    )

    # 验证更新结果
    assert update_result == True, "更新 API 应返回 True"
