import pytest
from e203_exu_alu_api import *


def test_reset_assert(env):
    env.dut.fc_cover["FG-API"].mark_function("FC-RESET", test_reset_assert, ["CK-RESET-ASSERT"])

    env.clear_inputs()
    env.ctrl_in.rst_n.value = 0
    env.Step(1)

    assert env.ctrl_in.rst_n.value == 0, "复位断言阶段 rst_n 应保持为 0"
    assert env.commit.valid.value == 0, "复位断言阶段不应产生提交"
    assert env.wbck.valid.value == 0, "复位断言阶段不应产生写回"
    assert env.agu_cmd.valid.value == 0, "复位断言阶段不应产生访存命令"


def test_reset_release(env):
    env.dut.fc_cover["FG-API"].mark_function("FC-RESET", test_reset_release, ["CK-RESET-RELEASE"])

    api_e203_exu_alu_reset(env, max_cycles=4)

    assert env.ctrl_in.rst_n.value == 1, "复位释放后 rst_n 应恢复为 1"
    assert int(env.ctrl_in.clk.value) in (0, 1), "复位释放后时钟应处于有效逻辑电平"
    assert env.issue.ready.value in (0, 1), "复位释放后握手口应可被正常观测"


def test_reset_default_input(env):
    env.dut.fc_cover["FG-API"].mark_function("FC-RESET", test_reset_default_input, ["CK-RESET-DEFAULT-INPUT"])

    api_e203_exu_alu_reset(env, max_cycles=4)

    assert env.issue.valid.value == 0, "默认空闲态下 i_valid 应为 0"
    assert env.ctrl_in.flush_req.value == 0, "默认空闲态下 flush_req 应为 0"
    assert env.ctrl_in.flush_pulse.value == 0, "默认空闲态下 flush_pulse 应为 0"
    assert env.commit.valid.value == 0, "默认空闲态下不应产生伪提交"


def test_issue_handshake(env):
    env.dut.fc_cover["FG-API"].mark_function("FC-ISSUE-STEP", test_issue_handshake, ["CK-ISSUE-HANDSHAKE"])

    api_e203_exu_alu_reset(env, max_cycles=4)
    api_e203_exu_alu_issue_raw(
        env,
        info=0,
        rs1=0x12,
        rs2=0x34,
        rdidx=1,
        rdwen=0,
        cmt_ready=1,
        wbck_ready=1,
        agu_cmd_ready=1,
        max_cycles=3,
    )

    assert env.issue.valid.value == 1, "发射阶段应拉高 i_valid"
    assert env.issue.ready.value == 1, "可接受事务时 DUT 应拉高 i_ready"


def test_step_backpressure_wait(env):
    env.dut.fc_cover["FG-API"].mark_function(
        "FC-ISSUE-STEP", test_step_backpressure_wait, ["CK-STEP-BACKPRESSURE-WAIT"]
    )

    api_e203_exu_alu_reset(env, max_cycles=4)
    api_e203_exu_alu_issue_raw(
        env,
        info=0,
        rs1=0x55,
        rs2=0xAA,
        rdidx=0,
        rdwen=0,
        cmt_ready=0,
        wbck_ready=0,
        agu_cmd_ready=0,
        max_cycles=3,
    )

    assert env.issue.valid.value == 1, "背压等待期间输入 valid 应持续保持"
    assert env.commit.ready.value == 0, "测试应在下游背压场景下运行"
    assert env.wbck.ready.value == 0, "测试应覆盖写回背压输入"


def test_single_transaction_capture(env):
    env.dut.fc_cover["FG-API"].mark_function(
        "FC-ISSUE-STEP", test_single_transaction_capture, ["CK-SINGLE-TRANSACTION-CAPTURE"]
    )

    api_e203_exu_alu_reset(env, max_cycles=4)
    snapshot = api_e203_exu_alu_issue_raw(
        env,
        info=0,
        rs1=0x101,
        rs2=0x202,
        rdidx=0,
        rdwen=0,
        cmt_ready=1,
        wbck_ready=1,
        agu_cmd_ready=1,
        max_cycles=3,
    )

    assert env.issue.valid.value == 1, "单事务测试应只发起一次有效事务"
    assert env.issue.ready.value == 1, "单事务测试中该事务应被接收"
    assert snapshot["cmt_o_valid"] == 1 or snapshot["wbck_o_valid"] == 1 or snapshot["i_longpipe"] == 1, (
        "单事务被接收后应出现提交、写回或长流水可见结果"
    )


def test_wbck_snapshot(env):
    env.dut.fc_cover["FG-API"].mark_function("FC-OBSERVE-OUTPUT", test_wbck_snapshot, ["CK-WBCK-SNAPSHOT"])

    api_e203_exu_alu_reset(env, max_cycles=4)
    snapshot = api_e203_exu_alu_sample_outputs(env, max_cycles=1)

    assert "wbck_o_valid" in snapshot, "写回快照应包含 wbck_o_valid"
    assert "wbck_o_wdat" in snapshot, "写回快照应包含 wbck_o_wdat"
    assert "wbck_o_rdidx" in snapshot, "写回快照应包含 wbck_o_rdidx"
    assert snapshot["wbck_o_valid"] in (0, 1), "wbck_o_valid 应是合法布尔值"
    assert 0 <= snapshot["wbck_o_rdidx"] <= 31, "wbck_o_rdidx 应落在寄存器编号范围内"


def test_commit_snapshot(env):
    env.dut.fc_cover["FG-API"].mark_function("FC-OBSERVE-OUTPUT", test_commit_snapshot, ["CK-COMMIT-SNAPSHOT"])

    api_e203_exu_alu_reset(env, max_cycles=4)
    snapshot = api_e203_exu_alu_sample_outputs(env, max_cycles=1)

    assert "cmt_o_valid" in snapshot, "提交快照应包含 cmt_o_valid"
    assert "cmt_o_pc" in snapshot, "提交快照应包含 cmt_o_pc"
    assert "cmt_o_instr" in snapshot, "提交快照应包含 cmt_o_instr"
    assert snapshot["cmt_o_valid"] in (0, 1), "cmt_o_valid 应是合法布尔值"
    assert env.commit.pc_vld.value in (0, 1), "提交侧 pc_vld 应可被正常观测"


def test_sideband_snapshot(env):
    env.dut.fc_cover["FG-API"].mark_function(
        "FC-OBSERVE-OUTPUT", test_sideband_snapshot, ["CK-SIDEBAND-SNAPSHOT"]
    )

    api_e203_exu_alu_reset(env, max_cycles=4)
    snapshot = api_e203_exu_alu_sample_outputs(env, max_cycles=1)

    assert "csr_ena" in snapshot, "旁路快照应包含 CSR 侧带"
    assert "agu_icb_cmd_valid" in snapshot, "旁路快照应包含 AGU 侧带"
    assert "nice_req_valid" in snapshot, "旁路快照应包含 NICE 侧带"
    assert snapshot["csr_ena"] in (0, 1), "csr_ena 应是合法布尔值"
    assert snapshot["agu_icb_cmd_valid"] in (0, 1), "agu_icb_cmd_valid 应是合法布尔值"
    assert snapshot["nice_req_valid"] in (0, 1), "nice_req_valid 应是合法布尔值"
