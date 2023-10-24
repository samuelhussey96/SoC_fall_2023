`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2023 07:32:23 PM
// Design Name: 
// Module Name: ms_counter
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


module ms_counter(
    input logic clk,
    input logic rst,
    input logic en,
    output logic [31:0] count
    );

    logic [47:0] counter, n_counter;
    logic [31:0] count_ms, n_count_ms;
    
    always_ff @(posedge(clk), posedge(rst))
        if(rst)
            begin
                counter <= 1'b0;
                count_ms <= 1'b0;
            end
        else
            begin
                counter <= n_counter;
                count_ms <= n_count_ms;
            end
    
    always_comb
        if(en)
            begin
                n_counter = (counter==99999) ? 0 : counter + 1;
                n_count_ms = count_ms; 
                if (counter==99999)
                    n_count_ms = count_ms + 1;
            end
        else
            n_counter = counter;
    
    assign count = count_ms;
endmodule
