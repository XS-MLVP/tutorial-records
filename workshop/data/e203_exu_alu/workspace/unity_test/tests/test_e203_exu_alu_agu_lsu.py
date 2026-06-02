import pytest
from e203_exu_alu_api import *


AGU_GRP = 0x1
AGU_LOAD_BIT = 4
AGU_STORE_BIT = 5
AGU_SIZE_LSB = 6
AGU_USIGN_BIT = 8
AGU_EXCL_BIT = 9
AGU_AMO_BIT = 10
AGU_AMOSWAP_BIT = 11
AGU_AMOADD_BIT = 12

SIZE_B = 0
SIZE_H = 1
SIZE_W = 2


def _agu_info(
    *,
    load=0,
    store=0,
    size=SIZE_W,
    usign=0,
    excl=0,
    amo=0,
    amoswap=0,
    amoadd=0,
):
    info = AGU_GRP
    info |= int(load) << AGU_LOAD_BIT
    info |= int(store) << AGU_STORE_BIT
    info |= (size & 0x3) << AGU_SIZE_LSB
    info |= int(usign) << AGU_USIGN_BIT
    info |= int(excl) << AGU_EXCL_BIT
    info |= int(amo) << AGU_AMO_BIT
    info |= int(amoswap) << AGU_AMOSWAP_BIT
    info |= int(amoadd) << AGU_AMOADD_BIT
    return info


def _issue_agu(env, *, info, rs1, rs2=0, imm=0, rdidx=1, rdwen=1, itag=1, agu_cmd_ready=1):
    api_e203_exu_alu_reset(env, max_cycles=4)
    return api_e203_exu_alu_issue_raw(
        env,
        info=info,
        rs1=rs1,
        rs2=rs2,
        imm=imm,
        rdidx=rdidx,
        rdwen=rdwen,
        itag=itag,
        cmt_ready=1,
        wbck_ready=1,
        agu_cmd_ready=agu_cmd_ready,
        max_cycles=4,
    )


def _start_amo(env, *, rs1, rs2, imm=0, itag=1, excl=1, amoadd=1, agu_cmd_ready=1):
    info = _agu_info(
        size=SIZE_W,
        usign=0,
        excl=excl,
        amo=1,
        amoadd=amoadd,
    )
    _issue_agu(
        env,
        info=info,
        rs1=rs1,
        rs2=rs2,
        imm=imm,
        rdidx=5,
        rdwen=1,
        itag=itag,
        agu_cmd_ready=agu_cmd_ready,
    )
    return info


def _drive_amo_response(env, *, rsp_rdata, rsp_err=0, hold_rsp_cycles=0):
    env.agu_rsp.valid.value = 1
    env.agu_rsp.err.value = rsp_err
    env.agu_rsp.excl_ok.value = 1
    env.agu_rsp.rdata.value = rsp_rdata
    env.Step(1)
    for _ in range(hold_rsp_cycles):
        env.Step(1)


def _wait_for_second_amo_cmd(env, max_cycles=6):
    for _ in range(max_cycles):
        if env.agu_cmd.valid.value and env.agu_cmd.read.value == 0:
            return
        env.Step(1)
    raise AssertionError("AMO 第二拍写命令未在预期周期内出现")


def _complete_amo(env, *, first_rsp_data, second_rsp_err=0, hold_last_rsp_cycles=0):
    _drive_amo_response(env, rsp_rdata=first_rsp_data)
    _wait_for_second_amo_cmd(env)
    env.agu_rsp.valid.value = 1
    env.agu_rsp.err.value = second_rsp_err
    env.agu_rsp.excl_ok.value = 1
    env.agu_rsp.rdata.value = 0
    env.Step(1)
    for _ in range(hold_last_rsp_cycles):
        env.Step(1)


def test_load_cmd(env):
    env.dut.fc_cover["FG-AGU-LSU"].mark_function("FC-LOAD", test_load_cmd, ["CK-LOAD-CMD"])

    base = 0x1000_0040
    imm = 0x18
    info = _agu_info(load=1, size=SIZE_W, usign=0)
    _issue_agu(env, info=info, rs1=base, imm=imm, rdidx=7, rdwen=1)

    assert env.agu_cmd.valid.value == 1, "Load 指令应发起 LSU 命令"
    assert env.agu_cmd.read.value == 1, "Load 命令必须标记为读"
    assert env.agu_cmd.addr.value == base + imm, "Load 地址应为 rs1 + imm"
    assert env.agu_cmd.size.value == SIZE_W, "Load 命令应携带正确 size"
    assert env.agu_cmd.usign.value == 0, "有符号 load 的 usign 应为 0"
    assert env.issue.longpipe.value == 1, "Load 应被识别为长流水 AGU 指令"

def test_load_rsp_wbck(env):
    env.dut.fc_cover["FG-AGU-LSU"].mark_function("FC-LOAD", test_load_rsp_wbck, ["CK-LOAD-RSP-WBCK"])

    rdidx = 13
    rsp_data = 0xDEAD_BEEF
    info = _agu_info(load=1, size=SIZE_W, usign=0)
    _issue_agu(env, info=info, rs1=0x1200_0000, imm=0x10, rdidx=rdidx, rdwen=1)

    env.agu_rsp.valid.value = 1
    env.agu_rsp.err.value = 0
    env.agu_rsp.excl_ok.value = 1
    env.agu_rsp.rdata.value = rsp_data
    env.Step(1)
    for _ in range(3):
        if env.wbck.valid.value:
            break
        env.Step(1)

    assert env.wbck.valid.value == 1, "Load 收到返回数据后应产生写回"
    assert env.wbck.wdat.value == rsp_data, "Load 写回数据应等于 LSU 返回数据"
    assert env.wbck.rdidx.value == rdidx, "Load 写回应保留原始 rdidx"

def test_load_usign_size(env):
    env.dut.fc_cover["FG-AGU-LSU"].mark_function("FC-LOAD", test_load_usign_size, ["CK-LOAD-USIGN-SIZE"])

    cases = [
        ("lb", SIZE_B, 0, 0x1000_0020, 0x0),
        ("lbu", SIZE_B, 1, 0x1000_0021, 0x0),
        ("lh", SIZE_H, 0, 0x1000_0040, 0x2),
        ("lhu", SIZE_H, 1, 0x1000_0044, 0x0),
        ("lw", SIZE_W, 0, 0x1000_0080, 0x0),
    ]

    for name, size, usign, base, imm in cases:
        info = _agu_info(load=1, size=size, usign=usign)
        _issue_agu(env, info=info, rs1=base, imm=imm, rdidx=9, rdwen=1)
        assert env.agu_cmd.valid.value == 1, f"{name} 应发起访存命令"
        assert env.agu_cmd.read.value == 1, f"{name} 应为读命令"
        assert env.agu_cmd.size.value == size, f"{name} 的 size 编码错误"
        assert env.agu_cmd.usign.value == usign, f"{name} 的 usign 编码错误"

def test_store_cmd(env):
    env.dut.fc_cover["FG-AGU-LSU"].mark_function("FC-STORE", test_store_cmd, ["CK-STORE-CMD"])

    base = 0x2000_0040
    imm = 0x0C
    store_data = 0x89AB_CDEF
    info = _agu_info(store=1, size=SIZE_W)
    _issue_agu(env, info=info, rs1=base, rs2=store_data, imm=imm, rdidx=0, rdwen=0)

    assert env.agu_cmd.valid.value == 1, "Store 应发起 LSU 命令"
    assert env.agu_cmd.read.value == 0, "Store 命令必须标记为写"
    assert env.agu_cmd.addr.value == base + imm, "Store 地址应为 rs1 + imm"
    assert env.agu_cmd.wdata.value == store_data, "字存储的写数据应直接为 rs2"
    assert env.agu_cmd.wmask.value == 0xF, "字存储应写满 4 个字节"

def test_store_wmask(env):
    env.dut.fc_cover["FG-AGU-LSU"].mark_function("FC-STORE", test_store_wmask, ["CK-STORE-WMASK"])

    cases = [
        ("sb@2", SIZE_B, 0x10, 0xA1B2_C3D4, 0x2, 0x04, 0xD4D4_D4D4),
        ("sh@2", SIZE_H, 0x20, 0x1122_3344, 0x2, 0x0C, 0x3344_3344),
        ("sw", SIZE_W, 0x40, 0x5566_7788, 0x0, 0x0F, 0x5566_7788),
    ]

    for name, size, base, data, imm, exp_wmask, exp_wdata in cases:
        info = _agu_info(store=1, size=size)
        _issue_agu(env, info=info, rs1=base, rs2=data, imm=imm, rdidx=0, rdwen=0)
        assert env.agu_cmd.valid.value == 1, f"{name} 应发起写命令"
        assert env.agu_cmd.read.value == 0, f"{name} 不应被编码成读命令"
        assert env.agu_cmd.wmask.value == exp_wmask, f"{name} 的 wmask 不符合按字节使能规则"
        assert env.agu_cmd.wdata.value == exp_wdata, f"{name} 的写数据拼接形式错误"

def test_store_no_wbck(env):
    env.dut.fc_cover["FG-AGU-LSU"].mark_function("FC-STORE", test_store_no_wbck, ["CK-STORE-NO-WBCK"])

    info = _agu_info(store=1, size=SIZE_W)
    _issue_agu(env, info=info, rs1=0x3000_0000, rs2=0x1234_5678, imm=0x8, rdidx=0, rdwen=0)

    assert env.commit.valid.value == 1, "Store 应向提交口报告完成"
    assert env.commit.stamo.value == 1, "Store 应在提交口标记为 stamo"
    assert env.wbck.valid.value == 0, "纯 Store 不应产生写回结果"

def test_amo_excl_cmd(env):
    env.dut.fc_cover["FG-AGU-LSU"].mark_function("FC-AMO", test_amo_excl_cmd, ["CK-AMO-EXCL-CMD"])

    _start_amo(
        env,
        rs1=0x9000_0040,
        rs2=0x0102_0304,
        imm=0x0,
        itag=1,
        excl=1,
        amoadd=1,
        agu_cmd_ready=0,
    )

    assert env.agu_cmd.valid.value == 1, "AMO 首拍应发起 LSU 命令"
    assert env.agu_cmd.read.value == 1, "AMO 首拍应先读旧值"
    assert env.agu_cmd.excl.value == 1, "独占 AMO 命令应拉高 excl"
    assert env.agu_cmd.back2agu.value == 1, "AMO 读响应应回到 AGU 做读改写"
    assert env.agu_cmd.lock.value == 1, "AMO 首拍应带 lock 属性"
    assert env.issue.ready.value == 0, "AMO 首拍在 LSU 背压下不应向上游释放 ready"

def test_amo_alu_result(env):
    env.dut.fc_cover["FG-AGU-LSU"].mark_function("FC-AMO", test_amo_alu_result, ["CK-AMO-ALU-RESULT"])

    base = 0x9000_1000
    first_rsp_data = 0x1020_3040
    amo_operand = 0x0101_0101
    _start_amo(env, rs1=base, rs2=amo_operand, imm=0x0, itag=1, excl=1, amoadd=1)

    _drive_amo_response(env, rsp_rdata=first_rsp_data)
    _wait_for_second_amo_cmd(env)

    assert env.agu_cmd.valid.value == 1, "AMO 第二拍应继续发起写命令"
    assert env.agu_cmd.read.value == 0, "AMO 第二拍必须是写回命令"
    assert env.agu_cmd.addr.value == base, "AMO 第二拍应回写到原地址"
    assert env.agu_cmd.wdata.value == (first_rsp_data + amo_operand) & 0xFFFF_FFFF, "AMOADD 应写回旧值与 rs2 的和"
    assert env.agu_cmd.wmask.value == 0xF, "AMO 第二拍应整字写回"

def test_amo_wait_clear(env):
    env.dut.fc_cover["FG-AGU-LSU"].mark_function("FC-AMO", test_amo_wait_clear, ["CK-AMO-WAIT-CLEAR"])

    _start_amo(env, rs1=0x9000_2000, rs2=0x0000_0003, imm=0x0, itag=1, excl=1, amoadd=1)
    assert env.ctrl_out.amo_wait.value == 1, "AMO 执行期间 amo_wait 应保持为 1"

    _complete_amo(env, first_rsp_data=0x20, hold_last_rsp_cycles=1)

    assert env.wbck.valid.value == 1, "AMO 完成后应产生写回"
    assert env.wbck.wdat.value == 0x20, "AMO 写回应返回首拍读出的旧值"
    env.Step(1)
    assert env.ctrl_out.amo_wait.value == 0, "AMO 完成并退出状态机后应清除 amo_wait"

def test_icb_cmd_hold(env):
    env.dut.fc_cover["FG-AGU-LSU"].mark_function("FC-ICB-HANDSHAKE", test_icb_cmd_hold, ["CK-ICB-CMD-HOLD"])

    base = 0x4000_0100
    imm = 0x10
    info = _agu_info(load=1, size=SIZE_W, usign=0)
    _issue_agu(env, info=info, rs1=base, imm=imm, rdidx=11, rdwen=1, agu_cmd_ready=0)

    first_addr = int(env.agu_cmd.addr.value)
    first_size = int(env.agu_cmd.size.value)
    first_usign = int(env.agu_cmd.usign.value)
    assert env.agu_cmd.valid.value == 1, "下游背压时 AGU 仍应保持 valid"
    assert env.issue.ready.value == 0, "命令未握手完成时上游不应看到 ready"

    env.Step(2)

    assert env.agu_cmd.valid.value == 1, "背压持续时 valid 不应撤销"
    assert env.agu_cmd.addr.value == first_addr, "背压期间命令地址必须保持稳定"
    assert env.agu_cmd.size.value == first_size, "背压期间 size 必须保持稳定"
    assert env.agu_cmd.usign.value == first_usign, "背压期间 usign 必须保持稳定"

    env.agu_cmd.ready.value = 1
    env.Step(1)
    assert env.issue.ready.value == 1, "背压解除后命令应完成握手"

def test_icb_rsp_ready(env):
    env.dut.fc_cover["FG-AGU-LSU"].mark_function("FC-ICB-HANDSHAKE", test_icb_rsp_ready, ["CK-ICB-RSP-READY"])

    info = _agu_info(load=1, size=SIZE_W, usign=0)
    _issue_agu(env, info=info, rs1=0x5000_0000, imm=0x0, rdidx=3, rdwen=1)

    env.agu_rsp.valid.value = 1
    env.agu_rsp.err.value = 0
    env.agu_rsp.excl_ok.value = 1
    env.agu_rsp.rdata.value = 0xCAFE_BABE
    env.Step(1)

    assert env.agu_rsp.ready.value == 1, "AGU 对 LSU 响应通道应始终保持 ready"
    assert env.agu_rsp.valid.value == 1, "测试应在 rsp_valid=1 的场景下验证 ready"

def test_itag_back2agu(env):
    env.dut.fc_cover["FG-AGU-LSU"].mark_function("FC-ICB-HANDSHAKE", test_itag_back2agu, ["CK-ITAG-BACK2AGU"])

    itag = 1
    _start_amo(env, rs1=0x9000_3000, rs2=0x55AA_1234, imm=0x0, itag=itag, excl=1, amoadd=1, agu_cmd_ready=0)

    assert env.agu_cmd.valid.value == 1, "需要回到 AGU 的 AMO 首拍应发起命令"
    assert env.agu_cmd.back2agu.value == 1, "AMO 首拍响应应回到 AGU"
    assert env.agu_cmd.itag.value == itag, "返回 AGU 的事务必须携带原始 itag"

def test_agu_misalign(env):
    env.dut.fc_cover["FG-AGU-LSU"].mark_function("FC-AGU-EXCEPTION", test_agu_misalign, ["CK-AGU-MISALIGN"])

    base = 0x6000_1000
    imm = 0x4
    api_e203_exu_alu_reset(env, max_cycles=4)
    api_e203_exu_alu_issue_raw(
        env,
        info=_agu_info(load=1, size=SIZE_W, usign=0),
        rs1=base,
        imm=imm,
        rdidx=6,
        rdwen=1,
        misalgn=1,
        cmt_ready=1,
        wbck_ready=1,
        agu_cmd_ready=1,
        max_cycles=4,
    )

    assert env.commit.valid.value == 1, "访存错位异常应进入提交路径"
    assert env.commit.misalgn.value == 1, "访存错位异常应拉高 cmt_o_misalgn"
    assert env.commit.badaddr.value == base + imm, "访存错位异常应上报触发异常的地址"

def test_agu_buserr(env):
    env.dut.fc_cover["FG-AGU-LSU"].mark_function("FC-AGU-EXCEPTION", test_agu_buserr, ["CK-AGU-BUSERR"])

    base = 0x6100_0000
    imm = 0x20
    info = _agu_info(load=1, size=SIZE_W, usign=0)
    _issue_agu(env, info=info, rs1=base, imm=imm, rdidx=8, rdwen=1)

    env.agu_rsp.valid.value = 1
    env.agu_rsp.err.value = 1
    env.agu_rsp.excl_ok.value = 1
    env.agu_rsp.rdata.value = 0
    env.Step(1)
    for _ in range(3):
        if env.commit.valid.value:
            break
        env.Step(1)

    assert env.commit.valid.value == 1, "访存 buserr 应进入提交路径"
    assert env.commit.buserr.value == 1, "LSU 返回 err 时应拉高 cmt_o_buserr"
    assert env.commit.badaddr.value == base + imm, "buserr 场景应上报触发异常的访存地址"

def test_agu_badaddr(env):
    env.dut.fc_cover["FG-AGU-LSU"].mark_function("FC-AGU-EXCEPTION", test_agu_badaddr, ["CK-AGU-BADADDR"])

    base = 0x6200_0100
    imm = 0x8
    api_e203_exu_alu_reset(env, max_cycles=4)
    api_e203_exu_alu_issue_raw(
        env,
        info=_agu_info(load=1, size=SIZE_W, usign=0),
        rs1=base,
        imm=imm,
        rdidx=10,
        rdwen=1,
        misalgn=1,
        cmt_ready=1,
        wbck_ready=1,
        agu_cmd_ready=1,
        max_cycles=4,
    )

    assert env.commit.valid.value == 1, "异常访存应进入提交路径"
    assert env.commit.badaddr.value == base + imm, "badaddr 应准确反映异常访存地址"
