#coding=utf-8

from e203_ifu_litebpu_api import *


def test_api_e203_ifu_litebpu_env_bundle_binding(env):
    """验证 env 中的 Bundle 已正确绑定到 DUT 公开端口。"""
    env.dut.fc_cover["FG-API"].mark_function(
        "FC-PREDICT-API",
        test_api_e203_ifu_litebpu_env_bundle_binding,
        ["CK-DRIVE-DEFAULTS", "CK-SAMPLE-OUTPUTS"],
    )

    env.set_defaults()
    env.decode.pc.value = 0x12345678
    env.regfile.x1.value = 0xA5A5A5A5

    assert env.dut.pc.value == 0x12345678
    assert env.dut.rf2bpu_x1.value == 0xA5A5A5A5
    assert set(env.sample_outputs().keys()) == {
        "prdt_taken",
        "prdt_pc_add_op1",
        "prdt_pc_add_op2",
        "bpu_wait",
        "bpu2rf_rs1_ena",
    }


def test_api_e203_ifu_litebpu_env_reset_method(env):
    """验证 env.reset 使用 Step 完成低有效复位和释放。"""
    env.dut.fc_cover["FG-API"].mark_function(
        "FC-RESET-API",
        test_api_e203_ifu_litebpu_env_reset_method,
        ["CK-RESET-ASSERT", "CK-RESET-RELEASE"],
    )

    env.reset()

    assert env.ctrl.rst_n.value == 1
    assert env.dut.rst_n.value == 1
    assert "bpu2rf_rs1_ena" in env.sample_outputs()


def test_api_e203_ifu_litebpu_env_drive_predict_method(env):
    """验证 env.drive_predict 可以统一驱动输入并返回输出采样。"""
    env.dut.fc_cover["FG-PREDICT"].mark_function(
        "FC-JAL-PREDICT",
        test_api_e203_ifu_litebpu_env_drive_predict_method,
        ["CK-JAL-TAKEN", "CK-JAL-NO-WAIT"],
    )

    outputs = env.drive_predict(
        pc=0x1000,
        dec_jal=1,
        dec_bjp_imm=4,
        dec_i_valid=1,
    )

    assert outputs["prdt_taken"] == 1
    assert outputs["bpu_wait"] == 0
    assert outputs["bpu2rf_rs1_ena"] == 0
