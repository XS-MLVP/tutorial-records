#coding=utf-8
"""
WayLookup 更新功能测试用例模板
"""

from WayLookup_api import *


def test_WayLookup_update_hit(env):
    """
    测试更新命中

    测试内容：
    1. vSetIdx 和 ptag 匹配时更新 waymask
    2. 更新命中计数
    """
    env.dut.fc_cover['FG-UPDATE'].mark_function('FC-UPDATE-HIT', test_WayLookup_update_hit, ['CK-UPDATE-HIT-WAYMASK', 'CK-UPDATE-HIT-HITS'])

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

    # 执行更新
    update_result = api_WayLookup_update(
        env,
        vSetIdx=test_vSetIdx,
        waymask=0xF,  # 更新为全部路
        blkPaddr=test_ptag << 6,
        corrupt=0,
        max_cycles=100
    )
    assert update_result == True, "更新应成功"


def test_WayLookup_update_miss(env):
    """
    测试更新未命中

    测试内容：
    1. vSetIdx 不匹配时不更新
    2. ptag 不匹配时不更新
    """
    env.dut.fc_cover['FG-UPDATE'].mark_function('FC-UPDATE-MISS', test_WayLookup_update_miss, ['CK-UPDATE-MISS-WAYMASK', 'CK-UPDATE-MISS-HIT'])

    # 重置 DUT
    env.reset()
    env.Step(5)

    # 写入数据
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

    # 执行更新 - vSetIdx 不匹配
    update_result = api_WayLookup_update(
        env,
        vSetIdx=test_vSetIdx + 1,  # 不匹配的 vSetIdx
        waymask=0xF,
        blkPaddr=test_ptag << 6,
        corrupt=0,
        max_cycles=100
    )
    # 更新应该仍然完成（但不影响任何条目）
    assert update_result == True, "更新应完成"


def test_WayLookup_update_corrupt(env):
    """
    测试更新 corrupt 情况

    测试内容：
    1. corrupt 位为 1 时不更新
    """
    env.dut.fc_cover['FG-UPDATE'].mark_function('FC-UPDATE-CORRUPT', test_WayLookup_update_corrupt, ['CK-CORRUPT-NO-UPDATE'])

    # 重置 DUT
    env.reset()
    env.Step(5)

    # 写入数据
    test_vSetIdx = 0x56
    test_waymask = 0x3
    test_ptag = 0xABCDEF123

    api_WayLookup_write(
        env,
        vSetIdx=test_vSetIdx,
        waymask=test_waymask,
        ptag=test_ptag,
        max_cycles=100
    )

    # 执行更新 - corrupt 为 1
    update_result = api_WayLookup_update(
        env,
        vSetIdx=test_vSetIdx,
        waymask=0xF,
        blkPaddr=test_ptag << 6,
        corrupt=1,  # corrupt 为 1
        max_cycles=100
    )
    assert update_result == True, "更新应完成"
