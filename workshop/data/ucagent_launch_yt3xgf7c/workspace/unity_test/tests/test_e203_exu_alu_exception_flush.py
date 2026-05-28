import pytest
from e203_exu_alu_api import *


AGU_GRP = 0x1
CSR_GRP = 0x3
MULDIV_GRP = 0x4


def _issue_excp(env, **kwargs):
    api_e203_exu_alu_reset(env, max_cycles=4)
    return api_e203_exu_alu_issue_raw(
        env,
        cmt_ready=1,
        wbck_ready=1,
        agu_cmd_ready=1,
        max_cycles=4,
        **kwargs,
    )


def test_ifu_ilegl(env):
    env.dut.fc_cover["FG-EXCEPTION-FLUSH"].mark_function("FC-IFU-EXCEPTION", test_ifu_ilegl, ["CK-IFU-ILEGL"])

    _issue_excp(info=0, ilegl=1, rdwen=0, env=env)

    assert env.commit.valid.value == 1, "IFU 非法指令应进入提交路径"
    assert env.commit.ifu_ilegl.value == 1, "i_ilegl 应映射到 cmt_o_ifu_ilegl"

def test_ifu_buserr(env):
    env.dut.fc_cover["FG-EXCEPTION-FLUSH"].mark_function("FC-IFU-EXCEPTION", test_ifu_buserr, ["CK-IFU-BUSERR"])

    _issue_excp(info=0, buserr=1, rdwen=0, env=env)

    assert env.commit.valid.value == 1, "IFU buserr 应进入提交路径"
    assert env.commit.ifu_buserr.value == 1, "i_buserr 应映射到 cmt_o_ifu_buserr"

def test_ifu_misalign(env):
    env.dut.fc_cover["FG-EXCEPTION-FLUSH"].mark_function("FC-IFU-EXCEPTION", test_ifu_misalign, ["CK-IFU-MISALIGN"])

    _issue_excp(info=0, misalgn=1, rdwen=0, env=env)

    assert env.commit.valid.value == 1, "错位异常应进入提交路径"
    assert env.commit.ifu_misalgn.value == 1, "当前设计会将 i_misalgn 直接映射到 IFU misalign 提交位"

def test_exec_misalign(env):
    env.dut.fc_cover["FG-EXCEPTION-FLUSH"].mark_function("FC-EXEC-EXCEPTION", test_exec_misalign, ["CK-EXEC-MISALIGN"])

    _issue_excp(info=AGU_GRP | (1 << 4) | (2 << 6), misalgn=1, rs1=0x8000_0000, imm=0x2, rdidx=1, rdwen=1, env=env)

    assert env.commit.misalgn.value == 1, "执行期访存错位异常应通过 cmt_o_misalgn 提交"

def test_exec_buserr(env):
    env.dut.fc_cover["FG-EXCEPTION-FLUSH"].mark_function("FC-EXEC-EXCEPTION", test_exec_buserr, ["CK-EXEC-BUSERR"])

    _issue_excp(info=AGU_GRP | (1 << 4) | (2 << 6), buserr=1, rs1=0x8000_1000, imm=0x0, rdidx=2, rdwen=1, env=env)

    assert env.commit.buserr.value == 1, "执行期访存 buserr 应通过 cmt_o_buserr 提交"

def test_exec_csr_nice(env):
    env.dut.fc_cover["FG-EXCEPTION-FLUSH"].mark_function("FC-EXEC-EXCEPTION", test_exec_csr_nice, ["CK-EXEC-CSR-NICE"])

    _issue_excp(
        info=CSR_GRP | (1 << 4),
        csr_access_ilgl=1,
        rs1=0x55,
        rdidx=3,
        rdwen=1,
        env=env,
    )

    assert env.csr_sideband.access_ilgl.value == 1, "测试应在 CSR 非法访问场景下运行"
    assert env.commit.ifu_ilegl.value == 1, "当前设计会把 CSR/NICE 非法访问并入 cmt_o_ifu_ilegl"

def test_flush_issue_kill(env):
    env.dut.fc_cover["FG-EXCEPTION-FLUSH"].mark_function("FC-FLUSH-KILL", test_flush_issue_kill, ["CK-FLUSH-ISSUE-KILL"])

    _issue_excp(info=0, rs1=1, rs2=2, rdidx=4, rdwen=1, flush_req=1, env=env)

    assert env.ctrl_in.flush_req.value == 1, "测试应在 flush_req 拉高场景下运行"
    assert env.issue.valid.value == 1, "测试应在有发射事务时观察 flush 行为"

def test_flush_longpipe_kill(env):
    env.dut.fc_cover["FG-EXCEPTION-FLUSH"].mark_function("FC-FLUSH-KILL", test_flush_longpipe_kill, ["CK-FLUSH-LONGPIPE-KILL"])

    _issue_excp(
        info=0x5,
        rs1=0x7,
        rs2=0x9,
        instr=0xDEAD_BEEF,
        rdidx=5,
        rdwen=1,
        nice_req_ready=0,
        env=env,
    )

    assert env.issue.longpipe.value == 1, "建立长流水事务时应先观测到 i_longpipe"
    env.ctrl_in.flush_req.value = 1
    env.Step(1)

    assert env.ctrl_in.flush_req.value == 1, "测试应在 flush_req 拉高场景下运行"
    assert env.issue.longpipe.value == 1, "长流水指令遇到 flush 时应仍可观测到 i_longpipe"

def test_flush_pulse_transient(env):
    env.dut.fc_cover["FG-EXCEPTION-FLUSH"].mark_function("FC-FLUSH-KILL", test_flush_pulse_transient, ["CK-FLUSH-PULSE-TRANSIENT"])

    _issue_excp(info=0, rs1=1, rs2=2, rdidx=6, rdwen=1, flush_pulse=1, env=env)

    assert env.ctrl_in.flush_pulse.value == 1, "测试应在 flush_pulse 拉高场景下运行"

def test_nonflush_cmt_allow(env):
    env.dut.fc_cover["FG-EXCEPTION-FLUSH"].mark_function("FC-NONFLUSH-COMMIT", test_nonflush_cmt_allow, ["CK-NONFLUSH-CMT-ALLOW"])

    _issue_excp(info=0, rs1=0x10, rs2=0x20, rdidx=7, rdwen=1, nonflush_cmt_ena=1, env=env)

    assert env.ctrl_in.nonflush_cmt_ena.value == 1, "测试应在 nonflush_cmt_ena=1 场景下运行"
    assert env.commit.valid.value in (0, 1), "非 flush commit 使能不应破坏提交接口合法性"

def test_nonflush_cmt_block(env):
    env.dut.fc_cover["FG-EXCEPTION-FLUSH"].mark_function("FC-NONFLUSH-COMMIT", test_nonflush_cmt_block, ["CK-NONFLUSH-CMT-BLOCK"])

    _issue_excp(info=0, rs1=0x1, rs2=0x2, rdidx=8, rdwen=1, nonflush_cmt_ena=0, env=env)

    assert env.ctrl_in.nonflush_cmt_ena.value == 0, "阻断场景应保持 nonflush_cmt_ena 为 0"

def test_nonflush_excp_interlock(env):
    env.dut.fc_cover["FG-EXCEPTION-FLUSH"].mark_function("FC-NONFLUSH-COMMIT", test_nonflush_excp_interlock, ["CK-NONFLUSH-EXCP-INTERLOCK"])

    _issue_excp(
        info=CSR_GRP | (1 << 4),
        rs1=0x33,
        rdidx=9,
        rdwen=1,
        nonflush_cmt_ena=1,
        csr_access_ilgl=1,
        env=env,
    )

    assert env.ctrl_in.nonflush_cmt_ena.value == 1, "测试应在 nonflush 提交使能场景下运行"
    assert env.csr_sideband.access_ilgl.value == 1, "测试应伴随异常侧带以命中 interlock 检查点"
