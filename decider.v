
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
output reg SAVE_LIGHT,
 //output  reg [3:0] count 
  output   wire [3:0] RAM_DATA_1,       
  output   wire [3:0]  RAM_DATA,
  output   wire  [2:0] count_1
    );  
    integer i;    
    reg [2:0] RAM_addr_1;
    reg [3:0] RAM_addr;
    reg [2:0] count;
 // output   wire [3:0] RAM_DATA_1;         
 // output   wire [3:0]  RAM_DATA;                                              
    reg [2:0] state_1,next_state_1;
 reg [3:0] RAM [3:0];
  reg [3:0] RAM_1 [2:0];
    initial $readmemb("RAM_DATA.txt",RAM_1,0,7);
    parameter B_0=4'b0001;   //LOCK
    parameter B_1=4'b0010;   //OPEN THE LOCK
    parameter B_2=4'b0100;   //SAVE
 //   parameter B_3=4'b1000;   //LOCK

 always @(posedge clk)
 begin
 if(reset_1==0)
 RAM_addr_1=0;
 else if(RAM_addr_1<=7)              //�洢����RAM��ַ
 begin
RAM_addr_1=RAM_addr_1+1;
end
else 
RAM_addr_1=0;
end

 always @(posedge clk)     //�洢����RAM��ַ
 begin
 if(reset_1==0)
 RAM_addr_1=0;
 else if(RAM_addr<=15)
 begin
RAM_addr=RAM_addr+1;
RAM[RAM_addr]=Code_1;
end
else 
RAM_addr=0;
end
 assign count_1=count;
assign  RAM_DATA_1=RAM_1[RAM_addr_1];        //�洢8λ�洢����
assign  RAM_DATA=RAM[RAM_addr];          //�洢����
   always@(posedge clk )            //###############
   begin
   if(reset_1)                                   //���븴λ����������������
   state_1<=B_2;                                 //����洢ģʽ
   else 
   state_1<=next_state_1;      
   end                       //���������һ״̬

always@(state_1,Valid_1,Code_1)
    begin
    OPEN=1'b0;
    SAVE_LIGHT=1'b0;
    LOCK=1'b1;
                case(state_1)
B_0:                                                        //����״̬���ж��Ƿ��������"#"������������ת������״̬

                    if((RAM_DATA[1]==RAM_DATA_1[1])&&(RAM_DATA[2]==RAM_DATA_1[2])&&(RAM_DATA[3]==RAM_DATA_1[3])&&(RAM_DATA[4]==RAM_DATA_1[4])&&(RAM_DATA[0]==4'b1011))
                        begin
                            next_state_1=B_1;
                            OPEN=1'b1;
                            SAVE_LIGHT=1'b0;
                            LOCK=1'b0;
                        end
                    else if(RAM_DATA[0]==4'b1011)                  //һֱ���¡�#��������һֱ��
                        begin
                        next_state_1=B_1;                  
                        OPEN=1'b1;
                        SAVE_LIGHT=1'b0;
                        LOCK=1'b0;
                        end
                        else if((RAM_DATA[1]==RAM_DATA_1[1])&&(RAM_DATA[2]==RAM_DATA_1[2])&&(RAM_DATA[3]==RAM_DATA_1[3])&&(RAM_DATA[4]==RAM_DATA_1[4])&&(RAM_DATA[0]==4'b1010))
                        begin
                        next_state_1=B_2;                 //����洢״̬
                        SAVE_LIGHT=1'b1;
                        OPEN=1'b0;
                        LOCK=1'b1;
                        end
                        else 
                        begin
                        next_state_1=B_0;                 //��������״̬
                        LOCK=1'b1;
                         OPEN=1'b0;
                          SAVE_LIGHT=1'b0;
                        end
                        
B_1:                                                               //��״̬
if((reset_1==0)&&(Valid_1==1))
begin
             OPEN=1'b1;
             LOCK=1'b0;
             SAVE_LIGHT=1'b0;
             if(RAM_DATA[0]==4'b1011)                            //һֱ���¡�#�����ִ�
             begin
             next_state_1=B_1;
             OPEN=1'b1;
             LOCK=1'b0;
             SAVE_LIGHT=1'b0;
            end
        else   
        /*
        if((RAM_DATA[1]==RAM_DATA_1[1])&&(RAM_DATA[2]==RAM_DATA_1[2])&&(RAM_DATA[3]==RAM_DATA_1[3])&&(RAM_DATA[4]==RAM_DATA_1[4])&&(RAM_DATA[0]==4'b1010))       //                
            begin
            
                        next_state_1=B_2;                 //����洢״̬
                        SAVE_LIGHT=1'b1;
                        OPEN=1'b0;
                        LOCK=1'b1;
             
            end
            */
    
            begin
                        next_state_1=B_0;                 //��������״̬
                        LOCK=1'b1;
                        SAVE_LIGHT=1'b0;
                        OPEN=1'b0;
                        end
end
B_2:                      //�洢״̬
if(reset_1==1)               //���븴λ������4λ����
begin
for(i=0;i<4;i=i+1)
RAM[i]=Code_1;
end
else
begin                          //����洢
count=0;
SAVE_LIGHT=1'b1;
 LOCK=1'b1;
 OPEN=1'b0;
for(i=0;i<10;i=i+1)                    //������������
begin
RAM[i]=Code_1;
end
while (!((RAM[1]&RAM[6])&&(RAM[2]&RAM[7])&&(RAM[3]&RAM[8]))&&(RAM[4]&RAM[9])&&(RAM[0]&4'b1011)&&(RAM[4]&4'b1011))   //���������벻ͬ���������롣ÿ�����붼��"#"����
begin
for(i=0;i<10;i=i+1)
begin
RAM[i]=Code_1;
count=count+1;
if(count>7)                                 //count����������
break;
end
end

SAVE_LIGHT=1'b0;   //�޸������룬�洢ָʾ����
 LOCK=1'b1;
 OPEN=1'b0;
 next_state_1=B_0;  //�޸��������������״̬
end
default: next_state_1=B_0;   //Ĭ�Ͻ�������״̬
endcase

end
endmodule
