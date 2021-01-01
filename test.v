
`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/15 21:10:57
// Design Name: 
// Module Name: test
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


module test_3();

reg clock,reset;
reg set_1;
reg [3:0] row;
reg [15:0] myrand;

wire OPEN_1;
wire SAVE_LIGHT_1;
wire LOCK_1 ;
wire CHANGE;
wire SET;

wire [7:0] duan;
wire [7:0] wei;
wire [2:0] col;

top_1 top(  .reset(reset),.clock(clock),.set_1(set_1),.row(row),
            .OPEN_1(OPEN_1),.SAVE_LIGHT_1(SAVE_LIGHT_1),.LOCK_1(LOCK_1),
            .CHANGE(CHANGE),.SET(SET),.wei(dict),.duan(sel),.col(col) );

initial clock = 1;
always #10 clock = ~clock;

initial begin
    reset = 0;
    row = 4'b1111;
    #201;
    reset = 1;
    #300;
    press;
    
    #1000;
    press;
    
    #1000;
    press;
    
    #1000;
    press;
    
    #2000;
    $stop;      
end

task press;
begin
    repeat(30) begin
        myrand = {$random}%1023;
        #myrand row[1] = ~row[1];
    end 
    
    row = 4'b1101;  
    #21_000;
            
    repeat(30) begin
        myrand = {$random}%1023;
        #myrand row[1] = ~row[1];
    end 
    
    row = 4'b1111;
    #21_000;
end
endtask  

endmodule

