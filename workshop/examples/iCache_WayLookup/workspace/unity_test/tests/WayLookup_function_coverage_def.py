#coding=utf-8
"""
WayLookup 功能覆盖定义

为 WayLookup 的每个功能分组定义覆盖点。
"""

import toffee.funcov as fc


def create_api_write_coverage(g, dut):
    """创建 API 写操作分组的覆盖点"""
    def check_write_basic(x):
        return x.io_write_valid.value == 1 and x.io_write_ready.value == 1
    
    def check_write_full(x):
        return x.io_write_ready.value == 0
    
    g.add_watch_point(dut,
        {
            "CK-WRITE-BASIC": check_write_basic,
            "CK-WRITE-FULL": check_write_full,
        },
        name="FC-API-WRITE")


def create_api_read_coverage(g, dut):
    """创建 API 读操作分组的覆盖点"""
    def check_read_basic(x):
        return x.io_read_valid.value == 1 and x.io_read_ready.value == 1
    
    def check_read_empty(x):
        return x.io_read_valid.value == 0
    
    g.add_watch_point(dut,
        {
            "CK-READ-BASIC": check_read_basic,
            "CK-READ-EMPTY": check_read_empty,
        },
        name="FC-API-READ")


def create_api_update_coverage(g, dut):
    """创建 API 更新操作分组的覆盖点"""
    def check_update_valid(x):
        return x.io_update_valid.value == 1
    
    g.add_watch_point(dut,
        {
            "CK-UPDATE-BASIC": check_update_valid,
        },
        name="FC-API-UPDATE")


def create_api_flush_coverage(g, dut):
    """创建 API 刷新操作分组的覆盖点"""
    def check_flush(x):
        return x.io_flush.value == 1
    
    g.add_watch_point(dut,
        {
            "CK-FLUSH-BASIC": check_flush,
        },
        name="FC-API-FLUSH")


def create_flush_read_ptr_coverage(g, dut):
    """创建刷新读指针分组的覆盖点"""
    g.add_watch_point(dut,
        {
            "CK-FLUSH-RP-VALUE": lambda x: x.io_flush.value == 1,
            "CK-FLUSH-RP-FLAG": lambda x: x.io_flush.value == 1,
        },
        name="FC-FLUSH-READ-PTR")


def create_flush_write_ptr_coverage(g, dut):
    """创建刷新写指针分组的覆盖点"""
    g.add_watch_point(dut,
        {
            "CK-FLUSH-WP-VALUE": lambda x: x.io_flush.value == 1,
            "CK-FLUSH-WP-FLAG": lambda x: x.io_flush.value == 1,
        },
        name="FC-FLUSH-WRITE-PTR")


def create_flush_gpf_coverage(g, dut):
    """创建刷新 GPF 分组的覆盖点"""
    g.add_watch_point(dut,
        {
            "CK-FLUSH-GPF-VALID": lambda x: x.io_flush.value == 1,
            "CK-FLUSH-GPF-BITS": lambda x: x.io_flush.value == 1,
        },
        name="FC-FLUSH-GPF")


def create_fifo_empty_coverage(g, dut):
    """创建 FIFO 队列空状态分组的覆盖点"""
    g.add_watch_point(dut,
        {
            "CK-EMPTY-TRUE": lambda x: x.io_read_valid.value == 0,
            "CK-EMPTY-READ-INVALID": lambda x: x.io_read_valid.value == 0,
        },
        name="FC-FIFO-EMPTY")


def create_fifo_full_coverage(g, dut):
    """创建 FIFO 队列满状态分组的覆盖点"""
    def check_queue_full(x):
        return x.io_write_ready.value == 0
    
    g.add_watch_point(dut,
        {
            "CK-FULL-TRUE": check_queue_full,
            "CK-FULL-WRITE-BLOCK": check_queue_full,
        },
        name="FC-FIFO-FULL")


def create_fifo_wrap_coverage(g, dut):
    """创建 FIFO 指针环绕分组的覆盖点"""
    g.add_watch_point(dut,
        {
            "CK-WRAP-READ": lambda x: True,
            "CK-WRAP-WRITE": lambda x: True,
        },
        name="FC-FIFO-PTR-WRAP")


def create_fifo_ptr_update_coverage(g, dut):
    """创建 FIFO 指针更新分组的覆盖点"""
    g.add_watch_point(dut,
        {
            "CK-READ-PTR-INCREMENT": lambda x: x.io_read_valid.value == 1,
            "CK-WRITE-PTR-INCREMENT": lambda x: x.io_write_valid.value == 1,
        },
        name="FC-FIFO-PTR-UPDATE")


def create_write_normal_coverage(g, dut):
    """创建写操作正常写入分组的覆盖点"""
    def check_write_fire(x):
        return x.io_write_valid.value == 1 and x.io_write_ready.value == 1
    
    g.add_watch_point(dut,
        {
            "CK-WRITE-FIRE": check_write_fire,
            "CK-WRITE-DATA": check_write_fire,
        },
        name="FC-WRITE-NORMAL")


def create_write_gpf_stall_coverage(g, dut):
    """创建写操作 GPF 停止分组的覆盖点"""
    g.add_watch_point(dut,
        {
            "CK-GPF-STALL-ACTIVE": lambda x: x.io_write_ready.value == 0,
            "CK-GPF-STALL-RELEASE": lambda x: x.io_write_ready.value == 1,
        },
        name="FC-WRITE-GPF-STALL")


def create_write_queue_full_coverage(g, dut):
    """创建写操作队列满分组的覆盖点"""
    def check_write_not_ready(x):
        return x.io_write_ready.value == 0
    
    g.add_watch_point(dut,
        {
            "CK-WRITE-NOT-READY": check_write_not_ready,
        },
        name="FC-WRITE-QUEUE-FULL")


def create_write_gpf_bypass_coverage(g, dut):
    """创建写操作 GPF Bypass 分组的覆盖点"""
    g.add_watch_point(dut,
        {
            "CK-GPF-BYPASS-NOT-STORE": lambda x: x.io_write_ready.value == 0,
        },
        name="FC-WRITE-GPF-BYPASS")


def create_write_gpf_store_coverage(g, dut):
    """创建写操作 GPF 存储分组的覆盖点"""
    g.add_watch_point(dut,
        {
            "CK-GPF-STORE-VALID": lambda x: x.io_write_valid.value == 1,
            "CK-GPF-STORE-DATA": lambda x: x.io_write_valid.value == 1,
            "CK-GPF-STORE-PTR": lambda x: x.io_write_valid.value == 1,
        },
        name="FC-WRITE-GPF-STORE")


def create_read_bypass_coverage(g, dut):
    """创建读操作 Bypass 读分组的覆盖点"""
    def check_bypass(x):
        return x.io_read_valid.value == 1 and x.io_write_valid.value == 1
    
    g.add_watch_point(dut,
        {
            "CK-BYPASS-CONDITION": check_bypass,
            "CK-BYPASS-DATA": check_bypass,
        },
        name="FC-READ-BYPASS")


def create_read_invalid_coverage(g, dut):
    """创建读操作无效分组的覆盖点"""
    g.add_watch_point(dut,
        {
            "CK-READ-NOT-VALID": lambda x: x.io_read_valid.value == 0,
        },
        name="FC-READ-INVALID")


def create_read_normal_coverage(g, dut):
    """创建读操作正常读分组的覆盖点"""
    def check_read_ready(x):
        return x.io_read_valid.value == 1 and x.io_read_ready.value == 1
    
    g.add_watch_point(dut,
        {
            "CK-READ-FROM-QUEUE": check_read_ready,
            "CK-READ-DATA-CORRECT": check_read_ready,
        },
        name="FC-READ-NORMAL")


def create_read_gpf_hit_coverage(g, dut):
    """创建读操作 GPF 命中分组的覆盖点"""
    g.add_watch_point(dut,
        {
            "CK-GPF-HIT-ACTIVE": lambda x: x.io_read_valid.value == 1,
            "CK-GPF-HIT-DATA": lambda x: x.io_read_valid.value == 1,
        },
        name="FC-READ-GPF-HIT")


def create_read_gpf_hit_read_coverage(g, dut):
    """创建读操作 GPF 命中读取分组的覆盖点"""
    def check_read_ready(x):
        return x.io_read_valid.value == 1 and x.io_read_ready.value == 1
    
    g.add_watch_point(dut,
        {
            "CK-GPF-READ-CLEAR": check_read_ready,
        },
        name="FC-READ-GPF-HIT-READ")


def create_read_gpf_miss_coverage(g, dut):
    """创建读操作 GPF 未命中分组的覆盖点"""
    def check_read_valid(x):
        return x.io_read_valid.value == 1
    
    g.add_watch_point(dut,
        {
            "CK-GPF-MISS-ZERO": check_read_valid,
        },
        name="FC-READ-GPF-MISS")


def create_update_hit_coverage(g, dut):
    """创建更新操作命中更新分组的覆盖点"""
    g.add_watch_point(dut,
        {
            "CK-UPDATE-HIT-WAYMASK": lambda x: x.io_update_valid.value == 1,
            "CK-UPDATE-HIT-HITS": lambda x: x.io_update_valid.value == 1,
        },
        name="FC-UPDATE-HIT")


def create_update_miss_coverage(g, dut):
    """创建更新操作未命中更新分组的覆盖点"""
    g.add_watch_point(dut,
        {
            "CK-UPDATE-MISS-WAYMASK": lambda x: x.io_update_valid.value == 1,
            "CK-UPDATE-MISS-HIT": lambda x: x.io_update_valid.value == 1,
        },
        name="FC-UPDATE-MISS")


def create_update_corrupt_coverage(g, dut):
    """创建更新操作 corrupt 分组的覆盖点"""
    g.add_watch_point(dut,
        {
            "CK-CORRUPT-NO-UPDATE": lambda x: x.io_update_valid.value == 1,
        },
        name="FC-UPDATE-CORRUPT")


def create_edge_queue_boundary_coverage(g, dut):
    """创建边界队列分组的覆盖点"""
    g.add_watch_point(dut,
        {
            "CK-EDGE-QUEUE-EMPTY": lambda x: x.io_read_valid.value == 0,
            "CK-EDGE-QUEUE-FULL": lambda x: x.io_write_ready.value == 0,
            "CK-EDGE-QUEUE-WRAP": lambda x: True,
        },
        name="FC-EDGE-QUEUE-BOUNDARY")


def create_edge_gpf_boundary_coverage(g, dut):
    """创建边界 GPF 分组的覆盖点"""
    g.add_watch_point(dut,
        {
            "CK-EDGE-GPF-FIRST": lambda x: x.io_write_valid.value == 1,
            "CK-EDGE-GPF-DOUBLE": lambda x: x.io_write_valid.value == 1,
            "CK-EDGE-GPF-OVERLAP": lambda x: x.io_read_valid.value == 1,
        },
        name="FC-EDGE-GPF-BOUNDARY")


def create_edge_update_boundary_coverage(g, dut):
    """创建边界更新分组的覆盖点"""
    g.add_watch_point(dut,
        {
            "CK-EDGE-UPDATE-VSET-MATCH": lambda x: x.io_update_valid.value == 1,
            "CK-EDGE-UPDATE-PTAG-MATCH": lambda x: x.io_update_valid.value == 1,
        },
        name="FC-EDGE-UPDATE-BOUNDARY")


def get_coverage_groups(dut):
    """
    获取所有功能覆盖组
    
    Returns:
        list: 功能覆盖组列表
    """
    ret = []
    
    # API 分组
    ret.append(fc.CovGroup("FG-API"))
    create_api_write_coverage(ret[-1], dut)
    create_api_read_coverage(ret[-1], dut)
    create_api_update_coverage(ret[-1], dut)
    create_api_flush_coverage(ret[-1], dut)
    
    # 刷新操作分组
    ret.append(fc.CovGroup("FG-FLUSH"))
    create_flush_read_ptr_coverage(ret[-1], dut)
    create_flush_write_ptr_coverage(ret[-1], dut)
    create_flush_gpf_coverage(ret[-1], dut)
    
    # FIFO 操作分组
    ret.append(fc.CovGroup("FG-FIFO"))
    create_fifo_empty_coverage(ret[-1], dut)
    create_fifo_full_coverage(ret[-1], dut)
    create_fifo_wrap_coverage(ret[-1], dut)
    create_fifo_ptr_update_coverage(ret[-1], dut)
    
    # 写操作分组
    ret.append(fc.CovGroup("FG-WRITE"))
    create_write_normal_coverage(ret[-1], dut)
    create_write_gpf_stall_coverage(ret[-1], dut)
    create_write_queue_full_coverage(ret[-1], dut)
    create_write_gpf_bypass_coverage(ret[-1], dut)
    create_write_gpf_store_coverage(ret[-1], dut)
    
    # 读操作分组
    ret.append(fc.CovGroup("FG-READ"))
    create_read_bypass_coverage(ret[-1], dut)
    create_read_invalid_coverage(ret[-1], dut)
    create_read_normal_coverage(ret[-1], dut)
    create_read_gpf_hit_coverage(ret[-1], dut)
    create_read_gpf_hit_read_coverage(ret[-1], dut)
    create_read_gpf_miss_coverage(ret[-1], dut)
    
    # 更新操作分组
    ret.append(fc.CovGroup("FG-UPDATE"))
    create_update_hit_coverage(ret[-1], dut)
    create_update_miss_coverage(ret[-1], dut)
    create_update_corrupt_coverage(ret[-1], dut)
    
    # 边界条件分组
    ret.append(fc.CovGroup("FG-EDGE"))
    create_edge_queue_boundary_coverage(ret[-1], dut)
    create_edge_gpf_boundary_coverage(ret[-1], dut)
    create_edge_update_boundary_coverage(ret[-1], dut)
    
    return ret
