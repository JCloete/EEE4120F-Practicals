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
wire [5:0] seconds;

// registers for storing the time
wire [3:0]hours1; //Hours tens decimal value
wire [3:0]hours2; //Hours units
wire [3:0]mins1; //Minutes tens
wire [3:0]mins2; //Minutes units


//UUT
WallClock WC(clk, buts, res, pause, pwmslider, seg, segdriv, seconds, hours1, hours2, mins1, mins2);

//Initialise
initial
begin
    // $monitor("Signals: ", "clk=%d", clk);
    buts <= 0;
    res <= 0;
    pause <= 0;
    pwmslider <= 8'b10101010;
    clk <= 1;
end

always 
begin
    #5 clk <= ~clk;
end

always @(posedge clk) 
begin
    $monitor("seconds: %d | hours1: %d | hours2: %d | mins1: %d | mins2: %d", seconds, hours1, hours2, mins1, mins2);
end

endmodule