`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2023 09:58:23 PM
// Design Name: 
// Module Name: rotating_square_tb
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


module rotating_square_tb();

    parameter N=27; 
    logic clk;
    logic reset_n;
    logic [1:0] sw; // en and cw controlled by switches
    logic [7:0] an; // enable for the 7-seg displays
    logic [7:0] sseg; // led segments
    
    rotating_square_top #(.N(N)) dut(
        .clk(clk),
        .reset_n(reset_n),
        .sw(sw),
        .an(an), 
        .sseg(sseg)
    );
    
    // clock
    always
    begin
        clk = 1'b1;
        #1;
        clk = 1'b0;
        #1;
    end
    
    initial begin
        reset_n = 0;
        #3 reset_n = 1;
        #3 reset_n = 0;
        #3;
        
        // en and cw
        sw[0] = 1;
        #5;
        sw[1] = 1;
        #5;
        
        // change leds 
        an = 4'b1110;
        #100;
        an = 4'b1101;
        #100;
        an = 4'b1011;
        #100;
        an = 4'b0111;
        #100;
    end

endmodule
