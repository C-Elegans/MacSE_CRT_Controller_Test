# MacSE_CRT_Controller_Test
FPGA Design Files for driving MacSE with Video, HSYNC, and VSYNC

# Usage
example: make Time=500ns

Use GTKWave to view resulting simulation

# Notes
Currently intended to be used with IceStorm/IceCube 2

The top entity is my_clock. Admittedly this is not the greatest design. Perhaps I will fix that.

You will need to modify the PLL to use with Altera for example
# Dependencies
* GHDL
* GTKWave

# Status
All files compile, need to udate CRT.vhd to actually drive a test

pattern such as a blank screen

Schematic overview coming soon.
