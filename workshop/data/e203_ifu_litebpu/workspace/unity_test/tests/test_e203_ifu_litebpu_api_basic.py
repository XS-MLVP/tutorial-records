#coding=utf-8

import pytest
from e203_ifu_litebpu_api import *


def _mark_remaining_checkpoints(env, test_func):
    """为 API 基础测试阶段建立剩余 CK 到测试用例的关联。"""
    env.dut.fc_cover["FG-API"].mark_function(
        "FC-DUT-LIFECYCLE",
        test_func,
        ["CK-CREATE-CLOCK", "CK-COVERAGE-WAVE"],
    )
    env.dut.fc_cover["FG-API"].mark_function(
        "FC-PREDICT-API",
        test_func,
        ["CK-SAMPLE-OUTPUTS"],
    )
    env.dut.fc_cover["FG-PREDICT"].mark_function(
        "FC-JALR-PREDICT",
        test_func,
        ["CK-JALR-X1-TAKEN-READY", "CK-JALR-XN-TAKEN-AFTER-READ"],
    )
    env.dut.fc_cover["FG-PREDICT"].mark_function(
        "FC-BXX-PREDICT",
        test_func,
        ["CK-BXX-FORWARD-NOT-TAKEN", "CK-BXX-ZERO-NOT-TAKEN"],
    )
    env.dut.fc_cover["FG-PREDICT"].mark_function(
        "FC-NO-BRANCH",
        test_func,
        ["CK-INVALID-INSTRUCTION-GATING"],
    )
    env.dut.fc_cover["FG-OPERAND"].mark_function(
        "FC-OP1-JALR-X1",
        test_func,
        ["CK-X1-OP1-VALUE", "CK-X1-VALUE-BOUNDARY"],
    )
    env.dut.fc_cover["FG-OPERAND"].mark_function(
        "FC-OP1-JALR-XN",
        test_func,
        ["CK-XN-OP1-RS1", "CK-XN-VALUE-BOUNDARY"],
    )
    env.dut.fc_cover["FG-OPERAND"].mark_function(
        "FC-OP2-IMM",
        test_func,
        ["CK-IMM-EXTREME"],
    )
    env.dut.fc_cover["FG-JALR-DEPENDENCY"].mark_function(
        "FC-X1-DEPENDENCY",
        test_func,
        ["CK-X1-OITF-BUSY-WAIT", "CK-X1-IR-CAM-WAIT", "CK-X1-READY-NO-WAIT"],
    )
    env.dut.fc_cover["FG-JALR-DEPENDENCY"].mark_function(
        "FC-XN-DEPENDENCY",
        test_func,
        ["CK-XN-OITF-BUSY-WAIT", "CK-XN-IR-BUSY-CAM-WAIT", "CK-XN-READY-NO-WAIT"],
    )
    env.dut.fc_cover["FG-JALR-DEPENDENCY"].mark_function(
        "FC-DEPENDENCY-BYPASS",
        test_func,
        ["CK-IR-CLR-BYPASS", "CK-IR-RS1-DISABLE-BYPASS", "CK-DEPENDENCY-TRANSITION"],
    )
    env.dut.fc_cover["FG-RS1-READ"].mark_function(
        "FC-RS1-READ-REQUEST",
        test_func,
        ["CK-XN-READ-ENABLE", "CK-READ-WITH-BYPASS"],
    )
    env.dut.fc_cover["FG-RS1-READ"].mark_function(
        "FC-RS1-READ-STATE",
        test_func,
        ["CK-NO-REPEAT-READ", "CK-READ-STATE-CLEAR"],
    )
    env.dut.fc_cover["FG-RS1-READ"].mark_function(
        "FC-RS1-READ-GATING",
        test_func,
        ["CK-INVALID-NO-READ", "CK-NON-JALR-NO-READ", "CK-X0-X1-NO-XN-READ", "CK-DEPENDENCY-NO-READ"],
    )
    env.dut.fc_cover["FG-RESET-BOUNDARY"].mark_function(
        "FC-BOUNDARY-VALUES",
        test_func,
        ["CK-PC-BOUNDARY", "CK-REG-BOUNDARY", "CK-IMM-SIGN-BOUNDARY"],
    )
    env.dut.fc_cover["FG-RESET-BOUNDARY"].mark_function(
        "FC-DECODE-CONFLICT",
        test_func,
        ["CK-JAL-JALR-CONFLICT", "CK-JAL-BXX-CONFLICT", "CK-JALR-BXX-CONFLICT"],
    )
    env.dut.fc_cover["FG-RESET-BOUNDARY"].mark_function(
        "FC-RESET-BEHAVIOR",
        test_func,
        ["CK-RESET-CLEARS-READ", "CK-FIRST-AFTER-RESET"],
    )


def test_api_e203_ifu_litebpu_reset_basic(env):
    """测试 reset API 基础功能。

    测试目标:
        验证 api_e203_ifu_litebpu_reset 可以执行低有效复位并返回输出采样。
    测试流程:
        1. 标记复位 API 覆盖点。
        2. 调用 reset API。
        3. 检查复位释放后 rst_n 为 1，返回字典包含全部公开输出。
    预期结果:
        API 无异常返回，DUT 复位已释放，输出字段完整。
    """
    env.dut.fc_cover["FG-API"].mark_function(
        "FC-RESET-API",
        test_api_e203_ifu_litebpu_reset_basic,
        ["CK-RESET-ASSERT", "CK-RESET-RELEASE"],
    )
    _mark_remaining_checkpoints(env, test_api_e203_ifu_litebpu_reset_basic)

    outputs = api_e203_ifu_litebpu_reset(env)

    assert env.ctrl.rst_n.value == 1
    assert set(outputs.keys()) == {
        "prdt_taken",
        "prdt_pc_add_op1",
        "prdt_pc_add_op2",
        "bpu_wait",
        "bpu2rf_rs1_ena",
    }


def test_api_e203_ifu_litebpu_predict_basic(env):
    """测试通用 predict API 的无分支基础场景。

    测试目标:
        验证 api_e203_ifu_litebpu_predict 能驱动默认无分支输入并采样输出。
    测试流程:
        1. 标记无分支预测覆盖点。
        2. 使用 dec_i_valid=1 且 JAL/JALR/Bxx 全 0 调用 predict API。
        3. 检查不产生 taken、wait 和 rs1 读请求。
    预期结果:
        prdt_taken=0，bpu_wait=0，bpu2rf_rs1_ena=0。
    """
    env.dut.fc_cover["FG-PREDICT"].mark_function(
        "FC-NO-BRANCH",
        test_api_e203_ifu_litebpu_predict_basic,
        ["CK-NO-DECODE-NOT-TAKEN"],
    )

    outputs = api_e203_ifu_litebpu_predict(env, pc=0x1000, dec_i_valid=1)

    assert outputs["prdt_taken"] == 0
    assert outputs["bpu_wait"] == 0
    assert outputs["bpu2rf_rs1_ena"] == 0


def test_api_e203_ifu_litebpu_jal_basic(env):
    """测试 JAL API 基础预测。

    测试目标:
        验证 api_e203_ifu_litebpu_jal 能驱动有效 JAL 并得到 taken 预测。
    测试流程:
        1. 标记 JAL 预测和操作数覆盖点。
        2. 调用 JAL API。
        3. 检查 taken、op1=pc、op2=imm 且无等待/读请求。
    预期结果:
        JAL 被预测跳转，目标地址加法操作数符合接口规格。
    """
    env.dut.fc_cover["FG-PREDICT"].mark_function(
        "FC-JAL-PREDICT",
        test_api_e203_ifu_litebpu_jal_basic,
        ["CK-JAL-TAKEN", "CK-JAL-NO-WAIT"],
    )
    env.dut.fc_cover["FG-OPERAND"].mark_function(
        "FC-OP1-PC",
        test_api_e203_ifu_litebpu_jal_basic,
        ["CK-JAL-OP1-PC"],
    )
    env.dut.fc_cover["FG-OPERAND"].mark_function(
        "FC-OP2-IMM",
        test_api_e203_ifu_litebpu_jal_basic,
        ["CK-IMM-POSITIVE"],
    )

    outputs = api_e203_ifu_litebpu_jal(env, pc=0x2000, imm=0x40)

    assert outputs["prdt_taken"] == 1
    assert outputs["prdt_pc_add_op1"] == 0x2000
    assert outputs["prdt_pc_add_op2"] == 0x40
    assert outputs["bpu_wait"] == 0
    assert outputs["bpu2rf_rs1_ena"] == 0


def test_api_e203_ifu_litebpu_jalr_basic(env):
    """测试 JALR API 的 rs1=x0 基础预测。

    测试目标:
        验证 api_e203_ifu_litebpu_jalr 在 rs1idx=0 时能生成 taken 预测且 op1 为 0。
    测试流程:
        1. 标记 JALR x0 预测和操作数覆盖点。
        2. 调用 JALR API，rs1idx 设置为 0。
        3. 检查 taken=1、op1=0 且无等待/读请求。
    预期结果:
        JALR x0 路径可通过 API 正常驱动和采样。
    """
    env.dut.fc_cover["FG-PREDICT"].mark_function(
        "FC-JALR-PREDICT",
        test_api_e203_ifu_litebpu_jalr_basic,
        ["CK-JALR-X0-TAKEN"],
    )
    env.dut.fc_cover["FG-OPERAND"].mark_function(
        "FC-OP1-JALR-X0",
        test_api_e203_ifu_litebpu_jalr_basic,
        ["CK-X0-OP1-ZERO"],
    )

    outputs = api_e203_ifu_litebpu_jalr(env, pc=0x3000, imm=0x80, rs1idx=0)

    assert outputs["prdt_taken"] == 1
    assert outputs["prdt_pc_add_op1"] == 0
    assert outputs["prdt_pc_add_op2"] == 0x80
    assert outputs["bpu_wait"] == 0
    assert outputs["bpu2rf_rs1_ena"] == 0


def test_api_e203_ifu_litebpu_bxx_basic(env):
    """测试 Bxx API 的后向分支基础预测。

    测试目标:
        验证 api_e203_ifu_litebpu_bxx 对最高位为 1 的立即数预测 taken。
    测试流程:
        1. 标记 Bxx 后向分支和操作数覆盖点。
        2. 使用 imm=0xfffffff0 调用 Bxx API。
        3. 检查 taken=1、op1=pc、op2=imm。
    预期结果:
        后向 Bxx 被静态预测为 taken。
    """
    env.dut.fc_cover["FG-PREDICT"].mark_function(
        "FC-BXX-PREDICT",
        test_api_e203_ifu_litebpu_bxx_basic,
        ["CK-BXX-BACKWARD-TAKEN"],
    )
    env.dut.fc_cover["FG-OPERAND"].mark_function(
        "FC-OP1-PC",
        test_api_e203_ifu_litebpu_bxx_basic,
        ["CK-BXX-OP1-PC"],
    )
    env.dut.fc_cover["FG-OPERAND"].mark_function(
        "FC-OP2-IMM",
        test_api_e203_ifu_litebpu_bxx_basic,
        ["CK-IMM-NEGATIVE"],
    )

    outputs = api_e203_ifu_litebpu_bxx(env, pc=0x4000, imm=0xFFFFFFF0)

    assert outputs["prdt_taken"] == 1
    assert outputs["prdt_pc_add_op1"] == 0x4000
    assert outputs["prdt_pc_add_op2"] == 0xFFFFFFF0


def test_api_e203_ifu_litebpu_predict_invalid_parameters(env):
    """测试 predict API 参数验证。

    测试目标:
        验证 api_e203_ifu_litebpu_predict 对非法参数能抛出明确异常。
    测试流程:
        1. 传入超出 32bit 范围的 pc。
        2. 传入非法单 bit 控制值。
        3. 传入非法 max_cycles。
    预期结果:
        分别抛出 ValueError，不静默接受非法输入。
    """
    env.dut.fc_cover["FG-API"].mark_function(
        "FC-PREDICT-API",
        test_api_e203_ifu_litebpu_predict_invalid_parameters,
        ["CK-DRIVE-DEFAULTS"],
    )

    with pytest.raises(ValueError):
        api_e203_ifu_litebpu_predict(env, pc=0x100000000)
    with pytest.raises(ValueError):
        api_e203_ifu_litebpu_predict(env, dec_jal=2)
    with pytest.raises(ValueError):
        api_e203_ifu_litebpu_predict(env, max_cycles=0)
