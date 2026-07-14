#!/bin/bash
set -e
echo "Running Simulation"
iverilog -g2012 -o sim/rx/sim.out \
rtl/rx.sv \
tb/rx_tb.sv \
rtl/baud_gen.sv
vvp sim/rx/sim.out
echo "Successfully Completed"
