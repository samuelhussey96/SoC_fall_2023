`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2023 04:59:50 PM
// Design Name: 
// Module Name: rotating_square
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


module rotating_square #(parameter N=27)(
    input logic clk,
    input logic reset_n,
    input logic en,
    input logic cw,
    output logic [7:0] en_led, // enable for the 7-seg displays
    output logic [7:0] sseg // led segments
    );
    
    // signal declaration 
    logic [7:0] d3_reg, d2_reg, d1_reg, d0_reg;
    logic [N-1:0] counter;
    
    // instantiate counter, 100 MHz/2^27
    counter_n #(.N(N)) cnt(
    .clk(clk),
    .rst(~reset_n),
    .up(cw),
    .en(en),
    .count(counter)
    );
    
    // instantiate 7-seg led display time-multiplexing module
    disp_mux #(.N(N)) disp_unit(
        .clk(clk),
        .rst(~reset_n),
        .in0(d0_reg),
        .in1(d1_reg),
        .in2(d2_reg),
        .in3(d3_reg),
        .counter(counter),
        .an(en_led),
        .sseg(sseg)
    );
     
    // registers for led patterns
    always_ff @(posedge(clk))
    begin
        case (counter[N-1:N-3])
            3'b000: 
                d0_reg <= 8'b10011100;
            3'b001: 
                d1_reg <= 8'b10011100;
            3'b010: 
                d2_reg <= 8'b10011100;
            3'b011: 
                d3_reg <= 8'b10011100;
            3'b100: 
                d3_reg <= 8'b10100011;
            3'b101: 
                d2_reg <= 8'b10100011;
            3'b110: 
                d1_reg <= 8'b10100011;
            3'b111: 
                d0_reg <= 8'b10100011;
        endcase
    
    end
endmodule