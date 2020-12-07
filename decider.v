
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
input write_en,
input read_en,
input  [3:0] RAM_addr,
input clk,
input set,
output reg OPEN,
output reg  LOCK,
output reg SAVE_LIGHT
    );  
    integer i;                                               
    reg [2:0] state_1,next_state_1;
 reg [3:0] RAM [15:0];
  reg [3:0] RAM_1 [3:0];
  reg [3:0] data;
reg [2:0] count_1;
    parameter B_0=4'b0001;   //LOCK
    parameter B_1=4'b0010;   //OPEN THE LOCK
    parameter B_2=4'b0100;   //SAVE


initial $readmemh("RAM_DATA.tzt",RAM_1,3,0);

 always @(posedge clk or posedge reset_1)     //存储输入RAM地址
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
else if(read_en)
begin
data<=RAM[RAM_addr];
end
else
begin
data<=4'bz;
end
end
assign Code_1=read_en?data:4'bz;
always@(Code_1,reset_1,state_1,Valid_1,set)
    begin
    if(reset_1==0)
    begin
    OPEN=1'b0;
    SAVE_LIGHT=1'b0;
    LOCK=1'b1;
    end
    else 
    begin
                case(state_1)
B_0:                                                        //空闲状态，判断是否按下密码和"#"键，按下则跳转至开启状态
begin
                    if((RAM[2]==RAM_1[1])&&(RAM[4]==RAM_1[2])&&(RAM[8]==RAM_1[4])&&(RAM[16]==RAM_1[8])&&(RAM[1]==4'b1011))
                        begin
                            next_state_1=B_1;
                            OPEN=1'b1;
                            SAVE_LIGHT=1'b0;
                            LOCK=1'b0;
                        end
                    else if(RAM[1]==4'b1011)                  //涓?鐩存寜涓嬧??#閿?濓紝鍒欎竴鐩存墦寮?
                        begin
                        next_state_1=B_1;                  
                        OPEN=1'b1;
                        SAVE_LIGHT=1'b0;
                        LOCK=1'b0;
                        end
                        else if((RAM[2]==RAM_1[1])&&(RAM[4]==RAM_1[2])&&(RAM[8]==RAM_1[4])&&(RAM[16]==RAM_1[8])&&(RAM[1]==4'b1010))
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
        end                
B_1: 
begin                                                              //打开状态
if(Valid_1==1)
begin
             OPEN=1'b1;
             LOCK=1'b0;
             SAVE_LIGHT=1'b0;
             if(RAM[1]==4'b1011)                            //一直按下”#“保持打开
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
end
B_2:                      //存储状态
begin
if(set==1)               //进入复位，输入4位密码
begin
for(i=0;i<8;i=i*2)
RAM_1[i]=Code_1;
end
else
begin                          //进入存储
count_1=1'b0;
SAVE_LIGHT=1'b1;
 LOCK=1'b1;
 OPEN=1'b0;
for(i=1;i<=512;i=i*2)                    //输入两遍密码
begin
RAM[i]=Code_1;
end

while (!((RAM[2]==RAM[64])&&(RAM[4]==RAM[128])&&(RAM[8]==RAM[256]))&&(RAM[16]==RAM[512])&&(RAM[1]==4'b1011)&&(RAM[32]==4'b1011))   //若两遍输入不同，重新输入。每次输入都以"#"结束
begin
for(i=1;i<=512;i=i+1)
begin
RAM[i]=Code_1;
count_1=count_1+1;
end
end
RAM_1[1]=RAM[2];
RAM_1[2]=RAM[4];
RAM_1[4]=RAM[8];
RAM_1[8]=RAM[16];
SAVE_LIGHT=1'b0;   //修改完密码，存储指示灯灭
 LOCK=1'b1;
 OPEN=1'b0;
 next_state_1=B_0;  //修改完密码进入锁定状态
end
end
endcase

end
end
endmodule
