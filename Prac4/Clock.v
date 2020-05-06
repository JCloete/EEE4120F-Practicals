`timescale 1ns / 1ps



module WallClock(
	input CLK100MHZ,
	input[1:0] buts,
	input res,
	input pause,
	input [7:0] pwmslider,
	output wire [7:0] seg,
	output wire [7:0] segdriv,
	output wire[5:0] LED,
	output wire[1:0] test
    );
    
    reg mTest = 0, hTest = 0;
    assign test[0] = mTest;
    assign test[1] = hTest;
	//Add the reset
    wire resState;
    Delay_Reset Reset1(CLK100MHZ, res, resState);
    
	//Add and debounce the buttons
	wire mState;
	wire hState;
	wire pState;
	Debounce Bounce1(CLK100MHZ, buts[0], mState);
	Debounce Bounce2(CLK100MHZ, buts[1], hState);
	Debounce Bounce3(CLK100MHZ, pause, pState);
	reg pToggle = 0;
	// Instantiate Debounce modules here
	
	// registers for storing the time
    reg [3:0]hours1=4'd0;
	reg [3:0]hours2=4'd0;
	reg [3:0]mins1=4'd0;
	reg [3:0]mins2=4'd0;
    integer counter = 0;
    
    reg [3:0] hours1pwm = 4'd0;
    reg [3:0] hours2pwm = 4'd0;
    reg [3:0] mins1pwm = 4'd0;
    reg [3:0] mins2pwm = 4'd0;
    wire pwm;
    
    reg [5:0]seconds;
    assign LED = seconds;
	//Initialize seven segment
	// You will need to change some signals depending on you constraints
	SS_Driver SS_Driver1(
		//<clock_signal>, <reset_signal>,
		CLK100MHZ, res,
        hours1pwm, hours2pwm, mins1pwm, mins2pwm, // Use temporary test values before adding hours2, hours1, mins2, mins1
        pwmslider, pwm,
        segdriv[3:0], seg //SegmentDrivers, SevenSegment
	);
	
	//The main logic
	always @(posedge CLK100MHZ) begin
		// implement your logic here
		if (pwm) begin
		    hours1pwm <= 4'ha;
		    hours2pwm <= 4'ha;
		    mins1pwm <= 4'ha;
		    mins2pwm <= 4'ha;
		end
		else begin
		    hours1pwm <= hours1;
		    hours2pwm <= hours2;
		    mins1pwm <= mins1;
		    mins2pwm <= mins2;
		end
		if (pState)
		    pToggle <= ~pToggle;
		if (!pause) begin
            if (mState)
                mins2 <= mins2 + 4'b1;
                if (mins2 >= 10) begin
                  mins2 <= 0;
                  mins1 <= mins1 + 1;
                  if (mins1 >= 5 && mins2 == 9) begin
                      mins1 <= 0;
                      hours2 <= hours2 + 1;
                      if (hours2 >= 4 && hours1 >= 2) begin
                          hours1 <= 0;
                          hours2 <= 0;
                      end
                      else if (hours2 >= 10) begin
                          hours2 <= 0;
                          hours1 <= hours1 + 1;
                      end
                   end
               end
            if (hState)
                hours2 <= hours2 + 1;
                  if (hours2 >= 4 && hours1 >= 2) begin
                      hours1 <= 0;
                      hours2 <= 0;
                  end
                  else if (hours2 >= 10) begin
                      hours2 <= 0;
                      hours1 <= hours1 + 1;
                  end
            if (resState) begin
                hours1 <= 0;
                hours2 <= 0;
                mins1 <= 0;
                mins2 <= 0;
            end
            counter <= counter + 1;
            if (counter == 2000000) begin
                counter <= 0;
                seconds <= seconds + 1;
            end
            if (seconds == 59) begin
                seconds <= 0;
                mins2 <= mins2 + 1;
                if (mins2 == 9) begin
                  mins2 <= 0;
                  mins1 <= mins1 + 1;
                  if (mins1 >= 5 && mins2 >= 9) begin
                      mins1 <= 0;
                      hours2 <= hours2 + 1;
                      if (hours2 >= 3 && hours1 == 2) begin
                          hours1 <= 0;
                          hours2 <= 0;
                      end
                      else if (hours2 >= 9) begin
                          hours2 <= 0;
                          hours1 <= hours1 + 1;
                      end
                   end
               end
           end
       end
    end
endmodule  
