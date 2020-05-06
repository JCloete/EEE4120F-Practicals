`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.04.2020 14:16:30
// Design Name: 
// Module Name: Debounce
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


module Debounce(
    input Clk,
    input but,
    output reg flag
        );
        
    reg prev;
    reg [21:0]counter;
    
    always @(posedge Clk)
    begin
        if (but && but != prev && &counter)
        begin
            prev <= 1;
            flag <= 1;
        end 
        else if (but && but != prev)
        begin
            counter <= counter + 1'b1;
            flag <= 0;
        end 
        else begin
            prev <= but;
            flag <= 0;
        end
    end
endmodule
