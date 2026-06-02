try:
    from UT_e203_ifu_litebpu import *
except:
    try:
        from e203_ifu_litebpu import *
    except:
        from __init__ import *


if __name__ == "__main__":
    dut = DUTe203_ifu_litebpu()
    # dut.InitClock("clk")

    dut.Step(1)

    dut.Finish()
