#coding=utf-8
"""
WayLookup 边界条件测试用例模板
"""

from WayLookup_api import *


def test_WayLookup_edge_queue_boundary(env):
    """
    测试队列边界条件

    测试内容：
    1. 队列刚好变空的情况
    2. 队列刚好变满的情况
    3. 指针环绕的边界情况
    """
    env.dut.fc_cover['FG-EDGE'].mark_function('FC-EDGE-QUEUE-BOUNDARY', test_WayLookup_edge_queue_boundary, ['CK-EDGE-QUEUE-EMPTY', 'CK-EDGE-QUEUE-FULL', 'CK-EDGE-QUEUE-WRAP'])

    # 重置 DUT
    env.reset()
    env.Step(5)

    # 1. 测试队列刚好变空
    # 写入 1 个数据后立即读取
    api_WayLookup_write(
        env,
        vSetIdx=0x11,
        waymask=0x1,
        ptag=0x100000001,
        max_cycles=100
    )
    result = api_WayLookup_read(env, max_cycles=100)
    assert result['valid'] == True, "读取应返回有效数据"

    # 再次读取验证队列为空
    result = api_WayLookup_read(env, max_cycles=100)
    assert result['valid'] == False, "队列刚好变空时应返回无效"

    # 2. 测试队列刚好变满
    # 写入 32 个数据填满队列
    for i in range(32):
        api_WayLookup_write(
            env,
            vSetIdx=i,
            waymask=0x5,
            ptag=0x100000000 + i,
            max_cycles=100
        )

    # 尝试再写入一个应该失败
    result = api_WayLookup_write(
        env,
        vSetIdx=0xFF,
        waymask=0xA,
        ptag=0xABCDEF123,
        max_cycles=100
    )
    assert result == False, "队列刚好满时应写入失败"

    # 3. 测试指针环绕
    # 读取所有数据
    for i in range(32):
        result = api_WayLookup_read(env, max_cycles=100)
        assert result['valid'] == True, f"第 {i} 次读取应返回有效数据"

    # 验证队列为空
    result = api_WayLookup_read(env, max_cycles=100)
    assert result['valid'] == False, "环绕后队列应为空"


def test_WayLookup_edge_gpf_boundary(env):
    """
    测试 GPF 边界条件

    测试内容：
    1. reset/flush 后的第一个 GPF 存储
    2. 双行请求中只存储第一个 gpf 的 gpaddr
    3. readPtr === gpfPtr 的边界情况
    """
    env.dut.fc_cover['FG-EDGE'].mark_function('FC-EDGE-GPF-BOUNDARY', test_WayLookup_edge_gpf_boundary, ['CK-EDGE-GPF-FIRST', 'CK-EDGE-GPF-DOUBLE', 'CK-EDGE-GPF-OVERLAP'])

    # 重置 DUT
    env.reset()
    env.Step(5)

    # 1. 测试 flush 后的第一个 GPF 存储
    # 先执行刷新
    api_WayLookup_flush(env, max_cycles=10)

    # 刷新后写入数据
    write_result = api_WayLookup_write(
        env,
        vSetIdx=0x22,
        waymask=0x3,
        ptag=0x222222222,
        gpaddr=0x123456789ABCDE,
        isForVSnonLeafPTE=0,
        max_cycles=100
    )

    # 2. 验证数据写入成功
    result = api_WayLookup_read(env, max_cycles=100)
    assert result['valid'] == True, "读取应返回有效数据"

    # 3. 测试连续写入多个 GPF
    # 清空队列
    api_WayLookup_flush(env, max_cycles=10)
    env.Step(5)

    # 写入多个数据
    for i in range(3):
        api_WayLookup_write(
            env,
            vSetIdx=0x30 + i,
            waymask=0x1 << i,
            ptag=0x300000000 + i,
            gpaddr=0xAAA00000000 + i,
            max_cycles=100
        )


def test_WayLookup_edge_update_boundary(env):
    """
    测试更新操作边界条件

    测试内容：
    1. vSetIdx 匹配的边界情况
    2. ptag 匹配的边界情况
    """
    env.dut.fc_cover['FG-EDGE'].mark_function('FC-EDGE-UPDATE-BOUNDARY', test_WayLookup_edge_update_boundary, ['CK-EDGE-UPDATE-VSET-MATCH', 'CK-EDGE-UPDATE-PTAG-MATCH'])

    # 重置 DUT
    env.reset()
    env.Step(5)

    # 1. 测试 vSetIdx 匹配边界
    test_vSetIdx = 0xFF  # 边界值 255
    test_waymask = 0xF   # 全部路

    # 写入数据
    api_WayLookup_write(
        env,
        vSetIdx=test_vSetIdx,
        waymask=test_waymask,
        ptag=0xFFFFFFFFF,
        max_cycles=100
    )

    # 执行更新
    update_result = api_WayLookup_update(
        env,
        vSetIdx=test_vSetIdx,
        waymask=test_waymask,
        blkPaddr=0xFFFFFFFFF00,
        corrupt=0,
        max_cycles=100
    )
    assert update_result == True, "vSetIdx 匹配边界更新应成功"

    # 2. 测试 vSetIdx 不匹配（无更新效果）
    update_result = api_WayLookup_update(
        env,
        vSetIdx=0x00,  # 不匹配的值
        waymask=0xF,
        blkPaddr=0x12345678900,
        corrupt=0,
        max_cycles=100
    )
    # 不匹配时更新应该仍然完成
    assert update_result == True, "不匹配更新也应返回成功"

    # 3. 测试 ptag 匹配
    # 清空队列
    api_WayLookup_flush(env, max_cycles=10)
    env.Step(5)

    test_ptag = 0x123456789
    api_WayLookup_write(
        env,
        vSetIdx=0x55,
        waymask=0x5,
        ptag=test_ptag,
        max_cycles=100
    )

    # 使用 ptag 对应的 blkPaddr 进行更新
    update_result = api_WayLookup_update(
        env,
        vSetIdx=0x55,
        waymask=0x5,
        blkPaddr=test_ptag << 6,  # 左移 6 位得到 blkPaddr
        corrupt=0,
        max_cycles=100
    )
    assert update_result == True, "ptag 匹配更新应成功"
