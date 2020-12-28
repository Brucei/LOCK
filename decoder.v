module decoder(input [7:0] conv8,
output reg [11:0] Key
);
always @(*)
begin
case(conv8)
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
endmodule
