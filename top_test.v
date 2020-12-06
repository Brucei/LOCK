
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/14 18:19:36
// Design Name: 
// Module Name: top_test
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


module top_test();
wire [3:0] Code;
wire Valid;
wire [2:0] Col;
wire [3:0] Row;
reg  clock,reset;
reg [15:0] Key;
integer j,k;
reg [39:0] Pressed;
parameter [39:0]  Key_0="Key_0",
                   Key_1="Key_1",
                   Key_2="Key_2",
                   Key_3="Key_3",
                   Key_4="Key_4",
                   Key_5="Key_5",
                   Key_6="Key_6",
                   Key_7="Key_7",
                   Key_8="Key_8",
                   Key_9="Key_9",
                   Key_jing="Key_#",
                   Key_xing="Key_*",
                   None="None";
 always @(Key)
 begin
 case(Key)
 16'h0000:Pressed=None;
 16'h0001:Pressed=Key_0;
 16'h0002:Pressed=Key_1;
 16'h0004:Pressed=Key_2;
 16'h0008:Pressed=Key_3;
 16'h0010:Pressed=Key_4;
 16'h0020:Pressed=Key_5;
 16'h0040:Pressed=Key_6;
 16'h0080:Pressed=Key_7;
 16'h0100:Pressed=Key_8;
 16'h0200:Pressed=Key_9;
 16'h0400:Pressed=Key_xing;
 16'h0800:Pressed=Key_jing;
 default:Pressed=None;
 endcase
 end
 
 keypad M1(Code,Col,Valid,Row,S_Row,clock,reset);
 Row_signal M2(Row,Key,Col);
Synchronizer M3(S_Row,Row,clock,reset);
decider    M4(
 
 
                   
                   
                   
endmodule
