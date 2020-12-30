module SegDisplay(
    input clk,
    input rst_n,
    input Seg_1,
    input Seg_2,
    input Seg_3,
    input Seg_4,
    input count_Wrong,
    
    output reg [7:0] wei,
    output reg [7:0] duan
);    

reg [24:0] count2;
reg clk_xHZ;
reg [7:0] array [0:9];
//parameter reg [7:0] array [0:9] = {
//    8'b11000000,
//    8'b11111001,
//    8'b10100100,
//    8'b10110000,
//    8'b10011001,
//    8'b10010010,
//    8'b10000010,
//    8'b11111000,
//    8'b10000000,
//    8'b10010000
//};

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        clk_xHZ <= 0;
        count2 <= 0;
    end else begin
        if(count2==6250-1) begin 
            clk_xHZ <= ~clk_xHZ;
            count2 <= 25'b0;
        end else
            count2 <= count2+1'b1;
    end
end

always @(posedge clk_xHZ or negedge rst_n) begin
	if(!rst_n) begin
		duan <= 8'bxxxxxxxx;
		wei <= 8'b11111110;
        array[0]=8'b11000000;
		array[1]=8'b11111001;
		array[2]=8'b10100100;
		array[3]=8'b10110000;
		array[4]=8'b10011001;
		array[5]=8'b10010010;
		array[6]=8'b10000010;
		array[7]=8'b11111000;
		array[8]=8'b10000000;
		array[9]=8'b10010000;
	end else begin
		wei <= {wei[0],wei[7:1]};
		case(wei)
			8'b11111110: begin
                if(Seg_1 >= 0 && Seg_1 <= 9) duan <= array[Seg_1];
                else duan <= 8'b11111111;
            end
			8'b11111101:begin
                if(Seg_1 >= 0 && Seg_1 <= 9) duan <= array[Seg_2];
                else duan <= 8'b11111111;
            end
			8'b11111011:begin
                if(Seg_1 >= 0 && Seg_1 <= 9) duan <= array[Seg_3];
                else duan <= 8'b11111111;
            end
			8'b11110111:begin
                if(Seg_1 >= 0 && Seg_1 <= 9) duan <= array[Seg_4];
                else duan <= 8'b11111111;
            end
            8'b01111111:begin
                if(count_Wrong >= 0 && count_Wrong <= 9) duan <= array[count_Wrong];
                else duan <= 8'b11111111;
            end
			default:duan <= 8'b11111111;
		endcase
	end
end

endmodule
