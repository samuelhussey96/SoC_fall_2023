`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2023 04:33:42 PM
// Design Name: 
// Module Name: reaction_timer_wrapper
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


module reaction_timer_wrapper #(parameter N=18)(
    input clk, reset_n,
    input logic [2:0] btn,
    output logic [7:0] an, // enable for the 7-seg displays
    output logic [7:0] sseg, // led segments
    output logic [3:3] led
    );
    
    reaction_timer #(.N(N)) timer(
        .clk(clk),
        .rst(~reset_n),
        .start(btn[0]), 
        .stop(btn[1]), 
        .clear(btn[2]),
        .en_led(an),
        .sseg(sseg),
        .led(led[3])
    );
endmodule
