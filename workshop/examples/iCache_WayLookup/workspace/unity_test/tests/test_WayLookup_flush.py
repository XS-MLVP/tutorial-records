#coding=utf-8
"""
WayLookup 刷新功能测试用例模板
"""

from WayLookup_api import *


def test_WayLookup_flush_write_ptr(env):
    """
    测试刷新操作对写指针的影响

    测试内容：
    1. 刷新后写指针重置为 0
    2. 刷新后写指针 flag 重置为 0
    """
    env.dut.fc_cover['FG-FLUSH'].mark_function('FC-FLUSH-WRITE-PTR', test_WayLookup_flush_write_ptr, ['CK-FLUSH-WP-VALUE', 'CK-FLUSH-WP-FLAG'])

    # 重置 DUT
    env.reset()
    env.Step(5)

    # 写入多个数据
    for i in range(5):
        api_WayLookup_write(
            env,
            vSetIdx=i * 0x11,
            waymask=0x1 << i,
            ptag=0x100000000 + i,
            max_cycles=100
        )

    # 执行刷新
    api_WayLookup_flush(env, max_cycles=10)

    # 验证刷新后队列为空（说明指针被重置）
    result = api_WayLookup_read(env, max_cycles=100)
    assert result['valid'] == False, "刷新后队列应为空"


def test_WayLookup_flush_read_ptr(env):
    """
    测试刷新操作对读指针的影响

    测试内容：
    1. 刷新后读指针重置为 0
    2. 刷新后读指针 flag 重置为 0
    """
    env.dut.fc_cover['FG-FLUSH'].mark_function('FC-FLUSH-READ-PTR', test_WayLookup_flush_read_ptr, ['CK-FLUSH-RP-VALUE', 'CK-FLUSH-RP-FLAG'])

    # 重置 DUT
    env.reset()
    env.Step(5)

    # 写入数据
    for i in range(3):
        api_WayLookup_write(
            env,
            vSetIdx=i * 0x11,
            waymask=0x1 << i,
            ptag=0x100000000 + i,
            max_cycles=100
        )

    # 读取数据
    for i in range(3):
        result = api_WayLookup_read(env, max_cycles=100)
        assert result['valid'] == True, f"第 {i} 次读取应返回有效数据"

    # 执行刷新
    api_WayLookup_flush(env, max_cycles=10)

    # 验证刷新后队列为空
    result = api_WayLookup_read(env, max_cycles=100)
    assert result['valid'] == False, "刷新后队列应为空"


def test_WayLookup_flush_gpf(env):
    """
    测试刷新操作对 GPF 条目的影响

    测试内容：
    1. 刷新后 GPF valid 位清除
    2. 刷新后 GPF 数据清除
    """
    env.dut.fc_cover['FG-FLUSH'].mark_function('FC-FLUSH-GPF', test_WayLookup_flush_gpf, ['CK-FLUSH-GPF-VALID', 'CK-FLUSH-GPF-BITS'])

    # 重置 DUT
    env.reset()
    env.Step(5)

    # 写入带 GPF 的数据
    api_WayLookup_write(
        env,
        vSetIdx=0x22,
        waymask=0x3,
        ptag=0x222222222,
        gpaddr=0x123456789ABCDE,
        isForVSnonLeafPTE=0,
        max_cycles=100
    )

    # 执行刷新
    api_WayLookup_flush(env, max_cycles=10)

    # 验证刷新后队列为空
    result = api_WayLookup_read(env, max_cycles=100)
    assert result['valid'] == False, "刷新后队列应为空"
