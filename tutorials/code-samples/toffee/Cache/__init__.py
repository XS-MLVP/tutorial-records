#coding=utf8

try:
    from . import xspcomm as xsp
except Exception as e:
    import xspcomm as xsp

if __package__ or "." in __name__:
    from .libUT_Cache import *
else:
    from libUT_Cache import *


class DUTCache(object):

    # initialize
    def __init__(self, *args, **kwargs):
        self.dut = DutUnifiedBase(*args)
        self.xclock = xsp.XClock(self.dut.pxcStep, self.dut.pSelf)
        self.xport  = xsp.XPort()
        self.xclock.Add(self.xport)
        self.event = self.xclock.getEvent()
        self.internal_signals = {}
        self.xcfg = xsp.XSignalCFG(self.dut.GetXSignalCFGPath(), self.dut.GetXSignalCFGBasePtr())

        # set output files
        if kwargs.get("waveform_filename"):
            self.dut.SetWaveform(kwargs.get("waveform_filename"))
        if kwargs.get("coverage_filename"):
            self.dut.SetCoverage(kwargs.get("coverage_filename"))

        # all Pins
        self.clock = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.reset = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.io_in_req_ready = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.io_in_req_valid = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.io_in_req_bits_addr = xsp.XPin(xsp.XData(32, xsp.XData.In), self.event)
        self.io_in_req_bits_size = xsp.XPin(xsp.XData(3, xsp.XData.In), self.event)
        self.io_in_req_bits_cmd = xsp.XPin(xsp.XData(4, xsp.XData.In), self.event)
        self.io_in_req_bits_wmask = xsp.XPin(xsp.XData(8, xsp.XData.In), self.event)
        self.io_in_req_bits_wdata = xsp.XPin(xsp.XData(64, xsp.XData.In), self.event)
        self.io_in_req_bits_user = xsp.XPin(xsp.XData(16, xsp.XData.In), self.event)
        self.io_in_resp_ready = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.io_in_resp_valid = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.io_in_resp_bits_cmd = xsp.XPin(xsp.XData(4, xsp.XData.Out), self.event)
        self.io_in_resp_bits_rdata = xsp.XPin(xsp.XData(64, xsp.XData.Out), self.event)
        self.io_in_resp_bits_user = xsp.XPin(xsp.XData(16, xsp.XData.Out), self.event)
        self.io_flush = xsp.XPin(xsp.XData(2, xsp.XData.In), self.event)
        self.io_out_mem_req_ready = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.io_out_mem_req_valid = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.io_out_mem_req_bits_addr = xsp.XPin(xsp.XData(32, xsp.XData.Out), self.event)
        self.io_out_mem_req_bits_size = xsp.XPin(xsp.XData(3, xsp.XData.Out), self.event)
        self.io_out_mem_req_bits_cmd = xsp.XPin(xsp.XData(4, xsp.XData.Out), self.event)
        self.io_out_mem_req_bits_wmask = xsp.XPin(xsp.XData(8, xsp.XData.Out), self.event)
        self.io_out_mem_req_bits_wdata = xsp.XPin(xsp.XData(64, xsp.XData.Out), self.event)
        self.io_out_mem_resp_ready = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.io_out_mem_resp_valid = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.io_out_mem_resp_bits_cmd = xsp.XPin(xsp.XData(4, xsp.XData.In), self.event)
        self.io_out_mem_resp_bits_rdata = xsp.XPin(xsp.XData(64, xsp.XData.In), self.event)
        self.io_out_coh_req_ready = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.io_out_coh_req_valid = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.io_out_coh_req_bits_addr = xsp.XPin(xsp.XData(32, xsp.XData.In), self.event)
        self.io_out_coh_req_bits_size = xsp.XPin(xsp.XData(3, xsp.XData.In), self.event)
        self.io_out_coh_req_bits_cmd = xsp.XPin(xsp.XData(4, xsp.XData.In), self.event)
        self.io_out_coh_req_bits_wmask = xsp.XPin(xsp.XData(8, xsp.XData.In), self.event)
        self.io_out_coh_req_bits_wdata = xsp.XPin(xsp.XData(64, xsp.XData.In), self.event)
        self.io_out_coh_resp_ready = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.io_out_coh_resp_valid = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.io_out_coh_resp_bits_cmd = xsp.XPin(xsp.XData(4, xsp.XData.Out), self.event)
        self.io_out_coh_resp_bits_rdata = xsp.XPin(xsp.XData(64, xsp.XData.Out), self.event)
        self.io_mmio_req_ready = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.io_mmio_req_valid = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.io_mmio_req_bits_addr = xsp.XPin(xsp.XData(32, xsp.XData.Out), self.event)
        self.io_mmio_req_bits_size = xsp.XPin(xsp.XData(3, xsp.XData.Out), self.event)
        self.io_mmio_req_bits_cmd = xsp.XPin(xsp.XData(4, xsp.XData.Out), self.event)
        self.io_mmio_req_bits_wmask = xsp.XPin(xsp.XData(8, xsp.XData.Out), self.event)
        self.io_mmio_req_bits_wdata = xsp.XPin(xsp.XData(64, xsp.XData.Out), self.event)
        self.io_mmio_resp_ready = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.io_mmio_resp_valid = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.io_mmio_resp_bits_cmd = xsp.XPin(xsp.XData(4, xsp.XData.In), self.event)
        self.io_mmio_resp_bits_rdata = xsp.XPin(xsp.XData(64, xsp.XData.In), self.event)
        self.io_empty = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.victim_way_mask_valid = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.victim_way_mask = xsp.XPin(xsp.XData(4, xsp.XData.Out), self.event)


        # BindDPI
        self.clock.BindDPIPtr(self.dut.GetDPIHandle("clock", 0), self.dut.GetDPIHandle("clock", 1))
        self.reset.BindDPIPtr(self.dut.GetDPIHandle("reset", 0), self.dut.GetDPIHandle("reset", 1))
        self.io_in_req_ready.BindDPIPtr(self.dut.GetDPIHandle("io_in_req_ready", 0), self.dut.GetDPIHandle("io_in_req_ready", 1))
        self.io_in_req_valid.BindDPIPtr(self.dut.GetDPIHandle("io_in_req_valid", 0), self.dut.GetDPIHandle("io_in_req_valid", 1))
        self.io_in_req_bits_addr.BindDPIPtr(self.dut.GetDPIHandle("io_in_req_bits_addr", 0), self.dut.GetDPIHandle("io_in_req_bits_addr", 1))
        self.io_in_req_bits_size.BindDPIPtr(self.dut.GetDPIHandle("io_in_req_bits_size", 0), self.dut.GetDPIHandle("io_in_req_bits_size", 1))
        self.io_in_req_bits_cmd.BindDPIPtr(self.dut.GetDPIHandle("io_in_req_bits_cmd", 0), self.dut.GetDPIHandle("io_in_req_bits_cmd", 1))
        self.io_in_req_bits_wmask.BindDPIPtr(self.dut.GetDPIHandle("io_in_req_bits_wmask", 0), self.dut.GetDPIHandle("io_in_req_bits_wmask", 1))
        self.io_in_req_bits_wdata.BindDPIPtr(self.dut.GetDPIHandle("io_in_req_bits_wdata", 0), self.dut.GetDPIHandle("io_in_req_bits_wdata", 1))
        self.io_in_req_bits_user.BindDPIPtr(self.dut.GetDPIHandle("io_in_req_bits_user", 0), self.dut.GetDPIHandle("io_in_req_bits_user", 1))
        self.io_in_resp_ready.BindDPIPtr(self.dut.GetDPIHandle("io_in_resp_ready", 0), self.dut.GetDPIHandle("io_in_resp_ready", 1))
        self.io_in_resp_valid.BindDPIPtr(self.dut.GetDPIHandle("io_in_resp_valid", 0), self.dut.GetDPIHandle("io_in_resp_valid", 1))
        self.io_in_resp_bits_cmd.BindDPIPtr(self.dut.GetDPIHandle("io_in_resp_bits_cmd", 0), self.dut.GetDPIHandle("io_in_resp_bits_cmd", 1))
        self.io_in_resp_bits_rdata.BindDPIPtr(self.dut.GetDPIHandle("io_in_resp_bits_rdata", 0), self.dut.GetDPIHandle("io_in_resp_bits_rdata", 1))
        self.io_in_resp_bits_user.BindDPIPtr(self.dut.GetDPIHandle("io_in_resp_bits_user", 0), self.dut.GetDPIHandle("io_in_resp_bits_user", 1))
        self.io_flush.BindDPIPtr(self.dut.GetDPIHandle("io_flush", 0), self.dut.GetDPIHandle("io_flush", 1))
        self.io_out_mem_req_ready.BindDPIPtr(self.dut.GetDPIHandle("io_out_mem_req_ready", 0), self.dut.GetDPIHandle("io_out_mem_req_ready", 1))
        self.io_out_mem_req_valid.BindDPIPtr(self.dut.GetDPIHandle("io_out_mem_req_valid", 0), self.dut.GetDPIHandle("io_out_mem_req_valid", 1))
        self.io_out_mem_req_bits_addr.BindDPIPtr(self.dut.GetDPIHandle("io_out_mem_req_bits_addr", 0), self.dut.GetDPIHandle("io_out_mem_req_bits_addr", 1))
        self.io_out_mem_req_bits_size.BindDPIPtr(self.dut.GetDPIHandle("io_out_mem_req_bits_size", 0), self.dut.GetDPIHandle("io_out_mem_req_bits_size", 1))
        self.io_out_mem_req_bits_cmd.BindDPIPtr(self.dut.GetDPIHandle("io_out_mem_req_bits_cmd", 0), self.dut.GetDPIHandle("io_out_mem_req_bits_cmd", 1))
        self.io_out_mem_req_bits_wmask.BindDPIPtr(self.dut.GetDPIHandle("io_out_mem_req_bits_wmask", 0), self.dut.GetDPIHandle("io_out_mem_req_bits_wmask", 1))
        self.io_out_mem_req_bits_wdata.BindDPIPtr(self.dut.GetDPIHandle("io_out_mem_req_bits_wdata", 0), self.dut.GetDPIHandle("io_out_mem_req_bits_wdata", 1))
        self.io_out_mem_resp_ready.BindDPIPtr(self.dut.GetDPIHandle("io_out_mem_resp_ready", 0), self.dut.GetDPIHandle("io_out_mem_resp_ready", 1))
        self.io_out_mem_resp_valid.BindDPIPtr(self.dut.GetDPIHandle("io_out_mem_resp_valid", 0), self.dut.GetDPIHandle("io_out_mem_resp_valid", 1))
        self.io_out_mem_resp_bits_cmd.BindDPIPtr(self.dut.GetDPIHandle("io_out_mem_resp_bits_cmd", 0), self.dut.GetDPIHandle("io_out_mem_resp_bits_cmd", 1))
        self.io_out_mem_resp_bits_rdata.BindDPIPtr(self.dut.GetDPIHandle("io_out_mem_resp_bits_rdata", 0), self.dut.GetDPIHandle("io_out_mem_resp_bits_rdata", 1))
        self.io_out_coh_req_ready.BindDPIPtr(self.dut.GetDPIHandle("io_out_coh_req_ready", 0), self.dut.GetDPIHandle("io_out_coh_req_ready", 1))
        self.io_out_coh_req_valid.BindDPIPtr(self.dut.GetDPIHandle("io_out_coh_req_valid", 0), self.dut.GetDPIHandle("io_out_coh_req_valid", 1))
        self.io_out_coh_req_bits_addr.BindDPIPtr(self.dut.GetDPIHandle("io_out_coh_req_bits_addr", 0), self.dut.GetDPIHandle("io_out_coh_req_bits_addr", 1))
        self.io_out_coh_req_bits_size.BindDPIPtr(self.dut.GetDPIHandle("io_out_coh_req_bits_size", 0), self.dut.GetDPIHandle("io_out_coh_req_bits_size", 1))
        self.io_out_coh_req_bits_cmd.BindDPIPtr(self.dut.GetDPIHandle("io_out_coh_req_bits_cmd", 0), self.dut.GetDPIHandle("io_out_coh_req_bits_cmd", 1))
        self.io_out_coh_req_bits_wmask.BindDPIPtr(self.dut.GetDPIHandle("io_out_coh_req_bits_wmask", 0), self.dut.GetDPIHandle("io_out_coh_req_bits_wmask", 1))
        self.io_out_coh_req_bits_wdata.BindDPIPtr(self.dut.GetDPIHandle("io_out_coh_req_bits_wdata", 0), self.dut.GetDPIHandle("io_out_coh_req_bits_wdata", 1))
        self.io_out_coh_resp_ready.BindDPIPtr(self.dut.GetDPIHandle("io_out_coh_resp_ready", 0), self.dut.GetDPIHandle("io_out_coh_resp_ready", 1))
        self.io_out_coh_resp_valid.BindDPIPtr(self.dut.GetDPIHandle("io_out_coh_resp_valid", 0), self.dut.GetDPIHandle("io_out_coh_resp_valid", 1))
        self.io_out_coh_resp_bits_cmd.BindDPIPtr(self.dut.GetDPIHandle("io_out_coh_resp_bits_cmd", 0), self.dut.GetDPIHandle("io_out_coh_resp_bits_cmd", 1))
        self.io_out_coh_resp_bits_rdata.BindDPIPtr(self.dut.GetDPIHandle("io_out_coh_resp_bits_rdata", 0), self.dut.GetDPIHandle("io_out_coh_resp_bits_rdata", 1))
        self.io_mmio_req_ready.BindDPIPtr(self.dut.GetDPIHandle("io_mmio_req_ready", 0), self.dut.GetDPIHandle("io_mmio_req_ready", 1))
        self.io_mmio_req_valid.BindDPIPtr(self.dut.GetDPIHandle("io_mmio_req_valid", 0), self.dut.GetDPIHandle("io_mmio_req_valid", 1))
        self.io_mmio_req_bits_addr.BindDPIPtr(self.dut.GetDPIHandle("io_mmio_req_bits_addr", 0), self.dut.GetDPIHandle("io_mmio_req_bits_addr", 1))
        self.io_mmio_req_bits_size.BindDPIPtr(self.dut.GetDPIHandle("io_mmio_req_bits_size", 0), self.dut.GetDPIHandle("io_mmio_req_bits_size", 1))
        self.io_mmio_req_bits_cmd.BindDPIPtr(self.dut.GetDPIHandle("io_mmio_req_bits_cmd", 0), self.dut.GetDPIHandle("io_mmio_req_bits_cmd", 1))
        self.io_mmio_req_bits_wmask.BindDPIPtr(self.dut.GetDPIHandle("io_mmio_req_bits_wmask", 0), self.dut.GetDPIHandle("io_mmio_req_bits_wmask", 1))
        self.io_mmio_req_bits_wdata.BindDPIPtr(self.dut.GetDPIHandle("io_mmio_req_bits_wdata", 0), self.dut.GetDPIHandle("io_mmio_req_bits_wdata", 1))
        self.io_mmio_resp_ready.BindDPIPtr(self.dut.GetDPIHandle("io_mmio_resp_ready", 0), self.dut.GetDPIHandle("io_mmio_resp_ready", 1))
        self.io_mmio_resp_valid.BindDPIPtr(self.dut.GetDPIHandle("io_mmio_resp_valid", 0), self.dut.GetDPIHandle("io_mmio_resp_valid", 1))
        self.io_mmio_resp_bits_cmd.BindDPIPtr(self.dut.GetDPIHandle("io_mmio_resp_bits_cmd", 0), self.dut.GetDPIHandle("io_mmio_resp_bits_cmd", 1))
        self.io_mmio_resp_bits_rdata.BindDPIPtr(self.dut.GetDPIHandle("io_mmio_resp_bits_rdata", 0), self.dut.GetDPIHandle("io_mmio_resp_bits_rdata", 1))
        self.io_empty.BindDPIPtr(self.dut.GetDPIHandle("io_empty", 0), self.dut.GetDPIHandle("io_empty", 1))
        self.victim_way_mask_valid.BindDPIPtr(self.dut.GetDPIHandle("victim_way_mask_valid", 0), self.dut.GetDPIHandle("victim_way_mask_valid", 1))
        self.victim_way_mask.BindDPIPtr(self.dut.GetDPIHandle("victim_way_mask", 0), self.dut.GetDPIHandle("victim_way_mask", 1))


        # Add2Port
        self.xport.Add("clock", self.clock.xdata)
        self.xport.Add("reset", self.reset.xdata)
        self.xport.Add("io_in_req_ready", self.io_in_req_ready.xdata)
        self.xport.Add("io_in_req_valid", self.io_in_req_valid.xdata)
        self.xport.Add("io_in_req_bits_addr", self.io_in_req_bits_addr.xdata)
        self.xport.Add("io_in_req_bits_size", self.io_in_req_bits_size.xdata)
        self.xport.Add("io_in_req_bits_cmd", self.io_in_req_bits_cmd.xdata)
        self.xport.Add("io_in_req_bits_wmask", self.io_in_req_bits_wmask.xdata)
        self.xport.Add("io_in_req_bits_wdata", self.io_in_req_bits_wdata.xdata)
        self.xport.Add("io_in_req_bits_user", self.io_in_req_bits_user.xdata)
        self.xport.Add("io_in_resp_ready", self.io_in_resp_ready.xdata)
        self.xport.Add("io_in_resp_valid", self.io_in_resp_valid.xdata)
        self.xport.Add("io_in_resp_bits_cmd", self.io_in_resp_bits_cmd.xdata)
        self.xport.Add("io_in_resp_bits_rdata", self.io_in_resp_bits_rdata.xdata)
        self.xport.Add("io_in_resp_bits_user", self.io_in_resp_bits_user.xdata)
        self.xport.Add("io_flush", self.io_flush.xdata)
        self.xport.Add("io_out_mem_req_ready", self.io_out_mem_req_ready.xdata)
        self.xport.Add("io_out_mem_req_valid", self.io_out_mem_req_valid.xdata)
        self.xport.Add("io_out_mem_req_bits_addr", self.io_out_mem_req_bits_addr.xdata)
        self.xport.Add("io_out_mem_req_bits_size", self.io_out_mem_req_bits_size.xdata)
        self.xport.Add("io_out_mem_req_bits_cmd", self.io_out_mem_req_bits_cmd.xdata)
        self.xport.Add("io_out_mem_req_bits_wmask", self.io_out_mem_req_bits_wmask.xdata)
        self.xport.Add("io_out_mem_req_bits_wdata", self.io_out_mem_req_bits_wdata.xdata)
        self.xport.Add("io_out_mem_resp_ready", self.io_out_mem_resp_ready.xdata)
        self.xport.Add("io_out_mem_resp_valid", self.io_out_mem_resp_valid.xdata)
        self.xport.Add("io_out_mem_resp_bits_cmd", self.io_out_mem_resp_bits_cmd.xdata)
        self.xport.Add("io_out_mem_resp_bits_rdata", self.io_out_mem_resp_bits_rdata.xdata)
        self.xport.Add("io_out_coh_req_ready", self.io_out_coh_req_ready.xdata)
        self.xport.Add("io_out_coh_req_valid", self.io_out_coh_req_valid.xdata)
        self.xport.Add("io_out_coh_req_bits_addr", self.io_out_coh_req_bits_addr.xdata)
        self.xport.Add("io_out_coh_req_bits_size", self.io_out_coh_req_bits_size.xdata)
        self.xport.Add("io_out_coh_req_bits_cmd", self.io_out_coh_req_bits_cmd.xdata)
        self.xport.Add("io_out_coh_req_bits_wmask", self.io_out_coh_req_bits_wmask.xdata)
        self.xport.Add("io_out_coh_req_bits_wdata", self.io_out_coh_req_bits_wdata.xdata)
        self.xport.Add("io_out_coh_resp_ready", self.io_out_coh_resp_ready.xdata)
        self.xport.Add("io_out_coh_resp_valid", self.io_out_coh_resp_valid.xdata)
        self.xport.Add("io_out_coh_resp_bits_cmd", self.io_out_coh_resp_bits_cmd.xdata)
        self.xport.Add("io_out_coh_resp_bits_rdata", self.io_out_coh_resp_bits_rdata.xdata)
        self.xport.Add("io_mmio_req_ready", self.io_mmio_req_ready.xdata)
        self.xport.Add("io_mmio_req_valid", self.io_mmio_req_valid.xdata)
        self.xport.Add("io_mmio_req_bits_addr", self.io_mmio_req_bits_addr.xdata)
        self.xport.Add("io_mmio_req_bits_size", self.io_mmio_req_bits_size.xdata)
        self.xport.Add("io_mmio_req_bits_cmd", self.io_mmio_req_bits_cmd.xdata)
        self.xport.Add("io_mmio_req_bits_wmask", self.io_mmio_req_bits_wmask.xdata)
        self.xport.Add("io_mmio_req_bits_wdata", self.io_mmio_req_bits_wdata.xdata)
        self.xport.Add("io_mmio_resp_ready", self.io_mmio_resp_ready.xdata)
        self.xport.Add("io_mmio_resp_valid", self.io_mmio_resp_valid.xdata)
        self.xport.Add("io_mmio_resp_bits_cmd", self.io_mmio_resp_bits_cmd.xdata)
        self.xport.Add("io_mmio_resp_bits_rdata", self.io_mmio_resp_bits_rdata.xdata)
        self.xport.Add("io_empty", self.io_empty.xdata)
        self.xport.Add("victim_way_mask_valid", self.victim_way_mask_valid.xdata)
        self.xport.Add("victim_way_mask", self.victim_way_mask.xdata)


        # Cascaded ports
        self.io = self.xport.NewSubPort("io_")
        self.io_in = self.xport.NewSubPort("io_in_")
        self.io_in_req = self.xport.NewSubPort("io_in_req_")
        self.io_in_req_bits = self.xport.NewSubPort("io_in_req_bits_")
        self.io_in_resp = self.xport.NewSubPort("io_in_resp_")
        self.io_in_resp_bits = self.xport.NewSubPort("io_in_resp_bits_")
        self.io_mmio = self.xport.NewSubPort("io_mmio_")
        self.io_mmio_req = self.xport.NewSubPort("io_mmio_req_")
        self.io_mmio_req_bits = self.xport.NewSubPort("io_mmio_req_bits_")
        self.io_mmio_resp = self.xport.NewSubPort("io_mmio_resp_")
        self.io_mmio_resp_bits = self.xport.NewSubPort("io_mmio_resp_bits_")
        self.io_out = self.xport.NewSubPort("io_out_")
        self.io_out_coh = self.xport.NewSubPort("io_out_coh_")
        self.io_out_coh_req = self.xport.NewSubPort("io_out_coh_req_")
        self.io_out_coh_req_bits = self.xport.NewSubPort("io_out_coh_req_bits_")
        self.io_out_coh_resp = self.xport.NewSubPort("io_out_coh_resp_")
        self.io_out_coh_resp_bits = self.xport.NewSubPort("io_out_coh_resp_bits_")
        self.io_out_mem = self.xport.NewSubPort("io_out_mem_")
        self.io_out_mem_req = self.xport.NewSubPort("io_out_mem_req_")
        self.io_out_mem_req_bits = self.xport.NewSubPort("io_out_mem_req_bits_")
        self.io_out_mem_resp = self.xport.NewSubPort("io_out_mem_resp_")
        self.io_out_mem_resp_bits = self.xport.NewSubPort("io_out_mem_resp_bits_")


    def __del__(self):
        self.Finish()

    ################################
    #         User APIs            #
    ################################
    def InitClock(self, name: str):
        self.xclock.Add(self.xport[name])

    def Step(self, i:int = 1):
        self.xclock.Step(i)

    def StepRis(self, callback, args=(), kwargs={}):
        self.xclock.StepRis(callback, args, kwargs)

    def StepFal(self, callback, args=(), kwargs={}):
        self.xclock.StepFal(callback, args, kwargs)

    def OpenWaveform(self):
        return self.dut.OpenWaveform()

    def CloseWaveform(self):
        return self.dut.CloseWaveform()

    def GetXPort(self):
        return self.xport

    def GetXClock(self):
        return self.xclock

    def SetWaveform(self, filename: str):
        self.dut.SetWaveform(filename)
    
    def FlushWaveform(self):
        self.dut.FlushWaveform()

    def SetCoverage(self, filename: str):
        self.dut.SetCoverage(filename)
    
    def CheckPoint(self, name: str) -> int:
        self.dut.CheckPoint(name)

    def Restore(self, name: str) -> int:
        self.dut.Restore(name)

    def GetInternalSignal(self, name: str, index=-1, is_array=False, use_vpi=False):
        if name not in self.internal_signals:
            signal = None
            if self.dut.GetXSignalCFGBasePtr() != 0 and not use_vpi:
                xname = "CFG:" + name
                if is_array:
                    assert index < 0, "Index is not supported for array signal"
                    signal = self.xcfg.NewXDataArray(name, xname)
                elif index >= 0:
                    signal = self.xcfg.NewXData(name, index, xname)
                else:
                    signal = self.xcfg.NewXData(name, xname)
            else:
                assert index < 0, "Index is not supported for VPI signal"
                assert not is_array, "Array is not supported for VPI signal"
                signal = xsp.XData.FromVPI(self.dut.GetVPIHandleObj(name),
                                           self.dut.GetVPIFuncPtr("vpi_get"),
                                           self.dut.GetVPIFuncPtr("vpi_get_value"),
                                           self.dut.GetVPIFuncPtr("vpi_put_value"), "VPI:" + name)
                if use_vpi:
                    assert signal is not None, f"Internal signal {name} not found (Check VPI is enabled)"
            if signal is None:
                return None
            if not isinstance(signal, xsp.XData):
                self.internal_signals[name] = [xsp.XPin(s, self.event) for s in signal]
            else:
                self.internal_signals[name] = xsp.XPin(signal, self.event)
        return self.internal_signals[name]

    def GetInternalSignalList(self, prefix="", deep=99, use_vpi=False):
        if self.dut.GetXSignalCFGBasePtr() != 0 and not use_vpi:
            return self.xcfg.GetSignalNames(prefix)
        else:
            return self.dut.VPIInternalSignalList(prefix, deep)

    def VPIInternalSignalList(self, prefix="", deep=99):
        return self.dut.VPIInternalSignalList(prefix, deep)

    def Finish(self):
        self.dut.Finish()

    def RefreshComb(self):
        self.dut.RefreshComb()

    ################################
    #      End of User APIs        #
    ################################

    def __getitem__(self, key):
        return xsp.XPin(self.port[key], self.event)

    # Async APIs wrapped from XClock
    async def AStep(self,i: int):
        return await self.xclock.AStep(i)

    async def Acondition(self,fc_cheker):
        return await self.xclock.ACondition(fc_cheker)

    def RunStep(self,i: int):
        return self.xclock.RunStep(i)

    def __setattr__(self, name, value):
        assert not isinstance(getattr(self, name, None),
                              (xsp.XPin, xsp.XData)), \
        f"XPin and XData of DUT are read-only, do you mean to set the value of the signal? please use `{name}.value = ` instead."
        return super().__setattr__(name, value)


if __name__=="__main__":
    dut=DUTCache()
    dut.Step(100)
