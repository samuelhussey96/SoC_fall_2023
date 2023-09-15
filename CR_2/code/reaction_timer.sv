`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2023 06:37:33 PM
// Design Name: 
// Module Name: reaction_timer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module reaction_timer #(parameter N=27)(
    input logic clk, rst,
    input logic start, stop, clear,
    output logic [7:0] en_led,
    output logic [7:0] sseg,
    output logic led
    );
    
    // fsm state type
    typedef enum {idle_state, wait_state, timer_state, display_state} state_type;
    state_type state_reg, state_next;
    
    // signal declaration
    logic [N-1:0] display_count;
    logic [7:0] d0_reg, d1_reg, d2_reg, d3_reg;
    logic [7:0] d0_next, d1_next, d2_next, d3_next;
    
    // module instantiation
    counter_n #(.N(N)) cnt(
    .clk(clk),
    .rst(rst),
    .up(1'b1),
    .en(1'b1),
    .count(display_count)
    );
    
    sseg_driver #(.N(N)) sseg_unit(
        .clk(clk), 
        .rst(rst),
        .in0(d0_reg),
        .in1(d1_reg),
        .in2(d2_reg),
        .in3(d3_reg),
        .counter(display_count),
        .an(en_led),
        .sseg(sseg)
    );
    
    logic [3:0] ms_dig, cs_dig, ds_dig, s_dig, wait_dig;
    logic count_en, wait_en;

    
    ms_counter ms_cnt(
        .clk(clk),
        .rst(clear),
        .en(count_en),
        .count(ms_dig)
    );

    cs_counter cs_cnt(
        .clk(clk),
        .rst(clear),
        .en(count_en),
        .count(cs_dig)
    );

    ds_counter ds_cnt(
        .clk(clk),
        .rst(clear),
        .en(count_en),
        .count(ds_dig)
    );

    s_counter s_cnt(
        .clk(clk),
        .rst(clear),
        .en(count_en),
        .count(s_dig)
    );
    
    s_counter wait_cnt(
        .clk(clk),
        .rst(rst),
        .en(wait_en),
        .count(wait_dig)
    );
    
    // body
    // FSMD state and data registers
    always_ff @(posedge(clk), posedge(rst))
        if (rst)
            begin
                state_reg <= idle_state;
                d0_reg <= 8'b00000000; 
                d1_reg <= 8'b00000000;
                d2_reg <= 8'b00000000;
                d3_reg <= 8'b00000000;
            end
        else
            begin
                state_reg <= state_next;
                d0_reg <= d0_next;
                d1_reg <= d1_next;
                d2_reg <= d2_next;
                d3_reg <= d3_next;
            end
    
    // FSDM next-state logic
    always_comb
    begin
        state_next = state_reg;
        d0_next = d0_reg;
        d1_next = d1_reg;
        d2_next = d2_reg;
        d3_next = d3_reg;
        led = 1'b0;
        count_en = 1'b0;
        wait_en = 1'b1;
        case (state_reg)
            idle_state:
                begin
                    if (start)
                        begin
                            d3_next = 8'b11111111; //"-"
                            d2_next = 8'b11111111;
                            d1_next = 8'b11111111; 
                            d0_next = 8'b11111111;
                            state_next = wait_state;
                        end
                    else
                        begin
                            d3_next = 8'b11111111;
                            d2_next = 8'b11111111;
                            d1_next = 8'b10001001; //"H"
                            d0_next = 8'b11111001; //"I"
                        end
                end
            wait_state:
                begin
                    if (clear)
                        state_next = idle_state;
                    else
                        begin 
                            // wait 2 - 15 seconds then turn on led
                            if (wait_dig == 4'b1001) // horrible randomness
                                state_next = timer_state;
                        end
                end
            timer_state:
                begin
                    count_en = 1'b1;
                    led = 1'b1;
                    d3_next = 8'b01000000;
                    if (stop)
                        begin
                            count_en = 1'b0;
                            state_next = display_state;
                        end
                    if (s_dig >= 4'b0001)
                        begin
                            d3_next = 8'b01111001;
                            d2_next = 8'b11000000;
                            d1_next = 8'b11000000;
                            d0_next = 8'b11000000;
                            count_en = 1'b0;
                            state_next = display_state;
                        end
                    case (ms_dig)
                        4'h0: d0_next = 8'b11000000;
                        4'h1: d0_next = 8'b11111001; 
                        4'h2: d0_next = 8'b10100100;
                        4'h3: d0_next = 8'b10110000;
                        4'h4: d0_next = 8'b10011001;
                        4'h5: d0_next = 8'b10010010;
                        4'h6: d0_next = 8'b10000010;
                        4'h7: d0_next = 8'b11111000;
                        4'h8: d0_next = 8'b10000000;
                        4'h9: d0_next = 8'b10010000;
                    endcase
                    case (cs_dig)
                        4'h0: d1_next = 8'b11000000;
                        4'h1: d1_next = 8'b11111001; 
                        4'h2: d1_next = 8'b10100100;
                        4'h3: d1_next = 8'b10110000;
                        4'h4: d1_next = 8'b10011001;
                        4'h5: d1_next = 8'b10010010;
                        4'h6: d1_next = 8'b10000010;
                        4'h7: d1_next = 8'b11111000;
                        4'h8: d1_next = 8'b10000000;
                        4'h9: d1_next = 8'b10010000;
                    endcase
                    case (ds_dig)
                        4'h0: d2_next = 8'b11000000;
                        4'h1: d2_next = 8'b11111001; 
                        4'h2: d2_next = 8'b10100100;
                        4'h3: d2_next = 8'b10110000;
                        4'h4: d2_next = 8'b10011001;
                        4'h5: d2_next = 8'b10010010;
                        4'h6: d2_next = 8'b10000010;
                        4'h7: d2_next = 8'b11111000;
                        4'h8: d2_next = 8'b10000000;
                        4'h9: d2_next = 8'b10010000;
                    endcase
                end
            display_state:
                if (clear)
                    state_next = idle_state;
            default:
                begin
                end
        endcase
    end
    
endmodule
