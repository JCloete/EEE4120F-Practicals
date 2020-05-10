// Set time and precision
`timescale 1ns / 1ps

module WallClock(
	input CLK100MHZ, //Clock, defined in constraints
	input[1:0] buts, //Push-buttons. buts[0] = button to advance minutes, buts[1] to advance hours
	input res, //Reset button
	input pause, //Pause button. NOT ASKED FOR. I just did it because I could.
	input [7:0] pwmslider, //Set of 8 switches. The 8 switches represent an 8-bit binary number. Higher the number, brighter the display
	output wire [7:0] seg, //7-Segment display screen
	output wire [7:0] segdriv, //Input that defines if a given digit on the 7-Seg is "on". There are 8 digits, we only turn 4 on.
	output wire[5:0] LED //6 LEDs used to diaply the current seconds in binary.
    );
    
	//Add the reset
    wire resState;
    Delay_Reset Reset1(CLK100MHZ, res, resState); //Set up reset function. restState = 1 -> Reset clock
    
	//Add and debounce the buttons
	wire mState; //If high, increment minutes on next cycle
	wire hState; //" "
	wire pState; //While high, pause everything
	Debounce Bounce1(CLK100MHZ, buts[0], mState); //Debounce most buttons
	Debounce Bounce2(CLK100MHZ, buts[1], hState);
	Debounce Bounce3(CLK100MHZ, pause, pState);
	// Instantiate Debounce modules here
	
	// registers for storing the time
    reg [3:0]hours1=4'd0; //Hours tens decimal value
	reg [3:0]hours2=4'd0; //Hours units
	reg [3:0]mins1=4'd0; //Minutes tens
	reg [3:0]mins2=4'd0; //Minutes units
    integer counter = 0; //Internal "clock" threshhold for seconds timescale
    
    reg [3:0] hours1pwm = 4'd0; //Used to actually display things. Will blank out when brightness needs to be adjusted.
    reg [3:0] hours2pwm = 4'd0; //If you don't understand, look up how PWM works.
    reg [3:0] mins1pwm = 4'd0; //Just don't think on it too hard.
    reg [3:0] mins2pwm = 4'd0;
    wire pwm; //Pwm state. Controls blinking
    
    reg [5:0]seconds = 0; //Holds value for seconds
    assign LED = seconds; //Display on the LEDs
	//Initialize seven segment
	// You will need to change some signals depending on you constraints
	SS_Driver SS_Driver1(
		//<clock_signal>, <reset_signal>,
		CLK100MHZ, res,
        hours1pwm, hours2pwm, mins1pwm, mins2pwm,
        pwmslider, pwm,
        segdriv[3:0], seg //SegmentDrivers, SevenSegment
	);
	
	//The main logic
	always @(posedge CLK100MHZ) begin
		// implement your logic here
		if (pwm) begin
		    hours1pwm <= 4'ha; //Turn off to blink if pwm state demands it
		    hours2pwm <= 4'ha;
		    mins1pwm <= 4'ha;
		    mins2pwm <= 4'ha;
		end
		else begin
		    hours1pwm <= hours1; //Otherwise show the relevant number
		    hours2pwm <= hours2;
		    mins1pwm <= mins1;
		    mins2pwm <= mins2;
		end
		if (!pause) begin
            if (mState) //After this is all the logic to track the advancement of time
                mins2 <= mins2 + 4'b1;
                if (mins2 >= 10) begin
                  mins2 <= 0;
                  if (mins1 == 5) begin
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
                   else
                       mins1 <= mins1 + 1;
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
            counter <= counter + 1; //COUNTER LOGIC
            if (counter == 2000000) begin //If we hit 20mil clock cycles, advance seconds
                counter <= 0; //100MHz clock * 20mil cycles = 20ms
                seconds <= seconds + 1; //Therefore clock is 5 times faster than normal
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
