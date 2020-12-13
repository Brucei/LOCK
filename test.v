
`timescale 1ns / 1ps
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


module test( );
reg clock,reset;
reg [11:0] Key;
//wire [2:0] Col;
//wire OPEN;
//wire SAVE_LIGHT;
integer j,k;
reg [39:0] Pressed;
reg set_1;
reg write_en_1;
reg [3:0] RAM_addr_1;
//wire  [2:0] count_1;
//wire  [3:0] RAM_1_DATA;
//wire  [3:0] RAM_DATA;
//wire  LOCK;
wire [2:0] Col;
wire [3:0] Row;
wire [3:0] Code;

wire OPEN_1;
wire SAVE_LIGHT_1;
wire   LOCK_1 ;
wire CHANGE;
wire SET;
wire  [15:0] data;

wire S_Row;
wire Valid;

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
always@(Key)
begin
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
default:
Pressed=None;
endcase
end
keypad M1(.Code(Code),.Col(Col),.Valid(Valid),.Row(Row),.S_Row(S_Row),.clock(clock),.reset(reset));
Row_Signal M2(.Col(Col),.Key(Key),.Row(Row));
Synchronizer M3(.clock(clock),.reset(reset),.Row(Row),.S_Row(S_Row));
decider M4(reset,Code,Valid,write_en_1,RAM_addr_1,clock,set_1,OPEN_1,LOCK_1,SAVE_LIGHT_1,CHANGE,SET,data);
//top_1 M5(.Key(Key),/*.Col(Col),*/.reset(reset),.clock(clock),.OPEN(OPEN),.SAVE_LIGHT(SAVE_LIGHT),.LOCK(LOCK),.count_1(count_1),.RAM_1_DATA(RAM_1_DATA),.RAM_DATA(RAM_DATA));
initial
begin
clock=0;
forever #5 clock=~clock;
end

initial
begin
RAM_addr_1=4'b0001;
reset=0;
set_1=0;
write_en_1=0;

  #20 reset=~reset;
   #10 reset=~reset;
    #100 reset=~reset;
     #50 reset=~reset;
#30 set_1=~set_1;
#40 set_1=~set_1;
#40 set_1=~set_1;
#40 set_1=~set_1;
#30 write_en_1=~write_en_1;
end
/*
initial
begin
RAM_addr_1=4'b0000;
#100 RAM_addr_1=4'b0001;
#100 RAM_addr_1=4'b0010;
#100 RAM_addr_1=4'b0011;
#100 RAM_addr_1=4'b0100;
#100 RAM_addr_1=4'b0101;
#100 RAM_addr_1=4'b0110;
#100 RAM_addr_1=4'b0111;
#100 RAM_addr_1=4'b1000;
#100 RAM_addr_1=4'b1001;
#100 RAM_addr_1=4'b1010;
#100 RAM_addr_1=4'b1011;
#100 RAM_addr_1=4'b1100;
#100 RAM_addr_1=4'b1101;
#100 RAM_addr_1=4'b1110;
#100 RAM_addr_1=4'b1111;
end
*/
always@ (posedge clock)
begin
if(RAM_addr_1<=15)
RAM_addr_1=RAM_addr_1+1;
else
RAM_addr_1=4'b0001;
end
initial
begin for(k=0;k<=1;k=k+1)
begin Key=0;
#20 for(j=0;j<=12;j=j+1)
begin Key=0;
#20 Key[j]=1;
#60 Key=0;
end

end
end
endmodule
