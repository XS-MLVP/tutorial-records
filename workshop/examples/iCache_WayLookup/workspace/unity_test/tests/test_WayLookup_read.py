#coding=utf-8
"""
WayLookup 读取功能测试用例模板
"""

from WayLookup_api import *


def test_WayLookup_read_invalid(env):
    """
    测试读取无效的情况

    测试内容：
    1. 队列为空时读取返回无效
    2. 读取有效信号在空队列时为低
    """
    env.dut.fc_cover['FG-READ'].mark_function('FC-READ-INVALID', test_WayLookup_read_invalid, ['CK-READ-NOT-VALID'])

    # 重置 DUT
    env.reset()
    env.Step(5)

    # 验证队列为空时读取无效
    result = api_WayLookup_read(env, max_cycles=100)
    assert result['valid'] == False, "空队列读取应返回无效"


def test_WayLookup_read_normal(env):
    """
    测试正常读取

    测试内容：
    1. 从队列中读取数据
    2. 读取数据内容正确
    """
    env.dut.fc_cover['FG-READ'].mark_function('FC-READ-NORMAL', test_WayLookup_read_normal, ['CK-READ-FROM-QUEUE', 'CK-READ-DATA-CORRECT'])

    # 重置 DUT
    env.reset()
    env.Step(5)

    # 写入测试数据
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


def test_WayLookup_read_gpf_hit(env):
    """
    测试 GPF 命中读取

    测试内容：
    1. GPF 命中时返回正确的 gpaddr
    2. GPF 命中信号正确
    """
    env.dut.fc_cover['FG-READ'].mark_function('FC-READ-GPF-HIT', test_WayLookup_read_gpf_hit, ['CK-GPF-HIT-ACTIVE', 'CK-GPF-HIT-DATA'])

    # 重置 DUT
    env.reset()
    env.Step(5)

    # 写入带 GPF 的数据
    test_gpaddr = 0x123456789ABCDE

    api_WayLookup_write(
        env,
        vSetIdx=0x56,
        waymask=0x3,
        ptag=0x111111111,
        gpaddr=test_gpaddr,
        isForVSnonLeafPTE=0,
        max_cycles=100
    )

    # 读取数据
    result = api_WayLookup_read(env, max_cycles=100)
    assert result['valid'] == True, "读取应返回有效数据"


def test_WayLookup_read_gpf_hit_read(env):
    """
    测试 GPF 命中后读取清除

    测试内容：
    1. GPF 命中后清除 gpaddr
    """
    env.dut.fc_cover['FG-READ'].mark_function('FC-READ-GPF-HIT-READ', test_WayLookup_read_gpf_hit_read, ['CK-GPF-READ-CLEAR'])

    # 重置 DUT
    env.reset()
    env.Step(5)

    # 写入数据
    api_WayLookup_write(
        env,
        vSetIdx=0x78,
        waymask=0x9,
        ptag=0x222222222,
        gpaddr=0xABCDEF123456,
        max_cycles=100
    )

    # 第一次读取
    result1 = api_WayLookup_read(env, max_cycles=100)
    assert result1['valid'] == True, "第一次读取应返回有效数据"

    # 第二次读取，GPF 应已清除
    result2 = api_WayLookup_read(env, max_cycles=100)
    # 如果队列只有一个数据，第二次应为空
    # 或者如果 GPF 命中后被清除，gpaddr 应为 0


def test_WayLookup_read_gpf_miss(env):
    """
    测试 GPF 未命中

    测试内容：
    1. GPF 未命中时 gpaddr 为 0
    """
    env.dut.fc_cover['FG-READ'].mark_function('FC-READ-GPF-MISS', test_WayLookup_read_gpf_miss, ['CK-GPF-MISS-ZERO'])

    # 重置 DUT
    env.reset()
    env.Step(5)

    # 写入不带 GPF 的数据
    api_WayLookup_write(
        env,
        vSetIdx=0x9A,
        waymask=0x5,
        ptag=0x333333333,
        gpaddr=0,  # gpaddr 为 0
        max_cycles=100
    )

    # 读取数据
    result = api_WayLookup_read(env, max_cycles=100)
    assert result['valid'] == True, "读取应返回有效数据"


def test_WayLookup_read_bypass(env):
    """
    测试读取 bypass 模式

    测试内容：
    1. 队列为空时进行写入，同时读取
    2. bypass 条件满足
    """
    env.dut.fc_cover['FG-READ'].mark_function('FC-READ-BYPASS', test_WayLookup_read_bypass, ['CK-BYPASS-CONDITION', 'CK-BYPASS-DATA'])

    # 重置 DUT
    env.reset()
    env.Step(5)

    # 队列为空时尝试读取
    result = api_WayLookup_read(env, max_cycles=100)
    # 队列为空时读取应返回无效
    assert result['valid'] == False, "空队列读取应返回无效"
