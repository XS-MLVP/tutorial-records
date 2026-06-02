import random

import pytest
import ucagent

from e203_exu_alu_api import *


MASK32 = 0xFFFF_FFFF

ALU_GRP = 0x0
ALU_ADD_BIT = 4
ALU_SUB_BIT = 5
ALU_XOR_BIT = 6
ALU_SLL_BIT = 7
ALU_SRL_BIT = 8
ALU_SRA_BIT = 9
ALU_AND_BIT = 11
ALU_SLT_BIT = 12
ALU_SLTU_BIT = 13
ALU_OP2IMM_BIT = 15

BJP_GRP = 0x2
RV32_BIT = 3
BJP_BPRDT_BIT = 5
BJP_BEQ_BIT = 6
BJP_BNE_BIT = 7
BJP_BLT_BIT = 8
BJP_BLTU_BIT = 10
BJP_BXX_BIT = 12


def _u32(value):
    return value & MASK32


def _s32(value):
    value &= MASK32
    return value if value < 0x8000_0000 else value - 0x1_0000_0000


def _alu_info(
    *,
    add=0,
    sub=0,
    xor=0,
    sll=0,
    srl=0,
    sra=0,
    op_and=0,
    slt=0,
    sltu=0,
    op2imm=0,
):
    info = ALU_GRP
    info |= int(add) << ALU_ADD_BIT
    info |= int(sub) << ALU_SUB_BIT
    info |= int(xor) << ALU_XOR_BIT
    info |= int(sll) << ALU_SLL_BIT
    info |= int(srl) << ALU_SRL_BIT
    info |= int(sra) << ALU_SRA_BIT
    info |= int(op_and) << ALU_AND_BIT
    info |= int(slt) << ALU_SLT_BIT
    info |= int(sltu) << ALU_SLTU_BIT
    info |= int(op2imm) << ALU_OP2IMM_BIT
    return info


def _bjp_info(*, beq=0, bne=0, blt=0, bltu=0, bprdt=0):
    info = BJP_GRP
    info |= 1 << RV32_BIT
    info |= int(bprdt) << BJP_BPRDT_BIT
    info |= int(beq) << BJP_BEQ_BIT
    info |= int(bne) << BJP_BNE_BIT
    info |= int(blt) << BJP_BLT_BIT
    info |= int(bltu) << BJP_BLTU_BIT
    info |= 1 << BJP_BXX_BIT
    return info


def _issue_alu(env, *, info, rs1=0, rs2=0, imm=0, rdidx=1):
    api_e203_exu_alu_reset(env, max_cycles=4)
    return api_e203_exu_alu_issue_raw(
        env,
        info=info,
        rs1=rs1,
        rs2=rs2,
        imm=imm,
        rdidx=rdidx,
        rdwen=1,
        cmt_ready=1,
        wbck_ready=1,
        agu_cmd_ready=1,
        max_cycles=4,
    )


def _issue_bjp(env, *, info, rs1=0, rs2=0, imm=0, pc=0x8000_0000):
    api_e203_exu_alu_reset(env, max_cycles=4)
    return api_e203_exu_alu_issue_raw(
        env,
        info=info,
        rs1=rs1,
        rs2=rs2,
        imm=imm,
        pc=pc,
        instr=0x0000_0063,
        rdidx=0,
        rdwen=0,
        cmt_ready=1,
        wbck_ready=1,
        agu_cmd_ready=1,
        max_cycles=4,
    )


@pytest.mark.parametrize("variant", ["arith_logic", "compare"])
def test_random_alu(env, variant):
    """随机验证常规 ALU 的算术/逻辑/比较写回语义。"""
    if variant == "arith_logic":
        env.dut.fc_cover["FG-ALU"].mark_function(
            "FC-ARITHMETIC",
            test_random_alu,
            ["CK-ARITH-ADD", "CK-ARITH-SUB", "CK-ARITH-IMM"],
        )
        env.dut.fc_cover["FG-ALU"].mark_function(
            "FC-LOGIC-SHIFT",
            test_random_alu,
            ["CK-LOGIC-BITWISE", "CK-SHIFT-LEFT-RIGHT", "CK-SHIFT-AMOUNT-BOUND"],
        )
    else:
        env.dut.fc_cover["FG-ALU"].mark_function(
            "FC-COMPARE",
            test_random_alu,
            ["CK-CMP-SIGNED", "CK-CMP-UNSIGNED"],
        )

    repeat = ucagent.repeat_count()
    base_seed = 0xE203_1000 if variant == "arith_logic" else 0xE203_2000

    for idx in range(repeat):
        rng = random.Random(base_seed + idx)
        rs1 = rng.getrandbits(32)
        rs2 = rng.getrandbits(32)
        imm = rng.getrandbits(32)
        rdidx = (idx % 31) + 1

        if variant == "arith_logic":
            op = rng.choice(["add", "sub", "add_imm", "and", "xor", "sll", "srl", "sra"])
            if op == "add":
                _issue_alu(env, info=_alu_info(add=1), rs1=rs1, rs2=rs2, rdidx=rdidx)
                expected = _u32(rs1 + rs2)
            elif op == "sub":
                _issue_alu(env, info=_alu_info(sub=1), rs1=rs1, rs2=rs2, rdidx=rdidx)
                expected = _u32(rs1 - rs2)
            elif op == "add_imm":
                _issue_alu(env, info=_alu_info(add=1, op2imm=1), rs1=rs1, rs2=0, imm=imm, rdidx=rdidx)
                expected = _u32(rs1 + imm)
            elif op == "and":
                _issue_alu(env, info=_alu_info(op_and=1), rs1=rs1, rs2=rs2, rdidx=rdidx)
                expected = _u32(rs1 & rs2)
            elif op == "xor":
                _issue_alu(env, info=_alu_info(xor=1), rs1=rs1, rs2=rs2, rdidx=rdidx)
                expected = _u32(rs1 ^ rs2)
            elif op == "sll":
                shamt = rs2 & 0x1F
                _issue_alu(env, info=_alu_info(sll=1), rs1=rs1, rs2=rs2, rdidx=rdidx)
                expected = _u32(rs1 << shamt)
            elif op == "srl":
                shamt = rs2 & 0x1F
                _issue_alu(env, info=_alu_info(srl=1), rs1=rs1, rs2=rs2, rdidx=rdidx)
                expected = _u32(rs1 >> shamt)
            else:
                shamt = rs2 & 0x1F
                _issue_alu(env, info=_alu_info(sra=1), rs1=rs1, rs2=rs2, rdidx=rdidx)
                expected = _u32(_s32(rs1) >> shamt)

            assert env.issue.longpipe.value == 0, f"{op} 随机场景不应误标记为长流水，seed={base_seed + idx:#x}"
            assert env.wbck.valid.value == 1, f"{op} 随机场景应产生写回，seed={base_seed + idx:#x}"
            assert env.wbck.rdidx.value == rdidx, f"{op} 写回 rdidx 不匹配，seed={base_seed + idx:#x}"
            assert env.wbck.wdat.value == expected, (
                f"{op} 随机结果错误，seed={base_seed + idx:#x} rs1={rs1:#010x} rs2={rs2:#010x} imm={imm:#010x}"
            )
        else:
            op = rng.choice(["slt", "sltu"])
            if op == "slt":
                _issue_alu(env, info=_alu_info(slt=1), rs1=rs1, rs2=rs2, rdidx=rdidx)
                expected = int(_s32(rs1) < _s32(rs2))
            else:
                _issue_alu(env, info=_alu_info(sltu=1), rs1=rs1, rs2=rs2, rdidx=rdidx)
                expected = int(_u32(rs1) < _u32(rs2))

            assert env.wbck.valid.value == 1, f"{op} 随机场景应产生写回，seed={base_seed + idx:#x}"
            assert env.wbck.wdat.value == expected, (
                f"{op} 随机比较结果错误，seed={base_seed + idx:#x} rs1={rs1:#010x} rs2={rs2:#010x}"
            )


@pytest.mark.parametrize("variant", ["eq_ne", "signed_unsigned"])
def test_random_branch(env, variant):
    """随机验证条件分支解析结果。"""
    if variant == "eq_ne":
        env.dut.fc_cover["FG-BRANCH-JUMP"].mark_function(
            "FC-COND-BRANCH",
            test_random_branch,
            ["CK-BRANCH-TAKEN", "CK-BRANCH-NOTTAKEN"],
        )
    else:
        env.dut.fc_cover["FG-BRANCH-JUMP"].mark_function(
            "FC-COND-BRANCH",
            test_random_branch,
            ["CK-BRANCH-SIGNED-UNSIGNED"],
        )

    repeat = ucagent.repeat_count()
    base_seed = 0xE203_3000 if variant == "eq_ne" else 0xE203_4000

    for idx in range(repeat):
        rng = random.Random(base_seed + idx)
        rs1 = rng.getrandbits(32)
        rs2 = rng.getrandbits(32)
        imm = (rng.getrandbits(12) << 1) & MASK32
        pc = _u32(0x8000_0000 + (idx << 2))

        if variant == "eq_ne":
            op = rng.choice(["beq", "bne"])
            if op == "beq" and (idx & 1):
                rs2 = rs1
            if op == "bne" and not (idx & 1):
                rs2 = rs1

            _issue_bjp(
                env,
                info=_bjp_info(beq=int(op == "beq"), bne=int(op == "bne"), bprdt=rng.randint(0, 1)),
                rs1=rs1,
                rs2=rs2,
                imm=imm,
                pc=pc,
            )
            expected = int(rs1 == rs2) if op == "beq" else int(rs1 != rs2)
        else:
            op = rng.choice(["blt", "bltu"])
            _issue_bjp(
                env,
                info=_bjp_info(blt=int(op == "blt"), bltu=int(op == "bltu"), bprdt=rng.randint(0, 1)),
                rs1=rs1,
                rs2=rs2,
                imm=imm,
                pc=pc,
            )
            expected = int(_s32(rs1) < _s32(rs2)) if op == "blt" else int(_u32(rs1) < _u32(rs2))

        assert env.commit.valid.value == 1, f"{op} 分支应进入提交路径，seed={base_seed + idx:#x}"
        assert env.commit.bjp.value == 1, f"{op} 分支应标记为 BJP，seed={base_seed + idx:#x}"
        assert env.commit.bjp_rslv.value == expected, (
            f"{op} 分支解析错误，seed={base_seed + idx:#x} rs1={rs1:#010x} rs2={rs2:#010x}"
        )
