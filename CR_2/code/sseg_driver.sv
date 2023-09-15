`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2023 06:35:33 PM
// Design Name: 
// Module Name: sseg_driver
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


module sseg_driver #(parameter N=27)(
    input logic clk, rst,
    input logic [7:0] in0, in1, in2, in3,
    input logic [N-1:0] counter,
    output logic [7:0] an, // enable for the 7-seg displays
    output logic [7:0] sseg// led segments
    );

    
    // 2 MSBs of counter to control 4-to-1 multiplexing
    // and to generate active-low enable signal
    always_comb
        case (counter[N-1:N-2])
            2'b00:
                begin
                    an = 4'b1110;
                    sseg = in0;
                end
            2'b01:
                begin
                    an = 4'b1101;
                    sseg = in1;
                end
            2'b10:
                begin
                    an = 4'b1011;
                    sseg = in2;
                end
            2'b11:
                begin
                    an = 4'b0111;
                    sseg = in3;
                end
        endcase
        
        // blank the upper 4 digits 
        assign an[7:4] = 4'b1111;
endmodule
