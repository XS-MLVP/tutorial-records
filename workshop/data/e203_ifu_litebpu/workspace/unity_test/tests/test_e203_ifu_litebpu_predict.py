import pytest
from e203_ifu_litebpu_api import *


def test_jal_taken(env):
    """验证有效 JAL 始终预测 taken。"""
    env.dut.fc_cover["FG-PREDICT"].mark_function("FC-JAL-PREDICT", test_jal_taken, ["CK-JAL-TAKEN"])

    result = api_e203_ifu_litebpu_jal(env, pc=0x1000, imm=0x20)
    assert result["prdt_taken"] == 1, "有效 JAL 应预测 taken"

def test_jal_no_wait(env):
    """验证 JAL 预测不需要等待且不读 rs1。"""
    env.dut.fc_cover["FG-PREDICT"].mark_function("FC-JAL-PREDICT", test_jal_no_wait, ["CK-JAL-NO-WAIT"])

    result = api_e203_ifu_litebpu_jal(env, pc=0x1000, imm=0x20)
    assert result["bpu_wait"] == 0, "JAL 不应触发 bpu_wait"
    assert result["bpu2rf_rs1_ena"] == 0, "JAL 不应发起 rs1 读请求"

def test_jalr_x0_taken(env):
    """验证 JALR rs1=x0 始终预测 taken 且不等待。"""
    env.dut.fc_cover["FG-PREDICT"].mark_function("FC-JALR-PREDICT", test_jalr_x0_taken, ["CK-JALR-X0-TAKEN"])

    result = api_e203_ifu_litebpu_jalr(env, pc=0x1000, imm=0x20, rs1idx=0)
    assert result["prdt_taken"] == 1, "JALR x0 应预测 taken"
    assert result["bpu_wait"] == 0, "JALR x0 不应等待"

def test_jalr_x1_taken_ready(env):
    """验证 JALR rs1=x1 ready 时预测 taken 且不等待。"""
    env.dut.fc_cover["FG-PREDICT"].mark_function("FC-JALR-PREDICT", test_jalr_x1_taken_ready, ["CK-JALR-X1-TAKEN-READY"])

    result = api_e203_ifu_litebpu_jalr(
        env, pc=0x1000, imm=0x20, rs1idx=1, rf2bpu_x1=0x2000, oitf_empty=1, jalr_rs1idx_cam_irrdidx=0
    )
    assert result["prdt_taken"] == 1, "JALR x1 ready 应预测 taken"
    assert result["bpu_wait"] == 0, "JALR x1 ready 不应等待"

def test_jalr_xn_taken_after_read(env):
    """验证 JALR rs1=xN 发起读请求后预测 taken 并使用 rs1 值。"""
    env.dut.fc_cover["FG-PREDICT"].mark_function("FC-JALR-PREDICT", test_jalr_xn_taken_after_read, ["CK-JALR-XN-TAKEN-AFTER-READ"])

    result = api_e203_ifu_litebpu_jalr(
        env, pc=0x1000, imm=0x20, rs1idx=5, rf2bpu_rs1=0xCAFEBABE, oitf_empty=1, ir_empty=1
    )
    assert result["bpu2rf_rs1_ena"] == 1, "JALR xN ready 应发起 rs1 读请求"
    assert result["prdt_taken"] == 1, "JALR xN 应预测 taken"
    assert result["prdt_pc_add_op1"] == 0xCAFEBABE, "JALR xN op1 应使用 rf2bpu_rs1"

def test_bxx_backward_taken(env):
    """验证 Bxx 负偏移静态预测 taken。"""
    env.dut.fc_cover["FG-PREDICT"].mark_function("FC-BXX-PREDICT", test_bxx_backward_taken, ["CK-BXX-BACKWARD-TAKEN"])

    result = api_e203_ifu_litebpu_bxx(env, pc=0x1000, imm=0xFFFF_FFFC)
    assert result["prdt_taken"] == 1, "Bxx 负偏移应预测 taken"

def test_bxx_forward_not_taken(env):
    """验证 Bxx 正偏移静态预测 not taken。"""
    env.dut.fc_cover["FG-PREDICT"].mark_function("FC-BXX-PREDICT", test_bxx_forward_not_taken, ["CK-BXX-FORWARD-NOT-TAKEN"])

    result = api_e203_ifu_litebpu_bxx(env, pc=0x1000, imm=0x00000010)
    assert result["prdt_taken"] == 0, "Bxx 正偏移应预测 not taken"

def test_bxx_zero_not_taken(env):
    """验证 Bxx 零偏移静态预测 not taken。"""
    env.dut.fc_cover["FG-PREDICT"].mark_function("FC-BXX-PREDICT", test_bxx_zero_not_taken, ["CK-BXX-ZERO-NOT-TAKEN"])

    result = api_e203_ifu_litebpu_bxx(env, pc=0x1000, imm=0)
    assert result["prdt_taken"] == 0, "Bxx 零偏移应预测 not taken"

def test_no_decode_not_taken(env):
    """验证有效但无 JAL/JALR/Bxx 译码时不预测跳转。"""
    env.dut.fc_cover["FG-PREDICT"].mark_function("FC-NO-BRANCH", test_no_decode_not_taken, ["CK-NO-DECODE-NOT-TAKEN"])

    result = api_e203_ifu_litebpu_predict(env, pc=0x1000, dec_i_valid=1)
    assert result["prdt_taken"] == 0, "无分支译码时 prdt_taken 应为 0"

def test_invalid_instruction_gating(env):
    """验证 dec_i_valid=0 时分支译码输入不应产生 taken 或等待。"""
    env.dut.fc_cover["FG-PREDICT"].mark_function("FC-NO-BRANCH", test_invalid_instruction_gating, ["CK-INVALID-INSTRUCTION-GATING"])

    result = api_e203_ifu_litebpu_predict(env, pc=0x1000, dec_jal=1, dec_bjp_imm=0x20, dec_i_valid=0)
    assert result["bpu_wait"] == 0, "无效指令不应触发等待"
    assert result["bpu2rf_rs1_ena"] == 0, "无效指令不应读 rs1"
    assert result["prdt_taken"] == 0, "无效指令即使 dec_jal=1 也不应预测 taken"
