`timescale 1ns/1ps
module baud_gen_tb();
logic clk;
logic rst;
logic baud_tick;

baud_gen #(
    .CLK_FREQ(50_000_000),
    .BAUD_RATE(9600)
) DUT1 (
    .clk,
    .rst,
    .baud_tick
);
initial clk = 0;
always #10 clk = ~clk;
initial begin
    $dumpfile("sim/baud_gen/sim.vcd");
    $dumpvars(0,baud_gen_tb);
    rst = 1;
    #20;
    rst = 0;
    #60000;
    $finish;
end
endmodule