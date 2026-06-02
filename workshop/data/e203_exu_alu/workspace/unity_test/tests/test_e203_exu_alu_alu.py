import pytest
from e203_exu_alu_api import *


ALU_GRP = 0x0
ALU_ADD_BIT = 4
ALU_SUB_BIT = 5
ALU_XOR_BIT = 6
ALU_SLL_BIT = 7
ALU_SRL_BIT = 8
ALU_SRA_BIT = 9
ALU_OR_BIT = 10
ALU_AND_BIT = 11
ALU_SLT_BIT = 12
ALU_SLTU_BIT = 13
ALU_LUI_BIT = 14
ALU_OP2IMM_BIT = 15
ALU_OP1PC_BIT = 16


def _alu_info(
    *,
    add=0,
    sub=0,
    xor=0,
    sll=0,
    srl=0,
    sra=0,
    op_or=0,
    op_and=0,
    slt=0,
    sltu=0,
    lui=0,
    op2imm=0,
    op1pc=0,
):
    info = ALU_GRP
    info |= int(add) << ALU_ADD_BIT
    info |= int(sub) << ALU_SUB_BIT
    info |= int(xor) << ALU_XOR_BIT
    info |= int(sll) << ALU_SLL_BIT
    info |= int(srl) << ALU_SRL_BIT
    info |= int(sra) << ALU_SRA_BIT
    info |= int(op_or) << ALU_OR_BIT
    info |= int(op_and) << ALU_AND_BIT
    info |= int(slt) << ALU_SLT_BIT
    info |= int(sltu) << ALU_SLTU_BIT
    info |= int(lui) << ALU_LUI_BIT
    info |= int(op2imm) << ALU_OP2IMM_BIT
    info |= int(op1pc) << ALU_OP1PC_BIT
    return info


def _issue_alu(env, *, info, rs1=0, rs2=0, imm=0, rdidx=1):
    api_e203_exu_alu_reset(env, max_cycles=4)
    api_e203_exu_alu_issue_raw(
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
    return env


def test_arith_add(env):
    env.dut.fc_cover["FG-ALU"].mark_function("FC-ARITHMETIC", test_arith_add, ["CK-ARITH-ADD"])

    rs1 = 0x1111_2222
    rs2 = 0x0102_0304
    _issue_alu(env, info=_alu_info(add=1), rs1=rs1, rs2=rs2, rdidx=4)

    assert env.issue.longpipe.value == 0, "常规 ALU 加法不应被标记为长流水"
    assert env.wbck.valid.value == 1, "加法应产生写回"
    assert env.wbck.wdat.value == (rs1 + rs2) & 0xFFFF_FFFF, "加法写回结果错误"
    assert env.wbck.rdidx.value == 4, "加法写回应保留目标寄存器号"

def test_arith_sub(env):
    env.dut.fc_cover["FG-ALU"].mark_function("FC-ARITHMETIC", test_arith_sub, ["CK-ARITH-SUB"])

    rs1 = 0x1234_5678
    rs2 = 0x0234_0001
    _issue_alu(env, info=_alu_info(sub=1), rs1=rs1, rs2=rs2, rdidx=5)

    assert env.issue.longpipe.value == 0, "常规 ALU 减法不应被标记为长流水"
    assert env.wbck.valid.value == 1, "减法应产生写回"
    assert env.wbck.wdat.value == (rs1 - rs2) & 0xFFFF_FFFF, "减法写回结果错误"

def test_arith_imm(env):
    env.dut.fc_cover["FG-ALU"].mark_function("FC-ARITHMETIC", test_arith_imm, ["CK-ARITH-IMM"])

    rs1 = 0x0000_1000
    imm = 0x0000_001C
    _issue_alu(env, info=_alu_info(add=1, op2imm=1), rs1=rs1, rs2=0xFFFF_FFFF, imm=imm, rdidx=2)

    assert env.wbck.valid.value == 1, "立即数加法应产生写回"
    assert env.wbck.wdat.value == (rs1 + imm) & 0xFFFF_FFFF, "立即数算术结果应使用 i_imm 而不是 rs2"
    assert env.issue.ready.value == 1, "短路径 ALU 指令应在当前拍完成握手"

def test_logic_bitwise(env):
    env.dut.fc_cover["FG-ALU"].mark_function("FC-LOGIC-SHIFT", test_logic_bitwise, ["CK-LOGIC-BITWISE"])

    lhs = 0xF0F0_AA55
    rhs = 0x0FF0_55AA
    expected = lhs & rhs
    _issue_alu(env, info=_alu_info(op_and=1), rs1=lhs, rs2=rhs, rdidx=6)

    assert env.wbck.valid.value == 1, "按位逻辑运算应产生写回"
    assert env.wbck.wdat.value == expected, "按位与结果错误"
    assert env.dut.agu_icb_cmd_valid.value == 0, "纯 ALU 逻辑运算不应误发 AGU 命令"

def test_shift_left_right(env):
    env.dut.fc_cover["FG-ALU"].mark_function("FC-LOGIC-SHIFT", test_shift_left_right, ["CK-SHIFT-LEFT-RIGHT"])

    sll_in = 0x0000_0011
    sll_amt = 4
    _issue_alu(env, info=_alu_info(sll=1), rs1=sll_in, rs2=sll_amt, rdidx=8)
    assert env.wbck.wdat.value == (sll_in << sll_amt) & 0xFFFF_FFFF, "左移结果错误"

    srl_in = 0x8000_0000
    srl_amt = 3
    _issue_alu(env, info=_alu_info(srl=1), rs1=srl_in, rs2=srl_amt, rdidx=8)
    assert env.wbck.wdat.value == (srl_in >> srl_amt) & 0xFFFF_FFFF, "逻辑右移结果错误"

    sra_in = 0x8000_0000
    sra_amt = 3
    _issue_alu(env, info=_alu_info(sra=1), rs1=sra_in, rs2=sra_amt, rdidx=8)
    assert env.wbck.wdat.value == 0xF000_0000, "算术右移结果错误"

def test_shift_amount_bound(env):
    env.dut.fc_cover["FG-ALU"].mark_function("FC-LOGIC-SHIFT", test_shift_amount_bound, ["CK-SHIFT-AMOUNT-BOUND"])

    data = 0x1357_9BDF
    _issue_alu(env, info=_alu_info(sll=1), rs1=data, rs2=0, rdidx=10)
    assert env.wbck.wdat.value == data, "零移位应保持原值"

    _issue_alu(env, info=_alu_info(sll=1), rs1=data, rs2=32, rdidx=10)
    assert env.wbck.wdat.value == data, "移位量 32 应只取低 5 位并等效为 0 移位"

    _issue_alu(env, info=_alu_info(srl=1), rs1=data, rs2=31, rdidx=10)
    assert env.wbck.wdat.value == 0, "31 位逻辑右移边界结果错误"

def test_cmp_eq_ne(env):
    env.dut.fc_cover["FG-ALU"].mark_function("FC-COMPARE", test_cmp_eq_ne, ["CK-CMP-EQ-NE"])

    equal_val = 0x2468_ACE0
    _issue_alu(env, info=_alu_info(slt=1), rs1=equal_val, rs2=equal_val, rdidx=12)
    assert env.wbck.valid.value == 1, "比较指令应产生写回"
    assert env.wbck.wdat.value == 1, "相等场景下比较结果应为 1"

    _issue_alu(env, info=_alu_info(slt=1), rs1=equal_val, rs2=(equal_val + 1) & 0xFFFF_FFFF, rdidx=12)
    assert env.wbck.valid.value == 1, "比较指令应产生写回"
    assert env.wbck.wdat.value == 0, "不等场景下比较结果应为 0"

def test_cmp_signed(env):
    env.dut.fc_cover["FG-ALU"].mark_function("FC-COMPARE", test_cmp_signed, ["CK-CMP-SIGNED"])

    _issue_alu(env, info=_alu_info(slt=1), rs1=0xFFFF_FFFF, rs2=0x0000_0001, rdidx=14)
    assert env.wbck.valid.value == 1, "有符号比较应产生写回"
    assert env.wbck.wdat.value == 1, "有符号 -1 < 1 时结果应为 1"

    _issue_alu(env, info=_alu_info(slt=1), rs1=0x7FFF_FFFF, rs2=0x8000_0000, rdidx=14)
    assert env.wbck.valid.value == 1, "有符号比较应产生写回"
    assert env.wbck.wdat.value == 0, "有符号 2147483647 < -2147483648 时结果应为 0"

def test_cmp_unsigned(env):
    env.dut.fc_cover["FG-ALU"].mark_function("FC-COMPARE", test_cmp_unsigned, ["CK-CMP-UNSIGNED"])

    _issue_alu(env, info=_alu_info(sltu=1), rs1=0x0000_0001, rs2=0xFFFF_FFFF, rdidx=15)
    assert env.wbck.valid.value == 1, "无符号比较应产生写回"
    assert env.wbck.wdat.value == 1, "无符号 1 < 0xFFFFFFFF 时结果应为 1"

    _issue_alu(env, info=_alu_info(sltu=1), rs1=0xFFFF_FFFF, rs2=0x0000_0001, rdidx=15)
    assert env.wbck.valid.value == 1, "无符号比较应产生写回"
    assert env.wbck.wdat.value == 0, "无符号 0xFFFFFFFF < 1 时结果应为 0"
