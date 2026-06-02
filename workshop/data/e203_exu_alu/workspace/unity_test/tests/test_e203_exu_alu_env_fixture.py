#coding=utf-8

from e203_exu_alu_api import *


def test_api_e203_exu_alu_env_bundle_binding(env):
    """验证 env 中的 Bundle 已正确绑定到 DUT 顶层引脚。"""
    env.dut.fc_cover["FG-API"].mark_function(
        "FC-OBSERVE-OUTPUT",
        test_api_e203_exu_alu_env_bundle_binding,
        ["CK-SIDEBAND-SNAPSHOT"],
    )

    env.issue.valid.value = 1
    env.issue.rs1.value = 0x12345678
    env.issue.rdidx.value = 7
    env.csr_sideband.read_dat.value = 0x55AA55AA
    env.nice_sideband.xs_off.value = 1

    assert env.dut.i_valid.value == 1, "issue.valid 应映射到 DUT 的 i_valid"
    assert env.dut.i_rs1.value == 0x12345678, "issue.rs1 应映射到 DUT 的 i_rs1"
    assert env.dut.i_rdidx.value == 7, "issue.rdidx 应映射到 DUT 的 i_rdidx"
    assert env.dut.read_csr_dat.value == 0x55AA55AA, "CSR 侧带输入映射错误"
    assert env.dut.nice_xs_off.value == 1, "NICE 侧带输入映射错误"


def test_api_e203_exu_alu_env_clear_inputs(env):
    """验证 clear_inputs 能把环境输入恢复到默认空闲态。"""
    env.dut.fc_cover["FG-API"].mark_function(
        "FC-RESET",
        test_api_e203_exu_alu_env_clear_inputs,
        ["CK-RESET-DEFAULT-INPUT"],
    )

    env.issue.valid.value = 1
    env.issue.rs1.value = 3
    env.commit.ready.value = 1
    env.wbck.ready.value = 1
    env.agu_rsp.valid.value = 1
    env.ctrl_in.flush_req.value = 1
    env.csr_sideband.read_dat.value = 0xFFFFFFFF

    env.clear_inputs()

    assert env.issue.valid.value == 0, "clear_inputs 后 issue.valid 应为 0"
    assert env.issue.rs1.value == 0, "clear_inputs 后 issue.rs1 应为 0"
    assert env.commit.ready.value == 0, "clear_inputs 后 cmt_o_ready 应为 0"
    assert env.wbck.ready.value == 0, "clear_inputs 后 wbck_o_ready 应为 0"
    assert env.agu_rsp.valid.value == 0, "clear_inputs 后 agu_icb_rsp_valid 应为 0"
    assert env.ctrl_in.flush_req.value == 0, "clear_inputs 后 flush_req 应为 0"
    assert env.csr_sideband.read_dat.value == 0, "clear_inputs 后 read_csr_dat 应为 0"


def test_api_e203_exu_alu_env_reset_and_step(env):
    """验证 reset 和 Step 接口可用，并在复位释放后回到可继续驱动的状态。"""
    env.dut.fc_cover["FG-API"].mark_function(
        "FC-RESET",
        test_api_e203_exu_alu_env_reset_and_step,
        ["CK-RESET-ASSERT", "CK-RESET-RELEASE"],
    )

    env.reset()
    env.Step(1)

    assert env.ctrl_in.rst_n.value == 1, "reset 完成后 rst_n 应恢复为 1"
    assert env.dut.rst_n.value == 1, "DUT 的 rst_n 应与 env 复位状态一致"
    assert env.issue.valid.value == 0, "reset 后输入应保持空闲态"
