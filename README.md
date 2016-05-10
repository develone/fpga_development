# fpga_development

This repository is taking information from jpeg-2000-test repository.
 




The repository is a collection of python used with MyHDL, RHEA, CATBOARD,
XuLA2 and Iverilog.

XuLA2 is available in 2 models XuLA2-LX9 and XuLA2-LX25

Small 1 in. x 2 in FPGA.

XuLA2-LX9

    Open-source design
    XC6SLX9 FPGA
    32 MByte SDRAM
    8 Mbit Flash
    microSD card socket
    3.3 & 1.2V regulators
    40-pin interface
    12 MHz oscillator
    PIC 18F14K50 micro
    USB 2.0 port
    Auxiliary JTAG port
    Works with the XSTOOLs software
    Works with XILINX ISE and WebPACK
    Works with XILINX iMPACT and ChipScope (requires Xilinx JTAG cable)

XuLA2-LX25

    Open-source design
    XC6SLX25 FPGA
    32 MByte SDRAM
    8 Mbit Flash
    microSD card socket
    3.3 & 1.2V regulators
    40-pin interface
    12 MHz oscillator
    PIC 18F14K50 micro
    USB 2.0 port
    Auxiliary JTAG port
    Works with the XSTOOLs software
    Works with XILINX ISE and WebPACK
    Works with XILINX iMPACT and ChipScope (requires Xilinx JTAG cable)




http://www.xess.com/store/fpga-boards/


MyHDL is a free, open-source package for using Python as a hardware
description and verification language.
 
https://github.com/jandecaluwe/myhdl 

RHEA 

The rhea python package is a collection of HDL cores written in MyHDL. 
The rhea package also includes a small set of utilities to augment 
the myhdl types and functions as well as FPGA build automation tools.

https://github.com/cfelton/rhea

CATBOARD

The CAT Board is a Raspberry Pi HAT with a Lattice iCE40HX FPGA.

Features

    Lattice iCE40-HX8K FPGA in 256-pin BGA.
    32 MByte SDRAM (16M x 16).
    Serial configuration flash (at least 2 Mbit).
    Three Grove connectors.
    Two PMOD connectors.
    One 20x2 header with 3.3V, ground and 18 FPGA I/Os.
    Two SATA headers (for differential signals; don't know if they would work with SATA HDDs.)
    DIP switch with four SPST switches.
    Two momentary pushbuttons.
    Four LEDs.
    100 MHz oscillator.
    5.0 V jack for external power supply.
    3.3 V and 1.2 V regulators.
    Adjustable voltage on one bank of FPGA I/O pins.
    32 KByte HAT EEPROM.
    40-pin RPi GPIO header.


https://github.com/xesscorp/CAT-Board

Icarus Verilog

Icarus Verilog is a Verilog simulation and synthesis tool. 
It operates as a compiler, compiling source code written
in Verilog (IEEE-1364) into some target format. For batch simulation,
the compiler can generate an intermediate form called vvp assembly.
This intermediate form is executed by the ``vvp'' command. 
For synthesis, the compiler generates netlists in the desired format

http://iverilog.icarus.com/
