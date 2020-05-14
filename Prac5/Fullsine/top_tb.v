`timescale 10ns/1ps //Represents 100MHz 

module top_tb();
    reg clk;
    
      // Memory IO
    reg ena = 1;
    reg wea = 0;
    reg [7:0] addra=0;
    reg [10:0] dina=0; //We're not putting data in, so we can leave this unassigned
    wire [10:0] douta;
    
    // Instantiate block memory here
    // Copy from the instantiation template and change signal names to the ones under "MemoryIO"
    blk_mem_gen_0 sine_wave (
        .clka(clk),
        .ena(ena),
        .wea(wea),      
        .addra(addra),  
        .dina(dina),    
        .douta(douta)  
    );
    
    initial
    begin
        clk <= 1;
    end
    
    always
    begin
        #1 clk <= ~clk; //Simulated the 100MHz Clock
    end
    
  
    
    always @ (posedge clk)
    begin
        #1493 addra <= addra + 1;
    end
    
endmodule
