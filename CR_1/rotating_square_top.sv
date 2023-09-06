`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2023 09:44:49 PM
// Design Name: 
// Module Name: rotating_square_top
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


module rotating_square_top #(parameter N=27)(
    input logic clk,
    input logic reset_n,
    input logic [1:0] sw,
    output logic [7:0] an, // enable for the 7-seg displays
    output logic [7:0] sseg // led segments
    );
    
    rotating_square #(.N(N)) rot_sq(
        .clk(clk),
        .reset_n(reset_n),
        .en(sw[0]),
        .cw(sw[1]),
        .en_led(an), // enable for the 7-seg displays
        .sseg(sseg) // led segments
    );
    
endmodule
