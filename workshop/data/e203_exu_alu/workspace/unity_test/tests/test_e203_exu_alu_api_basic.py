#coding=utf-8

import pytest

from e203_exu_alu_api import *


def test_api_e203_exu_alu_reset_basic(env):
    """验证基础复位 API 能完成拉低、释放和空闲态恢复。

    测试流程：
    1. 先人为污染若干输入，模拟复位前环境非空闲状态。
    2. 调用 `api_e203_exu_alu_reset` 统一执行低有效复位时序。
    3. 检查 `rst_n` 已恢复到释放态，关键输入已清空，且未产生伪提交/伪写回。

    预期结果：
    - API 返回 env 自身，便于后续链式调用。
    - `rst_n` 最终为 1。
    - 关键输入与对外可见结果保持空闲或无效状态。
    """
    env.dut.fc_cover["FG-API"].mark_function(
        "FC-RESET",
        test_api_e203_exu_alu_reset_basic,
        ["CK-RESET-ASSERT", "CK-RESET-RELEASE", "CK-RESET-DEFAULT-INPUT"],
    )

    env.issue.valid.value = 1
    env.issue.rs1.value = 0x1234
    env.ctrl_in.flush_req.value = 1

    ret = api_e203_exu_alu_reset(env, max_cycles=4)

    assert ret is env, "reset API 应返回 env 本身"
    assert env.ctrl_in.rst_n.value == 1, "复位释放后 rst_n 应为 1"
    assert env.issue.valid.value == 0, "复位后 issue.valid 应恢复为空闲态"
    assert env.issue.rs1.value == 0, "复位后 issue.rs1 应被清零"
    assert env.ctrl_in.flush_req.value == 0, "复位后 flush_req 应被清零"
    assert env.commit.valid.value == 0, "复位后不应产生伪提交"
    assert env.wbck.valid.value == 0, "复位后不应产生伪写回"
    with pytest.raises(ValueError, match="max_cycles"):
        api_e203_exu_alu_reset(env, max_cycles=0)


def test_api_e203_exu_alu_issue_raw_basic(env):
    """验证原始发射 API 能正确封装输入驱动并返回输出快照。

    测试流程：
    1. 先复位环境，确保驱动起点一致。
    2. 调用 `api_e203_exu_alu_issue_raw` 发射一组简单上下文。
    3. 检查顶层输入是否已被 API 正确写入，并核对返回快照与 env 当前观测一致。

    预期结果：
    - 原始输入字段准确映射到 DUT 顶层。
    - 返回值为包含主要输出字段的字典。
    - 字典中的观测值与 env 当前端口值一致。
    """
    env.dut.fc_cover["FG-API"].mark_function(
        "FC-ISSUE-STEP",
        test_api_e203_exu_alu_issue_raw_basic,
        ["CK-ISSUE-HANDSHAKE", "CK-SINGLE-TRANSACTION-CAPTURE", "CK-STEP-BACKPRESSURE-WAIT"],
    )
    env.dut.fc_cover["FG-API"].mark_function(
        "FC-OBSERVE-OUTPUT",
        test_api_e203_exu_alu_issue_raw_basic,
        ["CK-WBCK-SNAPSHOT", "CK-COMMIT-SNAPSHOT", "CK-SIDEBAND-SNAPSHOT"],
    )

    api_e203_exu_alu_reset(env, max_cycles=4)
    snapshot = api_e203_exu_alu_issue_raw(
        env,
        info=0,
        rs1=0x11,
        rs2=0x22,
        imm=0x33,
        pc=0x44,
        instr=0x55,
        rdidx=3,
        rdwen=1,
        itag=1,
        cmt_ready=1,
        wbck_ready=1,
        agu_cmd_ready=1,
        max_cycles=3,
    )

    assert env.dut.i_valid.value == 1, "issue_raw 应拉高 i_valid"
    assert env.dut.i_rs1.value == 0x11, "issue_raw 应正确驱动 i_rs1"
    assert env.dut.i_rs2.value == 0x22, "issue_raw 应正确驱动 i_rs2"
    assert env.dut.i_imm.value == 0x33, "issue_raw 应正确驱动 i_imm"
    assert env.dut.i_pc.value == 0x44, "issue_raw 应正确驱动 i_pc"
    assert env.dut.i_instr.value == 0x55, "issue_raw 应正确驱动 i_instr"
    assert env.dut.i_rdidx.value == 3, "issue_raw 应正确驱动 i_rdidx"
    assert env.dut.i_rdwen.value == 1, "issue_raw 应正确驱动 i_rdwen"
    assert isinstance(snapshot, dict), "issue_raw 返回值应为快照字典"
    assert snapshot["i_ready"] == int(env.issue.ready.value), "快照中的 i_ready 应与当前端口一致"
    assert snapshot["wbck_o_valid"] == int(env.wbck.valid.value), "快照中的 wbck_o_valid 应与当前端口一致"
    assert snapshot["cmt_o_valid"] == int(env.commit.valid.value), "快照中的 cmt_o_valid 应与当前端口一致"
    with pytest.raises(ValueError, match="max_cycles"):
        api_e203_exu_alu_issue_raw(env, info=0, max_cycles=0)


def test_api_e203_exu_alu_sample_outputs_basic(env):
    """验证输出采样 API 能返回稳定且可观测的端口快照。

    测试流程：
    1. 复位环境并设置少量下游握手输入。
    2. 调用 `api_e203_exu_alu_sample_outputs` 进行统一采样。
    3. 校验返回字段完整，并与 env 当前端口数值一一对应。

    预期结果：
    - API 返回包含主要提交、写回和 AGU/CSR/NICE 观测字段的字典。
    - 所有字段均可直接用于后续测试断言。
    """
    env.dut.fc_cover["FG-API"].mark_function(
        "FC-OBSERVE-OUTPUT",
        test_api_e203_exu_alu_sample_outputs_basic,
        ["CK-WBCK-SNAPSHOT", "CK-COMMIT-SNAPSHOT", "CK-SIDEBAND-SNAPSHOT"],
    )

    api_e203_exu_alu_reset(env, max_cycles=4)
    env.commit.ready.value = 1
    env.wbck.ready.value = 1
    snapshot = api_e203_exu_alu_sample_outputs(env, max_cycles=1)

    required_keys = {
        "i_ready",
        "i_longpipe",
        "cmt_o_valid",
        "cmt_o_pc",
        "cmt_o_instr",
        "wbck_o_valid",
        "wbck_o_wdat",
        "wbck_o_rdidx",
        "agu_icb_cmd_valid",
        "agu_icb_cmd_addr",
        "csr_ena",
        "nice_req_valid",
    }
    assert required_keys.issubset(snapshot.keys()), "输出快照缺少约定字段"
    assert snapshot["cmt_o_valid"] == int(env.commit.valid.value), "提交快照值应与端口一致"
    assert snapshot["wbck_o_wdat"] == int(env.wbck.wdat.value), "写回快照值应与端口一致"
    assert snapshot["agu_icb_cmd_addr"] == int(env.agu_cmd.addr.value), "AGU 地址快照值应与端口一致"
    with pytest.raises(ValueError, match="max_cycles"):
        api_e203_exu_alu_sample_outputs(env, max_cycles=0)
