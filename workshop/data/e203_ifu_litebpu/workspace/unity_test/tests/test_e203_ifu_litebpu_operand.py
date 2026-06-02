import pytest
from e203_ifu_litebpu_api import *


def test_jal_op1_pc(env):
    """验证 JAL 目标地址加法操作数 1 选择当前 PC。"""
    env.dut.fc_cover["FG-OPERAND"].mark_function("FC-OP1-PC", test_jal_op1_pc, ["CK-JAL-OP1-PC"])

    result = api_e203_ifu_litebpu_jal(env, pc=0x12345678, imm=0x20)
    assert result["prdt_pc_add_op1"] == 0x12345678, "JAL op1 应等于当前 PC"

def test_bxx_op1_pc(env):
    """验证 Bxx 目标地址加法操作数 1 选择当前 PC。"""
    env.dut.fc_cover["FG-OPERAND"].mark_function("FC-OP1-PC", test_bxx_op1_pc, ["CK-BXX-OP1-PC"])

    result = api_e203_ifu_litebpu_bxx(env, pc=0x87654321, imm=0x80000004)
    assert result["prdt_pc_add_op1"] == 0x87654321, "Bxx op1 应等于当前 PC"

def test_x0_op1_zero(env):
    """验证 JALR rs1=x0 时操作数 1 固定为 0。"""
    env.dut.fc_cover["FG-OPERAND"].mark_function("FC-OP1-JALR-X0", test_x0_op1_zero, ["CK-X0-OP1-ZERO"])

    result = api_e203_ifu_litebpu_jalr(env, pc=0x1000, imm=0x44, rs1idx=0, rf2bpu_rs1=0xFFFFFFFF)
    assert result["prdt_pc_add_op1"] == 0, "JALR x0 op1 应为 0"

def test_x1_op1_value(env):
    """验证 JALR rs1=x1 ready 时操作数 1 使用 x1 输入值。"""
    env.dut.fc_cover["FG-OPERAND"].mark_function("FC-OP1-JALR-X1", test_x1_op1_value, ["CK-X1-OP1-VALUE"])

    result = api_e203_ifu_litebpu_jalr(
        env, pc=0x1000, imm=0x44, rs1idx=1, rf2bpu_x1=0xA5A55A5A, oitf_empty=1, jalr_rs1idx_cam_irrdidx=0
    )
    assert result["prdt_pc_add_op1"] == 0xA5A55A5A, "JALR x1 op1 应等于 rf2bpu_x1"

def test_x1_value_boundary(env):
    """验证 JALR rs1=x1 边界值操作数选择。"""
    env.dut.fc_cover["FG-OPERAND"].mark_function("FC-OP1-JALR-X1", test_x1_value_boundary, ["CK-X1-VALUE-BOUNDARY"])

    for value in (0, 0xFFFFFFFF, 0x80000000):
        result = api_e203_ifu_litebpu_jalr(
            env, pc=0x1000, imm=0x44, rs1idx=1, rf2bpu_x1=value, oitf_empty=1, jalr_rs1idx_cam_irrdidx=0
        )
        assert result["prdt_pc_add_op1"] == value, f"JALR x1 边界值 op1 错误: 0x{value:08x}"

def test_xn_op1_rs1(env):
    """验证 JALR rs1=xN 发起读请求时操作数 1 使用 rs1 输入值。"""
    env.dut.fc_cover["FG-OPERAND"].mark_function("FC-OP1-JALR-XN", test_xn_op1_rs1, ["CK-XN-OP1-RS1"])

    result = api_e203_ifu_litebpu_jalr(
        env, pc=0x1000, imm=0x44, rs1idx=5, rf2bpu_rs1=0x13579BDF, oitf_empty=1, ir_empty=1
    )
    assert result["bpu2rf_rs1_ena"] == 1, "xN ready 时应发起 rs1 读请求"
    assert result["prdt_pc_add_op1"] == 0x13579BDF, "JALR xN op1 应等于 rf2bpu_rs1"

def test_xn_value_boundary(env):
    """验证 JALR rs1=xN 边界值操作数选择。"""
    env.dut.fc_cover["FG-OPERAND"].mark_function("FC-OP1-JALR-XN", test_xn_value_boundary, ["CK-XN-VALUE-BOUNDARY"])

    for value in (0, 0xFFFFFFFF, 0x80000000):
        api_e203_ifu_litebpu_reset(env)
        result = api_e203_ifu_litebpu_jalr(
            env, pc=0x1000, imm=0x20, rs1idx=5, rf2bpu_rs1=value, oitf_empty=1, ir_empty=1
        )
        assert result["bpu2rf_rs1_ena"] == 1, f"xN 边界值 0x{value:08x} 应发起读请求"
        assert result["prdt_pc_add_op1"] == value, f"JALR xN 边界值 op1 错误: 0x{value:08x}"

def test_imm_positive(env):
    """验证正立即数低 32 位透传到操作数 2。"""
    env.dut.fc_cover["FG-OPERAND"].mark_function("FC-OP2-IMM", test_imm_positive, ["CK-IMM-POSITIVE"])

    result = api_e203_ifu_litebpu_jal(env, pc=0x1000, imm=0x00000124)
    assert result["prdt_pc_add_op2"] == 0x00000124, "正立即数 op2 应直接透传"

def test_imm_negative(env):
    """验证负偏移编码立即数低 32 位透传到操作数 2。"""
    env.dut.fc_cover["FG-OPERAND"].mark_function("FC-OP2-IMM", test_imm_negative, ["CK-IMM-NEGATIVE"])

    result = api_e203_ifu_litebpu_bxx(env, pc=0x1000, imm=0xFFFF_FFFC)
    assert result["prdt_pc_add_op2"] == 0xFFFF_FFFC, "负立即数编码 op2 应直接透传"

def test_imm_extreme(env):
    """验证立即数 0、全 1 和符号边界值透传。"""
    env.dut.fc_cover["FG-OPERAND"].mark_function("FC-OP2-IMM", test_imm_extreme, ["CK-IMM-EXTREME"])

    for imm in (0, 0xFFFFFFFF, 0x80000000):
        result = api_e203_ifu_litebpu_bxx(env, pc=0x1000, imm=imm)
        assert result["prdt_pc_add_op2"] == imm, f"极值立即数 op2 错误: 0x{imm:08x}"
