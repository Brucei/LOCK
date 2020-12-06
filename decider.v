
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
input reset_1,       //缃綅淇″彿
input [3:0] Code_1, //杈撳叆鐨?1浣嶆寜閿?
input Valid_1,      //鏈夋晥淇″彿
//input [15:0] Key ,   //鐢ㄦ埛杈撳叆4浣嶅瘑鐮?
//input [15:0] Key_1,
//input  [3:0] Key,
input clk,
                                    //瀵瑰簲瀛樺偍鍣ㄧ殑鍦板潃
//input [2:0] RAM_1_addr,            //瀵瑰簲瀛樺偍鍣ㄧ殑鍦板潃
output reg OPEN,
output reg  LOCK,
output reg SAVE_LIGHT,
  output   reg  [2:0] count_1,
  output reg [3:0] RAM_1_DATA,
  output reg [3:0] RAM_DATA
    );  
    integer i;    
    reg [1:0] RAM_addr_1;
    reg [2:0] RAM_addr;
 // output   wire [3:0] RAM_DATA_1;         
 // output   wire [3:0]  RAM_DATA;                                              
    reg [2:0] state_1,next_state_1;
 reg [3:0] RAM [7:0];
  reg [3:0] RAM_1 [3:0];
    initial $readmemb("RAM_DATA.txt",RAM_1,0,3);
    parameter B_0=4'b0001;   //LOCK
    parameter B_1=4'b0010;   //OPEN THE LOCK
    parameter B_2=4'b0100;   //SAVE
 //   parameter B_3=4'b1000;   //LOCK

 always @(posedge clk)
 begin
 if(reset_1==0)
 RAM_addr_1=0;
 else if(RAM_addr_1<=3)              //存储输入RAM地址
 begin
RAM_addr_1=RAM_addr_1+1;
RAM_1_DATA=RAM_1[RAM_addr_1];
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
RAM_DATA=RAM[RAM_addr];
end
else 
RAM_addr=0;
end



   always@(posedge clk )            //###############
   begin
   if(reset_1)                                   //杩涘叆澶嶄綅锛屽彲浠ヨ緭鍏ユ柊瀵嗙爜
   state_1<=B_2;                                 //杩涘叆瀛樺偍妯″紡
   else 
   state_1<=next_state_1;      
   end                       //鍚﹀垯杩涘叆涓嬩竴鐘舵??

always@(state_1,Valid_1,Code_1)
    begin
    if(reset_1==0)
    OPEN=1'b0;
    SAVE_LIGHT=1'b0;
    LOCK=1'b1;
                case(state_1)
B_0:                                                        //空闲状态，判断是否按下密码和"#"键，按下则跳转至开启状态

                    if((RAM[1]==RAM_1[0])&&(RAM[2]==RAM_1[1])&&(RAM[3]==RAM_1[2])&&(RAM[4]==RAM_1[3])&&(RAM[0]==4'b1011))
                        begin
                            next_state_1=B_1;
                            OPEN=1'b1;
                            SAVE_LIGHT=1'b0;
                            LOCK=1'b0;
                        end
                    else if(RAM[0]==4'b1011)                  //涓?鐩存寜涓嬧??#閿?濓紝鍒欎竴鐩存墦寮?
                        begin
                        next_state_1=B_1;                  
                        OPEN=1'b1;
                        SAVE_LIGHT=1'b0;
                        LOCK=1'b0;
                        end
                        else if((RAM[1]==RAM_1[1])&&(RAM[2]==RAM_1[2])&&(RAM[3]==RAM_1[3])&&(RAM[4]==RAM_1[4])&&(RAM[0]==4'b1010))
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
             if(RAM[0]==4'b1011)                            //一直按下”#“保持打开
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
count_1=1'b0;
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
count_1=count_1+1;
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
