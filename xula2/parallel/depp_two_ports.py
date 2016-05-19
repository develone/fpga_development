import myhdl
from myhdl import *
import argparse
from argparse import Namespace
from random import *
from pprint import pprint 

from rhea.system import Reset
from rhea.build.boards import get_board
 
def build(args):
    '''
        3 GPIO for CTL OUTPUT 1 GPIO for CTL INPUT
        CH8 J14 CH31 A2 CH11 C16 CH9 F15
        BCM8    BCM2    BCM23    BCM25
	GPIO FOR XULA2-LX9

	8 GPIO FOR OUTPUT  
        CH6 K16 CH2 R16 CH4 M16 CH5 K15 CH12 C15 CH1 R15 CH3 M15 CH7 J16
        BCM12   BCM19   BCM13   BCM6    BCM18    BCM20   BCM16   BCM7 

	8 GPIO FOR INPUT 
        CH23 H2 CH25 F2 CH27 E2 CH29 B1 CH24 F1 CH26 E1 CH28 C1 CH30 B2 
        BCM11   BCM10   BCM27   BCM4    BCM9    BCM22   BCM17   BCM3


    '''
    brd = get_board(args.brd)
    brd.device = 'XC6SLX9'
    brd.add_port_name('fr_rpi2B', 'pm1', slice(0, 8))
    brd.add_port_name('to_rpi2B', 'pm3', slice(0, 8))
    brd.add_port('a_astb', 'A2')
    #brd.add_port('a_dstb', 'B15')
    brd.add_port('a_dstb', 'J14')
    #brd.add_port('a_write', 'H1')
    brd.add_port('a_write', 'C16')
    #brd.add_port('a_wait', 'B16')
    brd.add_port('a_wait', 'F15')
    print(("%s %s") % (brd, brd.device))
    flow = brd.get_flow(para_rpi2B)
    flow.run()
    info = flow.get_utilization()
    pprint(info)	
	
def cliparse():
    parser = argparse.ArgumentParser()
    parser.add_argument("--brd", default='xula2_stickit_mb')
    parser.add_argument("--flow", default="ise")
    parser.add_argument("--build", default=False, action='store_true')
    parser.add_argument("--trace", default=False, action='store_true')
    parser.add_argument("--convert", default=False, action='store_true')
 
    args = parser.parse_args()
    return args
def para_rpi2B( clock,fr_rpi2B,a_dstb,a_astb,a_write,a_wait,to_rpi2B):
    reset    = ResetSignal( 0, active=1, async=True )
    a_addr_reg = Signal(intbv(0)[8:])
    a_data_reg = Signal(intbv(0)[8:])
     

 
    reset_dly_cnt = Signal(intbv(0)[5:])
    @always( clock.posedge)
    def reset_tst():
        '''
        For the first 4 clocks the reset is forced to lo
        for clock 6 to 31 the reset is set hi
        then the reset is lo
        '''
        if (reset_dly_cnt < 10):
            reset_dly_cnt.next = reset_dly_cnt + 1
            if (reset_dly_cnt <= 4):
                reset.next = 0
            if (reset_dly_cnt >= 5):
                reset.next = 1
        else:
            reset.next = 0
 
    

    dut_depp = depp(clock,a_dstb,a_astb,a_write,a_wait,a_addr_reg,a_data_reg,fr_rpi2B,to_rpi2B)
    #dut_mul_ts = mul_ts(clock,fr_rpi2B,reset,tsenable,to_rpi2B)
    
 
      
    return myhdl.instances()    
def depp(clock,a_dstb,a_astb,a_write,a_wait,a_addr_reg,a_data_reg,fr_rpi2B,to_rpi2B):
    a_astb_sr = Signal(intbv(0)[3:])
    a_dstb_sr = Signal(intbv(0)[3:])
    @always_comb
    def rtl1():
        a_wait.next = ~ a_astb | ~ a_dstb

    @always(clock.posedge)
    def rtl2():
        a_astb_sr.next = concat(a_astb_sr[2:0], a_astb)
        a_dstb_sr.next = concat(a_dstb_sr[2:0], a_dstb)

    @always(clock.posedge)
    def rtl3():
        if (~a_write and a_astb_sr == 4):
            a_addr_reg.next = fr_rpi2B

    @always(clock.posedge)
    def rtl4():
        if (~a_write and a_dstb_sr == 4):
            a_data_reg.next = fr_rpi2B
     
    @always(clock.posedge)
    def rtl5():
	if(a_write == 1):
            to_rpi2B.next = a_data_reg
     
          

    return myhdl.instances()
 
def tb(clock, to_rpi2B,fr_rpi2B,a_dstb,a_astb,a_write,a_wait):
    a_addr_reg = Signal(intbv(0)[8:])
    a_data_reg = Signal(intbv(0)[8:])
    a_dstb_sr = Signal(intbv(0)[3:])
    a_astb_sr = Signal(intbv(0)[3:])
  
    dut = para_rpi2B( clock,fr_rpi2B,a_dstb,a_astb,a_write,a_wait,to_rpi2B)
    @always(delay(10))
    def clockgen():
        clock.next = not clock

    @instance
    def stimulus():
       yield delay(200)  	
       yield clock.posedge
       a_astb.next = 1
       yield clock.posedge
       a_dstb.next = 1
       yield clock.posedge
       a_write.next = 1
       yield clock.posedge 		
       yield delay(100)
       	
       for i in range(10):
           fr_rpi2B.next = randint(0,128)
           yield clock.posedge
                         		
           while(a_wait):
               print "wait for a_wait",a_wait
               '''
               a_astb.next = 1
               a_dstb.next = 1
               a_write.next = 1
               
               yield clock.posedge                    		
               '''        		
           #fr_rpi2B.next = 1
           #a_db.next = 1
           yield clock.posedge
           while(a_wait):
               print "wait for a_wait",a_wait
           '''           
           a_write.next = 0
           yield clock.posedge
           '''
           a_astb.next = 0
           yield clock.posedge
           a_write.next = 0
           yield clock.posedge       
           a_astb.next = 1
           yield clock.posedge
           a_write.next = 1
           yield clock.posedge
                         
       for i in range(10):
           fr_rpi2B.next = randint(0,128)
           yield clock.posedge
           #fr_rpi2B.next = 1 
           #a_db.next = 2
           yield clock.posedge
           while(a_wait):
               print "wait for a_wait",a_wait
           '''           
           a_write.next = 0
           yield clock.posedge
           '''
           a_dstb.next = 0
           yield clock.posedge
           a_write.next = 0
           yield clock.posedge       
           a_dstb.next = 1
           yield clock.posedge
           a_write.next = 1
           yield clock.posedge
 
           
           yield delay(200)  	                             

       raise StopSimulation
          		    
    return myhdl.instances()

 
def convert():
    tsenable = Signal(bool(0))
    fr_rpi2B = Signal(intbv(0)[8:]) 
    to_rpi2B = Signal(intbv(0)[8:]) 
     
    clock  = Signal(bool(0))
    a_dstb = Signal(bool(0))
    a_astb = Signal(bool(0))
    a_write = Signal(bool(0))
    a_wait = Signal(bool(0))
    
    toVerilog(para_rpi2B,clock,fr_rpi2B,a_dstb,a_astb,a_write,a_wait,to_rpi2B)
    a_addr_reg = Signal(intbv(0)[8:])
    a_data_reg = Signal(intbv(0)[8:])
         
    #toVerilog(depp,clock,a_dstb,a_astb,a_write,a_wait,a_addr_reg,a_data_reg,fr_rpi2B)
 
def main():
    args = cliparse()
    if args.trace:
        tsenable = Signal(bool(0))
        fr_rpi2B = Signal(intbv(0)[8:]) 
        to_rpi2B = Signal(intbv(0)[8:]) 
        clock  = Signal(bool(0))
        a_dstb = Signal(bool(0))
        a_astb = Signal(bool(0))
        a_write = Signal(bool(0))
        a_wait = Signal(bool(0))
        a_dstb_sr = Signal(intbv(0)[3:])
        a_addr_reg = Signal(intbv(0)[8:])
        a_data_reg = Signal(intbv(0)[8:])
        a_db = Signal(intbv(0)[8:])        		
        tb_fsm = traceSignals(tb,clock, to_rpi2B,fr_rpi2B,a_dstb,a_astb,a_write,a_wait )
         
         
        sim = Simulation(tb_fsm)
        sim.run()
    if args.build:
	    build(args)

    if args.convert: 
        convert()
if __name__ == '__main__':
    main()
