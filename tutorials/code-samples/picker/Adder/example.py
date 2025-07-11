from UT_Adder import *
import random


def random_int():
    return random.randint(-(2**127), 2**127 - 1) & ((1 << 128) - 1)

def as_uint(x,nbits):
    return x & ((1 << nbits) - 1)

def main():
    dut = DUTAdder()  # Assuming USE_VERILATOR 
    print("Initialized UTAdder")

    for c in range(11451):
        a, b, cin = random_int(), random_int(), random_int() & 1
        dut.a.value, dut.b.value, dut.cin.value  = a, b, cin

        dut.Step(1)
        print(f"[cycle {dut.xclock.clk}] a=0x{dut.a.value:x}, b=0x{dut.b.value:x}, cin=0x{dut.cin.value:x}, ref_sum={as_uint(a+b+cin,128)}, dut_sum={as_uint(dut.sum.value,128)}")
        assert as_uint(dut.sum.value,128) == as_uint(a + b + cin, 128), "sum mismatch"

    print("Test Passed, destroy UTAdder")
    dut.Finish() # When using VCS, DUT.Finish() will exit the program, so it should be the last line of the program

if __name__ == "__main__":
    main()
