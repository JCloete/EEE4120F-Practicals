`timescale 1ns / 1ps

module testbench();
    reg clk = 0;
    reg [7:0] SW = 0;
    reg but = 0;
    wire AUD_PWM;
    wire AUD_SD;
    wire [2:0] LED = 0;
    wire [10:0] magnitude;
    wire phasesw;
    wire invert;
    
    top mut(clk, SW, but, AUD_PWM, AUD_SD, LED, magnitude, phasesw, invert);
    
always
    begin
        #10 clk <= ~clk;
    end

initial
    begin
        but <= 0;
        #1000000 $finish;
    end
endmodule