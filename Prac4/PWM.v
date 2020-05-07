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
    input [7:0] pwmslider, //Input switches
    output reg pwmstate //Output state (turn lights on or off)
    );
    
    reg [7:0] pwmNew=0; //If this reaches limit, change state
    reg [7:0] pwmLimit=0; //Set limit.
    //Ie. the higher we set limit, the longer it takes between state changes
    //Ie. Blink slower
    always @(posedge clk)
    begin
        if (pwmLimit==0)
            pwmNew <= pwmslider;
        pwmLimit <= pwmLimit + 1'b1;
        if (pwmNew > pwmLimit)
            pwmstate <= 1;
        else
            pwmstate <= 0;
    end
    
endmodule
