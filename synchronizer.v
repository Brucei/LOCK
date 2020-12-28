module Synchronizer(
    input       [3:0]   Row,
    input               clock,
    input               reset,
    
    output     reg        S_Row
);
reg [3:0]  Row_1;
reg [23:0] cnt;
wire change;
parameter jitter=23'h1E8480;

always @(posedge clock)
if(!reset)
Row_1<=0;
else
Row_1<=Row;

assign change=(Row&!Row_1)|(!Row&Row_1);
always@(posedge clock)
if(!reset)
cnt<=0;
else if(change) cnt<=0;
else cnt<=cnt+1;

always @(posedge clock)
if(!reset)
S_Row<=1;
else if(cnt==jitter-1)
S_Row<=Row_1[0]||Row_1[1]||Row_1[2]||Row_1[3];
endmodule
