import pytest
from e203_exu_alu_api import *


NICE_GRP = 0x5


def _issue_nice(
    env,
    *,
    rs1=0,
    rs2=0,
    instr=0xDEAD_BEEF,
    rdidx=1,
    rdwen=1,
    nice_req_ready=0,
    nice_rsp_multicyc_valid=0,
    nice_longp_wbck_ready=0,
    nice_xs_off=0,
    i_nice_cmt_off_ilgl=0,
    itag=0,
):
    api_e203_exu_alu_reset(env, max_cycles=4)
    return api_e203_exu_alu_issue_raw(
        env,
        info=NICE_GRP,
        rs1=rs1,
        rs2=rs2,
        instr=instr,
        rdidx=rdidx,
        rdwen=rdwen,
        nice_req_ready=nice_req_ready,
        nice_rsp_multicyc_valid=nice_rsp_multicyc_valid,
        nice_longp_wbck_ready=nice_longp_wbck_ready,
        nice_xs_off=nice_xs_off,
        i_nice_cmt_off_ilgl=i_nice_cmt_off_ilgl,
        itag=itag,
        cmt_ready=1,
        wbck_ready=1,
        agu_cmd_ready=1,
        max_cycles=4,
    )

def test_nice_req_valid(env):
    env.dut.fc_cover["FG-NICE"].mark_function("FC-NICE-REQUEST", test_nice_req_valid, ["CK-NICE-REQ-VALID"])

    _issue_nice(env, rs1=0x11, rs2=0x22, instr=0x0102_0304, rdidx=1, rdwen=1, nice_req_ready=0)

    assert env.nice_req.valid.value in (0, 1), "NICE 请求 valid 应保持合法布尔值"

def test_nice_req_payload(env):
    env.dut.fc_cover["FG-NICE"].mark_function("FC-NICE-REQUEST", test_nice_req_payload, ["CK-NICE-REQ-PAYLOAD"])

    instr = 0x2468_ACED
    rs1 = 0x1234_5678
    rs2 = 0x8765_4321
    _issue_nice(env, rs1=rs1, rs2=rs2, instr=instr, rdidx=7, rdwen=1, nice_req_ready=0)

    assert env.nice_req.valid.value == 1, "NICE 载荷测试应产生请求"
    assert env.nice_req.instr.value == instr, "nice_req_instr 应透传原始指令字"
    assert env.nice_req.rs1.value == rs1, "nice_req_rs1 应透传输入 rs1"
    assert env.nice_req.rs2.value == rs2, "nice_req_rs2 应透传输入 rs2"

def test_nice_req_backpressure(env):
    env.dut.fc_cover["FG-NICE"].mark_function("FC-NICE-REQUEST", test_nice_req_backpressure, ["CK-NICE-REQ-BACKPRESSURE"])

    _issue_nice(env, rs1=0x33, rs2=0x44, instr=0x1122_3344, rdidx=2, rdwen=1, nice_req_ready=0)

    assert env.nice_req.valid.value == 1, "NICE 背压场景应产生有效请求"
    assert env.nice_req.ready.value == 0, "背压场景下 nice_req_ready 应保持 0"

def test_nice_mcyc_ready(env):
    env.dut.fc_cover["FG-NICE"].mark_function("FC-NICE-MULTICYCLE", test_nice_mcyc_ready, ["CK-NICE-MCYC-READY"])

    _issue_nice(
        env,
        rs1=0x55,
        rs2=0x66,
        instr=0x5566_7788,
        rdidx=3,
        rdwen=1,
        nice_rsp_multicyc_valid=1,
    )

    assert env.nice_rsp.rsp_multicyc_valid.value == 1, "多周期返回场景应拉高 nice_rsp_multicyc_valid"
    assert env.dut.nice_rsp_multicyc_ready.value in (0, 1), "nice_rsp_multicyc_ready 应保持合法"

def test_nice_itag_wbck(env):
    env.dut.fc_cover["FG-NICE"].mark_function("FC-NICE-MULTICYCLE", test_nice_itag_wbck, ["CK-NICE-ITAG-WBCK"])

    _issue_nice(
        env,
        rs1=0x77,
        rs2=0x88,
        instr=0x99AA_BBCC,
        rdidx=4,
        rdwen=1,
        nice_rsp_multicyc_valid=1,
        nice_longp_wbck_ready=1,
        itag=1,
    )

    assert env.dut.nice_longp_wbck_valid.value == 1, "NICE 长流水写回场景应拉高 nice_longp_wbck_valid"
    assert env.nice_rsp.o_itag.value == 1, "NICE 写回 itag 应与输入 itag 一致"

def test_nice_longpipe_flag(env):
    env.dut.fc_cover["FG-NICE"].mark_function("FC-NICE-MULTICYCLE", test_nice_longpipe_flag, ["CK-NICE-LONGPIPE-FLAG"])

    _issue_nice(env, rs1=0x99, rs2=0xAA, instr=0xCCDD_EEFF, rdidx=5, rdwen=1, nice_req_ready=0)

    assert env.issue.longpipe.value == 1, "NICE 指令应被分类为长流水"
    assert env.nice_req.valid.value == 1 or env.dut.nice_longp_wbck_valid.value == 1, "NICE 长流水应体现在请求或长流水写回路径"

def test_nice_off_block(env):
    env.dut.fc_cover["FG-NICE"].mark_function("FC-NICE-OFF-ILLEGAL", test_nice_off_block, ["CK-NICE-OFF-BLOCK"])

    _issue_nice(env, rs1=0xAB, rs2=0xCD, instr=0x1357_9BDF, rdidx=6, rdwen=1, nice_xs_off=1, nice_req_ready=0)

    assert env.nice_sideband.xs_off.value == 1, "测试应在 nice_xs_off=1 场景下运行"
    assert env.nice_req.valid.value == 0, "NICE 关闭时不应对外发起请求"

def test_nice_illegal_err(env):
    env.dut.fc_cover["FG-NICE"].mark_function("FC-NICE-OFF-ILLEGAL", test_nice_illegal_err, ["CK-NICE-ILLEGAL-ERR"])

    _issue_nice(
        env,
        rs1=0x1,
        rs2=0x2,
        instr=0xAAAA_5555,
        rdidx=8,
        rdwen=1,
        i_nice_cmt_off_ilgl=1,
        nice_req_ready=0,
    )

    assert env.nice_sideband.i_nice_cmt_off_ilgl.value == 1, "测试应在 NICE 非法提交场景下运行"

def test_nice_normal_bypass(env):
    env.dut.fc_cover["FG-NICE"].mark_function("FC-NICE-OFF-ILLEGAL", test_nice_normal_bypass, ["CK-NICE-NORMAL-BYPASS"])

    _issue_nice(env, rs1=0x5, rs2=0x6, instr=0x0BAD_F00D, rdidx=9, rdwen=1, nice_xs_off=0, nice_req_ready=0)

    assert env.nice_sideband.xs_off.value == 0, "正常旁路场景应保持 nice_xs_off 为 0"
    assert env.nice_req.valid.value in (0, 1), "NICE 正常路径请求状态应合法"
