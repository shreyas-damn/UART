`timescale 1ns/1ps

module tx(
    input wire       clk,
    input wire       rst,
    input wire       baud_tick,
    input wire       tx_start,
    input wire [7:0] tx_data,
    
    output reg       tx,
    output reg       tx_done,
    output reg       busy
);

    // FSM States
    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] state;
    reg [7:0] shift_reg;
    reg [2:0] bit_index;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state     <= IDLE;
            tx        <= 1'b1; // UART idle state is high
            tx_done   <= 1'b0;
            busy      <= 1'b0;
            shift_reg <= 8'b0;
            bit_index <= 3'b0;
        end
        else begin
            tx_done <= 1'b0; // Default single-cycle pulse

            case(state)
                IDLE: begin
                    tx   <= 1'b1;
                    busy <= 1'b0;
                    if (tx_start) begin
                        shift_reg <= tx_data; // Latch input data safely
                        bit_index <= 3'd0;
                        busy      <= 1'b1;
                        state     <= START;
                    end
                end

                START: begin
                    tx <= 1'b0; // Drive START bit low
                    if (baud_tick) begin
                        state <= DATA;
                    end
                end

                DATA: begin
                    tx <= shift_reg[bit_index]; // Drive current data bit
                    if (baud_tick) begin
                        if (bit_index == 3'd7) begin
                            state <= STOP;
                        end
                        else begin
                            bit_index <= bit_index + 1;
                        end
                    end
                end

                STOP: begin
                    tx <= 1'b1; // Drive STOP bit high
                    if (baud_tick) begin
                        tx_done <= 1'b1; // Pulse completion flag
                        busy    <= 1'b0;
                        state   <= IDLE;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule