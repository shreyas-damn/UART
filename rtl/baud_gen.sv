`timescale 1ns/1ps
module baud_gen #(
    parameter CLK_FREQ = 50_000_000,
    parameter BAUD_RATE = 9600
)
(
    input logic clk,
    input logic rst,
    output logic baud_tick
);
localparam DIV = CLK_FREQ/(BAUD_RATE * 16);
localparam NUM = $clog2(DIV);

logic [0:NUM-1] count = 0;

always @(posedge clk) begin
    if (rst) begin
        count <= 0;
    end
    else if (count == 325) begin
        count <= 0;
    end
    else begin
        count += 1;
    end

if (count == 325) begin
    baud_tick = 1;
end
else begin
    baud_tick = 0;
end
end
endmodule
