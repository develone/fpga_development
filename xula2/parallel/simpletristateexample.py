'''
Created on 18 May 2015

@author: Josy
'''

from __future__ import print_function

from myhdl import *

def ts( clock, reset, tsenable, tson, tspin , readback ):

    tspindriver = tspin.driver()

    @always_seq( clock.posedge, reset = reset )
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
    clock      = Signal( bool( 1 ) )
    reset    = ResetSignal( 0, active=1, async=True )
    tsenable = Signal( bool( 0 ) )
    tson     = Signal( bool( 0 ) )
    readback = Signal( bool( 0 ) )
    tspin    = TristateSignal( False )

    # a test function
    def _test():
        # instantiate the design under test
        tbdut = ts( clock, reset, tsenable, tson, tspin , readback )

        @always( delay( 3 ) )
        def tbclock():
            clock.next = not clock

        @instance
        def tbstim():
            tsenable.next = 0
            tson.next = 0
            reset.next = reset.active
            yield delay( 21 )
            reset.next = not reset.active

            yield clock.negedge
            yield clock.negedge
            tson.next = 1
            yield clock.negedge
            tsenable.next = 1
            yield clock.negedge
            tson.next = 0
            yield clock.negedge
            tsenable.next = 0
            yield clock.negedge

            raise StopSimulation

        return tbdut, tbclock, tbstim


    Simulation(traceSignals(_test)).run(100)
    print("** Simulation Successful **")
    toVHDL(ts, clock, reset, tsenable, tson, tspin , readback )
    toVerilog( ts, clock, reset,tsenable, tson, tspin , readback )


if __name__ == '__main__':
    tb_ts()
