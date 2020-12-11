

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
//       1011  1010    0000   0001    0010   0011     0100     0101     0110      0111      1000     1001
module decider(
input reset_1,       
input [3:0] Code_1, 
input Valid_1,     
input write_en,
input  [3:0] RAM_addr,
input clk,
input set,
output reg OPEN,
output reg  LOCK,
output reg SAVE_LIGHT,
output reg SET,
output reg CHANGE,
output reg [15:0] data_1
    );  
    integer i;                                               
reg [3:0] state_1;
reg [3:0] next_state_1;
reg [3:0] RAM [15:0];
reg [3:0] RAM_1 [3:0];
reg [2:0] count_1;
parameter B_0=4'b0001;   //LOCK
parameter B_1=4'b0010;   //OPEN THE LOCK
parameter B_2=4'b0100;   //SAVE
parameter B_3=4'b1000;    //SET
parameter B_4=4'b0011;     //CHANGE
initial $readmemb("RAM_DATA.txt",RAM_1,3,0);     //initial code saved in the "RAM_DATA.txt"
initial $readmemb("RAM_DATA_1.txt",RAM,15,0);
/*
 always @(posedge clk or negedge reset_1  )     //save input into RAM
 begin
 if(reset_1==1)
 begin
 data_1=16'h0000;
 for(i=0;i<16;i=i+1)
 RAM[i]=4'b0000;
 end
 else if(write_en)
 begin
for(i=0;i<16;i=i+1)
RAM[i]=Code_1;
end
end
*/

always @(posedge clk or negedge reset_1)
begin
if(reset_1)
begin
state_1<=B_0;
data_1<=16'h0000;
end
else
state_1<=next_state_1;
for(i=0;i<16;i=i+1)
RAM[i]<=Code_1;
data_1<=RAM[i];
end


always@(state_1,Code_1,Valid_1,set)
  begin
	next_state_1=B_0;

                case(state_1)
B_0:                                                        //lock state 
begin
                    if((RAM[1]==RAM_1[0])&&(RAM[2]==RAM_1[1])&&(RAM[3]==RAM_1[2])&&(RAM[4]==RAM_1[3])&&(RAM[0]==4'b1011)&&(!set)&&(Valid_1))         //if input code is the same as the initial code 
                       next_state_1=B_1;

                    else if((RAM[0]==4'b1011)&&(!set)&&(Valid_1))                  //keep pushing "#" ,hold open state 

                       next_state_1=B_1;   


                        else if((RAM[1]==RAM_1[0])&&(RAM[2]==RAM_1[1])&&(RAM[3]==RAM_1[2])&&(RAM[4]==RAM_1[3])&&(RAM[0]==4'b1010)&&(!set)&&(Valid_1))//input the correct code and end with "*" ,jump into save state
                    
						next_state_1=B_2;                // jump into save state

					
					
						else if((set)&&(!Valid_1))
						
						next_state_1=B_3;
						
                        else 

                        next_state_1=B_0;                 //jump into LOCK state
                
end                
B_1: 
begin                                                              //OPEN state         
             if((RAM[0]==4'b1011) &&(Valid_1)&&(!set))                          //keep pushing "#" ,hold open state 
            
             next_state_1=B_1;
            
			else if((RAM[1]==RAM_1[0])&&(RAM[2]==RAM_1[1])&&(RAM[3]==RAM_1[2])&&(RAM[4]==RAM_1[3])&&(RAM[0]==4'b1010)&&(!set)&&(Valid_1))//input the correct code and end with "*" ,jump into save state
                  
						next_state_1=B_2;                // jump into save state

else if((set)&&(!Valid_1))
						
						next_state_1=B_3;
						
        else     
            
                        state_1=B_0;                 //jump into LOCK state
            
end
B_2:                      //SAVE state
begin
if((set==1)&&(!Valid_1))               //jump into set ,we can input the code

next_state_1=B_3;


else if((RAM[1]==RAM_1[0])&&(RAM[2]==RAM_1[1])&&(RAM[3]==RAM_1[2])&&(RAM[4]==RAM_1[3])&&(RAM[0]==4'b1011)&&(!set)&&(Valid_1))

next_state_1=B_4;

else

next_state_1=B_0;

end
B_3:
begin
if((set==1)&&(!Valid_1))               //jump into set ,we can input the code

next_state_1=B_3;


else if((RAM[1]==RAM_1[0])&&(RAM[2]==RAM_1[1])&&(RAM[3]==RAM_1[2])&&(RAM[4]==RAM_1[3])&&(RAM[0]==4'b1010)&&(!set)&&(Valid_1))

next_state_1=B_2;

else if((RAM[1]==RAM_1[0])&&(RAM[2]==RAM_1[1])&&(RAM[3]==RAM_1[2])&&(RAM[4]==RAM_1[3])&&(RAM[0]==4'b1011)&&(!set)&&(Valid_1))

next_state_1=B_1;

else

next_state_1=B_0;
end

B_4:
begin
if((RAM[1]==RAM[6])&&(RAM[2]==RAM[7])&&(RAM[3]==RAM[8])&&(RAM[4]==RAM[9])&&(RAM[0]==4'b1011)&&(RAM[5]==4'b1011))

next_state_1=B_0;

else

next_state_1=B_4;

end
endcase
end
always@(posedge clk or negedge reset_1)
begin
OPEN<=1'b0;
                            SAVE_LIGHT<=1'b0;
                            LOCK<=1'b1;
							SET<=0;
							CHANGE<=0;
							data_1<={RAM[3],RAM[2],RAM[1],RAM[0]};
case(next_state_1)
B_0: 
begin
OPEN<=1'b0;
                            SAVE_LIGHT<=1'b0;
                            LOCK<=1'b1;
							SET<=0;
							CHANGE<=0;
							data_1<={RAM[3],RAM[2],RAM[1],RAM[0]};
					
end

B_1:
begin
OPEN<=1'b1;
                            SAVE_LIGHT<=1'b0;
                            LOCK<=1'b0;
							SET<=0;
							CHANGE<=0;
							data_1<={RAM[3],RAM[2],RAM[1],RAM[0]};
end
B_2:
begin
OPEN<=1'b0;
                            SAVE_LIGHT<=1'b1;
                            LOCK<=1'b1;
							SET<=0;		
CHANGE<=0;							
data_1<={RAM[3],RAM[2],RAM[1],RAM[0]};
end
B_3:
begin
OPEN<=1'b0;
                            SAVE_LIGHT<=1'b0;
                            LOCK<=1'b1;
							SET<=1;
							CHANGE<=0;
data_1<={RAM[3],RAM[2],RAM[1],RAM[0]};
end
B_4:
begin
OPEN<=1'b0;
                            SAVE_LIGHT<=1'b0;
                            LOCK<=1'b1;
							SET<=0;
							CHANGE<=1;
	data_1<={RAM[3],RAM[2],RAM[1],RAM[0]};			
end
endcase
end
endmodule
