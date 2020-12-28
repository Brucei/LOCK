module top_1(
    input           clock,
    input           reset,
   // input    [11:0] Key,
  input [7:0] conv8,
    input           set_1,
    //output     [6:0] led,
    output           OPEN_1,
    output           SAVE_LIGHT_1,
    output           LOCK_1,
    output           CHANGE,
    output           SET,
 //  output [3:0] dig, //????????????
  //  output  [6:0] dict ,
    output   [15:0]  data,
    output   [3:0]   count_Wrong_1,
	output sel,
	output [6:0] dict
);
wire [2:0] Col;
wire [3:0] Row;
wire [3:0] Code;
wire S_Row;
//wire clk;
wire Valid;
wire [11:0] Key;
//wire [15:0] data;
//virtual key module    
Row_Signal      M2(.clock(clock),.reset(reset),.Col(Col),.Key(Key),.Row(Row));
//clk M6(.clock(clock),.clk(clock),.rst(reset));
//check if Row has output
Synchronizer    M3(.clock(clock),.reset(reset),.Row(Row),.S_Row(S_Row));    
//shift_reg shift_reg(.set_data(data),.clk(clock),.rst(reset),.dig(dig),.dict(dict));
//key scan logic   
keypad1         M1(.Row(Row),.S_Row(S_Row),.clock(clock),.reset(reset),.Code(Code),.Col(Col),.Valid(Valid),.sel(sel),.dict(dict));
decoder M5(.conv8(conv8),.Key(Key));
//main logic
decider         M4(.reset_1(reset),.clk(clock),.Code_1(Code),.Valid_1(Valid),.set(set_1),.S_Row(S_Row),
                    .OPEN(OPEN_1),.LOCK(LOCK_1),.SAVE_LIGHT(SAVE_LIGHT_1),.CHANGE(CHANGE),.SET(SET),.data_1(data),.count_Wrong(count_Wrong_1));
endmodule

