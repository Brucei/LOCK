module Row_Signal(
    //input       [7:0] con8,
    input       [11:0]  Key,    //virtual key input
    input       [2:0]   Col,
    input 				clock,
    input				reset,
    output reg  [3:0]   Row
);
//reg [11:0] Key;
/*
always @(con8,Key,Row)
begin
Row[0]=Key[0]&&Col[0]||Key[1]&&Col[1]||Key[2]&&Col[2];
    Row[1]=Key[3]&&Col[0]||Key[4]&&Col[1]||Key[5]&&Col[2];
    Row[2]=Key[6]&&Col[0]||Key[7]&&Col[1]||Key[8]&&Col[2];
    Row[3]=Key[9]&&Col[0]||Key[10]&&Col[1]||Key[11]&&Col[2];
case(con8)
8'b01000001:Key=12'b0000_0000_0001;//1
8'b00100001:Key=12'b0000_0000_0010;//2
8'b00010001:Key=12'b0000_0000_0100;//3
8'b01000010:Key=12'b0000_0000_1000;//4
8'b00100010:Key=12'b0000_0001_0000;//5
8'b00010010:Key=12'b0000_0010_0000;//6
8'b01000100:Key=12'b0000_0100_0000;//7
8'b00100100:Key=12'b0000_1000_0000;//8
8'b00010100:Key=12'b0001_0000_0000;//9
8'b01001000:Key=12'b0010_0000_0000;//#
8'b00101000:Key=12'b0100_0000_0000;//0
8'b00011000:Key=12'b1000_0000_0000;//*
default:Key=12'b0100_0000_0000;//0
endcase
end
*/

always @(*) begin
    Row[0]=Key[0]&&Col[0]||Key[1]&&Col[1]||Key[2]&&Col[2];
    Row[1]=Key[3]&&Col[0]||Key[4]&&Col[1]||Key[5]&&Col[2];
    Row[2]=Key[6]&&Col[0]||Key[7]&&Col[1]||Key[8]&&Col[2];
    Row[3]=Key[9]&&Col[0]||Key[10]&&Col[1]||Key[11]&&Col[2];
end

endmodule

