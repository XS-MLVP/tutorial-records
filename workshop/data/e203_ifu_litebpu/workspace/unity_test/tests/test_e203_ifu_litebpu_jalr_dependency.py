import pytest
from e203_ifu_litebpu_api import *


def test_x1_oitf_busy_wait(env):
    """验证 JALR rs1=x1 且 OITF 非空时必须等待。"""
    env.dut.fc_cover["FG-JALR-DEPENDENCY"].mark_function("FC-X1-DEPENDENCY", test_x1_oitf_busy_wait, ["CK-X1-OITF-BUSY-WAIT"])

    result = api_e203_ifu_litebpu_jalr(
        env, pc=0x1000, imm=0x10, rs1idx=1, rf2bpu_x1=0x2000, oitf_empty=0
    )
    assert result["bpu_wait"] == 1, "x1 依赖 OITF 未空时 bpu_wait 应为 1"

def test_x1_ir_cam_wait(env):
    """验证 JALR rs1=x1 且 IR rd CAM 冲突时必须等待。"""
    env.dut.fc_cover["FG-JALR-DEPENDENCY"].mark_function("FC-X1-DEPENDENCY", test_x1_ir_cam_wait, ["CK-X1-IR-CAM-WAIT"])

    result = api_e203_ifu_litebpu_jalr(
        env,
        pc=0x1000,
        imm=0x10,
        rs1idx=1,
        rf2bpu_x1=0x2000,
        oitf_empty=1,
        jalr_rs1idx_cam_irrdidx=1,
    )
    assert result["bpu_wait"] == 1, "x1 与 IR rd 冲突时 bpu_wait 应为 1"

def test_x1_ready_no_wait(env):
    """验证 JALR rs1=x1 无 OITF/IR 冲突时不等待。"""
    env.dut.fc_cover["FG-JALR-DEPENDENCY"].mark_function("FC-X1-DEPENDENCY", test_x1_ready_no_wait, ["CK-X1-READY-NO-WAIT"])

    result = api_e203_ifu_litebpu_jalr(
        env,
        pc=0x1000,
        imm=0x10,
        rs1idx=1,
        rf2bpu_x1=0xDEADBEEF,
        oitf_empty=1,
        jalr_rs1idx_cam_irrdidx=0,
    )
    assert result["bpu_wait"] == 0, "x1 无依赖时 bpu_wait 应为 0"
    assert result["prdt_pc_add_op1"] == 0xDEADBEEF, "x1 ready 时 op1 应采用 rf2bpu_x1"

def test_xn_oitf_busy_wait(env):
    """验证 JALR rs1=xN 且 OITF 非空时等待且不发起读请求。"""
    env.dut.fc_cover["FG-JALR-DEPENDENCY"].mark_function("FC-XN-DEPENDENCY", test_xn_oitf_busy_wait, ["CK-XN-OITF-BUSY-WAIT"])

    result = api_e203_ifu_litebpu_jalr(
        env, pc=0x1000, imm=0x10, rs1idx=5, rf2bpu_rs1=0x3000, oitf_empty=0
    )
    assert result["bpu_wait"] == 1, "xN 依赖 OITF 未空时 bpu_wait 应为 1"
    assert result["bpu2rf_rs1_ena"] == 0, "xN 依赖未解除前不应发起 rs1 读请求"

def test_xn_ir_busy_cam_wait(env):
    """验证 JALR rs1=xN 且 IR 忙并 CAM 冲突时等待。"""
    env.dut.fc_cover["FG-JALR-DEPENDENCY"].mark_function("FC-XN-DEPENDENCY", test_xn_ir_busy_cam_wait, ["CK-XN-IR-BUSY-CAM-WAIT"])

    result = api_e203_ifu_litebpu_jalr(
        env,
        pc=0x1000,
        imm=0x10,
        rs1idx=5,
        rf2bpu_rs1=0x3000,
        oitf_empty=1,
        ir_empty=0,
        ir_rs1en=1,
        jalr_rs1idx_cam_irrdidx=1,
        ir_valid_clr=0,
    )
    assert result["bpu_wait"] == 1, "xN 与 IR 忙且 rd 冲突时 bpu_wait 应为 1"
    assert result["bpu2rf_rs1_ena"] == 0, "IR 依赖未解除前不应发起 rs1 读请求"

def test_xn_ready_no_wait(env):
    """验证 JALR rs1=xN 无 OITF/IR 依赖时应发起读请求且不等待。"""
    env.dut.fc_cover["FG-JALR-DEPENDENCY"].mark_function("FC-XN-DEPENDENCY", test_xn_ready_no_wait, ["CK-XN-READY-NO-WAIT"])

    result = api_e203_ifu_litebpu_jalr(
        env, pc=0x1000, imm=0x10, rs1idx=5, rf2bpu_rs1=0x3456789A, oitf_empty=1, ir_empty=1
    )
    assert result["bpu2rf_rs1_ena"] == 1, "xN ready 时应发起 rs1 读请求"
    assert result["bpu_wait"] == 0, "xN 无依赖且已可读寄存器时不应额外等待"

def test_ir_clr_bypass(env):
    """验证 IR 清除中的 xN 依赖可旁路并发起读请求。"""
    env.dut.fc_cover["FG-JALR-DEPENDENCY"].mark_function("FC-DEPENDENCY-BYPASS", test_ir_clr_bypass, ["CK-IR-CLR-BYPASS"])

    result = api_e203_ifu_litebpu_jalr(
        env,
        pc=0x1000,
        imm=0x10,
        rs1idx=5,
        rf2bpu_rs1=0x456789AB,
        oitf_empty=1,
        ir_empty=0,
        ir_rs1en=1,
        jalr_rs1idx_cam_irrdidx=1,
        ir_valid_clr=1,
    )
    assert result["bpu2rf_rs1_ena"] == 1, "IR valid 正在清除时应允许 xN 读请求"
    assert result["bpu_wait"] == 0, "IR 清除旁路场景不应等待"

def test_ir_rs1_disable_bypass(env):
    """验证 IR 不使用 rs1 时 xN 依赖可旁路并发起读请求。"""
    env.dut.fc_cover["FG-JALR-DEPENDENCY"].mark_function("FC-DEPENDENCY-BYPASS", test_ir_rs1_disable_bypass, ["CK-IR-RS1-DISABLE-BYPASS"])

    result = api_e203_ifu_litebpu_jalr(
        env,
        pc=0x1000,
        imm=0x10,
        rs1idx=5,
        rf2bpu_rs1=0x56789ABC,
        oitf_empty=1,
        ir_empty=0,
        ir_rs1en=0,
        jalr_rs1idx_cam_irrdidx=1,
        ir_valid_clr=0,
    )
    assert result["bpu2rf_rs1_ena"] == 1, "IR 不使用 rs1 时应允许 xN 读请求"
    assert result["bpu_wait"] == 0, "IR rs1 disable 旁路场景不应等待"

def test_dependency_transition(env):
    """验证 xN 依赖解除后应从等待转为不等待。"""
    env.dut.fc_cover["FG-JALR-DEPENDENCY"].mark_function("FC-DEPENDENCY-BYPASS", test_dependency_transition, ["CK-DEPENDENCY-TRANSITION"])

    busy = api_e203_ifu_litebpu_jalr(
        env, pc=0x1000, imm=0x10, rs1idx=5, rf2bpu_rs1=0x6789ABCD, oitf_empty=0
    )
    ready = api_e203_ifu_litebpu_jalr(
        env, pc=0x1000, imm=0x10, rs1idx=5, rf2bpu_rs1=0x6789ABCD, oitf_empty=1, ir_empty=1
    )
    assert busy["bpu_wait"] == 1, "依赖存在时应等待"
    assert ready["bpu_wait"] == 0, "依赖解除后应不等待"
