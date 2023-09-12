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

    parameter N=8; 
    logic clk;
    logic reset_n;
    logic en; 
    logic cw;
    logic [7:0] en_led; // enable for the 7-seg displays
    logic [7:0] sseg; // led segments
    
    rotating_square #(.N(N)) dut(
        .clk(clk),
        .reset_n(~reset_n),
        .en(en),
        .cw(cw),
        .en_led(en_led), 
        .sseg(sseg)
    );
    
    // clock
    always
    begin
        clk = 1'b1;
        #5;
        clk = 1'b0;
        #5;
    end
    
    task change_direction(input logic dir);
        begin
            cw = dir;
            #10;
        end
    endtask
    
    initial begin
        reset_n = 1'b0;
        en = 1'b0;
        cw = 1'b0;
        #3 reset_n = 1'b1;
        #3 reset_n = 1'b0;
        #3;
        
        // enable
        en = 1'b1;
        #5000;
        
        // go the other way
        change_direction(1'b1);
        #5000;
        
        // pause
        en = 1'b0;
        #5000;
        
        
        $finish;
    end

endmodule
