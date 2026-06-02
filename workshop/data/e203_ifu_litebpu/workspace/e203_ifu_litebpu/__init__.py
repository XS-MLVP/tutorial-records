#coding=utf8


try:
    from . import xspcomm as xsp
except Exception as e:
    import xspcomm as xsp

if __package__ or "." in __name__:
    from .libUT_e203_ifu_litebpu import *
else:
    from libUT_e203_ifu_litebpu import *


class DUTe203_ifu_litebpu(object):

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
        self.pc = xsp.XPin(xsp.XData(32, xsp.XData.In), self.event)
        self.dec_jal = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.dec_jalr = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.dec_bxx = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.dec_bjp_imm = xsp.XPin(xsp.XData(32, xsp.XData.In), self.event)
        self.dec_jalr_rs1idx = xsp.XPin(xsp.XData(5, xsp.XData.In), self.event)
        self.oitf_empty = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.ir_empty = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.ir_rs1en = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.jalr_rs1idx_cam_irrdidx = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.bpu_wait = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.prdt_taken = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.prdt_pc_add_op1 = xsp.XPin(xsp.XData(32, xsp.XData.Out), self.event)
        self.prdt_pc_add_op2 = xsp.XPin(xsp.XData(32, xsp.XData.Out), self.event)
        self.dec_i_valid = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.bpu2rf_rs1_ena = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.ir_valid_clr = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.rf2bpu_x1 = xsp.XPin(xsp.XData(32, xsp.XData.In), self.event)
        self.rf2bpu_rs1 = xsp.XPin(xsp.XData(32, xsp.XData.In), self.event)
        self.clk = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.rst_n = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)


        # BindDPI or Native pin address
        self.pc.BindNativeData(self.dut.NativeSignalAddr("pc"))
        self.dec_jal.BindNativeData(self.dut.NativeSignalAddr("dec_jal"))
        self.dec_jalr.BindNativeData(self.dut.NativeSignalAddr("dec_jalr"))
        self.dec_bxx.BindNativeData(self.dut.NativeSignalAddr("dec_bxx"))
        self.dec_bjp_imm.BindNativeData(self.dut.NativeSignalAddr("dec_bjp_imm"))
        self.dec_jalr_rs1idx.BindNativeData(self.dut.NativeSignalAddr("dec_jalr_rs1idx"))
        self.oitf_empty.BindNativeData(self.dut.NativeSignalAddr("oitf_empty"))
        self.ir_empty.BindNativeData(self.dut.NativeSignalAddr("ir_empty"))
        self.ir_rs1en.BindNativeData(self.dut.NativeSignalAddr("ir_rs1en"))
        self.jalr_rs1idx_cam_irrdidx.BindNativeData(self.dut.NativeSignalAddr("jalr_rs1idx_cam_irrdidx"))
        self.bpu_wait.BindNativeData(self.dut.NativeSignalAddr("bpu_wait"))
        self.prdt_taken.BindNativeData(self.dut.NativeSignalAddr("prdt_taken"))
        self.prdt_pc_add_op1.BindNativeData(self.dut.NativeSignalAddr("prdt_pc_add_op1"))
        self.prdt_pc_add_op2.BindNativeData(self.dut.NativeSignalAddr("prdt_pc_add_op2"))
        self.dec_i_valid.BindNativeData(self.dut.NativeSignalAddr("dec_i_valid"))
        self.bpu2rf_rs1_ena.BindNativeData(self.dut.NativeSignalAddr("bpu2rf_rs1_ena"))
        self.ir_valid_clr.BindNativeData(self.dut.NativeSignalAddr("ir_valid_clr"))
        self.rf2bpu_x1.BindNativeData(self.dut.NativeSignalAddr("rf2bpu_x1"))
        self.rf2bpu_rs1.BindNativeData(self.dut.NativeSignalAddr("rf2bpu_rs1"))
        self.clk.BindNativeData(self.dut.NativeSignalAddr("clk"))
        self.rst_n.BindNativeData(self.dut.NativeSignalAddr("rst_n"))


        # Add2Port
        self.xport.Add("pc", self.pc.xdata)
        self.xport.Add("dec_jal", self.dec_jal.xdata)
        self.xport.Add("dec_jalr", self.dec_jalr.xdata)
        self.xport.Add("dec_bxx", self.dec_bxx.xdata)
        self.xport.Add("dec_bjp_imm", self.dec_bjp_imm.xdata)
        self.xport.Add("dec_jalr_rs1idx", self.dec_jalr_rs1idx.xdata)
        self.xport.Add("oitf_empty", self.oitf_empty.xdata)
        self.xport.Add("ir_empty", self.ir_empty.xdata)
        self.xport.Add("ir_rs1en", self.ir_rs1en.xdata)
        self.xport.Add("jalr_rs1idx_cam_irrdidx", self.jalr_rs1idx_cam_irrdidx.xdata)
        self.xport.Add("bpu_wait", self.bpu_wait.xdata)
        self.xport.Add("prdt_taken", self.prdt_taken.xdata)
        self.xport.Add("prdt_pc_add_op1", self.prdt_pc_add_op1.xdata)
        self.xport.Add("prdt_pc_add_op2", self.prdt_pc_add_op2.xdata)
        self.xport.Add("dec_i_valid", self.dec_i_valid.xdata)
        self.xport.Add("bpu2rf_rs1_ena", self.bpu2rf_rs1_ena.xdata)
        self.xport.Add("ir_valid_clr", self.ir_valid_clr.xdata)
        self.xport.Add("rf2bpu_x1", self.rf2bpu_x1.xdata)
        self.xport.Add("rf2bpu_rs1", self.rf2bpu_rs1.xdata)
        self.xport.Add("clk", self.clk.xdata)
        self.xport.Add("rst_n", self.rst_n.xdata)


        # Cascaded ports
        self.dec = self.xport.NewSubPort("dec_")
        self.ir = self.xport.NewSubPort("ir_")
        self.prdt = self.xport.NewSubPort("prdt_")
        self.prdt_pc_add = self.xport.NewSubPort("prdt_pc_add_")
        self.rf2bpu = self.xport.NewSubPort("rf2bpu_")


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
    dut=DUTe203_ifu_litebpu()
    dut.Step(100)
