//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/05 19:15:55
// Design Name: 
// Module Name: decider
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
//code    #      *      0       1      2       3        4        5        6         7        8        9
//       1010  1011    0000   0001    0010   0011     0100     0101     0110      0111      1000     1001
module decider(
    input reset_1,       
    input clk,
    input [3:0] Code_1,             //scanned key 
    input Valid_1,                  //key valid     
    input set,
    input S_Row,
    
    output reg OPEN,
    output reg LOCK,
    output reg SAVE_LIGHT,
    output reg SET,
    output reg CHANGE,
    output reg [15:0] data_1,        //4key x 4bit
    output reg [3:0] count_Wrong
);
                                           
reg [4:0] state_1;
reg [4:0] next_state_1;
reg [4:0] state_2;
reg [4:0] next_state_2;
reg [3:0] RAM [0:9];    //10x 4bits RAM
reg [3:0] RAM_1 [0:3];   //4x 4bits RAM
integer i;
wire WAIT_Done;

parameter B_0=5'b00001;   //LOCK
parameter B_1=5'b00010;   //OPEN 
parameter B_2=5'b00100;   //SAVE
parameter B_3=5'b01000;   //SET
parameter B_4=5'b10000;   //CHANGE
parameter B_5=5'b00011;  
parameter B_6=5'b00111;   

parameter WAIT_KEY1=5'b00001;   //KEY1
parameter WAIT_KEY2=5'b00010;   //KEY2
parameter WAIT_KEY3=5'b00100;   //KEY3
parameter WAIT_KEY4=5'b01000;   //KEY4
parameter WAIT_KEY5=5'b10000;   //KEY_OP

assign WAIT_Done = (state_2 == WAIT_KEY5)&&(next_state_2 == WAIT_KEY1);

always @(posedge clk or negedge reset_1) begin
    if(!reset_1) begin
        state_2 <= WAIT_KEY1;
    end else
        state_2 <= next_state_2;
end

always@(posedge Valid_1 or negedge reset_1) begin  //change state at each up-rising of Valid_1
	if(!reset_1)
		next_state_2 <= WAIT_KEY1;
   	else begin
	    case(state_2)
	        WAIT_KEY1:begin if(Valid_1) next_state_2=WAIT_KEY2;end
	        WAIT_KEY2:begin if(Valid_1) next_state_2=WAIT_KEY3;end
	        WAIT_KEY3:begin if(Valid_1) next_state_2=WAIT_KEY4;end
	        WAIT_KEY4:begin if(Valid_1) next_state_2=WAIT_KEY5;end
	        WAIT_KEY5:begin if(Valid_1) next_state_2=WAIT_KEY1;end
	        default:next_state_2=WAIT_KEY1;
	    endcase
	end	
end

always@(negedge clk or negedge reset_1) begin
    if(!reset_1) begin
        for(i=0;i<5;i=i+1) RAM[i] <= 0;
    end
    else begin
        case(state_2)
        WAIT_KEY1:begin RAM[1]<=Code_1;end
        WAIT_KEY2:begin RAM[2]<=Code_1;end
        WAIT_KEY3:begin RAM[3]<=Code_1;end
        WAIT_KEY4:begin RAM[4]<=Code_1;end
        WAIT_KEY5:begin RAM[0]<=Code_1;end
        default:;
        endcase
    end
end

always @(posedge clk or negedge reset_1) begin
    if(!reset_1) begin
        state_1 <= B_0;
    end else
        state_1 <= next_state_1;
end

always@(*) begin
	if(!reset_1) 
		next_state_1=B_0;
    else begin
	    case(state_1)
	    B_0: begin   //LOCK state
	    if((set)&&(!S_Row))
	        next_state_1=B_3;                    //jump to SET state 
	    else if((RAM[1]==RAM_1[0])&&(RAM[2]==RAM_1[1])&&
	            (RAM[3]==RAM_1[2])&&(RAM[4]==RAM_1[3])&&
	            (RAM[0]==4'b1010) && WAIT_Done)         //if input code is the same as the initial code 
	        next_state_1=B_1; 
	    else if((RAM[1]==RAM_1[0])&&(RAM[2]==RAM_1[1])&&
	            (RAM[3]==RAM_1[2])&&(RAM[4]==RAM_1[3])&&
	            (RAM[0]==4'b1011)&& WAIT_Done)   //input the correct code and end with "*" ,jump into SAVE state
	        next_state_1=B_2;   
	    else if(((RAM[1]!=RAM_1[0])||(RAM[2]!=RAM_1[1])||
			     (RAM[3]!=RAM_1[2])||(RAM[4]!=RAM_1[3]))&& WAIT_Done)
			next_state_1=B_6;                   //if input wrong password
	    else 
	        next_state_1=B_0;                   //jump into LOCK state
	    end  
	              
	    B_1: begin  //OPEN state    
	    if((set)&&(!S_Row))
	        next_state_1=B_3;                //jump to SET state    
	    else if((RAM[0]==4'b1010) &&(S_Row)&&(!set))    //keep pushing "#" ,hold open state 
	        next_state_1=B_1;         
	    else             
	        next_state_1=B_0;               
	    end

	    B_2: begin  //SAVE state
	    if((set)&&(!S_Row))               //jump to SET state
	        next_state_1=B_3;
	    else if((RAM[0]==4'b1010)&&WAIT_Done)   //first input password end with '#'
	        next_state_1=B_4;
	    else
	        next_state_1=B_2;
	    end

	    B_3: begin  //SET state
	    if(!set)   
	        next_state_1=B_2;
	    else
	        next_state_1=B_3;
	    end

	    B_4: begin  //CHANGE state
	    if((set)&&(!S_Row))               //jump to SET state
	        next_state_1=B_3;
	    else if((RAM[1]==RAM[6])&&(RAM[2]==RAM[7])&&
	            (RAM[3]==RAM[8])&&(RAM[4]==RAM[9])&&    //if second input password same as first
	            (RAM[0]==4'b1010)&&WAIT_Done)
	        next_state_1=B_5;
        else if(((RAM[1]!=RAM[6])||(RAM[2]!=RAM[7])||
        		 (RAM[3]!=RAM[8])||(RAM[4]!=RAM[9]))&&    //if second input password not same as first
            	(RAM[0]==4'b1010)&&WAIT_Done)
        	next_state_1=B_2;
	    else
	        next_state_1=B_4;
	    end

	    B_5: begin
	        next_state_1=B_0;
	    end

	    B_6: begin
	    	next_state_1=B_0;
	    end
	    endcase
    end
end

always@(posedge clk or negedge reset_1) begin
    if(!reset_1) begin
        OPEN<=1'b0;
        SAVE_LIGHT<=1'b0;
        LOCK<=1'b1;
        SET<=1'b0;
        CHANGE<=1'b0;
        data_1 <= 16'h0000;
        count_Wrong <= 4'b0000;
        for(i=6;i<10;i=i+1) RAM[i] <= 0;
        RAM_1[0] = 4'b0010;     //2
        RAM_1[1] = 4'b0100;     //4
        RAM_1[2] = 4'b0011;     //3
        RAM_1[3] = 4'b0010;     //2
    end 
    else begin
        case(next_state_1)
        B_0: begin
	        OPEN<=1'b0;
	        SAVE_LIGHT<=1'b0;
	        LOCK<=1'b1;
	        SET<=1'b0;
	        CHANGE<=1'b0;
	        data_1<={RAM[4],RAM[3],RAM[2],RAM[1]};
        end

        B_1: begin
	        OPEN<=1'b1;
	        SAVE_LIGHT<=1'b0;
	        LOCK<=1'b0;
	        SET<=1'b0;
	        CHANGE<=1'b0;
	        count_Wrong <= 4'b0000;
	        data_1<={RAM[4],RAM[3],RAM[2],RAM[1]};
        end

        B_2: begin
	        OPEN<=1'b0;
	        SAVE_LIGHT<=1'b1;
	        LOCK<=1'b1;
	        SET<=1'b0;		
	        CHANGE<=1'b0;	
	        RAM[6]<=RAM[1];RAM[7]<=RAM[2];
	        RAM[8]<=RAM[3];RAM[9]<=RAM[4];
	        data_1<={RAM[4],RAM[3],RAM[2],RAM[1]};
        end
        
        B_3: begin
	        OPEN<=1'b0;
	        SAVE_LIGHT<=1'b0;
	        LOCK<=1'b1;
	        SET<=1'b1;
	        CHANGE<=1'b0;
	        RAM[0]=4'bxxxx;
        end

        B_4: begin
	        OPEN<=1'b0;
	        SAVE_LIGHT<=1'b1;
	        LOCK<=1'b1;
	        SET<=1'b0;
	        CHANGE<=1'b1;
	        data_1<={RAM[4],RAM[3],RAM[2],RAM[1]};
        end

        B_5: begin
        	RAM_1[0]<= RAM[6];RAM_1[1]<= RAM[7];
	        RAM_1[2]<= RAM[8];RAM_1[3]<= RAM[9];        
        end

        B_6: begin
        	count_Wrong = count_Wrong + 1;
        end
        endcase
    end
end

endmodule
