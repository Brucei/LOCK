module top_1(
    input           clock,
    input           reset,
    input    [11:0] Key,
    input           set_1,
    
    output           OPEN_1,
    output           SAVE_LIGHT_1,
    output           LOCK_1,
    output           CHANGE,
    output           SET,
    output   [15:0]  data
);

wire [2:0] Col;
wire [3:0] Row;
wire [3:0] Code;
wire S_Row;
wire Valid;

//virtual key module    
Row_Signal      M2(.clock(clock),.reset(reset),.Col(Col),.Key(Key),.Row(Row));

//check if Row has output
Synchronizer    M3(.clock(clock),.reset(reset),.Row(Row),.S_Row(S_Row));    

//key scan logic   
keypad1         M1(.Row(Row),.S_Row(S_Row),.clock(clock),.reset(reset),.Code(Code),.Col(Col),.Valid(Valid));

//main logic
decider         M4(.reset_1(reset),.clk(clock),.Code_1(Code),.Valid_1(Valid),.set(set_1),.S_Row(S_Row),
                    .OPEN(OPEN_1),.LOCK(LOCK_1),.SAVE_LIGHT(SAVE_LIGHT_1),.CHANGE(CHANGE),.SET(SET),.data_1(data));
endmodule
