
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
input reset_1,       //置位信号
input [3:0] Code_1, //输入的1位按键
input Valid_1,      //有效信号
//input [15:0] Key ,   //用户输入4位密码
//input [15:0] Key_1,
//input  [3:0] Key,
input clk,
                                    //对应存储器的地址
//input [2:0] RAM_1_addr,            //对应存储器的地址
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
 else if(RAM_addr_1<=7)              //存储输入RAM地址
 begin
RAM_addr_1=RAM_addr_1+1;
end
else 
RAM_addr_1=0;
end

 always @(posedge clk)     //存储密码RAM地址
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
assign  RAM_DATA_1=RAM_1[RAM_addr_1];        //存储8位存储密码
assign  RAM_DATA=RAM[RAM_addr];          //存储输入
   always@(posedge clk )            //###############
   begin
   if(reset_1)                                   //进入复位，可以输入新密码
   state_1<=B_2;                                 //进入存储模式
   else 
   state_1<=next_state_1;      
   end                       //否则进入下一状态

always@(state_1,Valid_1,Code_1)
    begin
    OPEN=1'b0;
    SAVE_LIGHT=1'b0;
    LOCK=1'b1;
                case(state_1)
B_0:                                                        //空闲状态，判断是否按下密码和"#"键，按下则跳转至开启状态

                    if((RAM_DATA[1]==RAM_DATA_1[1])&&(RAM_DATA[2]==RAM_DATA_1[2])&&(RAM_DATA[3]==RAM_DATA_1[3])&&(RAM_DATA[4]==RAM_DATA_1[4])&&(RAM_DATA[0]==4'b1011))
                        begin
                            next_state_1=B_1;
                            OPEN=1'b1;
                            SAVE_LIGHT=1'b0;
                            LOCK=1'b0;
                        end
                    else if(RAM_DATA[0]==4'b1011)                  //一直按下“#键”，则一直打开
                        begin
                        next_state_1=B_1;                  
                        OPEN=1'b1;
                        SAVE_LIGHT=1'b0;
                        LOCK=1'b0;
                        end
                        else if((RAM_DATA[1]==RAM_DATA_1[1])&&(RAM_DATA[2]==RAM_DATA_1[2])&&(RAM_DATA[3]==RAM_DATA_1[3])&&(RAM_DATA[4]==RAM_DATA_1[4])&&(RAM_DATA[0]==4'b1010))
                        begin
                        next_state_1=B_2;                 //进入存储状态
                        SAVE_LIGHT=1'b1;
                        OPEN=1'b0;
                        LOCK=1'b1;
                        end
                        else 
                        begin
                        next_state_1=B_0;                 //进入锁定状态
                        LOCK=1'b1;
                         OPEN=1'b0;
                          SAVE_LIGHT=1'b0;
                        end
                        
B_1:                                                               //打开状态
if((reset_1==0)&&(Valid_1==1))
begin
             OPEN=1'b1;
             LOCK=1'b0;
             SAVE_LIGHT=1'b0;
             if(RAM_DATA[0]==4'b1011)                            //一直按下”#“保持打开
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
            
                        next_state_1=B_2;                 //进入存储状态
                        SAVE_LIGHT=1'b1;
                        OPEN=1'b0;
                        LOCK=1'b1;
             
            end
            */
    
            begin
                        next_state_1=B_0;                 //进入锁定状态
                        LOCK=1'b1;
                        SAVE_LIGHT=1'b0;
                        OPEN=1'b0;
                        end
end
B_2:                      //存储状态
if(reset_1==1)               //进入复位，输入4位密码
begin
for(i=0;i<4;i=i+1)
RAM[i]=Code_1;
end
else
begin                          //进入存储
count=0;
SAVE_LIGHT=1'b1;
 LOCK=1'b1;
 OPEN=1'b0;
for(i=0;i<10;i=i+1)                    //输入两遍密码
begin
RAM[i]=Code_1;
end
while (!((RAM[1]&RAM[6])&&(RAM[2]&RAM[7])&&(RAM[3]&RAM[8]))&&(RAM[4]&RAM[9])&&(RAM[0]&4'b1011)&&(RAM[4]&4'b1011))   //若两遍输入不同，重新输入。每次输入都以"#"结束
begin
for(i=0;i<10;i=i+1)
begin
RAM[i]=Code_1;
count=count+1;
if(count>7)                                 //count计算错误次数
break;
end
end

SAVE_LIGHT=1'b0;   //修改完密码，存储指示灯灭
 LOCK=1'b1;
 OPEN=1'b0;
 next_state_1=B_0;  //修改完密码进入锁定状态
end
default: next_state_1=B_0;   //默认进入锁定状态
endcase

end
endmodule
