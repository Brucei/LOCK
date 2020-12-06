`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/15 20:51:09
// Design Name: 
// Module Name: top_1
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


module top_1(
    input       [11:0]  Key,
    input               reset,
    input               clock,
    output reg          OPEN,
    output reg          SAVE_LIGHT
);

wire [2:0] Col;
wire [3:0] Row;
wire [3:0] Code;
wire OPEN_1;
wire SAVE_LIGHT_1;
wire S_Row;
wire Valid;

assign OPEN_1=OPEN;
assign SAVE_LIGHT_1=SAVE_LIGHT;   

keypad M1(.Code(Code),.Col(Col),.Valid(Valid),.Row(Row),.S_Row(S_Row),.clock(clock),.reset(reset));
Row_Signal M2(.Col(Col),.Key(Key),.Row(Row));
Synchronizer M3(.clock(clock),.reset(reset),.Row(Row),.S_Row(S_Row));
decider M4(.OPEN(OPEN_1),.SAVE_LIGHT(SAVE_LIGHT_1),.Code_1(Code),.reset_1(reset),.Valid_1(Valid),.clk(clock));

endmodule
