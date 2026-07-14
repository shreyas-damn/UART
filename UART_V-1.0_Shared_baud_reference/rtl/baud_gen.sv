// Baud Rate Generator produces a common rate at which both the rx and tx communicate
// Baud Tick is given at every CLK_FREQ/BAUD_RATE
// This Baud tick enables transmission at tx and sampling at rx
// 50_000_000/115200 gives 434
`timescale 1ns/1ps
module baud_gen #(
    parameter CLK_FREQ = 50_000_000,
    parameter BAUD_RATE = 115200
)
(
    input wire clk,
    input wire rst,
    output reg baud_tick
);

//creating a counter to count upto DIV 
localparam integer DIV = CLK_FREQ/BAUD_RATE;
reg [$clog2(DIV)-1:0] counter;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
        baud_tick <= 0;
    end
    else begin
        //counts from 0 - 433 (434 ticks)
        if (counter == DIV - 1) begin
            counter <= 0;
            baud_tick <= 1'b1;
        end
        else begin
            counter <= counter + 1;
            baud_tick <= 1'b0;
        end
    end
end
endmodule
