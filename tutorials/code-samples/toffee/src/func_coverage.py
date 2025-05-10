import toffee.funcov as fc
import toffee_test
from toffee.funcov import CovGroup
from Cache import DUTCache
from env.ntcache_env import *
from env.simpleram import *

def is_cache_miss():
    """ detect whether pull up a read req from mem ports """
    def cache_miss(dut: DUTCache):
        req_valid = dut.io_out_mem_req_valid.value
        req_ready = dut.io_out_mem_req_ready.value
        return req_valid and req_ready
    return cache_miss


def is_cache_miss_block():
    """ block the pipeline when cache miss """
    def cache_miss(dut: DUTCache):
        req_valid = dut.io_out_mem_req_valid.value
        req_ready = dut.io_out_mem_req_ready.value
        top_ready = dut.io_in_req_ready.value
        return req_valid and req_ready and top_ready
    return cache_miss


def is_cache_miss_dirty():
    """ write back the dirty cacheline """
    def cache_miss_dirty(dut: DUTCache):
        req_valid = dut.io_out_mem_req_valid.value
        req_ready = dut.io_out_mem_req_ready.value
        req_cmd = dut.io_out_mem_req_bits_cmd.value
        return req_valid and req_ready and (req_cmd == CMD_WRITE or req_cmd == CMD_WRITEBST)
    return cache_miss_dirty

def is_use_mmio():
    def use_mmio(dut: DUTCache):        # use MMIO
        req_valid = dut.io_mmio_req_valid.value
        req_ready = dut.io_mmio_req_ready.value
        req_addr = dut.io_mmio_req_bits_addr.value
        return req_valid and req_ready and 0x30000000 <= req_addr <= 0x3fffffff
    return use_mmio


def is_not_burst():     # MMIO will not trigger burst request
    def not_burst(dut: DUTCache):
        req_valid = dut.io_mmio_req_valid.value
        req_ready = dut.io_mmio_req_ready.value
        req_cmd = dut.io_mmio_req_bits_cmd
        return req_valid and req_ready and req_cmd != CMD_READBST and req_cmd != CMD_WRITEBST
    return not_burst


def is_block_ppl():     # MMIO request will block the pipeline
    def block_ppl(dut: DUTCache):
        req_valid = dut.io_mmio_req_valid.value
        req_ready = dut.io_mmio_req_ready.value
        top_ready = dut.io_in_req_ready.value
        return req_valid and req_ready and not top_ready
    return block_ppl


def get_cov_grp_of_pass(dut: DUTCache):
    g = CovGroup("CovGroup pass")
    g.add_cover_point(dut,{"miss": is_cache_miss()}, name="Cache Miss")
    g.add_cover_point(dut,{"block": is_cache_miss_block()}, name = "Cache Miss Block")
    return g

def get_cov_grp_of_miss(dut: DUTCache):
    g = CovGroup("Cache miss")
    g.add_cover_point(dut.reset, {"io_count is0": fc.Eq(0)}, name = "Count is 0")
    g.add_cover_point(dut,{"miss": is_cache_miss()}, name="Cache Miss")
    g.add_cover_point(dut,{"block": is_cache_miss_block()}, name = "Cache Miss Block")
    g.add_cover_point(dut,{"write back dirty dat": is_cache_miss_dirty()}, name = "Cache Miss Wb dirty")
    return g

def get_cov_grp_of_mmio(dut: DUTCache):
    grp = CovGroup("NtCache MMIO")
    grp.add_watch_point(dut, {"use_mmio": is_use_mmio()}, name="MMIO Transmit")
    grp.add_watch_point(dut, {"no_burst_mmio": is_not_burst()}, name="MMIO Not Burst")
    grp.add_watch_point(dut, {"block_ppl_mmio": is_block_ppl()}, name="MMIO Block Pipeline")
    return grp
