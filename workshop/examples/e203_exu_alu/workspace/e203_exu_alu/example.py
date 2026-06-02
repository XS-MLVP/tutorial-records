try:
    from UT_e203_exu_alu import *
except:
    try:
        from e203_exu_alu import *
    except:
        from __init__ import *


if __name__ == "__main__":
    dut = DUTe203_exu_alu()
    # dut.InitClock("clk")

    dut.Step(1)

    dut.Finish()
