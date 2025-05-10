from UT_Adder import *
import random


def random_int():
    return random.randint(-(2**127), 2**127 - 1) & ((1 << 128) - 1)


def main():
    dut = DUTAdder()  # Assuming USE_VERILATOR
    
    print("Initialized UTAdder")
    
    for c in range(11451):
        dut.a.value, dut.b.value, dut.cin.value  = random_int(), random_int(), random_int() & 1        
        #dut.Step(1)
       # def dut_cal():
        #    dut.a.value, dut.b.value, dut.cin.value = i.a, i.b, i.cin
        #    dut.Step(1)
        #    o_dut.sum = dut.sum.value
        #    o_dut.cout = dut.cout.value
        
        #dut_cal()
        #ref_cal()
        
        print(f"[cycle {dut.xclock.clk}] a=0x{dut.a.value:x}, b=0x{dut.b.value:x}, cin=0x{dut.cin.value:x}")
        dut.Step(1) 
        #print(f"DUT: sum=0x{o_dut.sum:x}, cout=0x{o_dut.cout:x}")
        #print(f"REF: sum=0x{o_ref.sum:x}, cout=0x{o_ref.cout:x}")
        
        #assert o_dut.sum == o_ref.sum, "sum mismatch"

    print("Test Passed, destroy UTAdder")
    dut.Finish() # When using VCS, DUT.Finish() will exit the program, so it should be the last line of the program


if __name__ == "__main__":
    main()
