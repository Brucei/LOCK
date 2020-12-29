module top_1(
    input           clock,
    input           reset,
    input   [3:0]   row,
    input           set_1,
       
    output          OPEN_1,
    output          SAVE_LIGHT_1,
    output          LOCK_1,
    output          CHANGE,
    output          SET,

    output          sel,
	output  [7:0]   wei,
    output  [2:0]   col    
);

wire [3:0] Code;
wire S_Row;
wire Valid;
wire [15:0]  data;
wire [3:0]   count_Wrong_1;
wire [3:0]   seg_1;
wire [3:0]   seg_2;
wire [3:0]   seg_3;
wire [3:0]   seg_4;

assign S_Row = (row[0]||row[1]||row[2]||row[3]);

//key scan logic     
keypad1         M1(.clk(clock),.rst_n(reset),.row(row),.key_flag(Valid),.key_value(Code),.col(col));

//main logic
decider         M4(.reset_1(reset),.clk(clock),.Code_1(Code),.Valid_1(Valid),.set(set_1),.S_Row(S_Row),
                    .OPEN(OPEN_1),.LOCK(LOCK_1),.SAVE_LIGHT(SAVE_LIGHT_1),.CHANGE(CHANGE),.SET(SET),
                    .data_1(data),.count_Wrong(count_Wrong_1),.Seg_1(seg_1),.Seg_2(seg_2),.Seg_3(seg_3),.Seg_4(seg_4));
                    
SegDisplay      M6(.clk(clock),.rst_n(reset),.Seg_1(seg_1),.Seg_2(seg_2),.Seg_3(seg_3),.Seg_4(seg_4),.count_Wrong(count_Wrong_1),
                    .wei(wei),.duan(duan));
endmodule

