`timescale 1ns/1ps
module uart_tb();
reg clk_tb;
reg rst_tb;
reg tx_start_tb;
reg [7:0] tx_data_tb;

wire busy_tb;
wire tx_done_tb;
wire rx_done_tb;
wire [7:0] rx_data_tb;

uart DUT (
    .clk(clk_tb),
    .rst(rst_tb),
    .tx_start(tx_start_tb),
    .tx_data(tx_data_tb),
    .busy(busy_tb),
    .tx_done(tx_done_tb),
    .rx_done(rx_done_tb),
    .rx_data(rx_data_tb)
);

always #10 clk_tb = ~clk_tb;

initial begin
    $dumpfile("sim/uart/uart.vcd");
    $dumpvars(0, DUT);
        
        // Initialize
    clk_tb = 1'b0;
    rst_tb = 1'b1;
    tx_start_tb = 1'b0;
    tx_data_tb = 8'h00;
    #100;
        
        // Release Reset
    rst_tb = 1'b0;
    #200;

        // Transmit first byte
    @(posedge clk_tb);
    tx_data_tb  = 8'hA5;
    tx_start_tb = 1'b1;
    @(posedge clk_tb);
    tx_start_tb = 1'b0; // Clear start trigger
        // Wait for system to finish loopback completely automatically
    @(posedge rx_done_tb);
    @(negedge busy_tb);
    #100;
        
        // Transmit second byte
    @(posedge clk_tb);
    tx_data_tb  = 8'h3B;
    tx_start_tb = 1'b1;
    @(posedge clk_tb);
    tx_start_tb = 1'b0;
    @(posedge rx_done_tb);
    @(negedge busy_tb);

    #100;

    @(posedge clk_tb);
    tx_data_tb = 8'h42;
    tx_start_tb = 1'b1;
    @(posedge clk_tb);
    tx_start_tb = 1'b0;
    @(posedge rx_done_tb);
    @(negedge busy_tb);

    #100

    @(posedge clk_tb);
    tx_data_tb = 8'h33;
    tx_start_tb = 1'b1;
    @(posedge clk_tb);
    tx_start_tb = 1'b0;
    @(posedge rx_done_tb);
    @(negedge busy_tb);

    #100;

    #5000;
    $finish;
    end

    // Monitor Output Console
    always @(posedge rx_done_tb) begin
        $display("[%0t ns] Loopback captured byte: %h", $time, rx_data_tb);
    end

endmodule