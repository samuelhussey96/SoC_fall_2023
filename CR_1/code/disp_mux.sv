`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2023 10:15:59 AM
// Design Name: 
// Module Name: disp_mux
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


module disp_mux #(parameter N=29)(
    input logic clk, rst,
    input logic [7:0] in3, in2, in1, in0,
    input logic [N-1:0] counter,
    output logic [7:0] an, // enable for the 7-seg displays
    output logic [7:0] sseg // led segments
    );

    
    // 3 MSBs of counter to control 4-to-1 multiplexing
    // and to generate active-low enable signal
    always_comb
        case (counter[N-1:N-3])
            3'b000:
                begin
                    an = 4'b1110;
                    sseg = in0;
                end
            3'b001:
                begin
                    an = 4'b1101;
                    sseg = in1;
                end
            3'b010:
                begin
                    an = 4'b1011;
                    sseg = in2;
                end
            3'b011:
                begin
                    an = 4'b0111;
                    sseg = in3;
                end
            3'b100:
                begin
                    an = 4'b0111;
                    sseg = in3;
                end
            3'b101:
                begin
                    an = 4'b1011;
                    sseg = in2;
                end
            3'b110:
                begin
                    an = 4'b1101;
                    sseg = in1;
                end
            3'b111:
                begin
                    an = 4'b1110;
                    sseg = in0;
                end
        endcase
        
        // blank the upper 4 digits 
        assign an[7:4] = 4'b1111;
endmodule
