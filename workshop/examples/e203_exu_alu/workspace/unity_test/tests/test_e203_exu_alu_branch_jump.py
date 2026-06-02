import pytest
from e203_exu_alu_api import *


BJP_GRP = 0x2
RV32_BIT = 3
BJP_JUMP_BIT = 4
BJP_BPRDT_BIT = 5
BJP_BEQ_BIT = 6
BJP_BNE_BIT = 7
BJP_BLT_BIT = 8
BJP_BGT_BIT = 9
BJP_BLTU_BIT = 10
BJP_BGTU_BIT = 11
BJP_BXX_BIT = 12
BJP_MRET_BIT = 13
BJP_DRET_BIT = 14
BJP_FENCE_BIT = 15
BJP_FENCEI_BIT = 16


def _bjp_info(
    *,
    jump=0,
    bprdt=0,
    beq=0,
    bne=0,
    blt=0,
    bgt=0,
    bltu=0,
    bgtu=0,
    bxx=0,
    mret=0,
    dret=0,
    fencei=0,
    rv32=1,
):
    info = BJP_GRP
    info |= int(rv32) << RV32_BIT
    info |= int(jump) << BJP_JUMP_BIT
    info |= int(bprdt) << BJP_BPRDT_BIT
    info |= int(beq) << BJP_BEQ_BIT
    info |= int(bne) << BJP_BNE_BIT
    info |= int(blt) << BJP_BLT_BIT
    info |= int(bgt) << BJP_BGT_BIT
    info |= int(bltu) << BJP_BLTU_BIT
    info |= int(bgtu) << BJP_BGTU_BIT
    info |= int(bxx) << BJP_BXX_BIT
    info |= int(mret) << BJP_MRET_BIT
    info |= int(dret) << BJP_DRET_BIT
    info |= int(fencei) << BJP_FENCEI_BIT
    return info


def _issue_bjp(env, *, info, rs1=0, rs2=0, imm=0, pc=0x80000000, instr=0x6F, rdidx=1, rdwen=1):
    api_e203_exu_alu_reset(env, max_cycles=4)
    api_e203_exu_alu_issue_raw(
        env,
        info=info,
        rs1=rs1,
        rs2=rs2,
        imm=imm,
        pc=pc,
        instr=instr,
        rdidx=rdidx,
        rdwen=rdwen,
        cmt_ready=1,
        wbck_ready=1,
        agu_cmd_ready=1,
        max_cycles=4,
    )
    return env


def test_branch_taken(env):
    env.dut.fc_cover["FG-BRANCH-JUMP"].mark_function("FC-COND-BRANCH", test_branch_taken, ["CK-BRANCH-TAKEN"])

    _issue_bjp(
        env,
        info=_bjp_info(bxx=1, beq=1, bprdt=1),
        rs1=0x55AA,
        rs2=0x55AA,
        imm=0x10,
        pc=0x80000100,
        instr=0x00000063,
        rdidx=0,
        rdwen=0,
    )

    assert env.commit.valid.value == 1, "分支指令应进入提交路径"
    assert env.commit.bjp.value == 1, "条件分支应标记 cmt_o_bjp"
    assert env.commit.bjp_rslv.value == 1, "成立分支应拉高 resolved"

def test_branch_nottaken(env):
    env.dut.fc_cover["FG-BRANCH-JUMP"].mark_function("FC-COND-BRANCH", test_branch_nottaken, ["CK-BRANCH-NOTTAKEN"])

    _issue_bjp(
        env,
        info=_bjp_info(bxx=1, beq=1, bprdt=1),
        rs1=0x12,
        rs2=0x34,
        imm=0x10,
        pc=0x80000110,
        instr=0x00000063,
        rdidx=0,
        rdwen=0,
    )

    assert env.commit.valid.value == 1, "分支指令应进入提交路径"
    assert env.commit.bjp.value == 1, "条件分支应标记 cmt_o_bjp"
    assert env.commit.bjp_rslv.value == 0, "条件不满足时 resolved 应为 0"

def test_branch_signed_unsigned(env):
    env.dut.fc_cover["FG-BRANCH-JUMP"].mark_function("FC-COND-BRANCH", test_branch_signed_unsigned, ["CK-BRANCH-SIGNED-UNSIGNED"])

    lhs = 0xFFFF_FFFF
    rhs = 0x0000_0001
    _issue_bjp(
        env,
        info=_bjp_info(bxx=1, blt=1, bprdt=0),
        rs1=lhs,
        rs2=rhs,
        imm=0x20,
        pc=0x80000120,
        instr=0x00004063,
        rdidx=0,
        rdwen=0,
    )
    assert env.commit.bjp.value == 1, "有符号分支应标记为 BJP"
    assert env.commit.bjp_rslv.value == 1, "有符号 -1 < 1 应判定为成立"

    _issue_bjp(
        env,
        info=_bjp_info(bxx=1, bltu=1, bprdt=0),
        rs1=lhs,
        rs2=rhs,
        imm=0x20,
        pc=0x80000124,
        instr=0x00006063,
        rdidx=0,
        rdwen=0,
    )
    assert env.commit.bjp.value == 1, "无符号分支应标记为 BJP"
    assert env.commit.bjp_rslv.value == 0, "无符号 0xFFFFFFFF < 1 应判定为不成立"

def test_jal_wbck(env):
    env.dut.fc_cover["FG-BRANCH-JUMP"].mark_function("FC-JUMP-LINK", test_jal_wbck, ["CK-JAL-WBCK"])

    pc = 0x80000200
    _issue_bjp(
        env,
        info=_bjp_info(jump=1, bprdt=1),
        rs1=0,
        rs2=0,
        imm=0x40,
        pc=pc,
        instr=0x0000006F,
        rdidx=5,
        rdwen=1,
    )

    assert env.commit.bjp.value == 1, "JAL 应标记为 BJP 提交"
    assert env.wbck.valid.value == 1, "JAL 应产生返回地址写回"
    assert env.wbck.wdat.value == pc + 4, "JAL 写回应为 pc + 4"
    assert env.wbck.rdidx.value == 5, "JAL 写回应保留目标寄存器号"

def test_jalr_wbck(env):
    env.dut.fc_cover["FG-BRANCH-JUMP"].mark_function("FC-JUMP-LINK", test_jalr_wbck, ["CK-JALR-WBCK"])

    pc = 0x80000240
    _issue_bjp(
        env,
        info=_bjp_info(jump=1, bprdt=0),
        rs1=0x1000,
        rs2=0x20,
        imm=0x08,
        pc=pc,
        instr=0x00000067,
        rdidx=6,
        rdwen=1,
    )

    assert env.commit.bjp.value == 1, "JALR 应标记为 BJP 提交"
    assert env.wbck.valid.value == 1, "JALR 应产生返回地址写回"
    assert env.wbck.wdat.value == pc + 4, "JALR 写回应为 pc + 4"
    assert env.wbck.rdidx.value == 6, "JALR 写回应保留目标寄存器号"

def test_jump_pc_context(env):
    env.dut.fc_cover["FG-BRANCH-JUMP"].mark_function("FC-JUMP-LINK", test_jump_pc_context, ["CK-JUMP-PC-CONTEXT"])

    pc = 0x80000300
    instr = 0x00C0006F
    imm = 0x0C
    _issue_bjp(
        env,
        info=_bjp_info(jump=1, bprdt=1),
        rs1=0,
        rs2=0,
        imm=imm,
        pc=pc,
        instr=instr,
        rdidx=7,
        rdwen=1,
    )

    assert env.commit.bjp.value == 1, "跳转指令应标记为 BJP"
    assert env.commit.pc.value == pc, "提交口应保留原始 PC"
    assert env.commit.instr.value == instr, "提交口应保留原始指令字"
    assert env.commit.imm.value == imm, "提交口应保留原始立即数"

def test_bjp_commit_flags(env):
    env.dut.fc_cover["FG-BRANCH-JUMP"].mark_function("FC-BJP-COMMIT", test_bjp_commit_flags, ["CK-BJP-COMMIT-FLAGS"])

    _issue_bjp(
        env,
        info=_bjp_info(mret=1),
        rs1=0,
        rs2=0,
        imm=0,
        pc=0x80000340,
        instr=0x30200073,
        rdidx=0,
        rdwen=0,
    )

    assert env.commit.mret.value == 1, "mret 指令应拉高 cmt_o_mret"
    assert env.commit.bjp.value == 0, "mret 不应同时标记为普通 BJP"
    assert env.commit.dret.value == 0, "mret 与 dret 标记应互斥"
    assert env.commit.fencei.value == 0, "mret 与 fencei 标记应互斥"

def test_bjp_prdt_rslv(env):
    env.dut.fc_cover["FG-BRANCH-JUMP"].mark_function("FC-BJP-COMMIT", test_bjp_prdt_rslv, ["CK-BJP-PRDT-RSLV"])

    _issue_bjp(
        env,
        info=_bjp_info(bxx=1, bne=1, bprdt=0),
        rs1=0x1,
        rs2=0x2,
        imm=0x10,
        pc=0x80000380,
        instr=0x00101063,
        rdidx=0,
        rdwen=0,
    )

    assert env.commit.bjp.value == 1, "分支比较应标记为 BJP"
    assert env.commit.bjp_prdt.value == 0, "预测位应来自 bprdt 编码"
    assert env.commit.bjp_rslv.value == 1, "BNE 在 rs1 != rs2 时应解析为成立"

def test_sysret_fencei(env):
    env.dut.fc_cover["FG-BRANCH-JUMP"].mark_function("FC-BJP-COMMIT", test_sysret_fencei, ["CK-SYSRET-FENCEI"])

    _issue_bjp(
        env,
        info=_bjp_info(fencei=1),
        rs1=0,
        rs2=0,
        imm=0,
        pc=0x80000400,
        instr=0x0000100F,
        rdidx=0,
        rdwen=0,
    )

    assert env.commit.fencei.value == 1, "FENCEI 指令应拉高 cmt_o_fencei"
    assert env.commit.mret.value == 0, "FENCEI 与 mret 标记应互斥"
    assert env.commit.dret.value == 0, "FENCEI 与 dret 标记应互斥"
