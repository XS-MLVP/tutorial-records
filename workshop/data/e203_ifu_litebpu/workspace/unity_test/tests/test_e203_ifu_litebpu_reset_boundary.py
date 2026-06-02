import pytest
from e203_ifu_litebpu_api import *


def test_reset_clears_read(env):
    """验证复位会清除 xN 读寄存器状态和读请求输出。"""
    env.dut.fc_cover["FG-RESET-BOUNDARY"].mark_function("FC-RESET-BEHAVIOR", test_reset_clears_read, ["CK-RESET-CLEARS-READ"])

    api_e203_ifu_litebpu_jalr(env, pc=0x1000, imm=0x20, rs1idx=5, rf2bpu_rs1=0x1234)
    env.ctrl.rst_n.value = 0
    env.Step(1)
    result = env.sample_outputs()
    assert result["bpu2rf_rs1_ena"] == 0, "复位期间应清除 rs1 读请求"

def test_first_after_reset(env):
    """验证复位释放后的第一条有效预测输出稳定。"""
    env.dut.fc_cover["FG-RESET-BOUNDARY"].mark_function("FC-RESET-BEHAVIOR", test_first_after_reset, ["CK-FIRST-AFTER-RESET"])

    api_e203_ifu_litebpu_reset(env)
    result = api_e203_ifu_litebpu_bxx(env, pc=0x1000, imm=0x80000000)
    assert result["prdt_taken"] == 1, "复位后第一条负偏移 Bxx 应可稳定预测 taken"

def test_pc_boundary(env):
    """验证 JAL/Bxx 在 PC 边界值下 op1 仍选择 PC。"""
    env.dut.fc_cover["FG-RESET-BOUNDARY"].mark_function("FC-BOUNDARY-VALUES", test_pc_boundary, ["CK-PC-BOUNDARY"])

    for pc in (0, 0xFFFFFFFF, 0x80000000, 0x7FFFFFFF):
        result = api_e203_ifu_litebpu_jal(env, pc=pc, imm=0x20)
        assert result["prdt_pc_add_op1"] == pc, f"JAL PC 边界 op1 错误: 0x{pc:08x}"

def test_reg_boundary(env):
    """验证 JALR 寄存器边界值下 op1 选择对应寄存器输入。"""
    env.dut.fc_cover["FG-RESET-BOUNDARY"].mark_function("FC-BOUNDARY-VALUES", test_reg_boundary, ["CK-REG-BOUNDARY"])

    for value in (0, 0xFFFFFFFF, 0x80000000):
        result = api_e203_ifu_litebpu_jalr(
            env, pc=0x1000, imm=0x20, rs1idx=1, rf2bpu_x1=value, oitf_empty=1, jalr_rs1idx_cam_irrdidx=0
        )
        assert result["prdt_pc_add_op1"] == value, f"JALR x1 寄存器边界 op1 错误: 0x{value:08x}"

def test_imm_sign_boundary(env):
    """验证 Bxx 立即数符号边界预测方向。"""
    env.dut.fc_cover["FG-RESET-BOUNDARY"].mark_function("FC-BOUNDARY-VALUES", test_imm_sign_boundary, ["CK-IMM-SIGN-BOUNDARY"])

    forward = api_e203_ifu_litebpu_bxx(env, pc=0x1000, imm=0x7FFFFFFF)
    backward = api_e203_ifu_litebpu_bxx(env, pc=0x1000, imm=0x80000000)
    assert forward["prdt_taken"] == 0, "0x7fffffff 正偏移边界应 not taken"
    assert backward["prdt_taken"] == 1, "0x80000000 负偏移边界应 taken"

def test_jal_jalr_conflict(env):
    """验证 JAL 与 JALR 同时译码时 op1 优先保持 PC 路径。"""
    env.dut.fc_cover["FG-RESET-BOUNDARY"].mark_function("FC-DECODE-CONFLICT", test_jal_jalr_conflict, ["CK-JAL-JALR-CONFLICT"])

    result = api_e203_ifu_litebpu_predict(
        env,
        pc=0x2468ACE0,
        dec_jal=1,
        dec_jalr=1,
        dec_bjp_imm=0x20,
        dec_jalr_rs1idx=1,
        rf2bpu_x1=0x13579BDF,
        dec_i_valid=1,
    )
    assert result["prdt_pc_add_op1"] == 0x2468ACE0, "JAL/JALR 冲突时 op1 应选择 PC"

def test_jal_bxx_conflict(env):
    """验证 JAL 与 Bxx 同时译码时 op1 仍选择 PC。"""
    env.dut.fc_cover["FG-RESET-BOUNDARY"].mark_function("FC-DECODE-CONFLICT", test_jal_bxx_conflict, ["CK-JAL-BXX-CONFLICT"])

    result = api_e203_ifu_litebpu_predict(
        env, pc=0x10203040, dec_jal=1, dec_bxx=1, dec_bjp_imm=0x80000004, dec_i_valid=1
    )
    assert result["prdt_pc_add_op1"] == 0x10203040, "JAL/Bxx 冲突时 op1 应保持 PC"

def test_jalr_bxx_conflict(env):
    """验证 JALR 与 Bxx 同时译码时输出保持确定二值。"""
    env.dut.fc_cover["FG-RESET-BOUNDARY"].mark_function("FC-DECODE-CONFLICT", test_jalr_bxx_conflict, ["CK-JALR-BXX-CONFLICT"])

    result = api_e203_ifu_litebpu_predict(
        env,
        pc=0x1000,
        dec_jalr=1,
        dec_bxx=1,
        dec_bjp_imm=0x80000004,
        dec_jalr_rs1idx=1,
        rf2bpu_x1=0x22223333,
        dec_i_valid=1,
    )
    assert result["prdt_taken"] == 1, "JALR/Bxx 冲突输入下 taken 输出应保持确定"
    assert result["bpu2rf_rs1_ena"] == 0, "JALR x1/Bxx 冲突不应发起 xN rs1 读请求"
