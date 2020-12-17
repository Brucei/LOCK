module Synchronizer(
    input       [3:0]   Row,
    input               clock,
    input               reset,
    
    output        reg      S_Row
);
reg [23:0] cnt;
localparam TIME=24'h1E8480;
reg key_cnt;
always @(posedge clock or negedge reset) begin
        if(reset == 0)
            S_Row <= 0;
        else if(cnt == TIME - 1)
            S_Row<= (Row[0]||Row[1]||Row[2]||Row[3]);
    end
	always @(posedge clock or negedge reset) begin
        if(reset == 0)
            cnt <= 0;
        else if(key_cnt)
            cnt <= cnt + 1'b1;
        else
            cnt <= 0; 
    end
	always @(posedge clock or negedge reset) begin
            if(reset == 0)
                key_cnt <= 0;
            else if(key_cnt == 0 && Row != S_Row)
                key_cnt <= 1;
            else if(cnt == TIME - 1)
                key_cnt <= 0;
     end
//assign S_Row = (Row[0]||Row[1]||Row[2]||Row[3]);
endmodule
