`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2023 07:00:51 PM
// Design Name: 
// Module Name: counter_n
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


module counter_n #(parameter N=29) (
    input logic clk,
    input logic rst,
    input logic up,
    input logic en,
    output logic [N-1:0] count
    );

    logic [N-1:0] counter, n_counter;
    
    always_ff @(posedge(clk), posedge(rst))
        if(rst)
            counter <= 1'b0;
        else
            counter <= n_counter;
    
    always_comb
        if(en)
            if(up)
                n_counter = counter + 1;
            else
                n_counter = counter - 1;
        else
            n_counter = counter;
    
    assign count = counter;
endmodule
