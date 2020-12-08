
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
output reg [15:0] data,
output reg [15:0] data_initial
    );  
    integer i;                                               
reg [3:0] state_1;
reg [3:0] RAM [15:0];
reg [3:0] RAM_1 [3:0];
reg [2:0] count_1;
parameter B_0=4'b0001;   //LOCK
parameter B_1=4'b0010;   //OPEN THE LOCK
parameter B_2=4'b0100;   //SAVE
initial $readmemb("RAM_DATA.tzt",RAM_1,3,0);     //initial code saved in the "RAM_DATA.txt"
 always @(posedge clk or posedge reset_1)     //save input into RAM
 begin
 if(reset_1==1)
 begin
 for(i=0;i<16;i=i+1)
 RAM[i]<=4'b0000;
 end
 else if(write_en)
 begin
RAM[RAM_addr]<=Code_1;
end
end
always@(Code_1,Valid_1,reset_1,set,state_1)
    begin
    if(reset_1==1)
    begin
    OPEN<=1'b0;
    SAVE_LIGHT<=1'b0;
    LOCK<=1'b1;
    end
    else 
    begin
                case(state_1)
B_0:                                                        //lock state 
begin
                    if((RAM[1]==RAM_1[0])&&(RAM[2]==RAM_1[1])&&(RAM[3]==RAM_1[2])&&(RAM[4]==RAM_1[3])&&(RAM[0]==4'b1011)&&(!set)&&(Valid_1))         //if input code is the same as the initial code 
                        begin
                            state_1<=B_1;
                            OPEN<=1'b1;
                            SAVE_LIGHT<=1'b0;
                            LOCK<=1'b0;
                            data<={RAM[4],RAM[3],RAM[2],RAM[1]};
                        end
                    else if((RAM[0]==4'b1011)&&(!set)&&(Valid_1))                  //keep pushing "#" ,hold open state 
                        begin
                       state_1<=B_1;                  
                       OPEN<=1'b1;
                       SAVE_LIGHT<=1'b0;
                       LOCK<=1'b0;
                        end
                        else if((RAM[1]==RAM_1[0])&&(RAM[2]==RAM_1[1])&&(RAM[3]==RAM_1[2])&&(RAM[4]==RAM_1[3])&&(RAM[0]==4'b1010)&&(!set)&&(Valid_1))//input the correct code and end with "*" ,jump into save state
                        begin
                        state_1<=B_2;                 // jump into save state
                        SAVE_LIGHT<=1'b1;
                        OPEN<=1'b0;
                        LOCK<=1'b1;
                        data<={RAM[4],RAM[3],RAM[2],RAM[1]};
                        end
                        else 
                        begin
                        state_1<=B_0;                 //jump into LOCK state
                        LOCK<=1'b1;
                        OPEN<=1'b0;
                        SAVE_LIGHT<=1'b0;
                        data<={RAM[4],RAM[3],RAM[2],RAM[1]};
                        end
        end                
B_1: 
begin                                                              //OPEN state
if((Valid_1==1)&&(!set))
begin
             OPEN<=1'b1;
             LOCK<=1'b0;
             SAVE_LIGHT<=1'b0;
             if(RAM[0]==4'b1011)                            //keep pushing "#" ,hold open state 
             begin
             state_1<=B_1;
             OPEN<=1'b1;
             LOCK<=1'b0;
             SAVE_LIGHT<=1'b0;
            end
        else     
            begin
                        state_1<=B_0;                 //jump into LOCK state
                        LOCK<=1'b1;
                        SAVE_LIGHT<=1'b0;
                        OPEN<=1'b0;

                        end
end
end
B_2:                      //SAVE state
begin
if((set==1)&&(!Valid_1))               //jump into set ,we can input the code
begin
for(i=0;i<8;i=i*2)
RAM_1[i]<=Code_1;
end
else if((!set)&&(Valid_1))
begin                          //jump into SAVE state
count_1<=1'b0;
SAVE_LIGHT<=1'b1;
 LOCK<=1'b1;
 OPEN<=1'b0;
for(i=1;i<=512;i=i*2)                    //input code  2 times 
begin
RAM[i]<=Code_1;
end

while (!((RAM[1]==RAM[6])&&(RAM[2]==RAM[7])&&(RAM[3]==RAM[8]))&&(RAM[4]==RAM[9])&&(RAM[0]==4'b1011)&&(RAM[5]==4'b1011))   //if the first input is different with the second input ,then repeat
begin
for(i=0;i<=9;i=i+1)
begin
RAM[i]<=Code_1;
count_1<=count_1+1;
end
end
RAM_1[0]<=RAM[1];
RAM_1[1]<=RAM[2];
RAM_1[2]<=RAM[3];
RAM_1[3]<=RAM[4];
SAVE_LIGHT<=1'b0;   //after code changed, LIGHT is out 
 LOCK<=1'b1;
 OPEN<=1'b0;
state_1<=B_0;  //after code changed ,jump into LOCK state.
end
end
endcase

end
end
endmodule
