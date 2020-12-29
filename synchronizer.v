
module Synchronizer(
    input       [3:0]   Row,
    input               clock,
    input               reset,
    
    output              S_Row
);

reg [3:0]   Row_r;
reg         en_delay;
reg [19:0]  delay;		
parameter CNT_MAX = 999_999;
localparam SCAN     = 5'b00001,
localparam JUDGE  	= 5'b00010,
localparam FILTER0 	= 5'b00100,
localparam DOWN		= 5'b01000,
localparam FILTER1	= 5'b10000;

//Sync	
always@(posedge clock or negedge reset) begin
    if(!reset)
        Row_r <= 0;
    else 
        Row_r <= Row;
end
		
//FSM_Part1		
always@(posedge clock or negedge reset) begin
    if(!reset)
        c_state <= JUDGE;
    else 
        c_state <= n_state;
end

//FSM_Part2	
always@(*) begin
	n_state = 5'bxxxxx;
	case(c_state)
		JUDGE:begin
			if(Row_r != 4'b0000) n_state = FILTER0;
			else n_state = JUDGE;
		end			
		FILTER0:begin
			if(delay > CNT_MAX) begin
				if(Row_r != 4'b0000) n_state = DOWN;
				else n_state = JUDGE;
			end else
                n_state = c_state;                    
		end
        DOWN:begin
            if(Row_r == 4'b0000) n_state = FILTER1;
            else n_state = c_state;
        end        
        FILTER1:begin
            if(delay > CNT_MAX) begin
				if(Row_r != 4'b0000) n_state = DOWN;
				else n_state = JUDGE;
			end else
				n_state = c_state;
		end
		default:n_state = JUDGE;
	endcase
end 

//状态机第三段
always@(posedge clock or negedge reset) begin
	if(!reset) begin
		en_delay <= 0;
		S_Row <= 0;
	end else begin
		case(n_state)
			JUDGE:begin
                en_delay <= 0;
                S_Row <= 0;
			end			
			FILTER0:begin
				en_delay <= 1;
				if((delay > CNT_MAX-1)&&(Row_r != 4'b1111)) S_Row <= 1;
				else S_Row <= 0;
			end 
			
			DOWN:begin
				en_delay <= 0;
                S_Row <= 0;     //S_Row keeps only for one clock
			end 
				
			FILTER1:begin
				en_delay <= 1;
			end
            
			default:;
		endcase
	end	
end

//抖动20ms的时间计数		
always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
        delay <= 0;
    else if(en_delay) begin
        if(delay > CNT_MAX) delay <= 0;
        else delay <= delay + 1'b1;
    end else 
        delay <= 0;
end

endmodule
