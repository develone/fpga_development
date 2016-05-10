from myhdl import *
'''
m = 8

count = Signal(modbv(0)[m:])
enable = Signal(bool(0))
clock  = Signal(bool(0))
reset = ResetSignal(0, active=0, async=True)

inc_inst = Inc(count, enable, clock, reset)
inc_inst is an elaborated design instance that can be simulated. 
To convert it to Verilog, we change the last line as follows
'''
def Inc(count, enable, clock, reset):

    """ Incrementer with enable.

    count -- output
    enable -- control input, increment when 1
    clock -- clock input
    reset -- asynchronous reset input

    """

    @always_seq(clock.posedge, reset=reset)
    def incLogic():
        if enable:
            count.next = count + 1

    return incLogic
m = 8

count = Signal(modbv(0)[m:])
enable = Signal(bool(0))
clock  = Signal(bool(0))
reset = ResetSignal(0, active=0, async=True)

#inc_inst = Inc(count, enable, clock, reset)
inc_inst = toVerilog(Inc, count, enable, clock, reset)   
inc_inst1 = toVHDL(Inc, count, enable, clock, reset)
