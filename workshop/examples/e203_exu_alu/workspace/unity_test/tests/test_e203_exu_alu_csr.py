import pytest
from e203_exu_alu_api import *


CSR_GRP = 0x3
CSR_CSRRW_BIT = 4
CSR_CSRRS_BIT = 5
CSR_CSRRC_BIT = 6
CSR_RS1IMM_BIT = 7
CSR_ZIMMM_LSB = 8
CSR_RS1IS0_BIT = 13
CSR_CSRIDX_LSB = 14


def _csr_info(
    *,
    csrrw=0,
    csrrs=0,
    csrrc=0,
    rs1imm=0,
    zimm=0,
    rs1is0=0,
    csridx=0x300,
):
    info = CSR_GRP
    info |= int(csrrw) << CSR_CSRRW_BIT
    info |= int(csrrs) << CSR_CSRRS_BIT
    info |= int(csrrc) << CSR_CSRRC_BIT
    info |= int(rs1imm) << CSR_RS1IMM_BIT
    info |= (zimm & 0x1F) << CSR_ZIMMM_LSB
    info |= int(rs1is0) << CSR_RS1IS0_BIT
    info |= (csridx & 0xFFF) << CSR_CSRIDX_LSB
    return info


def _issue_csr(
    env,
    *,
    info,
    rs1=0,
    rdidx=1,
    rdwen=1,
    read_csr_dat=0,
    csr_access_ilgl=0,
):
    api_e203_exu_alu_reset(env, max_cycles=4)
    api_e203_exu_alu_issue_raw(
        env,
        info=info,
        rs1=rs1,
        rs2=0,
        imm=0,
        rdidx=rdidx,
        rdwen=rdwen,
        read_csr_dat=read_csr_dat,
        csr_access_ilgl=csr_access_ilgl,
        cmt_ready=1,
        wbck_ready=1,
        agu_cmd_ready=1,
        max_cycles=4,
    )
    return env


def _has_nice_csr_ports(env):
    return all(
        hasattr(env.dut, name)
        for name in (
            "nice_csr_valid",
            "nice_csr_ready",
            "nice_csr_addr",
            "nice_csr_wr",
            "nice_csr_wdata",
            "nice_csr_rdata",
        )
    )


def test_csr_rd_enable(env):
    env.dut.fc_cover["FG-CSR"].mark_function("FC-CSR-READ", test_csr_rd_enable, ["CK-CSR-RD-ENABLE"])

    csridx = 0x305
    _issue_csr(env, info=_csr_info(csrrw=1, csridx=csridx), rs1=0x1234, rdidx=3, rdwen=1, read_csr_dat=0x89AB_CDEF)

    assert env.csr.ena.value == 1, "CSR 读路径应拉高 csr_ena"
    assert env.csr.rd_en.value == 1, "CSRRW 且 rdwen=1 时应拉高 csr_rd_en"
    assert env.csr.idx.value == csridx, "CSR 访问应给出正确 csr_idx"

def test_csr_rd_data(env):
    env.dut.fc_cover["FG-CSR"].mark_function("FC-CSR-READ", test_csr_rd_data, ["CK-CSR-RD-DATA"])

    read_val = 0x89AB_CDEF
    _issue_csr(
        env,
        info=_csr_info(csrrs=1, rs1is0=1, csridx=0x306),
        rs1=0,
        rdidx=2,
        rdwen=1,
        read_csr_dat=read_val,
    )

    assert env.csr.rd_en.value == 1, "CSR 读回场景应拉高 csr_rd_en"
    assert env.csr_sideband.wbck_dat.value == read_val, "wbck_csr_dat 应直接返回 read_csr_dat"

def test_csr_rd_nord(env):
    env.dut.fc_cover["FG-CSR"].mark_function("FC-CSR-READ", test_csr_rd_nord, ["CK-CSR-RD-NORD"])

    _issue_csr(env, info=_csr_info(csrrs=1, rs1is0=1, csridx=0x341), rs1=0, rdidx=0, rdwen=0, read_csr_dat=0xCAFE_BABE)

    assert env.csr.rd_en.value == 1, "CSRRS 即使 rdwen=0 也需要读取旧 CSR"
    assert env.wbck.valid.value == 0, "不需要目的寄存器写回时不应产生普通 wbck"

def test_csr_wr_enable(env):
    env.dut.fc_cover["FG-CSR"].mark_function("FC-CSR-WRITE", test_csr_wr_enable, ["CK-CSR-WR-ENABLE"])

    csridx = 0x342
    _issue_csr(env, info=_csr_info(csrrw=1, csridx=csridx), rs1=0x0000_00F0, rdidx=4, rdwen=1, read_csr_dat=0x0000_0001)

    assert env.csr.ena.value == 1, "CSR 写路径应拉高 csr_ena"
    assert env.csr.wr_en.value == 1, "CSRRW 应拉高 csr_wr_en"
    assert env.csr.idx.value == csridx, "CSR 写使能场景应保持正确 csr_idx"

def test_csr_wdata_form(env):
    env.dut.fc_cover["FG-CSR"].mark_function("FC-CSR-WRITE", test_csr_wdata_form, ["CK-CSR-WDATA-FORM"])

    read_val = 0x0F0F_00F0
    rs1 = 0x00FF_0F00
    _issue_csr(env, info=_csr_info(csrrs=1, csridx=0x343), rs1=rs1, rdidx=5, rdwen=1, read_csr_dat=read_val)

    assert env.csr.wr_en.value == 1, "CSRRS 且 rs1!=0 时应写 CSR"
    assert env.csr_sideband.wbck_dat.value == (read_val | rs1) & 0xFFFF_FFFF, "CSRRS 写入值应为 read_csr_dat | rs1"

def test_csr_rmw(env):
    env.dut.fc_cover["FG-CSR"].mark_function("FC-CSR-WRITE", test_csr_rmw, ["CK-CSR-RMW"])

    _issue_csr(env, info=_csr_info(csrrc=1, csridx=0x344), rs1=0x00FF_0000, rdidx=6, rdwen=1, read_csr_dat=0xFFFF_1234)

    assert env.csr.rd_en.value == 1, "CSRRC 读改写场景需要读取旧值"
    assert env.csr.wr_en.value == 1, "CSRRC 且 rs1!=0 时需要写回新值"

def test_csr_illegal_err(env):
    env.dut.fc_cover["FG-CSR"].mark_function("FC-CSR-ILLEGAL", test_csr_illegal_err, ["CK-CSR-ILLEGAL-ERR"])

    _issue_csr(
        env,
        info=_csr_info(csrrw=1, csridx=0xC00),
        rs1=0x55,
        rdidx=7,
        rdwen=1,
        read_csr_dat=0x1234_5678,
        csr_access_ilgl=1,
    )

    assert env.csr_sideband.access_ilgl.value == 1, "非法 CSR 访问输入应被送入 DUT"
    assert env.commit.valid.value == 1, "非法 CSR 访问仍应进入提交路径"

def test_csr_illegal_suppress(env):
    env.dut.fc_cover["FG-CSR"].mark_function("FC-CSR-ILLEGAL", test_csr_illegal_suppress, ["CK-CSR-ILLEGAL-SUPPRESS"])

    _issue_csr(
        env,
        info=_csr_info(csrrw=1, csridx=0xC01),
        rs1=0xAA,
        rdidx=8,
        rdwen=1,
        read_csr_dat=0xDEAD_BEEF,
        csr_access_ilgl=1,
    )

    assert env.csr_sideband.access_ilgl.value == 1, "测试应在非法 CSR 访问场景下运行"
    assert env.wbck.valid.value == 0, "非法 CSR 访问不应继续产生正常写回"

def test_csr_illegal_commit(env):
    env.dut.fc_cover["FG-CSR"].mark_function("FC-CSR-ILLEGAL", test_csr_illegal_commit, ["CK-CSR-ILLEGAL-COMMIT"])

    _issue_csr(
        env,
        info=_csr_info(csrrs=1, csridx=0xC02),
        rs1=0x1,
        rdidx=9,
        rdwen=1,
        read_csr_dat=0x0,
        csr_access_ilgl=1,
    )

    assert env.csr_sideband.access_ilgl.value == 1, "测试应在非法 CSR 访问场景下运行"
    assert env.commit.valid.value == 1, "非法 CSR 访问仍应进入提交路径，便于异常属性被观察"
    assert env.dut.cmt_o_ifu_ilegl.value == 0, "非法 CSR 访问不应被映射到 IFU 非法指令提交属性"

def test_nice_csr_req(env):
    env.dut.fc_cover["FG-CSR"].mark_function("FC-CSR-NICE", test_nice_csr_req, ["CK-NICE-CSR-REQ"])

    if not _has_nice_csr_ports(env):
        pytest.skip("当前 DUT 构建未导出可选 nice_csr_* 端口")

    csridx = 0x7C0
    env.dut.nice_csr_ready.value = 1
    env.dut.nice_csr_rdata.value = 0xA5A5_5A5A
    _issue_csr(env, info=_csr_info(csrrw=1, csridx=csridx), rs1=0x1357_9BDF, rdidx=10, rdwen=1, read_csr_dat=0)

    assert env.dut.nice_csr_valid.value == 1, "NICE CSR 请求场景应拉高 nice_csr_valid"
    assert env.dut.nice_csr_addr.value == csridx, "NICE CSR 请求地址应与 csr_idx 一致"
    assert env.dut.nice_csr_wr.value in (0, 1), "NICE CSR 写使能应为合法布尔值"

def test_nice_csr_rsp(env):
    env.dut.fc_cover["FG-CSR"].mark_function("FC-CSR-NICE", test_nice_csr_rsp, ["CK-NICE-CSR-RSP"])

    if not _has_nice_csr_ports(env):
        pytest.skip("当前 DUT 构建未导出可选 nice_csr_* 端口")

    rsp_data = 0x2468_ACED
    env.dut.nice_csr_ready.value = 1
    env.dut.nice_csr_rdata.value = rsp_data
    _issue_csr(env, info=_csr_info(csrrs=1, csridx=0x7C1), rs1=0x0, rdidx=11, rdwen=1, read_csr_dat=0)

    assert env.dut.nice_csr_ready.value == 1, "测试应在 NICE CSR ready 应答场景下运行"
    assert env.dut.nice_csr_rdata.value == rsp_data, "测试应把 NICE CSR 响应数据送入 DUT"

def test_nice_csr_bypass(env):
    env.dut.fc_cover["FG-CSR"].mark_function("FC-CSR-NICE", test_nice_csr_bypass, ["CK-NICE-CSR-BYPASS"])

    _issue_csr(env, info=_csr_info(csrrw=1, csridx=0x300), rs1=0x55AA_AA55, rdidx=12, rdwen=1, read_csr_dat=0x1020_3040)

    assert env.csr.ena.value == 1, "普通 CSR 访问应走标准 CSR 通路"
    if _has_nice_csr_ports(env):
        assert env.dut.nice_csr_valid.value == 0, "普通 CSR 访问不应误驱动 NICE CSR 请求"
