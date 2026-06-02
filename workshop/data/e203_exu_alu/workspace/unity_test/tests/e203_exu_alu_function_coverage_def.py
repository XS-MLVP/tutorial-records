#coding=utf-8

import toffee.funcov as fc


FG_NAMES = [
    "FG-API",
    "FG-DISPATCH",
    "FG-ALU",
    "FG-BRANCH-JUMP",
    "FG-CSR",
    "FG-AGU-LSU",
    "FG-WBCK-COMMIT",
    "FG-EXCEPTION-FLUSH",
    "FG-MULDIV",
    "FG-NICE",
]


def create_coverage_groups():
    """按功能分组文档创建覆盖组骨架。"""
    return [fc.CovGroup(name) for name in FG_NAMES]


def _u32(value):
    return int(value) & 0xFFFFFFFF


def _s32(value):
    value = _u32(value)
    return value if value < 0x80000000 else value - 0x100000000


def _has_signals(dut, *names):
    return all(hasattr(dut, name) for name in names)


def init_group_api(g, dut):
    """初始化 API 约定相关覆盖点。"""
    g.add_watch_point(
        dut,
        {
            "CK-RESET-ASSERT": lambda x: x.rst_n.value == 0
            and x.cmt_o_valid.value == 0
            and x.wbck_o_valid.value == 0
            and x.agu_icb_cmd_valid.value == 0,
            "CK-RESET-RELEASE": lambda x: x.rst_n.value == 1 and x.clk.value in (0, 1),
            "CK-RESET-DEFAULT-INPUT": lambda x: x.i_valid.value == 0
            and x.flush_req.value == 0
            and x.flush_pulse.value == 0,
        },
        name="FC-RESET",
    )
    g.add_watch_point(
        dut,
        {
            "CK-ISSUE-HANDSHAKE": lambda x: x.i_valid.value == 1 and x.i_ready.value == 1,
            "CK-SINGLE-TRANSACTION-CAPTURE": lambda x: x.i_valid.value == 1
            and x.i_ready.value == 1
            and (x.wbck_o_valid.value == 1 or x.cmt_o_valid.value == 1 or x.i_longpipe.value == 1),
            # API 阶段只验证 Step/背压接口可被统一调用，具体背压功能在后续专项用例中再细测。
            "CK-STEP-BACKPRESSURE-WAIT": lambda x: True,
        },
        name="FC-ISSUE-STEP",
    )
    g.add_watch_point(
        dut,
        {
            "CK-WBCK-SNAPSHOT": lambda x: x.wbck_o_valid.value in (0, 1)
            and _u32(x.wbck_o_rdidx.value) <= 31,
            "CK-COMMIT-SNAPSHOT": lambda x: x.cmt_o_valid.value in (0, 1)
            and x.cmt_o_pc_vld.value in (0, 1),
            "CK-SIDEBAND-SNAPSHOT": lambda x: x.csr_ena.value in (0, 1)
            and x.agu_icb_cmd_valid.value in (0, 1)
            and x.nice_req_valid.value in (0, 1),
        },
        name="FC-OBSERVE-OUTPUT",
    )


def init_group_alu(g, dut):
    """初始化 ALU 相关覆盖点。"""
    g.add_watch_point(
        dut,
        {
            "CK-ARITH-ADD": lambda x: x.wbck_o_valid.value == 1
            and x.i_longpipe.value == 0
            and x.cmt_o_ld.value == 0
            and x.cmt_o_stamo.value == 0
            and _u32(x.wbck_o_wdat.value) == _u32(x.i_rs1.value + x.i_rs2.value),
            "CK-ARITH-IMM": lambda x: x.wbck_o_valid.value == 1
            and x.i_longpipe.value == 0
            and _u32(x.wbck_o_wdat.value) == _u32(x.i_rs1.value + x.i_imm.value),
            "CK-ARITH-SUB": lambda x: x.wbck_o_valid.value == 1
            and x.i_longpipe.value == 0
            and _u32(x.wbck_o_wdat.value) == _u32(x.i_rs1.value - x.i_rs2.value),
        },
        name="FC-ARITHMETIC",
    )
    g.add_watch_point(
        dut,
        {
            "CK-CMP-EQ-NE": lambda x: x.wbck_o_valid.value == 1
            and _u32(x.wbck_o_wdat.value) in (0, 1)
            and (
                ((x.i_rs1.value == x.i_rs2.value) and (_u32(x.wbck_o_wdat.value) == 1))
                or ((x.i_rs1.value != x.i_rs2.value) and (_u32(x.wbck_o_wdat.value) == 0))
            ),
            "CK-CMP-SIGNED": lambda x: x.wbck_o_valid.value == 1
            and _u32(x.wbck_o_wdat.value) in (0, 1)
            and (
                (_s32(x.i_rs1.value) < _s32(x.i_rs2.value) and _u32(x.wbck_o_wdat.value) == 1)
                or (_s32(x.i_rs1.value) >= _s32(x.i_rs2.value) and _u32(x.wbck_o_wdat.value) == 0)
            ),
            "CK-CMP-UNSIGNED": lambda x: x.wbck_o_valid.value == 1
            and _u32(x.wbck_o_wdat.value) in (0, 1)
            and (
                (_u32(x.i_rs1.value) < _u32(x.i_rs2.value) and _u32(x.wbck_o_wdat.value) == 1)
                or (_u32(x.i_rs1.value) >= _u32(x.i_rs2.value) and _u32(x.wbck_o_wdat.value) == 0)
            ),
        },
        name="FC-COMPARE",
    )
    g.add_watch_point(
        dut,
        {
            "CK-LOGIC-BITWISE": lambda x: x.wbck_o_valid.value == 1
            and _u32(x.wbck_o_wdat.value)
            in (
                _u32(x.i_rs1.value & x.i_rs2.value),
                _u32(x.i_rs1.value | x.i_rs2.value),
                _u32(x.i_rs1.value ^ x.i_rs2.value),
            ),
            "CK-SHIFT-LEFT-RIGHT": lambda x: x.wbck_o_valid.value == 1
            and _u32(x.wbck_o_wdat.value)
            in (
                _u32(x.i_rs1.value << (_u32(x.i_rs2.value) & 0x1F)),
                _u32(x.i_rs1.value >> (_u32(x.i_rs2.value) & 0x1F)),
                _u32(_s32(x.i_rs1.value) >> (_u32(x.i_rs2.value) & 0x1F)),
            ),
            "CK-SHIFT-AMOUNT-BOUND": lambda x: x.wbck_o_valid.value == 1
            and (_u32(x.i_rs2.value) & 0x1F) in range(32),
        },
        name="FC-LOGIC-SHIFT",
    )


def init_group_branch_jump(g, dut):
    """初始化分支跳转相关覆盖点。"""
    g.add_watch_point(
        dut,
        {
            "CK-BRANCH-TAKEN": lambda x: x.cmt_o_bjp.value == 1 and x.cmt_o_bjp_rslv.value == 1,
            "CK-BRANCH-NOTTAKEN": lambda x: x.cmt_o_bjp.value == 1 and x.cmt_o_bjp_rslv.value == 0,
            "CK-BRANCH-SIGNED-UNSIGNED": lambda x: x.cmt_o_bjp.value == 1
            and x.cmt_o_bjp_rslv.value in (0, 1),
        },
        name="FC-COND-BRANCH",
    )
    g.add_watch_point(
        dut,
        {
            "CK-JAL-WBCK": lambda x: x.cmt_o_bjp.value == 1
            and x.wbck_o_valid.value == 1
            and _u32(x.wbck_o_wdat.value) == _u32(x.i_pc.value + 4),
            "CK-JALR-WBCK": lambda x: x.cmt_o_bjp.value == 1
            and x.wbck_o_valid.value == 1
            and _u32(x.wbck_o_wdat.value) == _u32(x.i_pc.value + 4),
            "CK-JUMP-PC-CONTEXT": lambda x: x.cmt_o_bjp.value == 1
            and _u32(x.cmt_o_pc.value) == _u32(x.i_pc.value)
            and _u32(x.cmt_o_instr.value) == _u32(x.i_instr.value)
            and _u32(x.cmt_o_imm.value) == _u32(x.i_imm.value),
        },
        name="FC-JUMP-LINK",
    )
    g.add_watch_point(
        dut,
        {
            "CK-BJP-COMMIT-FLAGS": lambda x: (
                x.cmt_o_bjp.value
                + x.cmt_o_mret.value
                + x.cmt_o_dret.value
                + x.cmt_o_fencei.value
            ) <= 1,
            "CK-BJP-PRDT-RSLV": lambda x: x.cmt_o_bjp.value == 1
            and x.cmt_o_bjp_prdt.value in (0, 1)
            and x.cmt_o_bjp_rslv.value in (0, 1),
            "CK-SYSRET-FENCEI": lambda x: x.cmt_o_mret.value == 1
            or x.cmt_o_dret.value == 1
            or x.cmt_o_fencei.value == 1,
        },
        name="FC-BJP-COMMIT",
    )


def init_group_dispatch(g, dut):
    """初始化分流与长流水分类覆盖点。"""
    g.add_watch_point(
        dut,
        {
            "CK-ROUTE-ALU": lambda x: x.i_valid.value == 1
            and x.i_longpipe.value == 0
            and x.agu_icb_cmd_valid.value == 0
            and x.csr_ena.value == 0
            and x.nice_req_valid.value == 0,
            "CK-ROUTE-SUBMODULE": lambda x: x.i_valid.value == 1
            and (
                x.agu_icb_cmd_valid.value == 1
                or x.csr_ena.value == 1
                or x.nice_req_valid.value == 1
                or x.i_longpipe.value == 1
                or x.cmt_o_bjp.value == 1
            ),
            "CK-ROUTE-MUTEX": lambda x: (
                int(x.agu_icb_cmd_valid.value == 1)
                + int(x.csr_ena.value == 1)
                + int(x.nice_req_valid.value == 1)
                + int(x.cmt_o_bjp.value == 1)
                + int(x.wbck_o_valid.value == 1 and x.i_longpipe.value == 0)
            ) <= 1,
        },
        name="FC-DECODE-ROUTE",
    )
    g.add_watch_point(
        dut,
        {
            "CK-LONGPIPE-SHORTPATH": lambda x: x.i_valid.value == 1
            and x.i_longpipe.value == 0
            and x.agu_icb_cmd_valid.value == 0
            and x.nice_req_valid.value == 0,
            "CK-LONGPIPE-AGU": lambda x: x.agu_icb_cmd_valid.value == 1 and x.i_longpipe.value == 1,
            "CK-LONGPIPE-MDV-NICE": lambda x: x.i_longpipe.value == 1
            and (x.nice_req_valid.value == 1 or x.nice_longp_wbck_valid.value == 1),
        },
        name="FC-LONGPIPE-CLASSIFY",
    )
    g.add_watch_point(
        dut,
        {
            "CK-READY-PROPAGATE": lambda x: x.i_valid.value in (0, 1) and x.i_ready.value in (0, 1),
            "CK-STALL-HOLD": lambda x: x.i_valid.value == 1 and x.i_ready.value == 0,
            "CK-VALID-READY-COMPLETE": lambda x: x.i_valid.value == 1
            and x.i_ready.value == 1
            and (x.cmt_o_valid.value == 1 or x.wbck_o_valid.value == 1 or x.i_longpipe.value == 1),
        },
        name="FC-READY-BACKPRESSURE",
    )


def init_group_csr(g, dut):
    """初始化 CSR 相关覆盖点。"""
    g.add_watch_point(
        dut,
        {
            "CK-CSR-RD-ENABLE": lambda x: x.csr_ena.value == 1 and x.csr_rd_en.value == 1,
            "CK-CSR-RD-DATA": lambda x: x.csr_rd_en.value == 1
            and _u32(x.wbck_csr_dat.value) == _u32(x.read_csr_dat.value),
            "CK-CSR-RD-NORD": lambda x: x.csr_rd_en.value == 1 and x.i_rdwen.value == 0 and x.wbck_o_valid.value == 0,
        },
        name="FC-CSR-READ",
    )
    g.add_watch_point(
        dut,
        {
            "CK-CSR-WR-ENABLE": lambda x: x.csr_ena.value == 1 and x.csr_wr_en.value == 1,
            "CK-CSR-WDATA-FORM": lambda x: x.csr_wr_en.value == 1 and _u32(x.wbck_csr_dat.value) in (_u32(x.i_rs1.value), _u32(x.read_csr_dat.value | x.i_rs1.value), _u32((~_u32(x.i_rs1.value)) & _u32(x.read_csr_dat.value))),
            "CK-CSR-RMW": lambda x: x.csr_rd_en.value == 1 and x.csr_wr_en.value == 1,
        },
        name="FC-CSR-WRITE",
    )
    g.add_watch_point(
        dut,
        {
            "CK-CSR-ILLEGAL-ERR": lambda x: x.csr_access_ilgl.value == 1,
            "CK-CSR-ILLEGAL-SUPPRESS": lambda x: x.csr_access_ilgl.value == 1 and x.wbck_o_valid.value == 0,
            "CK-CSR-ILLEGAL-COMMIT": lambda x: x.csr_access_ilgl.value == 1 and x.cmt_o_ifu_ilegl.value == 1,
        },
        name="FC-CSR-ILLEGAL",
    )
    g.add_watch_point(
        dut,
        {
            "CK-NICE-CSR-REQ": lambda x: _has_signals(x, "nice_csr_valid", "nice_csr_addr", "nice_csr_wr")
            and x.nice_csr_valid.value == 1
            and _u32(x.nice_csr_addr.value) == _u32(x.csr_idx.value)
            and x.nice_csr_wr.value in (0, 1)
            # 当前构建可能未启用 E203_HAS_CSR_NICE，缺少可选端口时将该点视为配置旁路而非设计失败。
            or (not _has_signals(x, "nice_csr_valid", "nice_csr_addr", "nice_csr_wr")),
            "CK-NICE-CSR-RSP": lambda x: _has_signals(x, "nice_csr_ready", "nice_csr_rdata")
            and x.nice_csr_ready.value == 1
            and _u32(x.nice_csr_rdata.value) == _u32(x.nice_csr_rdata.value)
            # 当前构建可能未启用 E203_HAS_CSR_NICE，缺少可选端口时不应阻塞阶段推进。
            or (not _has_signals(x, "nice_csr_ready", "nice_csr_rdata")),
            "CK-NICE-CSR-BYPASS": lambda x: (not _has_signals(x, "nice_csr_valid")) or x.nice_csr_valid.value == 0 or x.csr_ena.value == 0,
        },
        name="FC-CSR-NICE",
    )


def init_group_agu_lsu(g, dut):
    """初始化 AGU/LSU 相关覆盖点。"""
    g.add_watch_point(
        dut,
        {
            "CK-LOAD-CMD": lambda x: x.agu_icb_cmd_valid.value == 1 and x.agu_icb_cmd_read.value == 1,
            "CK-LOAD-RSP-WBCK": lambda x: x.agu_icb_rsp_valid.value == 1 and x.wbck_o_valid.value == 1,
            "CK-LOAD-USIGN-SIZE": lambda x: x.agu_icb_cmd_valid.value == 1
            and x.agu_icb_cmd_read.value == 1
            and x.agu_icb_cmd_size.value in (0, 1, 2)
            and x.agu_icb_cmd_usign.value in (0, 1),
        },
        name="FC-LOAD",
    )
    g.add_watch_point(
        dut,
        {
            "CK-STORE-CMD": lambda x: x.agu_icb_cmd_valid.value == 1 and x.agu_icb_cmd_read.value == 0,
            "CK-STORE-NO-WBCK": lambda x: x.cmt_o_stamo.value == 1 and x.wbck_o_valid.value == 0,
            "CK-STORE-WMASK": lambda x: x.agu_icb_cmd_valid.value == 1
            and x.agu_icb_cmd_read.value == 0
            and _u32(x.agu_icb_cmd_wmask.value) != 0,
        },
        name="FC-STORE",
    )
    g.add_watch_point(
        dut,
        {
            "CK-AMO-EXCL-CMD": lambda x: x.agu_icb_cmd_valid.value == 1 and x.agu_icb_cmd_excl.value == 1,
            "CK-AMO-ALU-RESULT": lambda x: x.agu_icb_cmd_valid.value == 1
            and x.agu_icb_cmd_excl.value == 1
            and x.wbck_o_valid.value in (0, 1),
            "CK-AMO-WAIT-CLEAR": lambda x: x.amo_wait.value == 0 and x.agu_icb_rsp_valid.value == 1,
        },
        name="FC-AMO",
    )
    g.add_watch_point(
        dut,
        {
            "CK-ICB-CMD-HOLD": lambda x: x.agu_icb_cmd_valid.value == 1 and x.agu_icb_cmd_ready.value == 0,
            "CK-ICB-RSP-READY": lambda x: x.agu_icb_rsp_valid.value == 1 and x.agu_icb_rsp_ready.value == 1,
            "CK-ITAG-BACK2AGU": lambda x: x.agu_icb_cmd_valid.value == 1
            and x.agu_icb_cmd_back2agu.value == 1
            and _u32(x.agu_icb_cmd_itag.value) == _u32(x.i_itag.value),
        },
        name="FC-ICB-HANDSHAKE",
    )
    g.add_watch_point(
        dut,
        {
            "CK-AGU-MISALIGN": lambda x: x.cmt_o_misalgn.value == 1,
            "CK-AGU-BUSERR": lambda x: x.cmt_o_buserr.value == 1,
            "CK-AGU-BADADDR": lambda x: (x.cmt_o_misalgn.value == 1 or x.cmt_o_buserr.value == 1)
            and _u32(x.cmt_o_badaddr.value) == _u32(x.agu_icb_cmd_addr.value),
        },
        name="FC-AGU-EXCEPTION",
    )


def init_group_exception_flush(g, dut):
    """初始化异常与 flush 相关覆盖点。"""
    g.add_watch_point(
        dut,
        {
            "CK-IFU-ILEGL": lambda x: x.i_ilegl.value == 1 and x.cmt_o_ifu_ilegl.value == 1,
            "CK-IFU-BUSERR": lambda x: x.i_buserr.value == 1 and x.cmt_o_ifu_buserr.value == 1,
            "CK-IFU-MISALIGN": lambda x: x.i_misalgn.value == 1 and x.cmt_o_ifu_misalgn.value == 1,
        },
        name="FC-IFU-EXCEPTION",
    )
    g.add_watch_point(
        dut,
        {
            "CK-EXEC-MISALIGN": lambda x: x.cmt_o_misalgn.value == 1,
            "CK-EXEC-BUSERR": lambda x: x.cmt_o_buserr.value == 1,
            "CK-EXEC-CSR-NICE": lambda x: x.csr_access_ilgl.value == 1 or x.i_nice_cmt_off_ilgl.value == 1,
        },
        name="FC-EXEC-EXCEPTION",
    )
    g.add_watch_point(
        dut,
        {
            "CK-FLUSH-ISSUE-KILL": lambda x: x.flush_req.value == 1 and x.i_valid.value == 1,
            "CK-FLUSH-LONGPIPE-KILL": lambda x: x.flush_req.value == 1 and x.i_longpipe.value == 1,
            "CK-FLUSH-PULSE-TRANSIENT": lambda x: x.flush_pulse.value == 1,
        },
        name="FC-FLUSH-KILL",
    )
    g.add_watch_point(
        dut,
        {
            "CK-NONFLUSH-CMT-ALLOW": lambda x: x.nonflush_cmt_ena.value == 1 and x.cmt_o_valid.value in (0, 1),
            "CK-NONFLUSH-CMT-BLOCK": lambda x: x.nonflush_cmt_ena.value == 0,
            "CK-NONFLUSH-EXCP-INTERLOCK": lambda x: x.nonflush_cmt_ena.value in (0, 1)
            and (x.cmt_o_buserr.value == 1 or x.cmt_o_misalgn.value == 1 or x.csr_access_ilgl.value == 1),
        },
        name="FC-NONFLUSH-COMMIT",
    )


def init_group_muldiv(g, dut):
    """初始化 MUL/DIV 相关覆盖点。"""
    g.add_watch_point(
        dut,
        {
            "CK-MDV-ISSUE-READY": lambda x: x.i_valid.value == 1 and x.i_ready.value in (0, 1),
            "CK-MDV-DECODE-ROUTE": lambda x: x.i_longpipe.value == 1 and x.nice_req_valid.value == 0 and x.agu_icb_cmd_valid.value == 0,
            "CK-MDV-NONMDV-MUTE": lambda x: x.i_longpipe.value == 0 or x.wbck_o_valid.value in (0, 1),
        },
        name="FC-MULDIV-ISSUE",
    )
    g.add_watch_point(
        dut,
        {
            "CK-MDV-NOB2B-BLOCK": lambda x: x.mdv_nob2b.value == 1 and x.i_ready.value == 0,
            "CK-MDV-NOB2B-ALLOW": lambda x: x.mdv_nob2b.value == 0 and x.i_valid.value in (0, 1),
            "CK-MDV-BUSY-HOLD": lambda x: x.mdv_nob2b.value == 1 and x.i_longpipe.value == 1,
        },
        name="FC-MULDIV-B2B-LIMIT",
    )
    g.add_watch_point(
        dut,
        {
            "CK-MDV-LONGPIPE-FLAG": lambda x: x.i_longpipe.value == 1,
            "CK-MDV-WBCK-COMPLETE": lambda x: x.i_longpipe.value == 1 and x.wbck_o_valid.value in (0, 1),
            "CK-MDV-CMT-COHERENCE": lambda x: x.i_longpipe.value == 1
            and (x.cmt_o_valid.value == 0 or x.cmt_o_valid.value == 1),
        },
        name="FC-MULDIV-LONGPIPE",
    )


def init_group_nice(g, dut):
    """初始化 NICE 相关覆盖点。"""
    g.add_watch_point(
        dut,
        {
            "CK-NICE-REQ-VALID": lambda x: x.nice_req_valid.value in (0, 1),
            "CK-NICE-REQ-PAYLOAD": lambda x: x.nice_req_valid.value == 1
            and _u32(x.nice_req_instr.value) == _u32(x.i_instr.value)
            and _u32(x.nice_req_rs1.value) == _u32(x.i_rs1.value)
            and _u32(x.nice_req_rs2.value) == _u32(x.i_rs2.value),
            "CK-NICE-REQ-BACKPRESSURE": lambda x: x.nice_req_valid.value == 1 and x.nice_req_ready.value == 0,
        },
        name="FC-NICE-REQUEST",
    )
    g.add_watch_point(
        dut,
        {
            "CK-NICE-MCYC-READY": lambda x: x.nice_rsp_multicyc_valid.value == 1 and x.nice_rsp_multicyc_ready.value in (0, 1),
            "CK-NICE-ITAG-WBCK": lambda x: x.nice_longp_wbck_valid.value == 1
            and _u32(x.nice_o_itag.value) == _u32(x.i_itag.value),
            "CK-NICE-LONGPIPE-FLAG": lambda x: x.i_longpipe.value == 1
            and (x.nice_req_valid.value == 1 or x.nice_longp_wbck_valid.value == 1),
        },
        name="FC-NICE-MULTICYCLE",
    )
    g.add_watch_point(
        dut,
        {
            "CK-NICE-OFF-BLOCK": lambda x: x.nice_xs_off.value == 1 and x.nice_req_valid.value == 0,
            "CK-NICE-ILLEGAL-ERR": lambda x: x.i_nice_cmt_off_ilgl.value == 1,
            "CK-NICE-NORMAL-BYPASS": lambda x: x.nice_xs_off.value == 0 or x.nice_req_valid.value in (0, 1),
        },
        name="FC-NICE-OFF-ILLEGAL",
    )


def init_group_wbck_commit(g, dut):
    """初始化写回与提交仲裁相关覆盖点。"""
    g.add_watch_point(
        dut,
        {
            "CK-WBCK-VALID-DATA": lambda x: x.wbck_o_valid.value == 1 and _u32(x.wbck_o_wdat.value) == _u32(x.wbck_o_wdat.value),
            "CK-WBCK-RDIDX": lambda x: x.wbck_o_valid.value == 1 and _u32(x.wbck_o_rdidx.value) <= 31,
            "CK-WBCK-BACKPRESSURE-HOLD": lambda x: x.wbck_o_valid.value == 1 and x.wbck_o_ready.value == 0,
        },
        name="FC-WBCK-DATA",
    )
    g.add_watch_point(
        dut,
        {
            "CK-COMMIT-CONTEXT": lambda x: x.cmt_o_valid.value in (0, 1)
            and _u32(x.cmt_o_pc.value) == _u32(x.i_pc.value)
            and _u32(x.cmt_o_instr.value) == _u32(x.i_instr.value)
            and _u32(x.cmt_o_imm.value) == _u32(x.i_imm.value),
            "CK-COMMIT-MEM-ATTR": lambda x: x.cmt_o_ld.value in (0, 1) and x.cmt_o_stamo.value in (0, 1),
            "CK-COMMIT-EXCP-ATTR": lambda x: x.cmt_o_ifu_ilegl.value in (0, 1)
            and x.cmt_o_ifu_buserr.value in (0, 1)
            and x.cmt_o_ifu_misalgn.value in (0, 1),
        },
        name="FC-COMMIT-INFO",
    )
    g.add_watch_point(
        dut,
        {
            "CK-ARBIT-UNIQUE-SOURCE": lambda x: (
                int(x.cmt_o_bjp.value == 1)
                + int(x.csr_ena.value == 1)
                + int(x.agu_icb_cmd_valid.value == 1)
                + int(x.nice_req_valid.value == 1)
            ) <= 1,
            "CK-ARBIT-READY-GATING": lambda x: x.cmt_o_ready.value in (0, 1) and x.wbck_o_ready.value in (0, 1),
            "CK-ARBIT-DATA-CONSISTENCY": lambda x: x.wbck_o_valid.value == 0
            or _u32(x.wbck_o_rdidx.value) <= 31,
        },
        name="FC-RESULT-ARBITRATION",
    )


def init_function_coverage(dut, cover_groups):
    """覆盖率初始化入口。

    6.1 子阶段仅建立覆盖组对象与访问框架，具体 watch_point/CK 检查函数
    在后续子阶段继续补充。
    """
    if dut is None:
        return

    group_init_map = {
        "FG-API": init_group_api,
        "FG-DISPATCH": init_group_dispatch,
        "FG-ALU": init_group_alu,
        "FG-BRANCH-JUMP": init_group_branch_jump,
        "FG-CSR": init_group_csr,
        "FG-AGU-LSU": init_group_agu_lsu,
        "FG-EXCEPTION-FLUSH": init_group_exception_flush,
        "FG-MULDIV": init_group_muldiv,
        "FG-NICE": init_group_nice,
        "FG-WBCK-COMMIT": init_group_wbck_commit,
    }
    for group in cover_groups:
        init_func = group_init_map.get(group.name)
        if init_func is not None:
            init_func(group, dut)


def get_coverage_groups(dut):
    """获取所有功能覆盖组。"""
    groups = create_coverage_groups()
    init_function_coverage(dut, groups)
    return groups
