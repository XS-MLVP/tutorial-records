#coding=utf8


try:
    from . import xspcomm as xsp
except Exception as e:
    import xspcomm as xsp

if __package__ or "." in __name__:
    from .libUT_WayLookup import *
else:
    from libUT_WayLookup import *


class DUTWayLookup(object):

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

        # All pins
        self.clock = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.reset = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.io_flush = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.io_read_ready = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.io_read_valid = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.io_read_bits_entry_vSetIdx_0 = xsp.XPin(xsp.XData(8, xsp.XData.Out), self.event)
        self.io_read_bits_entry_vSetIdx_1 = xsp.XPin(xsp.XData(8, xsp.XData.Out), self.event)
        self.io_read_bits_entry_waymask_0 = xsp.XPin(xsp.XData(4, xsp.XData.Out), self.event)
        self.io_read_bits_entry_waymask_1 = xsp.XPin(xsp.XData(4, xsp.XData.Out), self.event)
        self.io_read_bits_entry_ptag_0 = xsp.XPin(xsp.XData(36, xsp.XData.Out), self.event)
        self.io_read_bits_entry_ptag_1 = xsp.XPin(xsp.XData(36, xsp.XData.Out), self.event)
        self.io_read_bits_entry_itlb_exception_0 = xsp.XPin(xsp.XData(2, xsp.XData.Out), self.event)
        self.io_read_bits_entry_itlb_exception_1 = xsp.XPin(xsp.XData(2, xsp.XData.Out), self.event)
        self.io_read_bits_entry_itlb_pbmt_0 = xsp.XPin(xsp.XData(2, xsp.XData.Out), self.event)
        self.io_read_bits_entry_itlb_pbmt_1 = xsp.XPin(xsp.XData(2, xsp.XData.Out), self.event)
        self.io_read_bits_entry_meta_codes_0 = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.io_read_bits_entry_meta_codes_1 = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.io_read_bits_gpf_gpaddr = xsp.XPin(xsp.XData(56, xsp.XData.Out), self.event)
        self.io_read_bits_gpf_isForVSnonLeafPTE = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.io_write_ready = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.io_write_valid = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.io_write_bits_entry_vSetIdx_0 = xsp.XPin(xsp.XData(8, xsp.XData.In), self.event)
        self.io_write_bits_entry_vSetIdx_1 = xsp.XPin(xsp.XData(8, xsp.XData.In), self.event)
        self.io_write_bits_entry_waymask_0 = xsp.XPin(xsp.XData(4, xsp.XData.In), self.event)
        self.io_write_bits_entry_waymask_1 = xsp.XPin(xsp.XData(4, xsp.XData.In), self.event)
        self.io_write_bits_entry_ptag_0 = xsp.XPin(xsp.XData(36, xsp.XData.In), self.event)
        self.io_write_bits_entry_ptag_1 = xsp.XPin(xsp.XData(36, xsp.XData.In), self.event)
        self.io_write_bits_entry_itlb_exception_0 = xsp.XPin(xsp.XData(2, xsp.XData.In), self.event)
        self.io_write_bits_entry_itlb_exception_1 = xsp.XPin(xsp.XData(2, xsp.XData.In), self.event)
        self.io_write_bits_entry_itlb_pbmt_0 = xsp.XPin(xsp.XData(2, xsp.XData.In), self.event)
        self.io_write_bits_entry_itlb_pbmt_1 = xsp.XPin(xsp.XData(2, xsp.XData.In), self.event)
        self.io_write_bits_entry_meta_codes_0 = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.io_write_bits_entry_meta_codes_1 = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.io_write_bits_gpf_gpaddr = xsp.XPin(xsp.XData(56, xsp.XData.In), self.event)
        self.io_write_bits_gpf_isForVSnonLeafPTE = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.io_update_valid = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.io_update_bits_blkPaddr = xsp.XPin(xsp.XData(42, xsp.XData.In), self.event)
        self.io_update_bits_vSetIdx = xsp.XPin(xsp.XData(8, xsp.XData.In), self.event)
        self.io_update_bits_waymask = xsp.XPin(xsp.XData(4, xsp.XData.In), self.event)
        self.io_update_bits_corrupt = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)


        # BindDPI or Native pin address
        self.clock.BindNativeData(self.dut.NativeSignalAddr("clock"))
        self.reset.BindNativeData(self.dut.NativeSignalAddr("reset"))
        self.io_flush.BindNativeData(self.dut.NativeSignalAddr("io_flush"))
        self.io_read_ready.BindNativeData(self.dut.NativeSignalAddr("io_read_ready"))
        self.io_read_valid.BindNativeData(self.dut.NativeSignalAddr("io_read_valid"))
        self.io_read_bits_entry_vSetIdx_0.BindNativeData(self.dut.NativeSignalAddr("io_read_bits_entry_vSetIdx_0"))
        self.io_read_bits_entry_vSetIdx_1.BindNativeData(self.dut.NativeSignalAddr("io_read_bits_entry_vSetIdx_1"))
        self.io_read_bits_entry_waymask_0.BindNativeData(self.dut.NativeSignalAddr("io_read_bits_entry_waymask_0"))
        self.io_read_bits_entry_waymask_1.BindNativeData(self.dut.NativeSignalAddr("io_read_bits_entry_waymask_1"))
        self.io_read_bits_entry_ptag_0.BindNativeData(self.dut.NativeSignalAddr("io_read_bits_entry_ptag_0"))
        self.io_read_bits_entry_ptag_1.BindNativeData(self.dut.NativeSignalAddr("io_read_bits_entry_ptag_1"))
        self.io_read_bits_entry_itlb_exception_0.BindNativeData(self.dut.NativeSignalAddr("io_read_bits_entry_itlb_exception_0"))
        self.io_read_bits_entry_itlb_exception_1.BindNativeData(self.dut.NativeSignalAddr("io_read_bits_entry_itlb_exception_1"))
        self.io_read_bits_entry_itlb_pbmt_0.BindNativeData(self.dut.NativeSignalAddr("io_read_bits_entry_itlb_pbmt_0"))
        self.io_read_bits_entry_itlb_pbmt_1.BindNativeData(self.dut.NativeSignalAddr("io_read_bits_entry_itlb_pbmt_1"))
        self.io_read_bits_entry_meta_codes_0.BindNativeData(self.dut.NativeSignalAddr("io_read_bits_entry_meta_codes_0"))
        self.io_read_bits_entry_meta_codes_1.BindNativeData(self.dut.NativeSignalAddr("io_read_bits_entry_meta_codes_1"))
        self.io_read_bits_gpf_gpaddr.BindNativeData(self.dut.NativeSignalAddr("io_read_bits_gpf_gpaddr"))
        self.io_read_bits_gpf_isForVSnonLeafPTE.BindNativeData(self.dut.NativeSignalAddr("io_read_bits_gpf_isForVSnonLeafPTE"))
        self.io_write_ready.BindNativeData(self.dut.NativeSignalAddr("io_write_ready"))
        self.io_write_valid.BindNativeData(self.dut.NativeSignalAddr("io_write_valid"))
        self.io_write_bits_entry_vSetIdx_0.BindNativeData(self.dut.NativeSignalAddr("io_write_bits_entry_vSetIdx_0"))
        self.io_write_bits_entry_vSetIdx_1.BindNativeData(self.dut.NativeSignalAddr("io_write_bits_entry_vSetIdx_1"))
        self.io_write_bits_entry_waymask_0.BindNativeData(self.dut.NativeSignalAddr("io_write_bits_entry_waymask_0"))
        self.io_write_bits_entry_waymask_1.BindNativeData(self.dut.NativeSignalAddr("io_write_bits_entry_waymask_1"))
        self.io_write_bits_entry_ptag_0.BindNativeData(self.dut.NativeSignalAddr("io_write_bits_entry_ptag_0"))
        self.io_write_bits_entry_ptag_1.BindNativeData(self.dut.NativeSignalAddr("io_write_bits_entry_ptag_1"))
        self.io_write_bits_entry_itlb_exception_0.BindNativeData(self.dut.NativeSignalAddr("io_write_bits_entry_itlb_exception_0"))
        self.io_write_bits_entry_itlb_exception_1.BindNativeData(self.dut.NativeSignalAddr("io_write_bits_entry_itlb_exception_1"))
        self.io_write_bits_entry_itlb_pbmt_0.BindNativeData(self.dut.NativeSignalAddr("io_write_bits_entry_itlb_pbmt_0"))
        self.io_write_bits_entry_itlb_pbmt_1.BindNativeData(self.dut.NativeSignalAddr("io_write_bits_entry_itlb_pbmt_1"))
        self.io_write_bits_entry_meta_codes_0.BindNativeData(self.dut.NativeSignalAddr("io_write_bits_entry_meta_codes_0"))
        self.io_write_bits_entry_meta_codes_1.BindNativeData(self.dut.NativeSignalAddr("io_write_bits_entry_meta_codes_1"))
        self.io_write_bits_gpf_gpaddr.BindNativeData(self.dut.NativeSignalAddr("io_write_bits_gpf_gpaddr"))
        self.io_write_bits_gpf_isForVSnonLeafPTE.BindNativeData(self.dut.NativeSignalAddr("io_write_bits_gpf_isForVSnonLeafPTE"))
        self.io_update_valid.BindNativeData(self.dut.NativeSignalAddr("io_update_valid"))
        self.io_update_bits_blkPaddr.BindNativeData(self.dut.NativeSignalAddr("io_update_bits_blkPaddr"))
        self.io_update_bits_vSetIdx.BindNativeData(self.dut.NativeSignalAddr("io_update_bits_vSetIdx"))
        self.io_update_bits_waymask.BindNativeData(self.dut.NativeSignalAddr("io_update_bits_waymask"))
        self.io_update_bits_corrupt.BindNativeData(self.dut.NativeSignalAddr("io_update_bits_corrupt"))


        # Add2Port
        self.xport.Add("clock", self.clock.xdata)
        self.xport.Add("reset", self.reset.xdata)
        self.xport.Add("io_flush", self.io_flush.xdata)
        self.xport.Add("io_read_ready", self.io_read_ready.xdata)
        self.xport.Add("io_read_valid", self.io_read_valid.xdata)
        self.xport.Add("io_read_bits_entry_vSetIdx_0", self.io_read_bits_entry_vSetIdx_0.xdata)
        self.xport.Add("io_read_bits_entry_vSetIdx_1", self.io_read_bits_entry_vSetIdx_1.xdata)
        self.xport.Add("io_read_bits_entry_waymask_0", self.io_read_bits_entry_waymask_0.xdata)
        self.xport.Add("io_read_bits_entry_waymask_1", self.io_read_bits_entry_waymask_1.xdata)
        self.xport.Add("io_read_bits_entry_ptag_0", self.io_read_bits_entry_ptag_0.xdata)
        self.xport.Add("io_read_bits_entry_ptag_1", self.io_read_bits_entry_ptag_1.xdata)
        self.xport.Add("io_read_bits_entry_itlb_exception_0", self.io_read_bits_entry_itlb_exception_0.xdata)
        self.xport.Add("io_read_bits_entry_itlb_exception_1", self.io_read_bits_entry_itlb_exception_1.xdata)
        self.xport.Add("io_read_bits_entry_itlb_pbmt_0", self.io_read_bits_entry_itlb_pbmt_0.xdata)
        self.xport.Add("io_read_bits_entry_itlb_pbmt_1", self.io_read_bits_entry_itlb_pbmt_1.xdata)
        self.xport.Add("io_read_bits_entry_meta_codes_0", self.io_read_bits_entry_meta_codes_0.xdata)
        self.xport.Add("io_read_bits_entry_meta_codes_1", self.io_read_bits_entry_meta_codes_1.xdata)
        self.xport.Add("io_read_bits_gpf_gpaddr", self.io_read_bits_gpf_gpaddr.xdata)
        self.xport.Add("io_read_bits_gpf_isForVSnonLeafPTE", self.io_read_bits_gpf_isForVSnonLeafPTE.xdata)
        self.xport.Add("io_write_ready", self.io_write_ready.xdata)
        self.xport.Add("io_write_valid", self.io_write_valid.xdata)
        self.xport.Add("io_write_bits_entry_vSetIdx_0", self.io_write_bits_entry_vSetIdx_0.xdata)
        self.xport.Add("io_write_bits_entry_vSetIdx_1", self.io_write_bits_entry_vSetIdx_1.xdata)
        self.xport.Add("io_write_bits_entry_waymask_0", self.io_write_bits_entry_waymask_0.xdata)
        self.xport.Add("io_write_bits_entry_waymask_1", self.io_write_bits_entry_waymask_1.xdata)
        self.xport.Add("io_write_bits_entry_ptag_0", self.io_write_bits_entry_ptag_0.xdata)
        self.xport.Add("io_write_bits_entry_ptag_1", self.io_write_bits_entry_ptag_1.xdata)
        self.xport.Add("io_write_bits_entry_itlb_exception_0", self.io_write_bits_entry_itlb_exception_0.xdata)
        self.xport.Add("io_write_bits_entry_itlb_exception_1", self.io_write_bits_entry_itlb_exception_1.xdata)
        self.xport.Add("io_write_bits_entry_itlb_pbmt_0", self.io_write_bits_entry_itlb_pbmt_0.xdata)
        self.xport.Add("io_write_bits_entry_itlb_pbmt_1", self.io_write_bits_entry_itlb_pbmt_1.xdata)
        self.xport.Add("io_write_bits_entry_meta_codes_0", self.io_write_bits_entry_meta_codes_0.xdata)
        self.xport.Add("io_write_bits_entry_meta_codes_1", self.io_write_bits_entry_meta_codes_1.xdata)
        self.xport.Add("io_write_bits_gpf_gpaddr", self.io_write_bits_gpf_gpaddr.xdata)
        self.xport.Add("io_write_bits_gpf_isForVSnonLeafPTE", self.io_write_bits_gpf_isForVSnonLeafPTE.xdata)
        self.xport.Add("io_update_valid", self.io_update_valid.xdata)
        self.xport.Add("io_update_bits_blkPaddr", self.io_update_bits_blkPaddr.xdata)
        self.xport.Add("io_update_bits_vSetIdx", self.io_update_bits_vSetIdx.xdata)
        self.xport.Add("io_update_bits_waymask", self.io_update_bits_waymask.xdata)
        self.xport.Add("io_update_bits_corrupt", self.io_update_bits_corrupt.xdata)


        # Cascaded ports
        self.io = self.xport.NewSubPort("io_")
        self.io_read = self.xport.NewSubPort("io_read_")
        self.io_read_bits = self.xport.NewSubPort("io_read_bits_")
        self.io_read_bits_entry = self.xport.NewSubPort("io_read_bits_entry_")
        self.io_read_bits_entry_itlb = self.xport.NewSubPort("io_read_bits_entry_itlb_")
        self.io_read_bits_entry_itlb_exception = self.xport.NewSubPort("io_read_bits_entry_itlb_exception_")
        self.io_read_bits_entry_itlb_pbmt = self.xport.NewSubPort("io_read_bits_entry_itlb_pbmt_")
        self.io_read_bits_entry_meta_codes = self.xport.NewSubPort("io_read_bits_entry_meta_codes_")
        self.io_read_bits_entry_ptag = self.xport.NewSubPort("io_read_bits_entry_ptag_")
        self.io_read_bits_entry_vSetIdx = self.xport.NewSubPort("io_read_bits_entry_vSetIdx_")
        self.io_read_bits_entry_waymask = self.xport.NewSubPort("io_read_bits_entry_waymask_")
        self.io_read_bits_gpf = self.xport.NewSubPort("io_read_bits_gpf_")
        self.io_update = self.xport.NewSubPort("io_update_")
        self.io_update_bits = self.xport.NewSubPort("io_update_bits_")
        self.io_write = self.xport.NewSubPort("io_write_")
        self.io_write_bits = self.xport.NewSubPort("io_write_bits_")
        self.io_write_bits_entry = self.xport.NewSubPort("io_write_bits_entry_")
        self.io_write_bits_entry_itlb = self.xport.NewSubPort("io_write_bits_entry_itlb_")
        self.io_write_bits_entry_itlb_exception = self.xport.NewSubPort("io_write_bits_entry_itlb_exception_")
        self.io_write_bits_entry_itlb_pbmt = self.xport.NewSubPort("io_write_bits_entry_itlb_pbmt_")
        self.io_write_bits_entry_meta_codes = self.xport.NewSubPort("io_write_bits_entry_meta_codes_")
        self.io_write_bits_entry_ptag = self.xport.NewSubPort("io_write_bits_entry_ptag_")
        self.io_write_bits_entry_vSetIdx = self.xport.NewSubPort("io_write_bits_entry_vSetIdx_")
        self.io_write_bits_entry_waymask = self.xport.NewSubPort("io_write_bits_entry_waymask_")
        self.io_write_bits_gpf = self.xport.NewSubPort("io_write_bits_gpf_")


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

    def ResumeWaveformDump(self):
        return self.dut.ResumeWaveformDump()

    def PauseWaveformDump(self):
        return self.dut.PauseWaveformDump()

    def WaveformPaused(self) -> int:
        """ Returns 1 if waveform export is paused """
        return self.dut.WaveformPaused()

    def GetXPort(self):
        return self.xport

    def GetXClock(self):
        return self.xclock

    def SetWaveform(self, filename: str):
        self.dut.SetWaveform(filename)

    def GetWaveFormat(self) -> str:
        """
        Get the waveform extension, or an empty string if disabled.

        Returns:
            str: The extension of waveform file.
        """
        return self.dut.GetWaveFormat()

    def FlushWaveform(self):
        self.dut.FlushWaveform()

    def SetCoverage(self, filename: str):
        self.dut.SetCoverage(filename)

    def GetCovMetrics(self) -> int:
        """
        Get the bitmask for collected coverage metrics. 0 means coverage is disabled

        Returns:
            int: Collected coverage metrics bitmask:
                - Bit 0: line   (Line coverage)
                - Bit 1: cond   (Condition coverage)
                - Bit 2: fsm    (Finite-State Machine coverage)
                - Bit 3: toggle (Toggle coverage)
                - Bit 4: branch (Branch coverage)
                - Bit 5: assert (Assertion coverage)
        """
        return self.dut.GetCovMetrics()
    
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

    def AtClone(self):
        """Re-init simulator state in child after fork."""
        return self.dut.atClone()

    ################################
    #      End of User APIs        #
    ################################

    def __getitem__(self, key):
        return xsp.XPin(self.port[key], self.event)

    # Async APIs wrapped from XClock
    async def AStep(self,i: int):
        return await self.xclock.AStep(i)

    async def ACondition(self,fc_cheker):
        return await self.xclock.ACondition(fc_cheker)

    def RunStep(self,i: int):
        return self.xclock.RunStep(i)

    def __setattr__(self, name, value):
        assert not isinstance(getattr(self, name, None),
                              (xsp.XPin, xsp.XData)), \
        f"XPin and XData of DUT are read-only, do you mean to set the value of the signal? please use `{name}.value = ` instead."
        return super().__setattr__(name, value)


if __name__=="__main__":
    dut=DUTWayLookup()
    dut.Step(100)
