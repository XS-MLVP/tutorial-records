import pytest
from e203_exu_alu_api import *


ALU_GRP = 0x0
AGU_GRP = 0x1
MULDIV_GRP = 0x4
NICE_GRP = 0x5
CSR_GRP = 0x3


def _issue_dispatch(
    env,
    *,
    info,
    rs1=0,
    rs2=0,
    imm=0,
    instr=0,
    rdidx=1,
    rdwen=1,
    agu_cmd_ready=1,
    nice_req_ready=0,
):
    api_e203_exu_alu_reset(env, max_cycles=4)
    return api_e203_exu_alu_issue_raw(
        env,
        info=info,
        rs1=rs1,
        rs2=rs2,
        imm=imm,
        instr=instr,
        rdidx=rdidx,
        rdwen=rdwen,
        cmt_ready=1,
        wbck_ready=1,
        agu_cmd_ready=agu_cmd_ready,
        nice_req_ready=nice_req_ready,
        max_cycles=4,
    )


def test_route_alu(env):
    env.dut.fc_cover["FG-DISPATCH"].mark_function("FC-DECODE-ROUTE", test_route_alu, ["CK-ROUTE-ALU"])

    _issue_dispatch(env, info=ALU_GRP, rs1=0x11, rs2=0x22, rdidx=3, rdwen=1)

    assert env.issue.longpipe.value == 0, "常规 ALU 指令不应被分类为长流水"
    assert env.agu_cmd.valid.value == 0, "常规 ALU 指令不应误路由到 AGU"
    assert env.csr.ena.value == 0, "常规 ALU 指令不应误触发 CSR 通路"
    assert env.nice_req.valid.value == 0, "常规 ALU 指令不应误触发 NICE 请求"

def test_route_submodule(env):
    env.dut.fc_cover["FG-DISPATCH"].mark_function("FC-DECODE-ROUTE", test_route_submodule, ["CK-ROUTE-SUBMODULE"])

    _issue_dispatch(env, info=AGU_GRP | (1 << 4) | (2 << 6), rs1=0x1000_0000, imm=0x20, rdidx=2, rdwen=1)

    assert env.agu_cmd.valid.value == 1, "AGU 子模块路径应发起 LSU 命令"
    assert env.issue.longpipe.value == 1, "AGU 访存路径应被识别为长流水"

def test_route_mutex(env):
    env.dut.fc_cover["FG-DISPATCH"].mark_function("FC-DECODE-ROUTE", test_route_mutex, ["CK-ROUTE-MUTEX"])

    cases = [
        (ALU_GRP, dict(rs1=1, rs2=2, rdidx=4, rdwen=1)),
        (CSR_GRP | (1 << 5) | (1 << 13), dict(rs1=0, rs2=0, rdidx=0, rdwen=0, read_csr_dat=0x1234_5678)),
        (AGU_GRP | (1 << 4) | (2 << 6), dict(rs1=0x1000, imm=0x4, rdidx=6, rdwen=1)),
    ]

    for info, kwargs in cases:
        api_e203_exu_alu_reset(env, max_cycles=4)
        api_e203_exu_alu_issue_raw(
            env,
            info=info,
            cmt_ready=1,
            wbck_ready=1,
            agu_cmd_ready=1,
            max_cycles=4,
            **kwargs,
        )
        active_paths = (
            int(env.agu_cmd.valid.value == 1)
            + int(env.csr.ena.value == 1)
            + int(env.nice_req.valid.value == 1)
            + int(env.commit.bjp.value == 1)
            + int(env.wbck.valid.value == 1 and env.issue.longpipe.value == 0)
        )
        assert active_paths <= 1, "同一拍最多只能选择一条功能路径"

def test_ready_propagate(env):
    env.dut.fc_cover["FG-DISPATCH"].mark_function("FC-READY-BACKPRESSURE", test_ready_propagate, ["CK-READY-PROPAGATE"])

    _issue_dispatch(env, info=ALU_GRP, rs1=0x1, rs2=0x2, rdidx=7, rdwen=1)
    ready_short = int(env.issue.ready.value)

    _issue_dispatch(env, info=AGU_GRP | (1 << 4) | (2 << 6), rs1=0x2000_0000, imm=0x8, rdidx=7, rdwen=1, agu_cmd_ready=0)
    ready_stall = int(env.issue.ready.value)

    assert ready_short in (0, 1), "顶层 i_ready 应保持为合法布尔值"
    assert ready_stall in (0, 1), "背压场景下 i_ready 仍应保持为合法布尔值"
    assert ready_short >= ready_stall, "下游 AGU 背压时不应比短路径场景更容易接收事务"

def test_stall_hold(env):
    env.dut.fc_cover["FG-DISPATCH"].mark_function("FC-READY-BACKPRESSURE", test_stall_hold, ["CK-STALL-HOLD"])

    api_e203_exu_alu_reset(env, max_cycles=4)
    env.commit.ready.value = 1
    env.wbck.ready.value = 1
    env.agu_cmd.ready.value = 0
    env.ctrl_in.rst_n.value = 1
    env.issue.valid.value = 1
    env.issue.info.value = AGU_GRP | (1 << 4) | (2 << 6)
    env.issue.rs1.value = 0x3000_0000
    env.issue.imm.value = 0x10
    env.issue.rdidx.value = 8
    env.issue.rdwen.value = 1
    env.Step(1)

    first_addr = int(env.agu_cmd.addr.value)
    first_valid = int(env.agu_cmd.valid.value)
    first_ready = int(env.issue.ready.value)
    env.Step(1)

    assert first_valid == 1, "AGU 背压场景下应保持命令 valid"
    assert first_ready == 0, "AGU 下游未 ready 时顶层应阻止握手完成"
    assert env.agu_cmd.valid.value == 1, "背压持续时 AGU 命令应保持 valid"
    assert env.agu_cmd.addr.value == first_addr, "背压持续时 AGU 命令地址应保持稳定"

def test_valid_ready_complete(env):
    env.dut.fc_cover["FG-DISPATCH"].mark_function("FC-READY-BACKPRESSURE", test_valid_ready_complete, ["CK-VALID-READY-COMPLETE"])

    snapshot = _issue_dispatch(env, info=ALU_GRP, rs1=0x1234, rs2=0x1, rdidx=9, rdwen=1)

    assert snapshot["i_ready"] == 1, "单周期短路径应完成 valid/ready 握手"
    assert snapshot["cmt_o_valid"] == 1 or snapshot["wbck_o_valid"] == 1 or snapshot["i_longpipe"] == 1, (
        "握手完成后应在提交、写回或长流水标记中体现事务已被接收"
    )

def test_longpipe_shortpath(env):
    env.dut.fc_cover["FG-DISPATCH"].mark_function("FC-LONGPIPE-CLASSIFY", test_longpipe_shortpath, ["CK-LONGPIPE-SHORTPATH"])

    _issue_dispatch(env, info=ALU_GRP, rs1=0xAAAA_0001, rs2=0x10, rdidx=10, rdwen=1)

    assert env.issue.longpipe.value == 0, "ALU 短路径不应拉高 i_longpipe"
    assert env.agu_cmd.valid.value == 0, "短路径不应误触发 AGU 命令"
    assert env.nice_req.valid.value == 0, "短路径不应误触发 NICE 请求"

def test_longpipe_agu(env):
    env.dut.fc_cover["FG-DISPATCH"].mark_function("FC-LONGPIPE-CLASSIFY", test_longpipe_agu, ["CK-LONGPIPE-AGU"])

    _issue_dispatch(env, info=AGU_GRP | (1 << 4) | (2 << 6), rs1=0x4000_0040, imm=0x4, rdidx=11, rdwen=1)

    assert env.agu_cmd.valid.value == 1, "AGU 访存类指令应发起命令"
    assert env.issue.longpipe.value == 1, "AGU 路径应拉高 i_longpipe"

def test_longpipe_mdv_nice(env):
    env.dut.fc_cover["FG-DISPATCH"].mark_function("FC-LONGPIPE-CLASSIFY", test_longpipe_mdv_nice, ["CK-LONGPIPE-MDV-NICE"])

    _issue_dispatch(env, info=MULDIV_GRP | (1 << 4), rs1=0x3, rs2=0x5, rdidx=12, rdwen=1)
    mdv_longpipe = int(env.issue.longpipe.value)
    mdv_agu = int(env.agu_cmd.valid.value)
    mdv_nice = int(env.nice_req.valid.value)

    _issue_dispatch(
        env,
        info=NICE_GRP,
        rs1=0x1111_2222,
        rs2=0x3333_4444,
        instr=0xDEAD_BEEF,
        rdidx=13,
        rdwen=1,
        nice_req_ready=0,
    )

    assert (mdv_longpipe == 1 and mdv_agu == 0 and mdv_nice == 0) or (
        env.issue.longpipe.value == 1 and env.nice_req.valid.value == 1
    ), "MULDIV 或 NICE 至少应有一路体现长流水分类且不误走 AGU"
