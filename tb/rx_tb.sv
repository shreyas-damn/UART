`timescale 1ns/1ps
module tb_rx();
reg clk_tb;
reg rst_tb;
wire baud_tick_tb;
reg rx_tb;
wire rx_done_tb;
wire [7:0] rx_data_tb;

baud_gen #(
    .CLK_FREQ(50_000_000),
    .BAUD_RATE(115200),
    .OVERSAMPLE(16)
) UUT1 (
    .clk(clk_tb),
    .rst(rst_tb),
    .baud_tick(baud_tick_tb)
);

rx UUT2 (
    .clk(clk_tb),
    .rst(rst_tb),
    .baud_tick(baud_tick_tb),
    .rx(rx_tb),
    .rx_done(rx_done_tb),
    .rx_data(rx_data_tb )
);
//initializing clock to always trigger every 10ns
always #10 clk_tb = ~clk_tb;

//converts parallel data to serial, (simulates tx behaviour)
//bit duration = 1/115200 = 8680 ns for transmitting 1 bit
task automatic send_byte (input [7:0] data);
    integer i;
    begin
        rx_tb = 1'b0; //sending start bit
        #8681;
        for (i = 0; i <8; i = i + 1) begin
            rx_tb = data[i];
            #8681;
        end
        rx_tb = 1'b1;
        #8681;
    end
endtask

initial begin
    $dumpfile("sim/rx/rx.vcd");
    $dumpvars(0,tb_rx);
    clk_tb = 1'b0;
    rst_tb = 1'b1;
    rx_tb = 1'b1;
    #100;
    rst_tb = 1'b0;
    #200;
    send_byte(8'hA5);
    send_byte(8'h3B);
    send_byte(8'h42);
    send_byte(8'h33);
    $finish;
end
always @(posedge clk_tb) begin
    $display("time=%0t rx=%b state=%d sample=%d bit=%d",
    $time,
    rx_tb,
    UUT2.current_state,
    UUT2.sample_count,
    UUT2.bit_index
    );
end
always @(posedge rx_done_tb) begin
    $display("Received data = %h", rx_data_tb);
end
endmodule