import myhdl 
from myhdl import *
import argparse
from argparse import Namespace



from simpletristateexample import *

clock = Signal(bool(0))

i_rpi2B = Signal(intbv(0)[8:])
t_rpi2B = Signal(intbv(0)[8:])

def cliparse():
    parser = argparse.ArgumentParser()
    parser.add_argument("--brd", default='xula2_stickit_mb')
    parser.add_argument("--flow", default="ise")
    parser.add_argument("--build", default=False, action='store_true')
    parser.add_argument("--trace", default=False, action='store_true')
    parser.add_argument("--convert", default=False, action='store_true')
 
    args = parser.parse_args()
    return args 
    
def mul_ts(clock,i_rpi2B,reset,tsenable,t_rpi2B):
	#reset    = ResetSignal( 0, active=1, async=True )
	#tsenable = Signal(bool(0))
	#i_rpi2B = Signal(intbv(0)[8:]) 
	d0_o = Signal(bool(0))
	rb0_o = Signal(bool(0))
	ts0 = TristateSignal( False )
	
	d1_o = Signal(bool(0))
	rb1_o = Signal(bool(0))
	ts1 = TristateSignal( False )	
 
	d2_o = Signal(bool(0))
	rb2_o = Signal(bool(0))
	ts2 = TristateSignal( False )
	
	d3_o = Signal(bool(0))
	rb3_o = Signal(bool(0))
	ts3 = TristateSignal( False )	
 
	d4_o = Signal(bool(0))
	rb4_o = Signal(bool(0))
	ts4 = TristateSignal( False )
	
	d5_o = Signal(bool(0))
	rb5_o = Signal(bool(0))
	ts5 = TristateSignal( False )	
 
	d6_o = Signal(bool(0))
	rb6_o = Signal(bool(0))
	ts6 = TristateSignal( False )
	
	d7_o = Signal(bool(0))
	rb7_o = Signal(bool(0))
	ts7 = TristateSignal( False )

        @always_comb
        def rtl1():
            d0_o.next = i_rpi2B[1:0]
            d1_o.next = i_rpi2B[2:1]
            d2_o.next = i_rpi2B[3:2]
            d3_o.next = i_rpi2B[4:3]
            d4_o.next = i_rpi2B[5:4]
            d5_o.next = i_rpi2B[6:5]
            d6_o.next = i_rpi2B[7:6]
            d7_o.next = i_rpi2B[8:7]	
	    '''
        @always_comb
        def rtl2():
            t_rpi2B.next = concat(ts7,ts6,ts5,ts4,ts3,ts2,ts1,ts0)
        ''' 
	
	 
	inst_0 = ts( clock, reset, tsenable, d0_o, ts0 , rb0_o )
	inst_1 = ts( clock, reset, tsenable, d1_o, ts1 , rb1_o )
	inst_2 = ts( clock, reset, tsenable, d2_o, ts2 , rb2_o )
	inst_3 = ts( clock, reset, tsenable, d3_o, ts3 , rb3_o )		
	inst_4 = ts( clock, reset, tsenable, d4_o, ts4 , rb4_o )
	inst_5 = ts( clock, reset, tsenable, d5_o, ts5 , rb5_o )
	inst_6 = ts( clock, reset, tsenable, d6_o, ts6 , rb6_o )
	inst_7 = ts( clock, reset, tsenable, d7_o, ts7 , rb7_o )
			
	return myhdl.instances()

def mul_ts_tb(clock,i_rpi2B,reset,tsenable,t_rpi2B):
        dut = mul_ts(clock,i_rpi2B,reset,tsenable,t_rpi2B)

	@always(delay(10))
	def clockgen():
		clock.next = not clock
	@instance
	def stimulus():
                reset.next = reset.active
                yield delay( 21 )
                reset.next = not reset.active
                yield clock.posedge
                for i in range(255):
		    i_rpi2B.next = i		
		    yield clock.posedge
		    tsenable.next = 1
		    yield clock.posedge
		
	            tsenable.next = 0
	            yield clock.posedge
                '''
		i_rpi2B.next = 0xA2
		yield clock.posedge		
		tsenable.next = 1
		yield clock.posedge
		tsenable.next = 0
		yield clock.posedge
                '''
		yield delay(200)		
		raise StopSimulation
	return myhdl.instances()

'''
tb_fsm = traceSignals(mul_ts_tb,clock,i_rpi2B,reset,tsenable,t_rpi2B)
sim = Simulation(tb_fsm)
sim.run()
'''
def convert():
    tsenable = Signal(bool(0))	
    reset    = ResetSignal( 0, active=1, async=True )		
    toVerilog(mul_ts,clock,i_rpi2B,reset,tsenable,t_rpi2B)
 
 
def main():
    args = cliparse()
    if args.trace:
        reset    = ResetSignal( 0, active=1, async=True )
        tsenable = Signal(bool(0))			
        tb_fsm = traceSignals(mul_ts_tb,clock,i_rpi2B,reset,tsenable,t_rpi2B )
         
         
        sim = Simulation(tb_fsm)
        sim.run()
    if args.build:
	    build(args)

    if args.convert: 
	convert()
if __name__ == '__main__':
    main()


