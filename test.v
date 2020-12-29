
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

reg [7:0] conv8;
reg set_1;



wire OPEN_1;
wire SAVE_LIGHT_1;
wire LOCK_1 ;
wire CHANGE;
wire SET;
wire [15:0] data;
wire [3:0] count_Wrong_1;
//wire [6:0] led;
wire sel;
wire [6:0] dict;
//wire  [3:0] dig; //????????????
//wire  [6:0] dict ;
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
/*
always@(*) begin
    case(Key)
    12'b0000_0000_0000: Pressed=None;
    12'b0000_0000_0001: Pressed=Key_1;
    12'b0000_0000_0010: Pressed=Key_2;
    12'b0000_0000_0100: Pressed=Key_3;
    12'b0000_0000_1000: Pressed=Key_4;
    12'b0000_0001_0000: Pressed=Key_5;
    12'b0000_0010_0000: Pressed=Key_6;
    12'b0000_0100_0000: Pressed=Key_7;
    12'b0000_1000_0000: Pressed=Key_8;
    12'b0001_0000_0000: Pressed=Key_9;
    12'b0010_0000_0000: Pressed=Key_jing;
    12'b0100_0000_0000: Pressed=Key_0;
    12'b1000_0000_0000: Pressed=Key_xing;
    default: Pressed=None;
    endcase
end
*/
top_1 top(.reset(reset),/*.Key(Key),*/.clock(clock),.set_1(set_1),.conv8(conv8),
            .OPEN_1(OPEN_1),.SAVE_LIGHT_1(SAVE_LIGHT_1),.LOCK_1(LOCK_1),.CHANGE(CHANGE),.SET(SET),.data(data),.count_Wrong_1(count_Wrong_1),.dict(dict),.sel(sel));


initial clock=0;
always #5 clock=~clock;

initial begin


conv8=8'b00101000;//0


    reset=1;
    set_1=0;
   // Key=12'b0000_0000_0000;//None
    #20 reset=~reset;//0
    #100 reset=~reset;//1
	
    #100 conv8 = 8'b00100001;//2
    #1000 conv8 = 8'b0;
    #100 conv8 = 8'b01000010;//4
    #1000conv8 = 8'b0;
    #100 conv8 = 8'b00010001;//3
    #1000 conv8 = 8'b0;
    #100 conv8 = 8'b00010001;//3
    #1000 conv8 = 8'b0;
    #100 conv8 = 8'b01001000;//#
    #1000 conv8 = 8'b0;
	
    #100 conv8 = 8'b00100001;//2
    #1000 conv8 = 8'b0;
    #100 conv8 = 8'b01000010;//4
    #1000 conv8 = 8'b0;
    #100 conv8 = 8'b00010001;//3
    #1000 conv8 = 8'b0;
    #100 conv8 = 8'b01000001;//1
    #1000 conv8 = 8'b0;
    #100 conv8 = 8'b01001000;//#
    #1000 conv8 = 8'b0;
	$stop;
end



endmodule

