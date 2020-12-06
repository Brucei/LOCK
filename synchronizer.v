module Synchronizer(output reg S_Row,input [3:0] Row,input clock,reset);
reg A_Row;
always @(negedge clock,posedge reset)
begin
if(reset==1'b1)
begin 
A_Row<=0;
S_Row<=0;
end
else
begin
A_Row<=(Row[0]||Row[1]||Row[2]||Row[3]);
S_Row<=A_Row;
end
end
endmodule
