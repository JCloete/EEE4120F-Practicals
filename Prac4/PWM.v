`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2020 18:10:49
// Design Name: 
// Module Name: PWM
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


module PWM(
    input clk,
    input [7:0] pwmslider,
    output reg pwmstate
    );
    
    reg [7:0] pwmNew=0;
    reg [7:0] pwmInc=0;
    
    always @(posedge clk)
    begin
        if (pwmInc==0)
            pwmNew <= pwmslider;
        pwmInc <= pwmInc + 1'b1;
        if (pwmNew > pwmInc)
            pwmstate <= 1;
        else
            pwmstate <= 0;
    end
    
endmodule
