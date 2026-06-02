import pytest
from e203_ifu_litebpu_api import *


def test_create_clock(env):
    """验证 DUT 已创建 Step 时钟推进接口。"""
    env.dut.fc_cover["FG-API"].mark_function("FC-DUT-LIFECYCLE", test_create_clock, ["CK-CREATE-CLOCK"])

    env.set_defaults()
    env.Step(1)
    result = env.sample_outputs()
    assert result["bpu_wait"] == 0, "默认输入下 Step 推进后 BPU 不应等待"

def test_coverage_wave(env):
    """验证 DUT 已配置覆盖率和波形生成接口。"""
    env.dut.fc_cover["FG-API"].mark_function("FC-DUT-LIFECYCLE", test_coverage_wave, ["CK-COVERAGE-WAVE"])

    env.set_defaults()
    env.Step(1)
    result = env.sample_outputs()
    assert result["bpu2rf_rs1_ena"] == 0, "默认输入下覆盖/波形采样周期不应产生 rs1 读请求"

def test_reset_assert(env):
    """验证复位拉低时读寄存器请求被清零。"""
    env.dut.fc_cover["FG-API"].mark_function("FC-RESET-API", test_reset_assert, ["CK-RESET-ASSERT"])

    env.set_defaults()
    env.ctrl.rst_n.value = 0
    env.Step(1)
    result = env.sample_outputs()
    assert result["bpu2rf_rs1_ena"] == 0, "rst_n=0 时应清除 rs1 读请求"

def test_reset_release(env):
    """验证复位释放后可立即响应有效分支预测输入。"""
    env.dut.fc_cover["FG-API"].mark_function("FC-RESET-API", test_reset_release, ["CK-RESET-RELEASE"])

    api_e203_ifu_litebpu_reset(env)
    result = api_e203_ifu_litebpu_jal(env, pc=0x1000, imm=0x20)
    assert result["prdt_taken"] == 1, "复位释放后一条有效 JAL 应被预测为 taken"

def test_drive_defaults(env):
    """验证默认驱动能产生稳定的无分支输出。"""
    env.dut.fc_cover["FG-API"].mark_function("FC-PREDICT-API", test_drive_defaults, ["CK-DRIVE-DEFAULTS"])

    env.set_defaults()
    env.Step(1)
    result = env.sample_outputs()
    assert result["prdt_taken"] == 0, "默认无译码输入时不应预测跳转"

def test_sample_outputs(env):
    """验证 sample_outputs 能采样 JAL 预测公开输出。"""
    env.dut.fc_cover["FG-API"].mark_function("FC-PREDICT-API", test_sample_outputs, ["CK-SAMPLE-OUTPUTS"])

    result = api_e203_ifu_litebpu_jal(env, pc=0x12345678, imm=0x40)
    sampled = env.sample_outputs()
    assert sampled["prdt_pc_add_op1"] == result["prdt_pc_add_op1"], "sample_outputs 应返回当前 PC 加法操作数"

