`timescale 1ns/1ps
module tx_tb_top ();
//INPUTS
reg clk_tb;
reg rst_tb;
reg baud_tick_tb;
reg tx_start_tb;
reg [7:0] tx_data_tb;
//OUTPUTS
wire tx_tb;
wire tx_done_tb;
wire busy_tb;

baud_gen #(
    .CLK_FREQ(50_000_000),
    .BAUD_RATE(115200)
) UUT1 (
    .clk(clk_tb),
    .rst(rst_tb),
    .baud_tick(baud_tick_tb)
);

tx UUT2 (
    .clk(clk_tb),
    .rst(rst_tb),
    .baud_tick(baud_tick_tb),
    .tx_start(tx_start_tb),
    .tx_data(tx_data_tb),
    .tx(tx_tb),
    .tx_done(tx_done_tb),
    .busy(busy_tb)
);

always #10 clk_tb = ~clk_tb;

initial begin
    $dumpfile ("sim/tx/tx.vcd");
    $dumpvars (0, tx_tb_top);
    //initializing inputs to 0 
    clk_tb = 1'b0;
    rst_tb = 1'b1;
    tx_start_tb = 1'b0;
    tx_data_tb = 8'h00;

    #100;
    rst_tb = 1'b0;
    #40;

    //BYTE 1
    //giving input to tx_data and setting tx_start as 1
    @(posedge clk_tb);
        tx_data_tb = 8'hA5;
        tx_start_tb = 1'b1;
    //sets tx_start back to low
    @(posedge clk_tb);
        tx_start_tb = 1'b0;
    //when tx_done gives high output, we 
    @(posedge tx_done_tb);
        $display("A5 successfully transmitted");

    //BYTE 2
    @(posedge clk_tb);
        tx_data_tb = 8'h3B;
        tx_start_tb = 1'b1;
    //sets tx_start back to low
    @(posedge clk_tb);
        tx_start_tb = 1'b0;
    //when tx_done gives high output, we 
    @(posedge tx_done_tb);
        $display("3B successfully transmitted");

    @(posedge clk_tb);
        tx_data_tb = 8'h42;
        tx_start_tb = 1'b1;
    //sets tx_start back to low
    @(posedge clk_tb);
        tx_start_tb = 1'b0;
    //when tx_done gives high output, we 
    @(posedge tx_done_tb);
        $display("42 successfully transmitted");


    @(posedge clk_tb);
        tx_data_tb = 8'h33;
        tx_start_tb = 1'b1;
    //sets tx_start back to low
    @(posedge clk_tb);
        tx_start_tb = 1'b0;
    //when tx_done gives high output, we 
    @(posedge tx_done_tb);
        $display("33 successfully transmitted");
    
    $finish;
end
endmodule








