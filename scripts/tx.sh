#!/bin/bash
set -e
echo "Running simulation"
iverilog -g2012 -o sim/tx/sim.out \
rtl/tx.sv \
tb/tx_tb.sv \
rtl/baud_gen.sv
vvp sim/tx/sim.out
echo "Successfully Completed"
