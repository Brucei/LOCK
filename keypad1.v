 module keypad(
    output reg  [3:0]   Code,
    output reg  [2:0]   Col,
    output              Valid,
    input       [3:0]   Row,
    input               S_Row,
    input               clock,
    input               reset
);

reg[4:0] state,next_state;
parameter S_0=5'b00001;
parameter S_1=5'b00010;
parameter S_2=5'b00100;
parameter S_3=5'b01000;
parameter S_4=5'b10000;

assign Valid=((state==S_1)||(state==S_2)||(state==S_3))&&Row;

always @(Row,Col) begin
    case({Row,Col})
        7'b0001_001: Code=1;
        7'b0001_010: Code=2;
        7'b0001_100: Code=3;
        7'b0010_001: Code=4;
        7'b0010_010: Code=5;
        7'b0010_100: Code=6;
        7'b0100_001: Code=7;
        7'b0100_010: Code=8;
        7'b0100_100: Code=9;
        7'b1000_001: Code=10;
        7'b1000_010: Code=0;
        7'b1000_100: Code=11;
        default:     Code=0;
    endcase
end

always @(posedge clock,posedge reset) begin
    if(reset==1'b1) state<=S_0;
    else state<=next_state;
end

always@(state,S_Row,Row) begin 
    next_state=S_0;
    Col=0;
    case(state)
        S_0:begin Col=7; if(S_Row) next_state=S_1;end
        S_1:begin Col=1; if(Row) next_state=S_4;else next_state=S_2;end
        S_2:begin Col=2; if(Row) next_state=S_4;else next_state=S_3;end
        S_3:begin Col=4; if(Row) next_state=S_4;else next_state=S_0;end
        S_4:begin Col=7; if(S_Row==0) next_state=S_0; else next_state=S_4; end
        default:next_state=S_0;
    endcase
end

endmodule
