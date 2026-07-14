`timescale 1ns/1ps
module uart(   
    input wire clk,
    input wire rst,
    input wire tx_start,
    input wire [7:0] tx_data,

    output wire busy,
    output wire tx_done,
    output wire rx_done,
    output wire [7:0] rx_data
);

wire tx_baud_tick;
wire rx_baud_tick;
wire tx;

baud_gen #(
    .CLK_FREQ(50_000_000),
    .BAUD_RATE(115200),
    .OVERSAMPLE(1)
) UUT1 (
    .clk(clk),
    .rst(rst),
    .baud_tick(tx_baud_tick)
);

baud_gen #(
    .CLK_FREQ(50_000_000),
    .BAUD_RATE(115200),
    .OVERSAMPLE(16)
) UUT2 (
    .clk(clk),
    .rst(rst),
    .baud_tick(rx_baud_tick)
);

tx UUT3 (
    .clk(clk),
    .rst(rst),
    .baud_tick(tx_baud_tick),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx),
    .tx_done(tx_done),
    .busy(busy)
);

rx UUT4 (
    .clk(clk),
    .rst(rst),
    .baud_tick(rx_baud_tick),
    .rx(tx),
    .rx_done(rx_done),
    .rx_data(rx_data)
);

endmodule