#!/bin/bash
set -e 
echo "Running Simulation"
iverilog -g2012 -o sim/baud_gen/sim.out \
rtl/baud_gen.sv \
tb/baud_gen_tb.sv
vvp sim/baud_gen/sim.out
echo "Successfully Completed"