#read liberty
read_liberty sky130/sky130_fd_sc_hd__tt_025C_1v80.lib
#read synthesized netlist
read_verilog synthesis/outputs/uart_synth.v
#top module
link_design uart
#clock definition
create_clock -name clk -period 10 [get_ports clk]
#input delays
set_input_delay 1 -clock clk [get_ports -filter {direction == in && name != clk}]
#output delays
set_output_delay 1 -clock clk [all_outputs]
#timing reports
report_checks -fields {slew cap input_pin net fanout} -digits 4
report_checks -path_delay max > sta/reports/setup.rpt
report_checks -path_delay min > sta/reports/hold.rpt
report_tns > sta/reports/tns.rpt
report_wns > sta/reports/wns.rpt
report_clock_properties > sta/reports/clock.rpt
report_check_types > sta/reports/check_types.rpt