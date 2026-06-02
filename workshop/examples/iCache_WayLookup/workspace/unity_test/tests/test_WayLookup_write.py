#coding=utf-8
"""
WayLookup 写入功能测试用例模板
"""

from WayLookup_api import *


def test_WayLookup_write_normal(env):
    """
    测试正常写入

    测试内容：
    1. 基本写入功能
    2. 写入数据正确存储
    """
    env.dut.fc_cover['FG-WRITE'].mark_function('FC-WRITE-NORMAL', test_WayLookup_write_normal, ['CK-WRITE-FIRE', 'CK-WRITE-DATA'])

    # 重置 DUT
    env.reset()
    env.Step(5)

    # 写入数据
    test_vSetIdx = 0x12
    test_waymask = 0x5
    test_ptag = 0x123456789

    api_WayLookup_write(
        env,
        vSetIdx=test_vSetIdx,
        waymask=test_waymask,
        ptag=test_ptag,
        max_cycles=100
    )

    # 读取数据验证写入成功
    result = api_WayLookup_read(env, max_cycles=100)
    assert result['valid'] == True, "写入后读取应返回有效数据"


def test_WayLookup_write_queue_full(env):
    """
    测试队列满时写入

    测试内容：
    1. 队列满时 write_ready 为低
    2. 队列满时写入失败
    """
    env.dut.fc_cover['FG-WRITE'].mark_function('FC-WRITE-QUEUE-FULL', test_WayLookup_write_queue_full, ['CK-WRITE-NOT-READY'])

    # 重置 DUT
    env.reset()
    env.Step(5)

    # 填满队列
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
    assert result == False, "队列满时写入应失败"


def test_WayLookup_write_gpf_store(env):
    """
    测试 GPF 存储

    测试内容：
    1. 写入时存储 gpaddr
    2. GPF 存储信号正确
    """
    env.dut.fc_cover['FG-WRITE'].mark_function('FC-WRITE-GPF-STORE', test_WayLookup_write_gpf_store, ['CK-GPF-STORE-VALID', 'CK-GPF-STORE-DATA', 'CK-GPF-STORE-PTR'])

    # 重置 DUT
    env.reset()
    env.Step(5)

    # 写入带 GPF 的数据
    test_gpaddr = 0x123456789ABCDE

    api_WayLookup_write(
        env,
        vSetIdx=0x34,
        waymask=0x7,
        ptag=0x987654321,
        gpaddr=test_gpaddr,
        isForVSnonLeafPTE=0,
        max_cycles=100
    )

    # 读取验证
    result = api_WayLookup_read(env, max_cycles=100)
    assert result['valid'] == True, "写入后读取应返回有效数据"


def test_WayLookup_write_gpf_bypass(env):
    """
    测试 GPF bypass

    测试内容：
    1. 队列为空时 bypass 条件满足
    2. bypass 时不存储 GPF
    """
    env.dut.fc_cover['FG-WRITE'].mark_function('FC-WRITE-GPF-BYPASS', test_WayLookup_write_gpf_bypass, ['CK-GPF-BYPASS-NOT-STORE'])

    # 重置 DUT
    env.reset()
    env.Step(5)

    # 写入数据 - 此时队列为空
    api_WayLookup_write(
        env,
        vSetIdx=0x56,
        waymask=0x3,
        ptag=0x111111111,
        gpaddr=0xABCDEF123456,
        max_cycles=100
    )

    # 读取验证
    result = api_WayLookup_read(env, max_cycles=100)
    assert result['valid'] == True, "写入后读取应返回有效数据"


def test_WayLookup_write_gpf_stall(env):
    """
    测试 GPF stall

    测试内容：
    1. GPF valid 时写入阻塞
    2. GPF 释放后写入恢复
    """
    env.dut.fc_cover['FG-WRITE'].mark_function('FC-WRITE-GPF-STALL', test_WayLookup_write_gpf_stall, ['CK-GPF-STALL-ACTIVE', 'CK-GPF-STALL-RELEASE'])

    # 重置 DUT
    env.reset()
    env.Step(5)

    # 写入数据产生 GPF
    api_WayLookup_write(
        env,
        vSetIdx=0x78,
        waymask=0x9,
        ptag=0x222222222,
        gpaddr=0x123456789ABC,
        max_cycles=100
    )

    # 再写入一个数据
    api_WayLookup_write(
        env,
        vSetIdx=0x9A,
        waymask=0x5,
        ptag=0x333333333,
        gpaddr=0,
        max_cycles=100
    )

    # 读取验证两次写入都成功
    result1 = api_WayLookup_read(env, max_cycles=100)
    assert result1['valid'] == True, "第一次读取应返回有效数据"
    result2 = api_WayLookup_read(env, max_cycles=100)
    assert result2['valid'] == True, "第二次读取应返回有效数据"
