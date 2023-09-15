`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/14/2023 09:01:56 PM
// Design Name: 
// Module Name: cs_counter
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


module cs_counter(
    input logic clk,
    input logic rst,
    input logic en,
    output logic [3:0] count
    );

    logic [19:0] counter, n_counter;
    logic [3:0] count_cs, n_count_cs;
    
    always_ff @(posedge(clk), posedge(rst))
        if(rst)
            begin
                counter <= 1'b0;
                count_cs <= 1'b0;
            end
        else
            begin
                counter <= n_counter;
                count_cs <= n_count_cs;
            end
    
    always_comb
        if(en)
            begin
                n_counter = (counter==999999) ? 0 : counter + 1;
                n_count_cs = count_cs; 
                if (counter==999999)
                    n_count_cs = (count_cs==9) ? 0 : count_cs + 1;
            end
        else
            n_counter = counter;
    
    assign count = count_cs;
endmodule