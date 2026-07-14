`timescale 1ns/1ps
module baud_gen_tb ();
reg clk_tb;
reg rst_tb;
wire baud_tick_tb;

baud_gen #(
    .CLK_FREQ(50_000_000),
    .BAUD_RATE(115200)
) UUT (
    .clk(clk_tb),
    .rst(rst_tb),
    .baud_tick(baud_tick_tb)
);

always #10 clk_tb = ~clk_tb;

initial begin
    clk_tb = 0;
    rst_tb = 0;
    #50
    rst_tb = 1;
    $dumpfile("sim/baud_gen/baud_gen.vcd");
    $dumpvars(0,baud_gen_tb);
    #100;
    rst_tb = 0;
    #50000;
    $finish;
end
endmodule