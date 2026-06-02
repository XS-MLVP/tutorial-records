try:
    from UT_WayLookup import *
except:
    try:
        from WayLookup import *
    except:
        from __init__ import *


if __name__ == "__main__":
    dut = DUTWayLookup()
    # dut.InitClock("clk")

    dut.Step(1)

    dut.Finish()
