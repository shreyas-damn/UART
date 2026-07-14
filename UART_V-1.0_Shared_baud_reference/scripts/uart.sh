#!/bin/bash
set -e 
echo "Running Simulation"
iverilog -g2012 -o sim/uart/sim.out \
rtl/uart.sv \
tb/uart_tb.sv \
rtl/baud_gen.sv \
rtl/rx.sv \
rtl/tx.sv
vvp sim/uart/sim.out
echo "Successfully Completed"