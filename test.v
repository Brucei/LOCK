
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


module test();

reg clock,reset;
reg [11:0] Key;
reg set_1;

integer j,k;
reg [39:0] Pressed;
wire [2:0] Col;
wire [3:0] Row;
wire [3:0] Code;

wire OPEN_1;
wire SAVE_LIGHT_1;
wire LOCK_1 ;
wire CHANGE;
wire SET;
wire [15:0] data;

parameter [39:0] None="None";
parameter [39:0] Key_0="Key_0";
parameter [39:0] Key_1="Key_1";
parameter [39:0] Key_2="Key_2";
parameter [39:0] Key_3="Key_3";
parameter [39:0] Key_4="Key_4";
parameter [39:0] Key_5="Key_5";
parameter [39:0] Key_6="Key_6";
parameter [39:0] Key_7="Key_7";
parameter [39:0] Key_8="Key_8";
parameter [39:0] Key_9="Key_9";
parameter [39:0] Key_xing="Key_#";
parameter [39:0] Key_jing="Key_*";

always@(*) begin
    case(Key)
    12'h000: Pressed=None;
    12'h001: Pressed=Key_0;
    12'h002: Pressed=Key_1;
    12'h004: Pressed=Key_2;
    12'h008: Pressed=Key_3;
    12'h010: Pressed=Key_4;
    12'h020: Pressed=Key_5;
    12'h040: Pressed=Key_6;
    12'h080: Pressed=Key_7;
    12'h100: Pressed=Key_8;
    12'h200: Pressed=Key_9;
    12'h400: Pressed=Key_xing;
    12'h800: Pressed=Key_jing;
    default: Pressed=None;
    endcase
end

top_1 top(.reset(reset),.clock(clock),.Key(Key),.set_1(set_1),
            .OPEN_1(OPEN_1),.SAVE_LIGHT_1(SAVE_LIGHT_1),.LOCK_1(LOCK_1),.CHANGE(CHANGE),.SET(SET),.data(data));


initial clock=0;
always #5 clock=~clock;

initial begin
    reset=1;
    set_1=0;

    #100 reset=~reset;//0
    #50 reset=~reset;//1
    #30 set_1=~set_1;
    #40 set_1=~set_1;
    #40 set_1=~set_1;
    #40 set_1=~set_1;
end

initial begin 
    for(k=0;k<=1;k=k+1) begin
        Key=0; #20        
        for(j=0;j<12;j=j+1) begin 
            Key=0;
            #20 Key[j]=1;
            #60 Key=0;
        end
    end
end

endmodule
