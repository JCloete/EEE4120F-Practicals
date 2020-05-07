// Set time and precision
`timescale 1ns / 1ps

module tb_top();

//Registers
reg clk;
reg [1:0] buts;
reg res;
reg pause;
reg [7:0] pwmslider;
wire [7:0] seg;
wire [7:0] segdriv;
wire [5:0] LED;


//UUT
WallClock WC(clk, buts, res, pause, pwmslider, seg, segdriv, LED);

//Initialise
initial
begin
    buts <= 0;
    res <= 0;
    pause <= 0;
    pwmslider <= 8'b10101010;
    clk <= 1;
end

always begin
    #5 clk <= ~clk;
end

endmodule