'''
Created on 18 May 2015

@author: Josy
'''

from __future__ import print_function

from myhdl import *

def ts( clk, reset, tsenable, tson, tspin , readback ):

    tspindriver = tspin.driver()

    @always_seq( clk.posedge, reset = reset )
    def rtlseq():
        if tsenable:
            if tson:
                tspindriver.next = 1
            else:
                tspindriver.next = 0
        else:
            tspindriver.next = None

    @always_comb
    def rtlcomb():
        if tspin :
            readback.next = 1
        else:
            readback.next = 0

    return rtlseq, rtlcomb


def tb_ts():
    clk      = Signal( bool( 1 ) )
    reset    = ResetSignal( 0, active=1, async=True )
    tsenable = Signal( bool( 0 ) )
    tson     = Signal( bool( 0 ) )
    readback = Signal( bool( 0 ) )
    tspin    = TristateSignal( False )

    # a test function
    def _test():
        # instantiate the design under test
        tbdut = ts( clk, reset, tsenable, tson, tspin , readback )

        @always( delay( 3 ) )
        def tbclk():
            clk.next = not clk

        @instance
        def tbstim():
            tsenable.next = 0
            tson.next = 0
            reset.next = reset.active
            yield delay( 21 )
            reset.next = not reset.active

            yield clk.negedge
            yield clk.negedge
            tson.next = 1
            yield clk.negedge
            tsenable.next = 1
            yield clk.negedge
            tson.next = 0
            yield clk.negedge
            tsenable.next = 0
            yield clk.negedge

            raise StopSimulation

        return tbdut, tbclk, tbstim


    Simulation(traceSignals(_test)).run(100)
    print("** Simulation Successful **")
    toVHDL(ts, clk, reset, tsenable, tson, tspin , readback )
    toVerilog( ts, clk, reset,tsenable, tson, tspin , readback )


if __name__ == '__main__':
    tb_ts()
