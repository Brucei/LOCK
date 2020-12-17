
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
reg [11:0] Key;
reg set_1;

reg [39:0] Pressed;

wire OPEN_1;
wire SAVE_LIGHT_1;
wire LOCK_1 ;
wire CHANGE;
wire SET;
wire [15:0] data;
wire [3:0] count_Wrong_1;

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

top_1 top(.reset(reset),.clock(clock),.Key(Key),.set_1(set_1),
            .OPEN_1(OPEN_1),.SAVE_LIGHT_1(SAVE_LIGHT_1),.LOCK_1(LOCK_1),.CHANGE(CHANGE),.SET(SET),.data(data),.count_Wrong_1(count_Wrong_1));


initial clock=0;
always #5 clock=~clock;

initial begin
    reset=1;
    set_1=0;
    Key=12'b0000_0000_0000;//None
    #100 reset=~reset;//0
    #50 reset=~reset;//1
	
    #100 Key = 12'b0000_0000_0010;//2
    #100 Key = 0;
    #100 Key = 12'b0000_0000_1000;//4
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0100;//3
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0100;//3
    #100 Key = 0;
    #100 Key = 12'b0010_0000_0000;//#
    #1000 Key = 0;
	
	#100 Key = 12'b0000_0000_0010;//2
    #100 Key = 0;
    #100 Key = 12'b0000_0000_1000;//4
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0100;//3
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0001;//1
    #100 Key = 0;
    #100 Key = 12'b0010_0000_0000;//#
	#1000 Key = 0;
	   
	#100 Key = 12'b0000_0000_0001;//1
    #100 Key = 0;
    #100 Key = 12'b0000_0000_1000;//4
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0100;//3
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0100;//3
    #100 Key = 0;
    #100 Key = 12'b0010_0000_0000;//#
	#1000 Key = 0;
	
	#100 Key = 12'b0000_0000_0010;//2
    #100 Key = 0;
    #100 Key = 12'b0000_0000_1000;//4
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0100;//3
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0010;//2
    #100 Key = 0;
    #100 Key = 12'b0010_0000_0000;//#
    #1000 Key = 0;
	
	#1000 set_1 = 1;
	#1000 set_1 = 0;
	
	#100 Key = 12'b0000_0000_0001;//1
    #100 Key = 0;
    #100 Key = 12'b0000_0000_1000;//4
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0100;//3
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0100;//3
    #100 Key = 0;
    #100 Key = 12'b0010_0000_0000;//#
	#1000 Key = 0;
	
	#100 Key = 12'b0000_0000_0001;//1
    #100 Key = 0;
    #100 Key = 12'b0000_0000_1000;//4
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0100;//3
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0100;//3
    #100 Key = 0;
    #100 Key = 12'b0010_0000_0000;//#
	#1000 Key = 0;
	
	#100 Key = 12'b0000_0000_0001;//1
    #100 Key = 0;
    #100 Key = 12'b0000_0000_1000;//4
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0100;//3
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0100;//3
    #100 Key = 0;
    #100 Key = 12'b1000_0000_0000;//*
	#1000 Key = 0;
	
	#100 Key = 12'b0000_0000_0001;//1
    #100 Key = 0;
    #100 Key = 12'b0000_0010_0000;//6
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0100;//3
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0100;//3
    #100 Key = 0;
    #100 Key = 12'b0010_0000_0000;//#
	#1000 Key = 0;
	
	#100 Key = 12'b0000_0000_0001;//1
    #100 Key = 0;
    #100 Key = 12'b0000_0010_0000;//6
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0100;//3
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0100;//3
    #100 Key = 0;
    #100 Key = 12'b0010_0000_0000;//#
	#1000 Key = 0;
/*
	#100 Key = 12'b0000_0000_0010;//2
	#100 Key = 0;
	#100 Key = 12'b0000_0000_1000;//4
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0100;//3
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0010;//2
	#100 Key = 0;
	#100 Key = 12'b1000_0000_0000;//*
    #100 Key = 0;

    #100 Key = 12'b0100_0000_0000;//0
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0001;//1
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0001;//1
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0100;//3
    #100 Key = 0;
    #100 Key = 12'b0010_0000_0000;//#
    #100 Key = 0;
    #100 Key = 12'b0100_0000_0000;//0
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0001;//1
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0010;//2
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0100;//3
    #100 Key = 0;
    #100 Key = 12'b0010_0000_0000;//#
    #100 Key = 0;

 #100 Key = 12'b0100_0000_0000;//0
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0001;//1
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0100;//3
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0100;//3
    #100 Key = 0;
    #100 Key = 12'b0010_0000_0000;//#
    #100 Key = 0;
	
    #100 Key = 12'b0100_0000_0000;//0
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0001;//1
    #100 Key = 0;
    #100 Key = 12'b0000_0000_1000;//4
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0100;//3
    #100 Key = 0;
    #100 Key = 12'b0010_0000_0000;//#
	 #100 Key = 0;
	 
	#100 Key = 12'b0100_0000_0000;//0
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0001;//1
    #100 Key = 0;
    #100 Key = 12'b0000_0000_1000;//4
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0100;//3
    #100 Key = 0;
    #100 Key = 12'b0010_0000_0000;//#
	#100 Key = 0;
	
	#100 Key = 12'b0100_0000_0000;//0
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0001;//1
    #100 Key = 0;
    #100 Key = 12'b0000_0000_1000;//4
    #100 Key = 0;
    #100 Key = 12'b0000_0000_0100;//3
    #100 Key = 0;
    #100 Key = 12'b0010_0000_0000;//#
    #100 Key = 0;
	*/
	$stop;
end



endmodule
