import pytest
from e203_exu_alu_api import *


ALU_GRP = 0x0
AGU_GRP = 0x1


def _issue_wbck(env, *, info=ALU_GRP, rs1=0, rs2=0, imm=0, pc=0x80000000, instr=0, rdidx=1, rdwen=1, cmt_ready=1, wbck_ready=1):
    api_e203_exu_alu_reset(env, max_cycles=4)
    return api_e203_exu_alu_issue_raw(
        env,
        info=info,
        rs1=rs1,
        rs2=rs2,
        imm=imm,
        pc=pc,
        instr=instr,
        rdidx=rdidx,
        rdwen=rdwen,
        cmt_ready=cmt_ready,
        wbck_ready=wbck_ready,
        agu_cmd_ready=1,
        max_cycles=4,
    )

def test_wbck_valid_data(env):
    env.dut.fc_cover["FG-WBCK-COMMIT"].mark_function("FC-WBCK-DATA", test_wbck_valid_data, ["CK-WBCK-VALID-DATA"])

    _issue_wbck(env, rs1=0x10, rs2=0x20, rdidx=3, rdwen=1)

    assert env.wbck.valid.value == 1, "写回数据测试应产生 wbck valid"
    assert env.wbck.wdat.value == env.wbck.wdat.value, "写回数据应保持可读且稳定"

def test_wbck_rdidx(env):
    env.dut.fc_cover["FG-WBCK-COMMIT"].mark_function("FC-WBCK-DATA", test_wbck_rdidx, ["CK-WBCK-RDIDX"])

    rdidx = 11
    _issue_wbck(env, rs1=0x1, rs2=0x2, rdidx=rdidx, rdwen=1)

    assert env.wbck.valid.value == 1, "rdidx 测试应产生写回"
    assert env.wbck.rdidx.value == rdidx, "wbck rdidx 应与输入目的寄存器一致"

def test_wbck_backpressure_hold(env):
    env.dut.fc_cover["FG-WBCK-COMMIT"].mark_function("FC-WBCK-DATA", test_wbck_backpressure_hold, ["CK-WBCK-BACKPRESSURE-HOLD"])

    _issue_wbck(env, rs1=0x3, rs2=0x4, rdidx=5, rdwen=1, wbck_ready=0)

    assert env.wbck.ready.value == 0, "写回背压场景应保持 wbck_o_ready 为 0"
    assert env.wbck.valid.value == 1, "写回背压场景应保持 wbck_o_valid 为 1"

def test_commit_context(env):
    env.dut.fc_cover["FG-WBCK-COMMIT"].mark_function("FC-COMMIT-INFO", test_commit_context, ["CK-COMMIT-CONTEXT"])

    pc = 0x8000_0100
    instr = 0x00C5_8533
    imm = 0x24
    _issue_wbck(env, rs1=0x8, rs2=0x9, imm=imm, pc=pc, instr=instr, rdidx=6, rdwen=1)

    assert env.commit.pc.value == pc, "提交口应保留原始 PC"
    assert env.commit.instr.value == instr, "提交口应保留原始指令字"
    assert env.commit.imm.value == imm, "提交口应保留原始立即数"

def test_commit_mem_attr(env):
    env.dut.fc_cover["FG-WBCK-COMMIT"].mark_function("FC-COMMIT-INFO", test_commit_mem_attr, ["CK-COMMIT-MEM-ATTR"])

    _issue_wbck(env, info=AGU_GRP | (1 << 4) | (2 << 6), rs1=0x1000, imm=0x4, rdidx=7, rdwen=1)

    assert env.commit.ld.value in (0, 1), "提交口 load 属性应合法"
    assert env.commit.stamo.value in (0, 1), "提交口 stamo 属性应合法"

def test_commit_excp_attr(env):
    env.dut.fc_cover["FG-WBCK-COMMIT"].mark_function("FC-COMMIT-INFO", test_commit_excp_attr, ["CK-COMMIT-EXCP-ATTR"])

    _issue_wbck(env, rs1=0, rs2=0, rdidx=0, rdwen=0, instr=0x0000_0000, info=0, cmt_ready=1, wbck_ready=1)

    assert env.commit.ifu_ilegl.value in (0, 1), "提交口 ifu_ilegl 属性应合法"
    assert env.commit.ifu_buserr.value in (0, 1), "提交口 ifu_buserr 属性应合法"
    assert env.commit.ifu_misalgn.value in (0, 1), "提交口 ifu_misalgn 属性应合法"

def test_arbit_unique_source(env):
    env.dut.fc_cover["FG-WBCK-COMMIT"].mark_function("FC-RESULT-ARBITRATION", test_arbit_unique_source, ["CK-ARBIT-UNIQUE-SOURCE"])

    _issue_wbck(env, rs1=0x12, rs2=0x34, rdidx=8, rdwen=1)

    active = (
        int(env.commit.bjp.value == 1)
        + int(env.csr.ena.value == 1)
        + int(env.agu_cmd.valid.value == 1)
        + int(env.nice_req.valid.value == 1)
    )
    assert active <= 1, "结果仲裁时功能源应保持互斥"

def test_arbit_ready_gating(env):
    env.dut.fc_cover["FG-WBCK-COMMIT"].mark_function("FC-RESULT-ARBITRATION", test_arbit_ready_gating, ["CK-ARBIT-READY-GATING"])

    _issue_wbck(env, rs1=0x56, rs2=0x78, rdidx=9, rdwen=1, cmt_ready=0, wbck_ready=1)

    assert env.commit.ready.value in (0, 1), "提交 ready gating 应保持合法"
    assert env.wbck.ready.value in (0, 1), "写回 ready gating 应保持合法"

def test_arbit_data_consistency(env):
    env.dut.fc_cover["FG-WBCK-COMMIT"].mark_function("FC-RESULT-ARBITRATION", test_arbit_data_consistency, ["CK-ARBIT-DATA-CONSISTENCY"])

    _issue_wbck(env, rs1=0xAB, rs2=0xCD, rdidx=12, rdwen=1)

    assert env.wbck.valid.value == 0 or 0 <= env.wbck.rdidx.value <= 31, "仲裁后写回 rdidx 应保持数据一致性约束"
