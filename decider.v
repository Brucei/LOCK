
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
input reset_1,       //��λ�ź�
input [3:0] Code_1, //�����1λ����
input Valid_1,      //��Ч�ź�
//input [15:0] Key ,   //�û�����4λ����
//input [15:0] Key_1,
//input  [3:0] Key,
input clk,
                                    //��Ӧ�洢���ĵ�ַ
//input [2:0] RAM_1_addr,            //��Ӧ�洢���ĵ�ַ
output reg  OPEN,
output reg LOCK,
output reg SAVE_LIGHT
 //output  reg [3:0] count 
    );  
    integer i;    
    reg RAM_addr;
   // reg RAM_addr_1;
    wire RAM_DATA_1;         
    wire RAM_DATA;                                                   
    reg [2:0] state_1,next_state_1;
 //   reg [2:0] sub_state_1,next_sub_state_1;
  // output  reg [3:0] count ; 
    reg [3:0] RAM [2:0];
    reg [3:0] RAM_1 [2:0];
 //   `include "RAM_DATA.txt"
    initial $readmemb("RAM_DATA.txt",RAM_1,0,7);
    parameter B_0=4'b0001;   //IDLE
    parameter B_1=4'b0010;   //OPEN THE LOCK
    parameter B_2=4'b0100;   //SAVE
    parameter B_3=4'b1000;   //LOCK
 //   parameter B_3=4'b1000;   //QUALIFY
 always @(posedge clk)
 begin
 if(reset_1==0)
 RAM_addr=0;
 else if(RAM_addr<=7)
 begin
RAM_addr=RAM_addr+1;
RAM[RAM_addr]=Code_1;
end
else 
RAM_addr=0;
end
assign  RAM_DATA_1=RAM_1[RAM_addr];
assign  RAM_DATA=RAM[RAM_addr
   always@(posedge clk )            //###############
   begin
   if(reset_1)                                   //���븴λ����������������
   state_1<=B_2;                                 //����洢ģʽ
   else 
   state_1<=next_state_1;      
   end                       //���������һ״̬
  /*
   always@(state_1,Valid)             //######################
   begin
   if(reset_1==1'b0)
   sub_state_1<=B_2;
   else
   sub_state_1<=next_sub_state_1;
   end
   */
always@(state_1,Valid_1,Code_1)
    begin
    OPEN=1'b0;
    SAVE_LIGHT=1'b0;
    LOCK=1'b0;
                case(state_1)
B_0:                                                        //����״̬���ж��Ƿ���"#"������������ת������״̬
                    if((Code_1==4'b1011)&&Valid_1)
                        begin
                            next_state_1=B_1;
                            OPEN=1;
                        end
                    else if(
                        begin
                        next_state_1=B_3;
                        LOCK=1;
                        end
B_1: 
        if((Code_1==4'b1011)&&Valid_1)                                  //����״̬��#��һֱ���£���һֱ���ڿ���״̬
            begin
             OPEN=1;
             next_state_1=B_1;
            end
        else                          
            begin
            next_state_1=B_2;
            SAVE_LIGHT=1;
            end
B_2:
if(Valid_1)
begin
/*
for(i=0;i<4;i=i+1)
RAM[i]=Code_1;
*/
for(i=0;i<5;i=i+1)
RAM_1[i]=Code_1;
if({RAM_1[3],RAM_1[2],RAM_1[1],RAM_1[0]}&&{RAM[3],RAM[2],RAM[1],RAM[0]})
if(RAM_1[4]==4'b1010)                                              //�����ʼ�����"*"������洢״̬
begin
SAVE_LIGHT=1;
/*
for(i=0;i<10;i=i+1)                                                  //���������ô���RAM�Ĵ���
RAM[i]=Code_1;
*/
if({RAM[3],RAM[2],RAM[1],RAM[0]}=={RAM[8],RAM[7],RAM[6],RAM[5]})
begin
if((RAM[4]==4'b1011)&&(RAM[9]==4'b1011))
SAVE_LIGHT=0;
end
/*
else
begin
for(i=0;i<8;i=i+1)
RAM[i]=Code_1;
end
*/
end
end
 endcase
 end
 /*
 always@(posedge clk or negedge reset_1)
 if(reset_1==0)
 if(Valid_1)
 begin
 begin                                                 //��״̬������ʱ���ź�������λ����Code_1
 SAVE_LIGHT<=0;
        case(sub_state_1)
 
B_2:
begin
for(i=0;i<4;i=i+1)
RAM[i]<=Code_1;
end
else
begin
for(i=0;i<5;i=i+1)
RAM_1[i]<=Code_1;
if({RAM_1[3],RAM_1[2],RAM_1[1],RAM_1[0]}=={RAM[3],RAM[2],RAM[1],RAM[0]})
if(RAM_1[4]==4'b1010)                                              //�����ʼ�����"*"������洢״̬
begin
SAVE_LIGHT<=1;
for(i=0;i<10;i=i+1)                                                  //���������ô���RAM�Ĵ���
RAM[i]<=Code_1;
if({RAM[3],RAM[2],RAM[1],RAM[0]}=={RAM[8],RAM[7],RAM[6],RAM[5]})
begin
if((RAM[4]==4'b1011)&&(RAM[9]==4'b1011))
SAVE_LIGHT<=0;
end
else
begin

for(i=0;i<8;i=i+1)
RAM[i]<=Code_1;
end
end
end
default:next_sub_state_1<=B_2;
endcase
end
end
*/
endmodule
