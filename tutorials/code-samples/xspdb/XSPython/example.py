try:
    from UT_SimTop import *
except:
    try:
        from SimTop import *
    except:
        from __init__ import *


if __name__ == "__main__":
    dut = DUTSimTop()
    # dut.InitClock("clk")

    dut.Step(1)

    dut.Finish()
