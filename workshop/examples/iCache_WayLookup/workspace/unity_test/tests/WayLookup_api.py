#coding=utf-8
"""
WayLookup 测试环境与 API 定义

本模块提供 WayLookup DUT 的引脚封装和 API 函数。
WayLookup 是一个 FIFO 环形队列模块，用于缓存元数据和处理 GPF。
"""

import pytest
import ucagent
from WayLookup_function_coverage_def import get_coverage_groups
from toffee_test.reporter import set_func_coverage, set_line_coverage, get_file_in_tmp_dir
from toffee_test.reporter import set_user_info, set_title_info
from toffee import Bundle, Signals, Signal

# 导入 DUT 类
from WayLookup import DUTWayLookup

import os


def current_path_file(file_name):
    """获取当前文件所在目录下的文件路径"""
    return os.path.join(os.path.dirname(os.path.abspath(__file__)), file_name)


def get_coverage_data_path(request, new_path: bool):
    """
    获取代码行覆盖率数据文件路径

    Args:
        request: pytest request 对象
        new_path: 是否获取新路径

    Returns:
        覆盖率数据文件路径
    """
    tc_name = request.node.name if request is not None else "WayLookup"
    return get_file_in_tmp_dir(request, current_path_file("data/"), f"{tc_name}.dat", new_path=new_path)


def get_waveform_path(request, new_path: bool):
    """
    获取波形文件路径

    Args:
        request: pytest request 对象
        new_path: 是否获取新路径

    Returns:
        波形文件路径
    """
    tc_name = request.node.name if request is not None else "WayLookup"
    return get_file_in_tmp_dir(request, current_path_file("data/"), f"{tc_name}.fst", new_path=new_path)


def create_dut(request):
    """
    创建 WayLookup DUT 实例

    Returns:
        DUTWayLookup 实例
    """
    if ucagent.is_imp_test_template():
        return ucagent.get_fake_dut(DUTWayLookup)

    dut = DUTWayLookup()

    # 设置覆盖率生成文件
    dut.SetCoverage(get_coverage_data_path(request, new_path=True))

    # 设置波形生成文件
    dut.SetWaveform(get_waveform_path(request, new_path=True))

    return dut


@pytest.fixture(scope="function")
def dut(request):
    """DUT fixture，负责创建和管理 DUT 实例"""
    dut = create_dut(request)
    func_coverage_group = get_coverage_groups(dut)

    # 初始化时钟（时序电路需要）
    dut.InitClock("clock")

    # 注册覆盖率采样回调
    dut.StepRis(lambda _: [g.sample() for g in func_coverage_group])

    # 保存覆盖组到 DUT
    setattr(dut, "fc_cover", {g.name: g for g in func_coverage_group})

    yield dut

    # 测试后处理
    set_func_coverage(request, func_coverage_group)
    set_line_coverage(request, get_coverage_data_path(request, new_path=False),
                      ignore=current_path_file("WayLookup.ignore"))
    set_user_info("UCAgent-0.9.1.source-code", "unitychip@bosc.ac.cn")
    set_title_info("WayLookup Test Report")

    for g in func_coverage_group:
        g.clear()
    dut.Finish()


@pytest.fixture(scope="function")
def mock_dut():
    """Mock DUT fixture"""
    return ucagent.get_mock_dut_from(DUTWayLookup)


class WayLookupEnv:
    """
    WayLookup 测试环境封装

    提供 WayLookup DUT 的引脚封装和常用操作方法。
    使用 from_dict 进行信号绑定，避免前缀匹配问题。
    """

    def __init__(self, dut):
        """
        初始化 WayLookup 测试环境

        Args:
            dut: DUTWayLookup 实例
        """
        self.dut = dut

        # 使用 from_dict 进行绑定，映射 DUT 信号名称
        # 写接口
        self.write_valid = dut.io_write_valid
        self.write_ready = dut.io_write_ready
        self.write_bits_entry_vSetIdx_0 = dut.io_write_bits_entry_vSetIdx_0
        self.write_bits_entry_vSetIdx_1 = dut.io_write_bits_entry_vSetIdx_1
        self.write_bits_entry_waymask_0 = dut.io_write_bits_entry_waymask_0
        self.write_bits_entry_waymask_1 = dut.io_write_bits_entry_waymask_1
        self.write_bits_entry_ptag_0 = dut.io_write_bits_entry_ptag_0
        self.write_bits_entry_ptag_1 = dut.io_write_bits_entry_ptag_1
        self.write_bits_entry_itlb_exception_0 = dut.io_write_bits_entry_itlb_exception_0
        self.write_bits_entry_itlb_exception_1 = dut.io_write_bits_entry_itlb_exception_1
        self.write_bits_entry_itlb_pbmt_0 = dut.io_write_bits_entry_itlb_pbmt_0
        self.write_bits_entry_itlb_pbmt_1 = dut.io_write_bits_entry_itlb_pbmt_1
        self.write_bits_entry_meta_codes_0 = dut.io_write_bits_entry_meta_codes_0
        self.write_bits_entry_meta_codes_1 = dut.io_write_bits_entry_meta_codes_1
        self.write_bits_gpf_gpaddr = dut.io_write_bits_gpf_gpaddr
        self.write_bits_gpf_isForVSnonLeafPTE = dut.io_write_bits_gpf_isForVSnonLeafPTE

        # 读接口
        self.read_ready = dut.io_read_ready
        self.read_valid = dut.io_read_valid
        self.read_bits_entry_vSetIdx_0 = dut.io_read_bits_entry_vSetIdx_0
        self.read_bits_entry_vSetIdx_1 = dut.io_read_bits_entry_vSetIdx_1
        self.read_bits_entry_waymask_0 = dut.io_read_bits_entry_waymask_0
        self.read_bits_entry_waymask_1 = dut.io_read_bits_entry_waymask_1
        self.read_bits_entry_ptag_0 = dut.io_read_bits_entry_ptag_0
        self.read_bits_entry_ptag_1 = dut.io_read_bits_entry_ptag_1
        self.read_bits_entry_itlb_exception_0 = dut.io_read_bits_entry_itlb_exception_0
        self.read_bits_entry_itlb_exception_1 = dut.io_read_bits_entry_itlb_exception_1
        self.read_bits_entry_itlb_pbmt_0 = dut.io_read_bits_entry_itlb_pbmt_0
        self.read_bits_entry_itlb_pbmt_1 = dut.io_read_bits_entry_itlb_pbmt_1
        self.read_bits_entry_meta_codes_0 = dut.io_read_bits_entry_meta_codes_0
        self.read_bits_entry_meta_codes_1 = dut.io_read_bits_entry_meta_codes_1
        self.read_bits_gpf_gpaddr = dut.io_read_bits_gpf_gpaddr
        self.read_bits_gpf_isForVSnonLeafPTE = dut.io_read_bits_gpf_isForVSnonLeafPTE

        # 更新接口
        self.update_valid = dut.io_update_valid
        self.update_bits_blkPaddr = dut.io_update_bits_blkPaddr
        self.update_bits_vSetIdx = dut.io_update_bits_vSetIdx
        self.update_bits_waymask = dut.io_update_bits_waymask
        self.update_bits_corrupt = dut.io_update_bits_corrupt

        # 刷新接口
        self.flush = dut.io_flush

        # 初始化输入信号
        self._init_signals()

    def _init_signals(self):
        """初始化所有输入信号为 0"""
        # 写接口
        self.write_valid.value = 0
        self.write_bits_entry_vSetIdx_0.value = 0
        self.write_bits_entry_vSetIdx_1.value = 0
        self.write_bits_entry_waymask_0.value = 0
        self.write_bits_entry_waymask_1.value = 0
        self.write_bits_entry_ptag_0.value = 0
        self.write_bits_entry_ptag_1.value = 0
        self.write_bits_entry_itlb_exception_0.value = 0
        self.write_bits_entry_itlb_exception_1.value = 0
        self.write_bits_entry_itlb_pbmt_0.value = 0
        self.write_bits_entry_itlb_pbmt_1.value = 0
        self.write_bits_entry_meta_codes_0.value = 0
        self.write_bits_entry_meta_codes_1.value = 0
        self.write_bits_gpf_gpaddr.value = 0
        self.write_bits_gpf_isForVSnonLeafPTE.value = 0

        # 读接口
        self.read_ready.value = 0

        # 更新接口
        self.update_valid.value = 0
        self.update_bits_blkPaddr.value = 0
        self.update_bits_vSetIdx.value = 0
        self.update_bits_waymask.value = 0
        self.update_bits_corrupt.value = 0

        # 刷新接口
        self.flush.value = 0

    def reset(self):
        """
        复位 DUT

        将 reset 信号置高一个周期，然后拉低。
        """
        self.dut.reset.value = 1
        self.dut.Step(1)
        self.dut.reset.value = 0
        self.dut.Step(1)
        self._init_signals()

    def flush_dut(self):
        """
        发送刷新信号

        将 flush 信号置高一个周期。
        """
        self.flush.value = 1
        self.dut.Step(1)
        self.flush.value = 0

    def Step(self, i: int = 1):
        """
        推进仿真时钟

        Args:
            i: 推进的时钟周期数
        """
        return self.dut.Step(i)


@pytest.fixture(scope="function")
def env(dut):
    """Env fixture"""
    return WayLookupEnv(dut)


# ==================== API 函数 ====================

def api_WayLookup_flush(env, max_cycles: int = 10):
    """
    刷新 WayLookup 队列

    发送 flush 信号，重置队列状态。

    Args:
        env: WayLookupEnv 实例
        max_cycles: 最大等待周期数

    Returns:
        bool: 刷新是否成功
    """
    env.flush_dut()
    env.Step(1)
    return True


def api_WayLookup_write(env, vSetIdx: int, waymask: int, ptag: int,
                        itlb_exception: int = 0, itlb_pbmt: int = 0,
                        meta_codes: int = 0, gpaddr: int = 0,
                        isForVSnonLeafPTE: int = 0, max_cycles: int = 100):
    """
    向 WayLookup 写入数据

    Args:
        env: WayLookupEnv 实例
        vSetIdx: 虚拟地址缓存组索引 (8bit)
        waymask: 路掩码 (4bit)
        ptag: 物理地址标签 (36bit)
        itlb_exception: ITLB 异常指示 (2bit)
        itlb_pbmt: ITLB PBMT 指示 (2bit)
        meta_codes: meta ECC 校验码 (1bit)
        gpaddr: 客户页地址 (56bit)
        isForVSnonLeafPTE: 非叶 PTE 指示 (1bit)
        max_cycles: 最大等待周期数

    Returns:
        bool: 写入是否成功
    """
    # 设置写数据
    env.write_bits_entry_vSetIdx_0.value = vSetIdx & 0xFF
    env.write_bits_entry_vSetIdx_1.value = (vSetIdx >> 8) & 0xFF
    env.write_bits_entry_waymask_0.value = waymask & 0xF
    env.write_bits_entry_waymask_1.value = (waymask >> 4) & 0xF
    env.write_bits_entry_ptag_0.value = ptag & 0xFFFFFFFFF
    env.write_bits_entry_ptag_1.value = (ptag >> 36) & 0xF
    env.write_bits_entry_itlb_exception_0.value = itlb_exception & 0x3
    env.write_bits_entry_itlb_exception_1.value = (itlb_exception >> 2) & 0x3
    env.write_bits_entry_itlb_pbmt_0.value = itlb_pbmt & 0x3
    env.write_bits_entry_itlb_pbmt_1.value = (itlb_pbmt >> 2) & 0x3
    env.write_bits_entry_meta_codes_0.value = meta_codes & 0x1
    env.write_bits_entry_meta_codes_1.value = (meta_codes >> 1) & 0x1
    env.write_bits_gpf_gpaddr.value = gpaddr
    env.write_bits_gpf_isForVSnonLeafPTE.value = isForVSnonLeafPTE

    # 发起写操作
    env.write_valid.value = 1
    for i in range(max_cycles):
        try:
            wp = env.dut.GetInternalSignal("WayLookup_top.WayLookup.writePtr_value").value
            rp = env.dut.GetInternalSignal("WayLookup_top.WayLookup.readPtr_value").value
            wf = env.dut.GetInternalSignal("WayLookup_top.WayLookup.writePtr_flag").value
            rf = env.dut.GetInternalSignal("WayLookup_top.WayLookup.readPtr_flag").value
            print(f"DEBUG: WP={wf}:{wp}, RP={rf}:{rp}, ready={env.write_ready.value}, cycle={i}")
        except:
            pass
        
        if env.write_ready.value == 1:
            env.Step(1)
            env.write_valid.value = 0
            return True
        env.Step(1)

    env.write_valid.value = 0
    return False


def api_WayLookup_read(env, max_cycles: int = 100):
    """
    从 WayLookup 读取数据

    Args:
        env: WayLookupEnv 实例
        max_cycles: 最大等待周期数

    Returns:
        dict: 读取的数据，None 表示读取失败
    """
    # 发起读请求
    env.read_ready.value = 1
    env.Step(1)

    # 等待读有效
    for _ in range(max_cycles):
        if env.read_valid.value == 1:
            # 读取数据
            result = {
                'valid': True,
                'vSetIdx': (env.read_bits_entry_vSetIdx_1.value << 8) | env.read_bits_entry_vSetIdx_0.value,
                'waymask': (env.read_bits_entry_waymask_1.value << 4) | env.read_bits_entry_waymask_0.value,
                'ptag': (env.read_bits_entry_ptag_1.value << 36) | env.read_bits_entry_ptag_0.value,
                'itlb_exception': (env.read_bits_entry_itlb_exception_1.value << 2) | env.read_bits_entry_itlb_exception_0.value,
                'itlb_pbmt': (env.read_bits_entry_itlb_pbmt_1.value << 2) | env.read_bits_entry_itlb_pbmt_0.value,
                'meta_codes': (env.read_bits_entry_meta_codes_1.value << 1) | env.read_bits_entry_meta_codes_0.value,
                'gpaddr': env.read_bits_gpf_gpaddr.value,
                'isForVSnonLeafPTE': env.read_bits_gpf_isForVSnonLeafPTE.value,
            }
            env.read_ready.value = 0
            env.Step(1)
            return result
        env.Step(1)

    env.read_ready.value = 0
    env.Step(1)
    return {'valid': False}


def api_WayLookup_update(env, vSetIdx: int, waymask: int,
                         blkPaddr: int, corrupt: int = 0,
                         max_cycles: int = 100):
    """
    更新 WayLookup 的命中信息

    Args:
        env: WayLookupEnv 实例
        vSetIdx: 虚拟地址缓存组索引 (8bit)
        waymask: 路掩码 (4bit)
        blkPaddr: 缓存行物理地址 (42bit，取 [41:6] 与 ptag 比较)
        corrupt: 数据损坏指示
        max_cycles: 最大等待周期数

    Returns:
        bool: 更新是否成功
    """
    # 设置更新数据
    env.update_bits_vSetIdx.value = vSetIdx & 0xFF
    env.update_bits_waymask.value = waymask & 0xF
    env.update_bits_blkPaddr.value = blkPaddr & 0x3FFFFFFFFFF
    env.update_bits_corrupt.value = corrupt & 0x1

    # 发起更新
    env.update_valid.value = 1
    env.Step(1)
    env.update_valid.value = 0

    # 等待更新完成 - update_valid 变为 0 表示更新完成
    for _ in range(max_cycles):
        if env.update_valid.value == 0:
            env.Step(1)
            return True
        env.Step(1)

    return False
