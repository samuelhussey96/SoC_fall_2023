`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2023 03:40:34 PM
// Design Name: 
// Module Name: blinking_led
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


module blinking_led(
    input  logic clk,
    input  logic reset,
    // slot interface
    input  logic cs,
    input  logic read,
    input  logic write,
    input  logic [4:0] addr,
    input  logic [31:0] wr_data,
    output logic [31:0] rd_data,
    // external port
    output logic [3:0] out
    );
    
    // signal declaration
    logic wr_en0, wr_en1, wr_en2, wr_en3;
    logic [31:0] ms_count;
    logic [31:0] buf0_reg = 0;
    logic [31:0] buf1_reg = 0;
    logic [31:0] buf2_reg = 0;
    logic [31:0] buf3_reg = 0;
    logic [3:0] led_reg = 0;
    
    ms_counter count(
        .clk(clk),
        .rst(reset),
        .en(1'b1),
        .count(ms_count)
    );
    
    // custom blinking led circuit
    always_ff @(posedge(clk), posedge(reset))
        if (reset)
            led_reg <= 0;
        else
            begin
            led_reg[0] <= (ms_count%buf0_reg>(buf0_reg/2)) ? 1'b1: 1'b0;
            led_reg[1] <= (ms_count%buf1_reg>(buf1_reg/2)) ? 1'b1: 1'b0;
            led_reg[2] <= (ms_count%buf2_reg>(buf2_reg/2)) ? 1'b1: 1'b0;
            led_reg[3] <= (ms_count%buf3_reg>(buf3_reg/2)) ? 1'b1: 1'b0;
            end
    
    // wrapping circuit
    always_ff @(posedge(clk), posedge(reset))
        if (reset)
            begin
            buf0_reg <= 0;
            buf1_reg <= 0;
            buf2_reg <= 0;
            buf3_reg <= 0;
            end
        else
            begin
            if (wr_en0)
                buf0_reg <= wr_data;
            if (wr_en1)
                buf1_reg <= wr_data;
            if (wr_en2)
                buf2_reg <= wr_data;
            if (wr_en3)
                buf3_reg <= wr_data;
            end
    
    // decoding logic 
    assign wr_en0 = cs && write && (addr[1:0]==2'b00);
    assign wr_en1 = cs && write && (addr[1:0]==2'b01);
    assign wr_en2 = cs && write && (addr[1:0]==2'b10);
    assign wr_en3 = cs && write && (addr[1:0]==2'b11);
    // slot read interface
    assign rd_data = 0;
    // external output
    assign out = led_reg;
    
endmodule
