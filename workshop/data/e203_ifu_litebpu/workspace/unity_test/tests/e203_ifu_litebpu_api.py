#coding=utf-8

import pytest
import ucagent
from e203_ifu_litebpu_function_coverage_def import get_coverage_groups
from toffee_test.reporter import set_func_coverage, set_line_coverage, get_file_in_tmp_dir
from toffee_test.reporter import set_user_info, set_title_info
from toffee import Bundle, Signals, Signal

# import your dut module here
from e203_ifu_litebpu import DUTe203_ifu_litebpu  # Replace with the actual DUT class import

import os


def current_path_file(file_name):
    return os.path.join(os.path.dirname(os.path.abspath(__file__)), file_name)


def get_coverage_data_path(request, new_path:bool):
    # 通过toffee_test.reporter提供的get_file_in_tmp_dir方法可以让各用例产生的文件名称不重复 (获取新路径需要new_path=True，获取已有路径new_path=False)
    # 获取测试用例名称，为每个测试用例创建对应的代码行覆盖率文件
    tc_name = request.node.name if request is not None else "e203_ifu_litebpu"
    return get_file_in_tmp_dir(request, current_path_file("data/"), f"{tc_name}.dat",  new_path=new_path)


def get_waveform_path(request, new_path:bool):
    # 通过toffee_test.reporter提供的get_file_in_tmp_dir方法可以让各用例产生的文件名称不重复 (获取新路径需要new_path=True，获取已有路径new_path=False)
    # 获取测试用例名称，为每个测试用例创建对应的波形
    tc_name = request.node.name if request is not None else "e203_ifu_litebpu"
    return get_file_in_tmp_dir(request, current_path_file("data/"), f"{tc_name}.fst",  new_path=new_path)


def create_dut(request):
    """
    创建 e203_ifu_litebpu DUT 实例。
    
    Returns:
        已完成基础仿真资源配置的 DUT 实例。
    """
    # 如果是正在生成测试模板，返回fake DUT用于提速（模板中不会真运行DUT）
    if ucagent.is_imp_test_template():
        return ucagent.get_fake_dut(DUTe203_ifu_litebpu)

    # 仅创建 DUT 实例，不在 create_dut 阶段驱动任何输入引脚。
    dut = DUTe203_ifu_litebpu()

    # 设置覆盖率生成文件(必须设置覆盖率文件，否则无法统计覆盖率，导致测试失败)
    dut.SetCoverage(get_coverage_data_path(request, new_path=True))

    # 设置波形生成文件
    dut.SetWaveform(get_waveform_path(request, new_path=True))

    # e203_ifu_litebpu 是时序电路，必须绑定 clk 供 Step 推进。
    dut.InitClock("clk")

    return dut


@pytest.fixture(scope="function") # 用scope="function"确保每个测试用例都创建了一个全新的DUT
def dut(request):
    dut = create_dut(request)                         # 创建DUT
    func_coverage_group = get_coverage_groups(dut)

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
    # 代码行覆盖率 ignore 文件的固定路径为当前文件所在目录下的：e203_ifu_litebpu.ignore，请不要改变
    set_line_coverage(request, get_coverage_data_path(request, new_path=False), ignore=current_path_file("e203_ifu_litebpu.ignore"))

    # 设置用户信息到报告
    set_user_info("UCAgent-0.9.1.source-code", "unitychip@bosc.ac.cn")
    set_title_info("e203_ifu_litebpu Test Report")

    for g in func_coverage_group:                        # 采样覆盖组
        g.clear()                                        # 清空统计
    dut.Finish()                                         # 清理DUT，每个DUT class 都有 Finish 方法

@pytest.fixture(scope="function") # 用scope="function"确保每个测试用例都创建了一个全新的 Mock DUT
def mock_dut():
    return ucagent.get_mock_dut_from(DUTe203_ifu_litebpu)

class BpuControlBundle(Bundle):
    """BPU 时钟以外的基础控制输入。"""
    rst_n = Signal()


class BpuDecodeBundle(Bundle):
    """译码侧输入端口封装。"""
    pc, dec_jal, dec_jalr, dec_bxx = Signals(4)
    dec_bjp_imm, dec_jalr_rs1idx, dec_i_valid = Signals(3)


class BpuDependencyBundle(Bundle):
    """OITF/IR 依赖判断输入端口封装。"""
    oitf_empty, ir_empty, ir_rs1en = Signals(3)
    jalr_rs1idx_cam_irrdidx, ir_valid_clr = Signals(2)


class BpuRegfileBundle(Bundle):
    """来自寄存器堆的旁路值输入端口封装。"""
    x1, rs1 = Signals(2)


class BpuPredictBundle(Bundle):
    """BPU 预测输出端口封装。"""
    taken, pc_add_op1, pc_add_op2 = Signals(3)
    wait, rs1_ena = Signals(2)


# 定义e203_ifu_litebpuEnv类，封装DUT的引脚和常用操作
class e203_ifu_litebpuEnv:
    """e203_ifu_litebpu 基础测试环境，按功能分组封装 DUT 公开端口。"""

    def __init__(self, dut):
        self.dut = dut

        # DUT 端口前缀不完全统一，因此按功能用 from_dict 显式绑定。
        self.ctrl = BpuControlBundle.from_dict({
            "rst_n": "rst_n",
        })
        self.decode = BpuDecodeBundle.from_dict({
            "pc": "pc",
            "dec_jal": "dec_jal",
            "dec_jalr": "dec_jalr",
            "dec_bxx": "dec_bxx",
            "dec_bjp_imm": "dec_bjp_imm",
            "dec_jalr_rs1idx": "dec_jalr_rs1idx",
            "dec_i_valid": "dec_i_valid",
        })
        self.dependency = BpuDependencyBundle.from_dict({
            "oitf_empty": "oitf_empty",
            "ir_empty": "ir_empty",
            "ir_rs1en": "ir_rs1en",
            "jalr_rs1idx_cam_irrdidx": "jalr_rs1idx_cam_irrdidx",
            "ir_valid_clr": "ir_valid_clr",
        })
        self.regfile = BpuRegfileBundle.from_dict({
            "x1": "rf2bpu_x1",
            "rs1": "rf2bpu_rs1",
        })
        self.predict = BpuPredictBundle.from_dict({
            "taken": "prdt_taken",
            "pc_add_op1": "prdt_pc_add_op1",
            "pc_add_op2": "prdt_pc_add_op2",
            "wait": "bpu_wait",
            "rs1_ena": "bpu2rf_rs1_ena",
        })

        self.ctrl.bind(dut)
        self.decode.bind(dut)
        self.dependency.bind(dut)
        self.regfile.bind(dut)
        self.predict.bind(dut)

        # 只初始化输入端口；输出端口由 DUT 驱动，不调用 set_all。
        self.ctrl.rst_n.value = 1
        self.decode.set_all(0)
        self.dependency.set_all(0)
        self.regfile.set_all(0)

    def set_defaults(self):
        """将所有输入恢复到确定默认值，避免测试间历史输入污染。"""
        self.ctrl.rst_n.value = 1
        self.decode.assign({"*": 0})
        self.dependency.assign({
            "*": 0,
            "oitf_empty": 1,
            "ir_empty": 1,
        })
        self.regfile.assign({"*": 0})

    def reset(self, low_cycles:int = 2):
        """执行低有效复位并释放，所有推进均通过 Step 完成。"""
        self.set_defaults()
        self.ctrl.rst_n.value = 0
        self.Step(low_cycles)
        self.ctrl.rst_n.value = 1
        self.Step(1)

    def sample_outputs(self):
        """读取 BPU 公开输出，返回普通字典便于断言。"""
        return {
            "prdt_taken": self.predict.taken.value,
            "prdt_pc_add_op1": self.predict.pc_add_op1.value,
            "prdt_pc_add_op2": self.predict.pc_add_op2.value,
            "bpu_wait": self.predict.wait.value,
            "bpu2rf_rs1_ena": self.predict.rs1_ena.value,
        }

    def drive_predict(
        self,
        *,
        pc=0,
        dec_jal=0,
        dec_jalr=0,
        dec_bxx=0,
        dec_bjp_imm=0,
        dec_jalr_rs1idx=0,
        dec_i_valid=1,
        oitf_empty=1,
        ir_empty=1,
        ir_rs1en=0,
        jalr_rs1idx_cam_irrdidx=0,
        ir_valid_clr=0,
        rf2bpu_x1=0,
        rf2bpu_rs1=0,
        step=True,
    ):
        """驱动一次分支预测输入，并可选择 Step 后返回输出采样。"""
        self.ctrl.rst_n.value = 1
        self.decode.assign({
            "pc": pc,
            "dec_jal": dec_jal,
            "dec_jalr": dec_jalr,
            "dec_bxx": dec_bxx,
            "dec_bjp_imm": dec_bjp_imm,
            "dec_jalr_rs1idx": dec_jalr_rs1idx,
            "dec_i_valid": dec_i_valid,
        })
        self.dependency.assign({
            "oitf_empty": oitf_empty,
            "ir_empty": ir_empty,
            "ir_rs1en": ir_rs1en,
            "jalr_rs1idx_cam_irrdidx": jalr_rs1idx_cam_irrdidx,
            "ir_valid_clr": ir_valid_clr,
        })
        self.regfile.assign({
            "x1": rf2bpu_x1,
            "rs1": rf2bpu_rs1,
        })
        if step:
            self.Step(1)
        return self.sample_outputs()

    # 直接导出DUT的通用操作Step
    def Step(self, i:int = 1):
        return self.dut.Step(i)


# 定义env fixture, 请取消下面的注释，并根据需要修改名称
@pytest.fixture(scope="function") # 用scope="function"确保每个测试用例都创建了一个全新的Env
def env(dut):
    # 一般情况下为每个test都创建全新的 env 不需要 yield
    return e203_ifu_litebpuEnv(dut)


def _check_u32(name, value):
    """检查 32bit 无符号输入参数。"""
    if not isinstance(value, int):
        raise TypeError(f"{name} 必须为 int")
    if value < 0 or value > 0xFFFFFFFF:
        raise ValueError(f"{name} 超出 32bit 范围: {value}")


def _check_bit(name, value):
    """检查单 bit 输入参数。"""
    if value not in (0, 1):
        raise ValueError(f"{name} 必须为 0 或 1: {value}")


def api_e203_ifu_litebpu_reset(env, max_cycles=3):
    """复位 e203_ifu_litebpu DUT 并返回释放后的输出状态。

    该 API 封装低有效复位流程，内部调用 Env.reset，并通过 DUT.Step 推进时钟。
    适用于每个测试开始前建立确定初始状态。

    Args:
        env: e203_ifu_litebpuEnv 实例，必须由 env fixture 创建。
        max_cycles (int): 复位流程总周期数，至少为 2。默认值为 3。

    Returns:
        dict: 复位释放后的公开输出采样，包含 prdt_taken、prdt_pc_add_op1、
        prdt_pc_add_op2、bpu_wait 和 bpu2rf_rs1_ena。

    Raises:
        ValueError: max_cycles 小于 2 时抛出。
    """
    if max_cycles < 2:
        raise ValueError("max_cycles 至少为 2，才能完成复位拉低和释放")
    env.reset(low_cycles=max_cycles - 1)
    return env.sample_outputs()


def api_e203_ifu_litebpu_predict(
    env,
    pc=0,
    dec_jal=0,
    dec_jalr=0,
    dec_bxx=0,
    dec_bjp_imm=0,
    dec_jalr_rs1idx=0,
    dec_i_valid=1,
    oitf_empty=1,
    ir_empty=1,
    ir_rs1en=0,
    jalr_rs1idx_cam_irrdidx=0,
    ir_valid_clr=0,
    rf2bpu_x1=0,
    rf2bpu_rs1=0,
    max_cycles=1,
):
    """驱动一次 BPU 预测输入并返回输出采样。

    该 API 是 e203_ifu_litebpu 的底层通用操作接口，封装 PC、译码标志、
    JALR rs1 编号、依赖状态和寄存器值输入。函数内部先驱动输入，再通过
    Step 推进 max_cycles 个周期，最后返回 DUT 公开输出。

    Args:
        env: e203_ifu_litebpuEnv 实例，必须由 env fixture 创建。
        pc (int): 当前 PC，32bit 无符号值。
        dec_jal (int): JAL 译码有效标志，0 或 1。
        dec_jalr (int): JALR 译码有效标志，0 或 1。
        dec_bxx (int): 条件分支译码有效标志，0 或 1。
        dec_bjp_imm (int): 分支/跳转立即数，32bit 无符号值。
        dec_jalr_rs1idx (int): JALR rs1 寄存器编号，范围 0 到 31。
        dec_i_valid (int): 当前译码指令有效标志，0 或 1。
        oitf_empty (int): OITF 空标志，0 或 1。
        ir_empty (int): IR 空标志，0 或 1。
        ir_rs1en (int): IR 阶段 rs1 使用标志，0 或 1。
        jalr_rs1idx_cam_irrdidx (int): JALR rs1 与 IR rd 冲突标志，0 或 1。
        ir_valid_clr (int): IR valid 清除标志，0 或 1。
        rf2bpu_x1 (int): 寄存器 x1 旁路值，32bit 无符号值。
        rf2bpu_rs1 (int): rs1 旁路值，32bit 无符号值。
        max_cycles (int): 推进周期数，至少为 1。默认值为 1。

    Returns:
        dict: DUT 公开输出采样。

    Raises:
        ValueError: 参数越界或 max_cycles 小于 1 时抛出。
        TypeError: 32bit 数值参数不是 int 时抛出。
    """
    if max_cycles < 1:
        raise ValueError("max_cycles 至少为 1")
    for name, value in (
        ("pc", pc),
        ("dec_bjp_imm", dec_bjp_imm),
        ("rf2bpu_x1", rf2bpu_x1),
        ("rf2bpu_rs1", rf2bpu_rs1),
    ):
        _check_u32(name, value)
    if not (0 <= dec_jalr_rs1idx <= 31):
        raise ValueError(f"dec_jalr_rs1idx 超出范围: {dec_jalr_rs1idx}")
    for name, value in (
        ("dec_jal", dec_jal),
        ("dec_jalr", dec_jalr),
        ("dec_bxx", dec_bxx),
        ("dec_i_valid", dec_i_valid),
        ("oitf_empty", oitf_empty),
        ("ir_empty", ir_empty),
        ("ir_rs1en", ir_rs1en),
        ("jalr_rs1idx_cam_irrdidx", jalr_rs1idx_cam_irrdidx),
        ("ir_valid_clr", ir_valid_clr),
    ):
        _check_bit(name, value)

    env.drive_predict(
        pc=pc,
        dec_jal=dec_jal,
        dec_jalr=dec_jalr,
        dec_bxx=dec_bxx,
        dec_bjp_imm=dec_bjp_imm,
        dec_jalr_rs1idx=dec_jalr_rs1idx,
        dec_i_valid=dec_i_valid,
        oitf_empty=oitf_empty,
        ir_empty=ir_empty,
        ir_rs1en=ir_rs1en,
        jalr_rs1idx_cam_irrdidx=jalr_rs1idx_cam_irrdidx,
        ir_valid_clr=ir_valid_clr,
        rf2bpu_x1=rf2bpu_x1,
        rf2bpu_rs1=rf2bpu_rs1,
        step=False,
    )
    env.Step(max_cycles)
    return env.sample_outputs()


def api_e203_ifu_litebpu_jal(env, pc, imm, max_cycles=1):
    """驱动一条有效 JAL 预测请求并返回输出采样。

    Args:
        env: e203_ifu_litebpuEnv 实例。
        pc (int): 当前 PC，32bit 无符号值。
        imm (int): JAL 立即数，32bit 无符号值。
        max_cycles (int): 推进周期数，默认 1。

    Returns:
        dict: DUT 公开输出采样。
    """
    return api_e203_ifu_litebpu_predict(
        env,
        pc=pc,
        dec_jal=1,
        dec_bjp_imm=imm,
        dec_i_valid=1,
        max_cycles=max_cycles,
    )


def api_e203_ifu_litebpu_jalr(
    env,
    pc,
    imm,
    rs1idx,
    rf2bpu_x1=0,
    rf2bpu_rs1=0,
    oitf_empty=1,
    ir_empty=1,
    ir_rs1en=0,
    jalr_rs1idx_cam_irrdidx=0,
    ir_valid_clr=0,
    max_cycles=1,
):
    """驱动一条有效 JALR 预测请求并返回输出采样。

    Args:
        env: e203_ifu_litebpuEnv 实例。
        pc (int): 当前 PC，32bit 无符号值。
        imm (int): JALR 立即数，32bit 无符号值。
        rs1idx (int): JALR rs1 寄存器编号，范围 0 到 31。
        rf2bpu_x1 (int): x1 输入值，32bit 无符号值。
        rf2bpu_rs1 (int): rs1 输入值，32bit 无符号值。
        oitf_empty (int): OITF 空标志。
        ir_empty (int): IR 空标志。
        ir_rs1en (int): IR rs1 使用标志。
        jalr_rs1idx_cam_irrdidx (int): JALR rs1 与 IR rd 冲突标志。
        ir_valid_clr (int): IR valid 清除标志。
        max_cycles (int): 推进周期数，默认 1。

    Returns:
        dict: DUT 公开输出采样。
    """
    return api_e203_ifu_litebpu_predict(
        env,
        pc=pc,
        dec_jalr=1,
        dec_bjp_imm=imm,
        dec_jalr_rs1idx=rs1idx,
        dec_i_valid=1,
        oitf_empty=oitf_empty,
        ir_empty=ir_empty,
        ir_rs1en=ir_rs1en,
        jalr_rs1idx_cam_irrdidx=jalr_rs1idx_cam_irrdidx,
        ir_valid_clr=ir_valid_clr,
        rf2bpu_x1=rf2bpu_x1,
        rf2bpu_rs1=rf2bpu_rs1,
        max_cycles=max_cycles,
    )


def api_e203_ifu_litebpu_bxx(env, pc, imm, max_cycles=1):
    """驱动一条有效 Bxx 条件分支预测请求并返回输出采样。

    Args:
        env: e203_ifu_litebpuEnv 实例。
        pc (int): 当前 PC，32bit 无符号值。
        imm (int): Bxx 分支立即数，32bit 无符号值；最高位为 1 表示负偏移。
        max_cycles (int): 推进周期数，默认 1。

    Returns:
        dict: DUT 公开输出采样。
    """
    return api_e203_ifu_litebpu_predict(
        env,
        pc=pc,
        dec_bxx=1,
        dec_bjp_imm=imm,
        dec_i_valid=1,
        max_cycles=max_cycles,
    )
