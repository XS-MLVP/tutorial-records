#coding=utf8

try:
    from . import xspcomm as xsp
except Exception as e:
    import xspcomm as xsp

if __package__ or "." in __name__:
    from .libUT_SimTop import *
else:
    from libUT_SimTop import *


class DUTSimTop(object):

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
        self.difftest_exit = xsp.XPin(xsp.XData(64, xsp.XData.Out), self.event)
        self.difftest_step = xsp.XPin(xsp.XData(64, xsp.XData.Out), self.event)
        self.difftest_perfCtrl_clean = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.difftest_perfCtrl_dump = xsp.XPin(xsp.XData(0, xsp.XData.In), self.event)
        self.difftest_logCtrl_begin = xsp.XPin(xsp.XData(64, xsp.XData.In), self.event)
        self.difftest_logCtrl_end = xsp.XPin(xsp.XData(64, xsp.XData.In), self.event)
        self.difftest_logCtrl_level = xsp.XPin(xsp.XData(64, xsp.XData.In), self.event)
        self.difftest_uart_out_valid = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.difftest_uart_out_ch = xsp.XPin(xsp.XData(8, xsp.XData.Out), self.event)
        self.difftest_uart_in_valid = xsp.XPin(xsp.XData(0, xsp.XData.Out), self.event)
        self.difftest_uart_in_ch = xsp.XPin(xsp.XData(8, xsp.XData.In), self.event)


        # BindDPI
        self.clock.BindDPIPtr(self.dut.GetDPIHandle("clock", 0), self.dut.GetDPIHandle("clock", 1))
        self.reset.BindDPIPtr(self.dut.GetDPIHandle("reset", 0), self.dut.GetDPIHandle("reset", 1))
        self.difftest_exit.BindDPIPtr(self.dut.GetDPIHandle("difftest_exit", 0), self.dut.GetDPIHandle("difftest_exit", 1))
        self.difftest_step.BindDPIPtr(self.dut.GetDPIHandle("difftest_step", 0), self.dut.GetDPIHandle("difftest_step", 1))
        self.difftest_perfCtrl_clean.BindDPIPtr(self.dut.GetDPIHandle("difftest_perfCtrl_clean", 0), self.dut.GetDPIHandle("difftest_perfCtrl_clean", 1))
        self.difftest_perfCtrl_dump.BindDPIPtr(self.dut.GetDPIHandle("difftest_perfCtrl_dump", 0), self.dut.GetDPIHandle("difftest_perfCtrl_dump", 1))
        self.difftest_logCtrl_begin.BindDPIPtr(self.dut.GetDPIHandle("difftest_logCtrl_begin", 0), self.dut.GetDPIHandle("difftest_logCtrl_begin", 1))
        self.difftest_logCtrl_end.BindDPIPtr(self.dut.GetDPIHandle("difftest_logCtrl_end", 0), self.dut.GetDPIHandle("difftest_logCtrl_end", 1))
        self.difftest_logCtrl_level.BindDPIPtr(self.dut.GetDPIHandle("difftest_logCtrl_level", 0), self.dut.GetDPIHandle("difftest_logCtrl_level", 1))
        self.difftest_uart_out_valid.BindDPIPtr(self.dut.GetDPIHandle("difftest_uart_out_valid", 0), self.dut.GetDPIHandle("difftest_uart_out_valid", 1))
        self.difftest_uart_out_ch.BindDPIPtr(self.dut.GetDPIHandle("difftest_uart_out_ch", 0), self.dut.GetDPIHandle("difftest_uart_out_ch", 1))
        self.difftest_uart_in_valid.BindDPIPtr(self.dut.GetDPIHandle("difftest_uart_in_valid", 0), self.dut.GetDPIHandle("difftest_uart_in_valid", 1))
        self.difftest_uart_in_ch.BindDPIPtr(self.dut.GetDPIHandle("difftest_uart_in_ch", 0), self.dut.GetDPIHandle("difftest_uart_in_ch", 1))


        # Add2Port
        self.xport.Add("clock", self.clock.xdata)
        self.xport.Add("reset", self.reset.xdata)
        self.xport.Add("difftest_exit", self.difftest_exit.xdata)
        self.xport.Add("difftest_step", self.difftest_step.xdata)
        self.xport.Add("difftest_perfCtrl_clean", self.difftest_perfCtrl_clean.xdata)
        self.xport.Add("difftest_perfCtrl_dump", self.difftest_perfCtrl_dump.xdata)
        self.xport.Add("difftest_logCtrl_begin", self.difftest_logCtrl_begin.xdata)
        self.xport.Add("difftest_logCtrl_end", self.difftest_logCtrl_end.xdata)
        self.xport.Add("difftest_logCtrl_level", self.difftest_logCtrl_level.xdata)
        self.xport.Add("difftest_uart_out_valid", self.difftest_uart_out_valid.xdata)
        self.xport.Add("difftest_uart_out_ch", self.difftest_uart_out_ch.xdata)
        self.xport.Add("difftest_uart_in_valid", self.difftest_uart_in_valid.xdata)
        self.xport.Add("difftest_uart_in_ch", self.difftest_uart_in_ch.xdata)


        # Cascaded ports
        self.difftest = self.xport.NewSubPort("difftest_")
        self.difftest_logCtrl = self.xport.NewSubPort("difftest_logCtrl_")
        self.difftest_perfCtrl = self.xport.NewSubPort("difftest_perfCtrl_")
        self.difftest_uart = self.xport.NewSubPort("difftest_uart_")
        self.difftest_uart_in = self.xport.NewSubPort("difftest_uart_in_")
        self.difftest_uart_out = self.xport.NewSubPort("difftest_uart_out_")


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
    dut=DUTSimTop()
    dut.Step(100)
