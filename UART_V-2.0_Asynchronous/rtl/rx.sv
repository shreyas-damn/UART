`timescale 1ns/1ps

module rx (
    input wire clk,
    input wire rst,
    input wire baud_tick,
    input wire rx,          // Serial input pin
    output reg rx_done,
    output reg [7:0] rx_data
);

    typedef enum reg [1:0] {
        IDLE  = 2'b00,
        START = 2'b01,
        DATA  = 2'b10,
        STOP  = 2'b11
    } state_t;

    state_t current_state, next_state;

    reg [2:0] bit_index;
    reg [7:0] shift_reg;
    reg [3:0] sample_count; //8 bit counter for 8 oversampling

    // 1. State Transition Logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= IDLE;
        end
        else begin
            current_state <= next_state;
        end
    end

    // 2. Next State Combinational Logic
    always @(*) begin
        next_state = current_state;
        case (current_state)
            IDLE: begin
                if (rx == 1'b0) begin // Detect falling edge (START bit)
                    next_state = START;
                end
            end
            START: begin
                if (baud_tick && (sample_count == 7)) begin
                    if (rx == 0)
                        next_state = DATA;
                    else
                        next_state = IDLE;
                end
            end
            DATA: begin
                if (baud_tick && sample_count == 15 && (bit_index == 3'd7)) begin
                    next_state = STOP;
                end
            end
            STOP: begin
                if (baud_tick && sample_count == 15) begin
                    next_state = IDLE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // 3. Sequential Control Logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bit_index   <= 3'd0;
            shift_reg   <= 8'h00;
            rx_data     <= 8'h00;
            rx_done     <= 1'b0;
            sample_count <= 0;
        end 
        else begin
            rx_done <= 1'b0; // Default single-cycle pulse

            case (current_state)
                IDLE: begin
                    bit_index <= 3'd0;
                    if (rx == 0) begin
                        sample_count <= 0;
                    end
                end

                START: begin
                    // Clear bit counter preparing for data collection
                    bit_index <= 3'd0;
                    if (baud_tick) begin
                        if (sample_count == 7) begin
                            sample_count <= 0;
                        end
                        else begin
                        sample_count <= sample_count + 1;
                        end
                    end
                        
                end

                DATA: begin
                    if (baud_tick) begin
                        if(sample_count == 15) begin
                            sample_count <= 0;
                            shift_reg <= {rx, shift_reg[7:1]};
                            if (bit_index < 3'd7) begin
                                bit_index <= bit_index + 1'b1;
                            end
                        end
                        else begin
                            sample_count <= sample_count + 1;
                        end
                    end
                end

                STOP: begin
                    if (baud_tick) begin
                        if (sample_count == 15) begin
                            sample_count <= 0;
                            if(rx == 1) begin
                                rx_data   <= shift_reg; // Push valid parallel data out
                                rx_done   <= 1'b1;      // Strike the handshake pulse
                            end
                        end
                        else 
                            sample_count <= sample_count + 1;
                    end
                end
                
                default: ;
            endcase
        end
    end

endmodule