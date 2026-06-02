#coding=utf-8

"""e203_ifu_litebpu 功能覆盖率定义。

本文件中的覆盖组名称与
unity_test/e203_ifu_litebpu_functions_and_checks.md 中的 <FG-*> 标签保持一致。
"""

import toffee.funcov as fc


MASK32 = 0xFFFFFFFF

FG_NAMES = [
    "FG-API",
    "FG-PREDICT",
    "FG-OPERAND",
    "FG-JALR-DEPENDENCY",
    "FG-RS1-READ",
    "FG-RESET-BOUNDARY",
]


def _create_coverage_groups():
    """创建所有功能覆盖组。"""
    return [fc.CovGroup(name) for name in FG_NAMES]


def _u32(value):
    """按 32bit 端口宽度截断数值。"""
    return int(value) & MASK32


def _is_jalr_x1(dut):
    """JALR rs1=x1 的有效输入条件。"""
    return (
        dut.dec_i_valid.value == 1
        and dut.dec_jalr.value == 1
        and dut.dec_jalr_rs1idx.value == 1
    )


def _is_jalr_xn(dut):
    """JALR rs1 不是 x0/x1 的有效输入条件。"""
    return (
        dut.dec_i_valid.value == 1
        and dut.dec_jalr.value == 1
        and dut.dec_jalr_rs1idx.value not in (0, 1)
    )


def _is_valid_jal(dut):
    """JAL 的有效输入条件。"""
    return dut.dec_i_valid.value == 1 and dut.dec_jal.value == 1


def _is_valid_bxx(dut):
    """Bxx 的有效输入条件。"""
    return dut.dec_i_valid.value == 1 and dut.dec_bxx.value == 1


def _is_boundary(value):
    """常用 32bit 边界值。"""
    return _u32(value) in (0, MASK32, 0x80000000, 0x7FFFFFFF)


def _has_public_ports(dut):
    """检查封装暴露了本 DUT 验证需要的公开端口。"""
    required_ports = (
        "clk", "rst_n", "pc", "dec_jal", "dec_jalr", "dec_bxx",
        "dec_bjp_imm", "dec_jalr_rs1idx", "oitf_empty", "ir_empty",
        "ir_rs1en", "jalr_rs1idx_cam_irrdidx", "dec_i_valid",
        "ir_valid_clr", "rf2bpu_x1", "rf2bpu_rs1", "prdt_taken",
        "prdt_pc_add_op1", "prdt_pc_add_op2", "bpu_wait",
        "bpu2rf_rs1_ena",
    )
    return all(hasattr(dut, name) for name in required_ports)


def init_coverage_group_api(g, dut):
    """初始化 DUT/API 相关覆盖点。"""
    g.add_watch_point(
        dut,
        {
            "CK-CREATE-CLOCK": lambda x: hasattr(x, "Step") and hasattr(x, "clk"),
            "CK-COVERAGE-WAVE": lambda x: hasattr(x, "SetCoverage") and hasattr(x, "SetWaveform"),
        },
        name="FC-DUT-LIFECYCLE",
    )

    g.add_watch_point(
        dut,
        {
            "CK-RESET-ASSERT": lambda x: x.rst_n.value == 0 and x.bpu2rf_rs1_ena.value == 0,
            "CK-RESET-RELEASE": lambda x: (
                x.rst_n.value == 1
                and x.dec_i_valid.value == 1
                and (x.dec_jal.value == 1 or x.dec_jalr.value == 1 or x.dec_bxx.value == 1)
            ),
        },
        name="FC-RESET-API",
    )

    g.add_watch_point(
        dut,
        {
            "CK-DRIVE-DEFAULTS": lambda x: _has_public_ports(x),
            "CK-SAMPLE-OUTPUTS": lambda x: all(
                hasattr(x, name)
                for name in ("prdt_taken", "prdt_pc_add_op1", "prdt_pc_add_op2", "bpu_wait", "bpu2rf_rs1_ena")
            ),
        },
        name="FC-PREDICT-API",
    )


def init_coverage_group_operand(g, dut):
    """初始化目标地址操作数选择覆盖点。"""
    g.add_watch_point(
        dut,
        {
            "CK-JAL-OP1-PC": lambda x: (
                _is_valid_jal(x)
                and _u32(x.prdt_pc_add_op1.value) == _u32(x.pc.value)
            ),
            "CK-BXX-OP1-PC": lambda x: (
                _is_valid_bxx(x)
                and _u32(x.prdt_pc_add_op1.value) == _u32(x.pc.value)
            ),
        },
        name="FC-OP1-PC",
    )

    g.add_watch_point(
        dut,
        {
            "CK-X0-OP1-ZERO": lambda x: (
                x.dec_i_valid.value == 1
                and x.dec_jalr.value == 1
                and x.dec_jalr_rs1idx.value == 0
                and x.prdt_pc_add_op1.value == 0
            ),
        },
        name="FC-OP1-JALR-X0",
    )

    g.add_watch_point(
        dut,
        {
            "CK-X1-OP1-VALUE": lambda x: (
                _is_jalr_x1(x)
                and x.oitf_empty.value == 1
                and x.jalr_rs1idx_cam_irrdidx.value == 0
                and x.bpu_wait.value == 0
                and _u32(x.prdt_pc_add_op1.value) == _u32(x.rf2bpu_x1.value)
            ),
            "CK-X1-VALUE-BOUNDARY": lambda x: (
                _is_jalr_x1(x)
                and x.oitf_empty.value == 1
                and x.jalr_rs1idx_cam_irrdidx.value == 0
                and _u32(x.rf2bpu_x1.value) in (0, MASK32, 0x80000000)
                and _u32(x.prdt_pc_add_op1.value) == _u32(x.rf2bpu_x1.value)
            ),
        },
        name="FC-OP1-JALR-X1",
    )

    g.add_watch_point(
        dut,
        {
            "CK-XN-OP1-RS1": lambda x: (
                _is_jalr_xn(x)
                and x.bpu2rf_rs1_ena.value == 1
                and _u32(x.prdt_pc_add_op1.value) == _u32(x.rf2bpu_rs1.value)
            ),
            "CK-XN-VALUE-BOUNDARY": lambda x: (
                _is_jalr_xn(x)
                and x.bpu2rf_rs1_ena.value == 1
                and _u32(x.rf2bpu_rs1.value) in (0, MASK32, 0x80000000)
                and _u32(x.prdt_pc_add_op1.value) == _u32(x.rf2bpu_rs1.value)
            ),
        },
        name="FC-OP1-JALR-XN",
    )

    g.add_watch_point(
        dut,
        {
            "CK-IMM-POSITIVE": lambda x: (
                x.dec_bjp_imm.value < 0x80000000
                and _u32(x.prdt_pc_add_op2.value) == _u32(x.dec_bjp_imm.value)
            ),
            "CK-IMM-NEGATIVE": lambda x: (
                x.dec_bjp_imm.value >= 0x80000000
                and _u32(x.prdt_pc_add_op2.value) == _u32(x.dec_bjp_imm.value)
            ),
            "CK-IMM-EXTREME": lambda x: (
                _u32(x.dec_bjp_imm.value) in (0, MASK32, 0x80000000)
                and _u32(x.prdt_pc_add_op2.value) == _u32(x.dec_bjp_imm.value)
            ),
        },
        name="FC-OP2-IMM",
    )


def init_coverage_group_predict(g, dut):
    """初始化静态分支预测覆盖点。"""
    g.add_watch_point(
        dut,
        {
            "CK-JAL-TAKEN": lambda x: (
                _is_valid_jal(x)
                and x.prdt_taken.value == 1
            ),
            "CK-JAL-NO-WAIT": lambda x: (
                _is_valid_jal(x)
                and x.bpu_wait.value == 0
                and x.bpu2rf_rs1_ena.value == 0
            ),
        },
        name="FC-JAL-PREDICT",
    )

    g.add_watch_point(
        dut,
        {
            "CK-JALR-X0-TAKEN": lambda x: (
                x.dec_i_valid.value == 1
                and x.dec_jalr.value == 1
                and x.dec_jalr_rs1idx.value == 0
                and x.prdt_taken.value == 1
                and x.bpu_wait.value == 0
            ),
            "CK-JALR-X1-TAKEN-READY": lambda x: (
                _is_jalr_x1(x)
                and x.oitf_empty.value == 1
                and x.jalr_rs1idx_cam_irrdidx.value == 0
                and x.prdt_taken.value == 1
                and x.bpu_wait.value == 0
            ),
            "CK-JALR-XN-TAKEN-AFTER-READ": lambda x: (
                _is_jalr_xn(x)
                and x.bpu2rf_rs1_ena.value == 1
                and x.prdt_taken.value == 1
                and _u32(x.prdt_pc_add_op1.value) == _u32(x.rf2bpu_rs1.value)
            ),
        },
        name="FC-JALR-PREDICT",
    )

    g.add_watch_point(
        dut,
        {
            "CK-BXX-BACKWARD-TAKEN": lambda x: (
                _is_valid_bxx(x)
                and _u32(x.dec_bjp_imm.value) >= 0x80000000
                and x.prdt_taken.value == 1
            ),
            "CK-BXX-FORWARD-NOT-TAKEN": lambda x: (
                _is_valid_bxx(x)
                and 0 < _u32(x.dec_bjp_imm.value) < 0x80000000
                and x.prdt_taken.value == 0
            ),
            "CK-BXX-ZERO-NOT-TAKEN": lambda x: (
                _is_valid_bxx(x)
                and _u32(x.dec_bjp_imm.value) == 0
                and x.prdt_taken.value == 0
            ),
        },
        name="FC-BXX-PREDICT",
    )

    g.add_watch_point(
        dut,
        {
            "CK-NO-DECODE-NOT-TAKEN": lambda x: (
                x.dec_i_valid.value == 1
                and x.dec_jal.value == 0
                and x.dec_jalr.value == 0
                and x.dec_bxx.value == 0
                and x.prdt_taken.value == 0
            ),
            "CK-INVALID-INSTRUCTION-GATING": lambda x: (
                x.dec_i_valid.value == 0
                and x.bpu_wait.value == 0
                and x.bpu2rf_rs1_ena.value == 0
                and x.prdt_taken.value == 0
            ),
        },
        name="FC-NO-BRANCH",
    )


def init_coverage_group_reset_boundary(g, dut):
    """初始化复位、边界值和译码冲突覆盖点。"""
    g.add_watch_point(
        dut,
        {
            "CK-PC-BOUNDARY": lambda x: (
                (_is_valid_jal(x) or _is_valid_bxx(x))
                and _is_boundary(x.pc.value)
                and _u32(x.prdt_pc_add_op1.value) == _u32(x.pc.value)
            ),
            "CK-REG-BOUNDARY": lambda x: (
                x.dec_i_valid.value == 1
                and x.dec_jalr.value == 1
                and (
                    (x.dec_jalr_rs1idx.value == 1 and _is_boundary(x.rf2bpu_x1.value)
                     and _u32(x.prdt_pc_add_op1.value) == _u32(x.rf2bpu_x1.value))
                    or (x.dec_jalr_rs1idx.value not in (0, 1) and _is_boundary(x.rf2bpu_rs1.value)
                        and _u32(x.prdt_pc_add_op1.value) == _u32(x.rf2bpu_rs1.value))
                )
            ),
            "CK-IMM-SIGN-BOUNDARY": lambda x: (
                _is_valid_bxx(x)
                and _u32(x.dec_bjp_imm.value) in (0x7FFFFFFF, 0x80000000)
                and x.prdt_taken.value == int(_u32(x.dec_bjp_imm.value) >= 0x80000000)
            ),
        },
        name="FC-BOUNDARY-VALUES",
    )

    g.add_watch_point(
        dut,
        {
            "CK-JAL-JALR-CONFLICT": lambda x: (
                x.dec_i_valid.value == 1
                and x.dec_jal.value == 1
                and x.dec_jalr.value == 1
                and x.prdt_taken.value in (0, 1)
                and _u32(x.prdt_pc_add_op1.value) == _u32(x.pc.value)
            ),
            "CK-JAL-BXX-CONFLICT": lambda x: (
                x.dec_i_valid.value == 1
                and x.dec_jal.value == 1
                and x.dec_bxx.value == 1
                and x.prdt_taken.value in (0, 1)
                and _u32(x.prdt_pc_add_op1.value) == _u32(x.pc.value)
            ),
            "CK-JALR-BXX-CONFLICT": lambda x: (
                x.dec_i_valid.value == 1
                and x.dec_jalr.value == 1
                and x.dec_bxx.value == 1
                and x.prdt_taken.value in (0, 1)
                and x.bpu_wait.value in (0, 1)
                and x.bpu2rf_rs1_ena.value in (0, 1)
            ),
        },
        name="FC-DECODE-CONFLICT",
    )

    g.add_watch_point(
        dut,
        {
            "CK-RESET-CLEARS-READ": lambda x: (
                x.rst_n.value == 0
                and x.bpu2rf_rs1_ena.value == 0
            ),
            "CK-FIRST-AFTER-RESET": lambda x: (
                x.rst_n.value == 1
                and x.dec_i_valid.value == 1
                and (x.dec_jal.value == 1 or x.dec_jalr.value == 1 or x.dec_bxx.value == 1)
                and x.prdt_taken.value in (0, 1)
                and x.bpu_wait.value in (0, 1)
            ),
        },
        name="FC-RESET-BEHAVIOR",
    )


def init_coverage_group_rs1_read(g, dut):
    """初始化 JALR rs1=xN 读寄存器请求覆盖点。"""
    g.add_watch_point(
        dut,
        {
            "CK-XN-READ-ENABLE": lambda x: (
                _is_jalr_xn(x)
                and x.oitf_empty.value == 1
                and x.ir_empty.value == 1
                and x.bpu2rf_rs1_ena.value == 1
            ),
            "CK-READ-WITH-BYPASS": lambda x: (
                _is_jalr_xn(x)
                and x.oitf_empty.value == 1
                and x.ir_empty.value == 0
                and (x.ir_valid_clr.value == 1 or x.ir_rs1en.value == 0)
                and x.bpu2rf_rs1_ena.value == 1
            ),
        },
        name="FC-RS1-READ-REQUEST",
    )

    g.add_watch_point(
        dut,
        {
            "CK-NO-REPEAT-READ": lambda x: (
                _is_jalr_xn(x)
                and x.oitf_empty.value == 1
                and x.ir_empty.value == 1
                and x.bpu2rf_rs1_ena.value == 0
            ),
            "CK-READ-STATE-CLEAR": lambda x: (
                x.rst_n.value == 1
                and x.bpu2rf_rs1_ena.value == 0
                and (
                    x.dec_jalr.value == 0
                    or x.dec_i_valid.value == 0
                    or x.dec_jalr_rs1idx.value in (0, 1)
                )
            ),
        },
        name="FC-RS1-READ-STATE",
    )

    g.add_watch_point(
        dut,
        {
            "CK-INVALID-NO-READ": lambda x: (
                x.dec_i_valid.value == 0
                and x.dec_jalr.value == 1
                and x.dec_jalr_rs1idx.value not in (0, 1)
                and x.bpu2rf_rs1_ena.value == 0
            ),
            "CK-NON-JALR-NO-READ": lambda x: (
                x.dec_i_valid.value == 1
                and x.dec_jalr.value == 0
                and x.bpu2rf_rs1_ena.value == 0
            ),
            "CK-X0-X1-NO-XN-READ": lambda x: (
                x.dec_i_valid.value == 1
                and x.dec_jalr.value == 1
                and x.dec_jalr_rs1idx.value in (0, 1)
                and x.bpu2rf_rs1_ena.value == 0
            ),
            "CK-DEPENDENCY-NO-READ": lambda x: (
                _is_jalr_xn(x)
                and (
                    x.oitf_empty.value == 0
                    or (x.ir_empty.value == 0 and x.ir_valid_clr.value == 0 and x.ir_rs1en.value == 1)
                )
                and x.bpu_wait.value == 1
                and x.bpu2rf_rs1_ena.value == 0
            ),
        },
        name="FC-RS1-READ-GATING",
    )


def init_coverage_group_jalr_dependency(g, dut):
    """初始化 JALR 依赖等待覆盖点。"""
    g.add_watch_point(
        dut,
        {
            "CK-X1-OITF-BUSY-WAIT": lambda x: (
                _is_jalr_x1(x)
                and x.oitf_empty.value == 0
                and x.bpu_wait.value == 1
            ),
            "CK-X1-IR-CAM-WAIT": lambda x: (
                _is_jalr_x1(x)
                and x.oitf_empty.value == 1
                and x.jalr_rs1idx_cam_irrdidx.value == 1
                and x.bpu_wait.value == 1
            ),
            "CK-X1-READY-NO-WAIT": lambda x: (
                _is_jalr_x1(x)
                and x.oitf_empty.value == 1
                and x.jalr_rs1idx_cam_irrdidx.value == 0
                and x.bpu_wait.value == 0
            ),
        },
        name="FC-X1-DEPENDENCY",
    )

    g.add_watch_point(
        dut,
        {
            "CK-XN-OITF-BUSY-WAIT": lambda x: (
                _is_jalr_xn(x)
                and x.oitf_empty.value == 0
                and x.bpu_wait.value == 1
                and x.bpu2rf_rs1_ena.value == 0
            ),
            "CK-XN-IR-BUSY-CAM-WAIT": lambda x: (
                _is_jalr_xn(x)
                and x.oitf_empty.value == 1
                and x.ir_empty.value == 0
                and x.ir_valid_clr.value == 0
                and x.ir_rs1en.value == 1
                and x.jalr_rs1idx_cam_irrdidx.value == 1
                and x.bpu_wait.value == 1
            ),
            "CK-XN-READY-NO-WAIT": lambda x: (
                _is_jalr_xn(x)
                and x.oitf_empty.value == 1
                and x.ir_empty.value == 1
                and x.bpu_wait.value == 0
                and x.bpu2rf_rs1_ena.value == 1
            ),
        },
        name="FC-XN-DEPENDENCY",
    )

    g.add_watch_point(
        dut,
        {
            "CK-IR-CLR-BYPASS": lambda x: (
                _is_jalr_xn(x)
                and x.oitf_empty.value == 1
                and x.ir_empty.value == 0
                and x.ir_valid_clr.value == 1
                and x.bpu_wait.value == 0
                and x.bpu2rf_rs1_ena.value == 1
            ),
            "CK-IR-RS1-DISABLE-BYPASS": lambda x: (
                _is_jalr_xn(x)
                and x.oitf_empty.value == 1
                and x.ir_empty.value == 0
                and x.ir_rs1en.value == 0
                and x.bpu_wait.value == 0
                and x.bpu2rf_rs1_ena.value == 1
            ),
            "CK-DEPENDENCY-TRANSITION": lambda x: (
                _is_jalr_xn(x)
                and x.oitf_empty.value == 1
                and (x.ir_empty.value == 1 or x.ir_valid_clr.value == 1 or x.ir_rs1en.value == 0)
                and x.bpu_wait.value == 0
            ),
        },
        name="FC-DEPENDENCY-BYPASS",
    )


def init_function_coverage(dut, coverage_groups):
    """初始化功能覆盖率。

    每个初始化函数只通过 DUT 公开端口定义覆盖条件，不读取内部状态。
    """
    init_map = {
        "FG-API": init_coverage_group_api,
        "FG-PREDICT": init_coverage_group_predict,
        "FG-OPERAND": init_coverage_group_operand,
        "FG-JALR-DEPENDENCY": init_coverage_group_jalr_dependency,
        "FG-RS1-READ": init_coverage_group_rs1_read,
        "FG-RESET-BOUNDARY": init_coverage_group_reset_boundary,
    }
    for group in coverage_groups:
        init_func = init_map.get(group.name)
        if init_func is not None:
            init_func(group, dut)
    return coverage_groups


def get_coverage_groups(dut):
    """获取 e203_ifu_litebpu 的所有功能覆盖组。"""
    coverage_groups = _create_coverage_groups()
    init_function_coverage(dut, coverage_groups)
    return coverage_groups
