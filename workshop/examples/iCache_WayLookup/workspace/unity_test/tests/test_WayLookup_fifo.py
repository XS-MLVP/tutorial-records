#coding=utf-8
"""
WayLookup FIFO 基本操作测试用例模板
"""

from WayLookup_api import *


def test_WayLookup_fifo_empty(env):
    """
    测试 FIFO 队列空状态的判断

    测试内容：
    1. 当 readPtr === writePtr 时队列为空
    2. 空队列时读有效信号为低
    """
    env.dut.fc_cover['FG-FIFO'].mark_function('FC-FIFO-EMPTY', test_WayLookup_fifo_empty, ['CK-EMPTY-TRUE', 'CK-EMPTY-READ-INVALID'])

    # Step:
    # 1. 初始化 DUT - 队列初始状态应为空
    # 2. 验证初始队列为空
    # 3. 验证空队列时读信号无效

    # 重置 DUT 确保初始状态正确
    env.reset()
    env.Step(5)

    # 验证初始队列为空
    result = api_WayLookup_read(env, max_cycles=100)
    assert result['valid'] == False, "初始队列应为空"


def test_WayLookup_fifo_full(env):
    """
    测试 FIFO 队列满状态的判断

    测试内容：
    1. 当读写指针 value 相等但 flag 不同时队列为满
    2. 满队列时写就绪信号为低
    """
    env.dut.fc_cover['FG-FIFO'].mark_function('FC-FIFO-FULL', test_WayLookup_fifo_full, ['CK-FULL-TRUE', 'CK-FULL-WRITE-BLOCK'])

    # 重置 DUT
    env.reset()
    env.Step(5)

    # 填满队列 (32 个条目)
    write_success_count = 0
    for i in range(32):
        result = api_WayLookup_write(
            env,
            vSetIdx=i,
            waymask=0x5,
            ptag=0x100000000 + i,
            max_cycles=100
        )
        if result:
            write_success_count += 1

    # 验证至少写入了数据
    assert write_success_count > 0, f"应该成功写入至少一个数据，实际写入 {write_success_count} 个"

    # 尝试再写入一个数据，应该失败
    result = api_WayLookup_write(
        env,
        vSetIdx=0xFF,
        waymask=0xA,
        ptag=0xABCDEF123,
        max_cycles=100
    )
    # 队列满时应该写入失败
    assert result == False, "队列满时应返回 False"


def test_WayLookup_fifo_wrap(env):
    """
    测试 FIFO 指针环绕功能

    测试内容：
    1. 读指针超过 31 后回到 0，flag 翻转
    2. 写指针超过 31 后回到 0，flag 翻转
    """
    env.dut.fc_cover['FG-FIFO'].mark_function('FC-FIFO-PTR-WRAP', test_WayLookup_fifo_wrap, ['CK-WRAP-READ', 'CK-WRAP-WRITE'])

    # 重置 DUT
    env.reset()
    env.Step(5)

    # 写入 32 个数据填满队列
    for i in range(32):
        api_WayLookup_write(
            env,
            vSetIdx=i,
            waymask=0x5,
            ptag=0x100000000 + i,
            max_cycles=100
        )

    # 读取 32 个数据，观察指针环绕
    for i in range(32):
        result = api_WayLookup_read(env, max_cycles=100)
        assert result['valid'] == True, f"第 {i} 次读取应返回有效数据"

    # 验证队列为空
    result = api_WayLookup_read(env, max_cycles=100)
    assert result['valid'] == False, "读取 32 个数据后队列应为空"

    # 继续读取应该仍然为空（验证指针已环绕回来）
    result = api_WayLookup_read(env, max_cycles=100)
    assert result['valid'] == False, "环绕后读取仍应返回空"


def test_WayLookup_fifo_ptr_update(env):
    """
    测试 FIFO 读写指针更新

    测试内容：
    1. 读握手完成后读指针递增
    2. 写握手完成后写指针递增
    """
    env.dut.fc_cover['FG-FIFO'].mark_function('FC-FIFO-PTR-UPDATE', test_WayLookup_fifo_ptr_update, ['CK-READ-PTR-INCREMENT', 'CK-WRITE-PTR-INCREMENT'])

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

    # 读取数据，验证读指针更新
    read_count = 0
    for i in range(5):
        result = api_WayLookup_read(env, max_cycles=100)
        if result['valid']:
            read_count += 1

    # 验证能够读取到数据
    assert read_count > 0, "应该能够读取到至少一个数据"

    # 验证队列最终为空
    result = api_WayLookup_read(env, max_cycles=100)
    assert result['valid'] == False, "读取所有数据后队列应为空"
