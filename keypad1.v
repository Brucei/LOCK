 module keypad1(
    input       [3:0]   Row,
    input               S_Row,
    input               clock,
    input               reset,
    
    output reg  [3:0]   Code,
    output reg  [2:0]   Col,
    output reg          Valid
);
reg Valid_1,Valid_2;
reg Code_OK;
reg[4:0] state,next_state;
parameter S_0=5'b00001;
parameter S_1=5'b00010;
parameter S_2=5'b00100;
parameter S_3=5'b01000;
parameter S_4=5'b10000;

always @(posedge clock or negedge reset) begin
    if(!reset)
        Valid <= 0;
    else
        Valid <= ((next_state==S_1)||(next_state==S_2)||(next_state==S_3))&&S_Row;
end

always @(posedge clock or negedge reset) begin
    if(!reset)
        Code=4'bxxxx;
    //else if(Code_OK) begin
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
            default:Code=4'bxxxx;
        endcase
    end
end

always @(posedge clock,negedge reset) begin
    if(!reset) 
        state<=S_0;
    else 
        state<=next_state;
end

always@(negedge clock or negedge reset) begin 
    if(!reset)
        Col<=3'b000;
    else begin
        case(state)
            S_0:begin 
                Code_OK = 0;
                if(S_Row) begin next_state<=S_1; Col<=3'b001; end
                else begin next_state<=S_0; Col<=3'b111; end 
            end
            S_1:begin  
                Code_OK = 0;
                if(S_Row) begin next_state=S_4; Col<=3'b111; end
                else begin next_state=S_2; Col<=3'b010; end
            end
            S_2:begin  
                Code_OK = 0;
                if(S_Row) begin next_state=S_4; Col<=3'b111; end
                else begin next_state=S_3; Col<=3'b100; end
            end
            S_3:begin 
                Code_OK = 0;
                if(S_Row) begin next_state=S_4; Col<=3'b111; end
                else begin next_state=S_0; Col<=3'b111; end 
            end
            S_4:begin 
                Code_OK = 1;
                if(!S_Row) begin next_state=S_0; Col<=3'b111; end
                else begin next_state=S_4; Col<=3'b111; end
            end
            default:next_state=S_0;
        endcase
    end
end

endmodule
