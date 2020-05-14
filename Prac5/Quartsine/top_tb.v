`timescale 10ns / 1ns

module testbench;
    reg clk = 0;
    reg [7:0] SW = 0;
    reg but = 0;
    wire AUD_PWM;
    wire AUD_SD;
    wire [2:0] LED = 0;
    wire [10:0] out;
    
    top mut(clk, SW, but, AUD_PWM, AUD_SD, LED,out);
    
always
    begin
        #1 clk <= ~clk;
    end

initial
    begin
        
        but <= 1;

        #1000000 $finish;
    end
endmodule