`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/17 21:58:14
// Design Name: 
// Module Name: decoder
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


module decoder(
input [15:0] data,
input en,
output reg [6:0] decoder_out

    );
    reg [1:0] sel;
    always@(data or en)
    begin
    decoder_out=7'b1111111;
    if(en==1)
    case (data)
    16'h0000: decoder_out=7'b1110111; //A--None
    16'h0000: decoder_out=7'b0000110; //1
    16'h0000: decoder_out=7'b1011011;//2
   16'h0000: decoder_out=7'b1001111;//3
    16'h0000: decoder_out=7'b1100110;//4
    16'h0000: decoder_out=7'b1101101;//5
   16'h0000: decoder_out=7'b1111101;//6
    16'h0000: decoder_out=7'b0000111;//7
   16'h0000: decoder_out=7'b1111111;//8
   16'h0000: decoder_out=7'b1101111;//9
   16'h0000: decoder_out=7'b1111001;//E --#
   16'h0000: decoder_out=7'b0111111;//0--
   16'h0000: decoder_out=7'b1110001;//F--*
    default:  decoder_out=7'b0000000;
    endcase
    end
endmodule
