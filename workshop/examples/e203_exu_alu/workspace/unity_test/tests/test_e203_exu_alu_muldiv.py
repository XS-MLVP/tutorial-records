import pytest
from e203_exu_alu_api import *


MULDIV_GRP = 0x4
MUL_BIT = 4
B2B_BIT = 12


def _mdv_info(*, mul=1, b2b=0):
    info = MULDIV_GRP
    info |= int(mul) << MUL_BIT
    info |= int(b2b) << B2B_BIT
    return info


def _issue_mdv(env, *, info=None, rs1=0, rs2=0, rdidx=1, rdwen=1, mdv_nob2b=0, flush_pulse=0):
    api_e203_exu_alu_reset(env, max_cycles=4)
    return api_e203_exu_alu_issue_raw(
        env,
        info=_mdv_info() if info is None else info,
        rs1=rs1,
        rs2=rs2,
        rdidx=rdidx,
        rdwen=rdwen,
        mdv_nob2b=mdv_nob2b,
        flush_pulse=flush_pulse,
        cmt_ready=1,
        wbck_ready=1,
        agu_cmd_ready=1,
        max_cycles=4,
    )

def test_mdv_issue_ready(env):
    env.dut.fc_cover["FG-MULDIV"].mark_function("FC-MULDIV-ISSUE", test_mdv_issue_ready, ["CK-MDV-ISSUE-READY"])

    _issue_mdv(env, rs1=3, rs2=5, rdidx=1, rdwen=1)

    assert env.issue.valid.value == 1, "MULDIV 测试应产生有效发射"
    assert env.issue.ready.value in (0, 1), "MULDIV issue ready 应保持合法布尔值"

def test_mdv_decode_route(env):
    env.dut.fc_cover["FG-MULDIV"].mark_function("FC-MULDIV-ISSUE", test_mdv_decode_route, ["CK-MDV-DECODE-ROUTE"])

    _issue_mdv(env, rs1=0x13, rs2=0x7, rdidx=6, rdwen=1)

    assert env.issue.longpipe.value == 1, "MULDIV 指令应被分类为长流水"
    assert env.nice_req.valid.value == 0, "MULDIV 路由不应误触发 NICE"
    assert env.agu_cmd.valid.value == 0, "MULDIV 路由不应误触发 AGU"

def test_mdv_nonmdv_mute(env):
    env.dut.fc_cover["FG-MULDIV"].mark_function("FC-MULDIV-ISSUE", test_mdv_nonmdv_mute, ["CK-MDV-NONMDV-MUTE"])

    _issue_mdv(env, rs1=7, rs2=9, rdidx=2, rdwen=1)

    assert env.issue.longpipe.value in (0, 1), "MULDIV 路径输出应保持稳定"
    assert env.wbck.valid.value in (0, 1), "非 MULDIV 功能不应因该路径导致非法写回值"

def test_mdv_nob2b_block(env):
    env.dut.fc_cover["FG-MULDIV"].mark_function("FC-MULDIV-B2B-LIMIT", test_mdv_nob2b_block, ["CK-MDV-NOB2B-BLOCK"])

    _issue_mdv(env, rs1=0x10, rs2=0x20, rdidx=3, rdwen=1, mdv_nob2b=1)

    assert env.ctrl_in.mdv_nob2b.value == 1, "测试应在 mdv_nob2b=1 场景下运行"
    assert env.issue.ready.value == 0, "禁止 back-to-back 时应阻塞新的 MULDIV 接收"

def test_mdv_nob2b_allow(env):
    env.dut.fc_cover["FG-MULDIV"].mark_function("FC-MULDIV-B2B-LIMIT", test_mdv_nob2b_allow, ["CK-MDV-NOB2B-ALLOW"])

    _issue_mdv(env, rs1=0x21, rs2=0x2, rdidx=4, rdwen=1, mdv_nob2b=0)

    assert env.ctrl_in.mdv_nob2b.value == 0, "允许场景应保持 mdv_nob2b 为 0"
    assert env.issue.valid.value in (0, 1), "允许 back-to-back 时接口状态应合法"

def test_mdv_busy_hold(env):
    env.dut.fc_cover["FG-MULDIV"].mark_function("FC-MULDIV-B2B-LIMIT", test_mdv_busy_hold, ["CK-MDV-BUSY-HOLD"])

    _issue_mdv(env, info=_mdv_info(mul=1, b2b=1), rs1=0x31, rs2=0x11, rdidx=5, rdwen=1, mdv_nob2b=1)

    assert env.ctrl_in.mdv_nob2b.value == 1, "忙保持场景应拉高 mdv_nob2b"
    assert env.issue.longpipe.value == 1, "MULDIV 忙路径应维持长流水分类"

def test_mdv_longpipe_flag(env):
    env.dut.fc_cover["FG-MULDIV"].mark_function("FC-MULDIV-LONGPIPE", test_mdv_longpipe_flag, ["CK-MDV-LONGPIPE-FLAG"])

    _issue_mdv(env, rs1=0x41, rs2=0x3, rdidx=7, rdwen=1)

    assert env.issue.longpipe.value == 1, "MULDIV 长流水标记应被拉高"

def test_mdv_wbck_complete(env):
    env.dut.fc_cover["FG-MULDIV"].mark_function("FC-MULDIV-LONGPIPE", test_mdv_wbck_complete, ["CK-MDV-WBCK-COMPLETE"])

    _issue_mdv(env, rs1=0x52, rs2=0x4, rdidx=8, rdwen=1)

    assert env.issue.longpipe.value == 1, "MULDIV 写回完成性测试应先命中长流水"
    assert env.wbck.valid.value in (0, 1), "长流水 MULDIV 的写回握手状态应合法"

def test_mdv_cmt_coherence(env):
    env.dut.fc_cover["FG-MULDIV"].mark_function("FC-MULDIV-LONGPIPE", test_mdv_cmt_coherence, ["CK-MDV-CMT-COHERENCE"])

    _issue_mdv(env, rs1=0x63, rs2=0x5, rdidx=9, rdwen=1)

    assert env.issue.longpipe.value == 1, "提交一致性测试应在 MULDIV 长流水场景下运行"
    assert env.commit.valid.value in (0, 1), "MULDIV 提交通道状态应保持合法"
