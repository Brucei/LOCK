 module keypad1(
    input       [3:0]   Row,
    input               S_Row,
    input               clock,
    input               reset,
    
    output reg  [3:0]   Code,
    output reg  [2:0]   Col,
    output              Valid
);
reg Valid_1;
reg[4:0] state,next_state;
parameter S_0=5'b00001;
parameter S_1=5'b00010;
parameter S_2=5'b00100;
parameter S_3=5'b01000;
parameter S_4=5'b10000;

always@ (posedge clock)
begin
Valid_1<=((state==S_1)||(state==S_2)||(state==S_3))&&Row;
end

assign Valid=Valid_1;

always @(posedge clock or negedge reset) begin
    if(!reset)
        Code = 0;
    else begin
        case({Row,Col})
            7'b0001_001: Code=1;    //1
            7'b0001_010: Code=2;    //2
            7'b0001_100: Code=3;    //3
            7'b0010_001: Code=4;    //4
            7'b0010_010: Code=5;    //5
            7'b0010_100: Code=6;    //6
            7'b0100_001: Code=7;    //7
            7'b0100_010: Code=8;    //8
            7'b0100_100: Code=9;    //9
            7'b1000_001: Code=10;   //#
            7'b1000_010: Code=0;    //0
            7'b1000_100: Code=11;   //*
            default:     Code=0;
        endcase
    end
end

always @(posedge clock,negedge reset) begin
    if(!reset) 
        state<=S_0;
    else 
        state<=next_state;
end

always@(*) begin 
    next_state=S_0;
    case(state)
        S_0:begin Col=3'b111; if(S_Row==1) next_state=S_1;else next_state=S_0;end
        S_1:begin Col=3'b001; if(Row) next_state=S_4;else next_state=S_2;end
        S_2:begin Col=3'b010; if(Row) next_state=S_4;else next_state=S_3;end
        S_3:begin Col=3'b100; if(Row) next_state=S_4;else next_state=S_0;end
        S_4:begin Col=3'b111; if(S_Row==0) next_state=S_0;else next_state=S_4;end
        default:next_state=S_0;
    endcase
end

endmodule
