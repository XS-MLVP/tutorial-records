import pytest
from e203_ifu_litebpu_api import *


def test_xn_read_enable(env):
    """验证 JALR rs1=xN ready 首周期发起 rs1 读请求。"""
    env.dut.fc_cover["FG-RS1-READ"].mark_function("FC-RS1-READ-REQUEST", test_xn_read_enable, ["CK-XN-READ-ENABLE"])

    result = api_e203_ifu_litebpu_jalr(env, pc=0x1000, imm=0x20, rs1idx=5, rf2bpu_rs1=0x1234)
    assert result["bpu2rf_rs1_ena"] == 1, "xN ready 首周期应发起 rs1 读请求"

def test_read_with_bypass(env):
    """验证 IR 依赖可旁路时允许 xN 发起 rs1 读请求。"""
    env.dut.fc_cover["FG-RS1-READ"].mark_function("FC-RS1-READ-REQUEST", test_read_with_bypass, ["CK-READ-WITH-BYPASS"])

    result = api_e203_ifu_litebpu_jalr(
        env,
        pc=0x1000,
        imm=0x20,
        rs1idx=5,
        rf2bpu_rs1=0x12345678,
        oitf_empty=1,
        ir_empty=0,
        ir_rs1en=1,
        jalr_rs1idx_cam_irrdidx=1,
        ir_valid_clr=1,
    )
    assert result["bpu2rf_rs1_ena"] == 1, "IR valid 清除旁路时应允许 xN 读 rs1"

def test_no_repeat_read(env):
    """验证连续保持同一 xN JALR 时第二周期不重复发起读请求。"""
    env.dut.fc_cover["FG-RS1-READ"].mark_function("FC-RS1-READ-STATE", test_no_repeat_read, ["CK-NO-REPEAT-READ"])

    first = api_e203_ifu_litebpu_jalr(env, pc=0x1000, imm=0x20, rs1idx=5, rf2bpu_rs1=0x1234)
    second = api_e203_ifu_litebpu_jalr(env, pc=0x1000, imm=0x20, rs1idx=5, rf2bpu_rs1=0x1234)
    assert first["bpu2rf_rs1_ena"] == 1, "首个 xN ready 周期应读 rs1"
    assert second["bpu2rf_rs1_ena"] == 0, "读状态置位后的下一周期不应重复读 rs1"

def test_read_state_clear(env):
    """验证 xN 读状态置位后遇到非 JALR 输入会清除读请求输出。"""
    env.dut.fc_cover["FG-RS1-READ"].mark_function("FC-RS1-READ-STATE", test_read_state_clear, ["CK-READ-STATE-CLEAR"])

    api_e203_ifu_litebpu_jalr(env, pc=0x1000, imm=0x20, rs1idx=5, rf2bpu_rs1=0x1234)
    result = api_e203_ifu_litebpu_predict(env, pc=0x1004, dec_i_valid=1)
    assert result["bpu2rf_rs1_ena"] == 0, "非 JALR 周期应清除 xN 读请求输出"

def test_invalid_no_read(env):
    """验证 dec_i_valid=0 的 xN JALR 不发起 rs1 读请求。"""
    env.dut.fc_cover["FG-RS1-READ"].mark_function("FC-RS1-READ-GATING", test_invalid_no_read, ["CK-INVALID-NO-READ"])

    result = api_e203_ifu_litebpu_predict(
        env, pc=0x1000, dec_jalr=1, dec_jalr_rs1idx=5, dec_i_valid=0, rf2bpu_rs1=0x1234
    )
    assert result["bpu2rf_rs1_ena"] == 0, "无效 xN JALR 不应发起 rs1 读请求"

def test_non_jalr_no_read(env):
    """验证非 JALR 指令不发起 xN rs1 读请求。"""
    env.dut.fc_cover["FG-RS1-READ"].mark_function("FC-RS1-READ-GATING", test_non_jalr_no_read, ["CK-NON-JALR-NO-READ"])

    result = api_e203_ifu_litebpu_jal(env, pc=0x1000, imm=0x20)
    assert result["bpu2rf_rs1_ena"] == 0, "JAL 不应发起 xN rs1 读请求"

def test_x0_x1_no_xn_read(env):
    """验证 JALR rs1=x0/x1 不走 xN rs1 读请求路径。"""
    env.dut.fc_cover["FG-RS1-READ"].mark_function("FC-RS1-READ-GATING", test_x0_x1_no_xn_read, ["CK-X0-X1-NO-XN-READ"])

    x0 = api_e203_ifu_litebpu_jalr(env, pc=0x1000, imm=0x20, rs1idx=0)
    x1 = api_e203_ifu_litebpu_jalr(env, pc=0x1000, imm=0x20, rs1idx=1, rf2bpu_x1=0x1234)
    assert x0["bpu2rf_rs1_ena"] == 0, "JALR x0 不应发起 xN rs1 读请求"
    assert x1["bpu2rf_rs1_ena"] == 0, "JALR x1 不应发起 xN rs1 读请求"

def test_dependency_no_read(env):
    """验证 xN 依赖未解除时等待且不发起 rs1 读请求。"""
    env.dut.fc_cover["FG-RS1-READ"].mark_function("FC-RS1-READ-GATING", test_dependency_no_read, ["CK-DEPENDENCY-NO-READ"])

    result = api_e203_ifu_litebpu_jalr(env, pc=0x1000, imm=0x20, rs1idx=5, rf2bpu_rs1=0x1234, oitf_empty=0)
    assert result["bpu_wait"] == 1, "xN OITF 依赖未解除时应等待"
    assert result["bpu2rf_rs1_ena"] == 0, "xN 依赖未解除时不应读 rs1"
