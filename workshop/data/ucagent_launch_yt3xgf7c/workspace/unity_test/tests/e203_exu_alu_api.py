#coding=utf-8

import pytest
import ucagent
from e203_exu_alu_function_coverage_def import get_coverage_groups
from toffee_test.reporter import set_func_coverage, set_line_coverage, get_file_in_tmp_dir
from toffee_test.reporter import set_user_info, set_title_info
from toffee import Bundle, Signals, Signal

# import your dut module here
from e203_exu_alu import DUTe203_exu_alu  # Replace with the actual DUT class import

import os


def current_path_file(file_name):
    return os.path.join(os.path.dirname(os.path.abspath(__file__)), file_name)


def get_coverage_data_path(request, new_path:bool):
    # 通过toffee_test.reporter提供的get_file_in_tmp_dir方法可以让各用例产生的文件名称不重复 (获取新路径需要new_path=True，获取已有路径new_path=False)
    # 获取测试用例名称，为每个测试用例创建对应的代码行覆盖率文件
    tc_name = request.node.name if request is not None else "e203_exu_alu"
    return get_file_in_tmp_dir(request, current_path_file("data/"), f"{tc_name}.dat",  new_path=new_path)


def get_waveform_path(request, new_path:bool):
    # 通过toffee_test.reporter提供的get_file_in_tmp_dir方法可以让各用例产生的文件名称不重复 (获取新路径需要new_path=True，获取已有路径new_path=False)
    # 获取测试用例名称，为每个测试用例创建对应的波形
    tc_name = request.node.name if request is not None else "e203_exu_alu"
    return get_file_in_tmp_dir(request, current_path_file("data/"), f"{tc_name}.fst",  new_path=new_path)


def create_dut(request):
    """创建并返回 DUT 实例。"""
    # 如果是正在生成测试模板，返回fake DUT用于提速（模板中不会真运行DUT）
    if ucagent.is_imp_test_template():
        return ucagent.get_fake_dut(DUTe203_exu_alu)

    dut = DUTe203_exu_alu()

    # 设置覆盖率生成文件(必须设置覆盖率文件，否则无法统计覆盖率，导致测试失败)
    dut.SetCoverage(get_coverage_data_path(request, new_path=True))

    # 设置波形生成文件
    dut.SetWaveform(get_waveform_path(request, new_path=True))

    # e203_exu_alu 是时序电路，创建后立即绑定时钟，但不在此处修改任何引脚默认值。
    dut.InitClock("clk")

    return dut


@pytest.fixture(scope="function") # 用scope="function"确保每个测试用例都创建了一个全新的DUT
def dut(request):
    dut = create_dut(request)                         # 创建DUT
    func_coverage_group = get_coverage_groups(dut)
    # 时钟已在 create_dut 中完成绑定，这里只负责覆盖率和生命周期管理。

    # 上升沿采样，StepRis也适用于组合电路用dut.Step推进时采样.
    # 必须要有g.sample()采样覆盖组, 如何不在StepRis/StepFal中采样，则需要在test function中手动调用，否则无法统计覆盖率导致失败
    dut.StepRis(lambda _: [g.sample()
                           for g in
                           func_coverage_group])

    # 以属性名称fc_cover保存覆盖组到DUT
    setattr(dut, "fc_cover",
            {g.name:g for g in func_coverage_group})

    # 返回DUT实例
    yield dut

    # 测试后处理
    # 需要在测试结束的时候，通过set_func_coverage把覆盖组传递给toffee_test*
    set_func_coverage(request, func_coverage_group)

    # 设置需要收集的代码行覆盖率文件(获取已有路径new_path=False) 向toffee_test传代码行递覆盖率数据
    # 代码行覆盖率 ignore 文件的固定路径为当前文件所在目录下的：e203_exu_alu.ignore，请不要改变
    set_line_coverage(request, get_coverage_data_path(request, new_path=False), ignore=current_path_file("e203_exu_alu.ignore"))

    # 设置用户信息到报告
    set_user_info("UCAgent-0.9.1.source-code", "unitychip@bosc.ac.cn")
    set_title_info("e203_exu_alu Test Report")

    for g in func_coverage_group:                        # 采样覆盖组
        g.clear()                                        # 清空统计
    dut.Finish()                                         # 清理DUT，每个DUT class 都有 Finish 方法

@pytest.fixture(scope="function") # 用scope="function"确保每个测试用例都创建了一个全新的 Mock DUT
def mock_dut():
    return ucagent.get_mock_dut_from(DUTe203_exu_alu)


class IssueBundle(Bundle):
    valid, ready, longpipe = Signals(3)
    itag, rs1, rs2, imm, info, pc, instr = Signals(7)
    pc_vld, rdidx, rdwen, ilegl, buserr, misalgn = Signals(6)


class CommitBundle(Bundle):
    valid, ready, pc_vld, pc, instr, imm = Signals(6)
    rv32, bjp, mret, dret, ecall, ebreak, fencei, wfi = Signals(8)
    ifu_misalgn, ifu_buserr, ifu_ilegl = Signals(3)
    bjp_prdt, bjp_rslv, misalgn, ld, stamo, buserr, badaddr = Signals(7)


class WritebackBundle(Bundle):
    valid, ready, wdat, rdidx = Signals(4)


class CsrBundle(Bundle):
    ena, wr_en, rd_en, idx = Signals(4)


class AguCmdBundle(Bundle):
    valid, ready, addr, read, wdata, wmask = Signals(6)
    lock, excl, size, back2agu, usign, itag = Signals(6)


class AguRspBundle(Bundle):
    valid, ready, err, excl_ok, rdata = Signals(5)


class NiceReqBundle(Bundle):
    valid, ready, instr, rs1, rs2 = Signals(5)


class NiceRspBundle(Bundle):
    rsp_multicyc_valid, rsp_multicyc_ready = Signals(2)
    longp_wbck_valid, longp_wbck_ready = Signals(2)
    o_itag = Signal()


class CoreCtrlInBundle(Bundle):
    clk, rst_n = Signals(2)
    flush_req, flush_pulse = Signals(2)
    oitf_empty, mdv_nob2b = Signals(2)
    nonflush_cmt_ena = Signal()


class CoreCtrlOutBundle(Bundle):
    amo_wait = Signal()


class NiceSidebandBundle(Bundle):
    xs_off = Signal()
    i_nice_cmt_off_ilgl = Signal()


class CsrSidebandBundle(Bundle):
    access_ilgl, read_dat, wbck_dat = Signals(3)


# 定义e203_exu_aluEnv类，封装DUT的引脚和常用操作
class e203_exu_aluEnv:
    """封装 e203_exu_alu 顶层端口分组，便于后续 API、Mock 和测试用例复用。"""

    def __init__(self, dut):
        self.dut = dut
        # 按公共前缀组织主接口，避免后续 API 直接散落访问原始 DUT 引脚。
        self.issue = IssueBundle.from_prefix("i_")
        self.issue.bind(dut)
        self.commit = CommitBundle.from_prefix("cmt_o_")
        self.commit.bind(dut)
        self.wbck = WritebackBundle.from_prefix("wbck_o_")
        self.wbck.bind(dut)
        self.csr = CsrBundle.from_prefix("csr_")
        self.csr.bind(dut)
        self.agu_cmd = AguCmdBundle.from_prefix("agu_icb_cmd_")
        self.agu_cmd.bind(dut)
        self.agu_rsp = AguRspBundle.from_prefix("agu_icb_rsp_")
        self.agu_rsp.bind(dut)
        self.nice_req = NiceReqBundle.from_prefix("nice_req_")
        self.nice_req.bind(dut)
        self.nice_rsp = NiceRspBundle.from_prefix("nice_")
        self.nice_rsp.bind(dut)

        # 无法仅靠同一前缀完整表达的侧带信号，用 from_dict 做显式映射。
        self.ctrl_in = CoreCtrlInBundle.from_dict({
            "clk": "clk",
            "rst_n": "rst_n",
            "flush_req": "flush_req",
            "flush_pulse": "flush_pulse",
            "oitf_empty": "oitf_empty",
            "mdv_nob2b": "mdv_nob2b",
            "nonflush_cmt_ena": "nonflush_cmt_ena",
        })
        self.ctrl_in.bind(dut)
        self.ctrl_out = CoreCtrlOutBundle.from_dict({
            "amo_wait": "amo_wait",
        })
        self.ctrl_out.bind(dut)
        self.nice_sideband = NiceSidebandBundle.from_dict({
            "xs_off": "nice_xs_off",
            "i_nice_cmt_off_ilgl": "i_nice_cmt_off_ilgl",
        })
        self.nice_sideband.bind(dut)
        self.csr_sideband = CsrSidebandBundle.from_dict({
            "access_ilgl": "csr_access_ilgl",
            "read_dat": "read_csr_dat",
            "wbck_dat": "wbck_csr_dat",
        })
        self.csr_sideband.bind(dut)

        self.clear_inputs()

    def clear_inputs(self):
        """将输入方向信号复位到默认空闲值，避免伪事务。"""
        self.issue.valid.value = 0
        self.issue.itag.value = 0
        self.issue.rs1.value = 0
        self.issue.rs2.value = 0
        self.issue.imm.value = 0
        self.issue.info.value = 0
        self.issue.pc.value = 0
        self.issue.instr.value = 0
        self.issue.pc_vld.value = 0
        self.issue.rdidx.value = 0
        self.issue.rdwen.value = 0
        self.issue.ilegl.value = 0
        self.issue.buserr.value = 0
        self.issue.misalgn.value = 0
        self.commit.ready.value = 0
        self.wbck.ready.value = 0
        self.agu_cmd.ready.value = 0
        self.agu_rsp.set_all(0)
        self.nice_req.ready.value = 0
        self.nice_rsp.rsp_multicyc_valid.value = 0
        self.nice_rsp.longp_wbck_ready.value = 0
        self.ctrl_in.rst_n.value = 0
        self.ctrl_in.flush_req.value = 0
        self.ctrl_in.flush_pulse.value = 0
        self.ctrl_in.oitf_empty.value = 0
        self.ctrl_in.mdv_nob2b.value = 0
        self.ctrl_in.nonflush_cmt_ena.value = 0
        self.nice_sideband.set_all(0)
        self.csr_sideband.access_ilgl.value = 0
        self.csr_sideband.read_dat.value = 0

    def reset(self, cycles: int = 2):
        """按低有效复位约定驱动 DUT，并在释放后恢复空闲输入。"""
        self.clear_inputs()
        self.ctrl_in.rst_n.value = 0
        self.Step(cycles)
        self.ctrl_in.rst_n.value = 1
        self.Step(1)

    # 直接导出DUT的通用操作Step
    def Step(self, i:int = 1):
        return self.dut.Step(i)


# 定义env fixture, 请取消下面的注释，并根据需要修改名称
@pytest.fixture(scope="function") # 用scope="function"确保每个测试用例都创建了一个全新的Env
def env(dut):
    # 一般情况下为每个test都创建全新的 env 不需要 yield
    return e203_exu_aluEnv(dut)


# 定义其他Env
# @pytest.fixture(scope="function") # 用scope="function"确保每个测试用例都创建了一个全新的Env
# def env1(dut):
#     return MyEnv1(dut)
#
#
def api_e203_exu_alu_reset(env, max_cycles=4):
    """执行 e203_exu_alu 的基础复位流程。

    该 API 用于把环境中的输入信号恢复到空闲态，并按 DUT 的低有效复位约定
    对 `rst_n` 进行拉低和释放。该接口只封装环境初始化时序，不校验具体功能结果，
    适合作为其他 API 或测试用例的统一起点。

    Args:
        env: e203_exu_aluEnv 实例，必须是 pytest 注入的 env fixture。
        max_cycles (int): 复位阶段允许使用的最大周期数，必须为正整数。

    Returns:
        e203_exu_aluEnv: 复位后的 env 本身，便于链式调用后续 API。

    Raises:
        ValueError: 当 max_cycles 小于 1 时抛出。

    Example:
        >>> api_e203_exu_alu_reset(env, max_cycles=4)
        >>> env.ctrl_in.rst_n.value
        1

    Note:
        - API 底层统一通过 `env.Step(...)` 推进时序。
        - 该接口不会主动等待任何写回或提交结果。
    """
    if max_cycles < 1:
        raise ValueError(f"max_cycles 必须大于 0，当前为 {max_cycles}")

    hold_cycles = max(1, min(max_cycles - 1, 2))
    env.clear_inputs()
    env.ctrl_in.rst_n.value = 0
    env.Step(hold_cycles)
    env.ctrl_in.rst_n.value = 1
    env.Step(1)
    return env


def api_e203_exu_alu_issue_raw(
    env,
    info,
    rs1=0,
    rs2=0,
    imm=0,
    pc=0,
    instr=0,
    rdidx=0,
    rdwen=0,
    itag=0,
    pc_vld=1,
    ilegl=0,
    buserr=0,
    misalgn=0,
    flush_req=0,
    flush_pulse=0,
    oitf_empty=1,
    mdv_nob2b=0,
    nonflush_cmt_ena=0,
    csr_access_ilgl=0,
    read_csr_dat=0,
    agu_rsp_valid=0,
    agu_rsp_err=0,
    agu_rsp_excl_ok=0,
    agu_rsp_rdata=0,
    nice_xs_off=0,
    nice_req_ready=0,
    nice_rsp_multicyc_valid=0,
    nice_longp_wbck_ready=0,
    i_nice_cmt_off_ilgl=0,
    cmt_ready=1,
    wbck_ready=1,
    agu_cmd_ready=1,
    max_cycles=4,
):
    """按原始顶层上下文发射一次 e203_exu_alu 指令事务。

    该 API 是后续功能测试的底层通用发射入口。调用时会先清空环境输入，再一次性
    配置 issue/flush/CSR/AGU/NICE 相关上下文，通过 `Step` 推进至少一个周期，
    最终返回当前周期可观测到的主要输出快照。API 本身不假设具体指令语义，只负责
    稳定地驱动顶层接口。

    Args:
        env: e203_exu_aluEnv 实例。
        info (int): `i_info` 原始译码信息。
        rs1 (int): `i_rs1` 源操作数 1。
        rs2 (int): `i_rs2` 源操作数 2。
        imm (int): `i_imm` 立即数。
        pc (int): `i_pc` 程序计数器。
        instr (int): `i_instr` 原始指令字。
        rdidx (int): `i_rdidx` 目的寄存器号。
        rdwen (int): `i_rdwen` 写回使能。
        itag (int): `i_itag` 事务标签。
        pc_vld (int): `i_pc_vld` 指示 PC 是否有效。
        ilegl (int): `i_ilegl` 非法指令输入。
        buserr (int): `i_buserr` 总线错误输入。
        misalgn (int): `i_misalgn` 错位异常输入。
        flush_req (int): `flush_req` 冲刷请求。
        flush_pulse (int): `flush_pulse` 冲刷脉冲。
        oitf_empty (int): `oitf_empty` 输入。
        mdv_nob2b (int): `mdv_nob2b` 输入。
        nonflush_cmt_ena (int): `nonflush_cmt_ena` 输入。
        csr_access_ilgl (int): `csr_access_ilgl` 输入。
        read_csr_dat (int): `read_csr_dat` 输入。
        agu_rsp_valid (int): `agu_icb_rsp_valid` 输入。
        agu_rsp_err (int): `agu_icb_rsp_err` 输入。
        agu_rsp_excl_ok (int): `agu_icb_rsp_excl_ok` 输入。
        agu_rsp_rdata (int): `agu_icb_rsp_rdata` 输入。
        nice_xs_off (int): `nice_xs_off` 输入。
        nice_req_ready (int): `nice_req_ready` 输入。
        nice_rsp_multicyc_valid (int): `nice_rsp_multicyc_valid` 输入。
        nice_longp_wbck_ready (int): `nice_longp_wbck_ready` 输入。
        i_nice_cmt_off_ilgl (int): `i_nice_cmt_off_ilgl` 输入。
        cmt_ready (int): `cmt_o_ready` 握手输入。
        wbck_ready (int): `wbck_o_ready` 握手输入。
        agu_cmd_ready (int): `agu_icb_cmd_ready` 握手输入。
        max_cycles (int): 驱动后额外等待的最大周期数，至少为 1。

    Returns:
        dict: 当前事务推进后的主要输出快照，包含 `i_ready`、`i_longpipe`、
        `cmt_o_valid`、`wbck_o_valid`、`wbck_o_wdat`、`agu_icb_cmd_valid` 等字段。

    Raises:
        ValueError: 当 max_cycles 小于 1 时抛出。

    Example:
        >>> snapshot = api_e203_exu_alu_issue_raw(env, info=0, rs1=1, rs2=2)
        >>> sorted(snapshot.keys())[:3]
        ['agu_icb_cmd_valid', 'cmt_o_valid', 'i_longpipe']

    Note:
        - 该 API 只封装原始顶层驱动，不负责解释 `i_info` 的具体编码。
        - 若测试需要更复杂的等待策略，可在此 API 之上再封装高层 API。
    """
    if max_cycles < 1:
        raise ValueError(f"max_cycles 必须大于 0，当前为 {max_cycles}")

    env.clear_inputs()
    env.ctrl_in.rst_n.value = 1
    env.issue.valid.value = 1
    env.issue.info.value = info
    env.issue.rs1.value = rs1
    env.issue.rs2.value = rs2
    env.issue.imm.value = imm
    env.issue.pc.value = pc
    env.issue.instr.value = instr
    env.issue.rdidx.value = rdidx
    env.issue.rdwen.value = rdwen
    env.issue.itag.value = itag
    env.issue.pc_vld.value = pc_vld
    env.issue.ilegl.value = ilegl
    env.issue.buserr.value = buserr
    env.issue.misalgn.value = misalgn
    env.ctrl_in.flush_req.value = flush_req
    env.ctrl_in.flush_pulse.value = flush_pulse
    env.ctrl_in.oitf_empty.value = oitf_empty
    env.ctrl_in.mdv_nob2b.value = mdv_nob2b
    env.ctrl_in.nonflush_cmt_ena.value = nonflush_cmt_ena
    env.csr_sideband.access_ilgl.value = csr_access_ilgl
    env.csr_sideband.read_dat.value = read_csr_dat
    env.agu_rsp.valid.value = agu_rsp_valid
    env.agu_rsp.err.value = agu_rsp_err
    env.agu_rsp.excl_ok.value = agu_rsp_excl_ok
    env.agu_rsp.rdata.value = agu_rsp_rdata
    env.nice_sideband.xs_off.value = nice_xs_off
    env.nice_sideband.i_nice_cmt_off_ilgl.value = i_nice_cmt_off_ilgl
    env.nice_req.ready.value = nice_req_ready
    env.nice_rsp.rsp_multicyc_valid.value = nice_rsp_multicyc_valid
    env.nice_rsp.longp_wbck_ready.value = nice_longp_wbck_ready
    env.commit.ready.value = cmt_ready
    env.wbck.ready.value = wbck_ready
    env.agu_cmd.ready.value = agu_cmd_ready

    env.Step(1)
    for _ in range(max_cycles - 1):
        if env.commit.valid.value or env.wbck.valid.value or env.agu_cmd.valid.value or env.issue.ready.value:
            break
        env.Step(1)

    return api_e203_exu_alu_sample_outputs(env, max_cycles=1)


def api_e203_exu_alu_sample_outputs(env, max_cycles=1):
    """采样 e203_exu_alu 当前周期的主要输出和握手状态。

    该 API 仅负责把后续测试最常用的输出端口整理为字典，减少测试代码直接分散访问
    多个 Bundle 的样板逻辑。采样前会先通过 `Step` 推进指定周期数，以保证组合路径
    和时序路径都通过统一接口观察。

    Args:
        env: e203_exu_aluEnv 实例。
        max_cycles (int): 采样前推进的周期数，至少为 1。

    Returns:
        dict: 输出快照字典，字段包括握手、提交、写回和 AGU 命令相关信号。

    Raises:
        ValueError: 当 max_cycles 小于 1 时抛出。

    Example:
        >>> snapshot = api_e203_exu_alu_sample_outputs(env, max_cycles=1)
        >>> isinstance(snapshot["wbck_o_valid"], int)
        True

    Note:
        - 该 API 不修改除 `Step` 之外的 DUT 输入状态。
        - 返回值适合用于基础 API 测试和后续更高层接口封装。
    """
    if max_cycles < 1:
        raise ValueError(f"max_cycles 必须大于 0，当前为 {max_cycles}")

    env.Step(max_cycles)
    return {
        "i_ready": int(env.issue.ready.value),
        "i_longpipe": int(env.issue.longpipe.value),
        "cmt_o_valid": int(env.commit.valid.value),
        "cmt_o_pc": int(env.commit.pc.value),
        "cmt_o_instr": int(env.commit.instr.value),
        "wbck_o_valid": int(env.wbck.valid.value),
        "wbck_o_wdat": int(env.wbck.wdat.value),
        "wbck_o_rdidx": int(env.wbck.rdidx.value),
        "agu_icb_cmd_valid": int(env.agu_cmd.valid.value),
        "agu_icb_cmd_addr": int(env.agu_cmd.addr.value),
        "csr_ena": int(env.csr.ena.value),
        "nice_req_valid": int(env.nice_req.valid.value),
    }
