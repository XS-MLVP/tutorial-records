#coding=utf-8
"""
WayLookup env fixture 测试文件

验证 env fixture 的基本功能是否正常工作。
"""

from WayLookup_api import *


def test_api_WayLookup_env_basic(env):
    """
    测试 WayLookupEnv 的基本功能

    测试内容：
    - env fixture 能否正常工作
    - Step 方法是否能正常推进仿真
    """
    env.dut.fc_cover['FG-API'].mark_function('FC-API-FLUSH', test_api_WayLookup_env_basic, ['CK-FLUSH-BASIC'])
    # 推进仿真时钟
    env.Step(10)
    assert True, "Step 方法正常工作"


def test_api_WayLookup_env_reset(env):
    """
    测试 reset 功能

    测试内容：
    - reset 方法是否能正常复位 DUT
    """
    env.dut.fc_cover['FG-API'].mark_function('FC-API-FLUSH', test_api_WayLookup_env_reset, ['CK-FLUSH-BASIC'])
    # 执行复位
    env.reset()
    # 复位后推进几个时钟周期
    env.Step(5)
    assert True, "reset 方法正常工作"


def test_api_WayLookup_env_flush(env):
    """
    测试 flush 功能

    测试内容：
    - flush 方法是否能正常发送刷新信号
    """
    env.dut.fc_cover['FG-API'].mark_function('FC-API-FLUSH', test_api_WayLookup_env_flush, ['CK-FLUSH-BASIC'])
    # 执行刷新
    env.flush_dut()
    # 刷新后推进一个时钟周期
    env.Step(1)
    assert True, "flush_dut 方法正常工作"


def test_api_WayLookup_env_signals(env):
    """
    测试信号赋值功能

    测试内容：
    - 能否正确赋值输入信号
    """
    env.dut.fc_cover['FG-API'].mark_function('FC-API-WRITE', test_api_WayLookup_env_signals, ['CK-WRITE-BASIC'])
    # 设置写数据
    env.write_valid.value = 1
    env.write_bits_entry_vSetIdx_0.value = 0x12
    env.write_bits_entry_waymask_0.value = 0x5

    # 推进仿真
    env.Step(1)

    # 验证信号已设置
    assert env.write_valid.value == 1
    assert env.write_bits_entry_vSetIdx_0.value == 0x12
    assert env.write_bits_entry_waymask_0.value == 0x5


def test_api_WayLookup_env_read_ready(env):
    """
    测试读就绪信号

    测试内容：
    - 能否正确设置和读取读就绪信号
    """
    env.dut.fc_cover['FG-API'].mark_function('FC-API-READ', test_api_WayLookup_env_read_ready, ['CK-READ-BASIC'])
    env.read_ready.value = 1
    env.Step(1)
    assert env.read_ready.value == 1, "读就绪信号设置成功"
    env.read_ready.value = 0
    env.Step(1)
    assert env.read_ready.value == 0, "读就绪信号清除成功"
