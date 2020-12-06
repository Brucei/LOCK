
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
input reset_1,       //ç½®ä½ä¿¡å·
input [3:0] Code_1, //è¾“å…¥çš„1ä½æŒ‰é”®
input Valid_1,      //æœ‰æ•ˆä¿¡å·
//input [15:0] Key ,   //ç”¨æˆ·è¾“å…¥4ä½å¯†ç 
//input [15:0] Key_1,
//input  [3:0] Key,
input clk,
                                    //å¯¹åº”å­˜å‚¨å™¨çš„åœ°å€
//input [2:0] RAM_1_addr,            //å¯¹åº”å­˜å‚¨å™¨çš„åœ°å€
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
 else if(RAM_addr_1<=7)              //´æ´¢ÊäÈëRAMµØÖ·
 begin
RAM_addr_1=RAM_addr_1+1;
end
else 
RAM_addr_1=0;
end

 always @(posedge clk)     //´æ´¢ÃÜÂëRAMµØÖ·
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
<<<<<<< HEAD
 assign count_1=count;
assign  RAM_DATA_1=RAM_1[RAM_addr_1];        //´æ´¢8Î»´æ´¢ÃÜÂë
assign  RAM_DATA=RAM[RAM_addr];          //´æ´¢ÊäÈë
=======

assign  RAM_DATA_1=RAM_1[RAM_addr_1];        //å­˜å‚¨8ä½å­˜å‚¨å¯†ç 
assign  RAM_DATA=RAM[RAM_addr];          //å­˜å‚¨è¾“å…¥
>>>>>>> f3f7652d60cf34cbbff404440ef527375849e52b
   always@(posedge clk )            //###############
   begin
   if(reset_1)                                   //è¿›å…¥å¤ä½ï¼Œå¯ä»¥è¾“å…¥æ–°å¯†ç 
   state_1<=B_2;                                 //è¿›å…¥å­˜å‚¨æ¨¡å¼
   else 
   state_1<=next_state_1;      
   end                       //å¦åˆ™è¿›å…¥ä¸‹ä¸€çŠ¶æ€

always@(state_1,Valid_1,Code_1)
    begin
    OPEN=1'b0;
    SAVE_LIGHT=1'b0;
    LOCK=1'b1;
                case(state_1)
<<<<<<< HEAD
B_0:                                                        //¿ÕÏĞ×´Ì¬£¬ÅĞ¶ÏÊÇ·ñ°´ÏÂÃÜÂëºÍ"#"¼ü£¬°´ÏÂÔòÌø×ªÖÁ¿ªÆô×´Ì¬

=======
B_0:                                                        //ç©ºé—²çŠ¶æ€ï¼Œåˆ¤æ–­æ˜¯å¦æŒ‰ä¸‹å¯†ç å’Œ"#"é”®ï¼ŒæŒ‰ä¸‹åˆ™è·³è½¬è‡³å¼€å¯çŠ¶æ€
>>>>>>> f3f7652d60cf34cbbff404440ef527375849e52b
                    if((RAM_DATA[1]==RAM_DATA_1[1])&&(RAM_DATA[2]==RAM_DATA_1[2])&&(RAM_DATA[3]==RAM_DATA_1[3])&&(RAM_DATA[4]==RAM_DATA_1[4])&&(RAM_DATA[0]==4'b1011))
                        begin
                            next_state_1=B_1;
                            OPEN=1'b1;
                            SAVE_LIGHT=1'b0;
                            LOCK=1'b0;
                        end
                    else if(RAM_DATA[0]==4'b1011)                  //ä¸€ç›´æŒ‰ä¸‹â€œ#é”®â€ï¼Œåˆ™ä¸€ç›´æ‰“å¼€
                        begin
                        next_state_1=B_1;                  
                        OPEN=1'b1;
                        SAVE_LIGHT=1'b0;
                        LOCK=1'b0;
                        end
                        else if((RAM_DATA[1]==RAM_DATA_1[1])&&(RAM_DATA[2]==RAM_DATA_1[2])&&(RAM_DATA[3]==RAM_DATA_1[3])&&(RAM_DATA[4]==RAM_DATA_1[4])&&(RAM_DATA[0]==4'b1010))
                        begin
<<<<<<< HEAD
                        next_state_1=B_2;                 //½øÈë´æ´¢×´Ì¬
                        SAVE_LIGHT=1'b1;
                        OPEN=1'b0;
                        LOCK=1'b1;
                        end
                        else 
                        begin
                        next_state_1=B_0;                 //½øÈëËø¶¨×´Ì¬
                        LOCK=1'b1;
                         OPEN=1'b0;
                          SAVE_LIGHT=1'b0;
=======
                        next_state_1=B_2;                 //è¿›å…¥å­˜å‚¨çŠ¶æ€
                        SAVE_LIGHT=1;
                        end
                        else 
                        begin
                        next_state_1=B_3;                 //è¿›å…¥é”å®šçŠ¶æ€
                        LOCK=1;
>>>>>>> f3f7652d60cf34cbbff404440ef527375849e52b
                        end
                        
B_1:                                                               //´ò¿ª×´Ì¬
if((reset_1==0)&&(Valid_1==1))
begin
             OPEN=1'b1;
             LOCK=1'b0;
             SAVE_LIGHT=1'b0;
             if(RAM_DATA[0]==4'b1011)                            //Ò»Ö±°´ÏÂ¡±#¡°±£³Ö´ò¿ª
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
            
<<<<<<< HEAD
                        next_state_1=B_2;                 //½øÈë´æ´¢×´Ì¬
                        SAVE_LIGHT=1'b1;
                        OPEN=1'b0;
                        LOCK=1'b1;
=======
                        next_state_1=B_2;                 //è¿›å…¥å­˜å‚¨çŠ¶æ€
                        SAVE_LIGHT=1;
>>>>>>> f3f7652d60cf34cbbff404440ef527375849e52b
             
            end
            */
    
            begin
<<<<<<< HEAD
                        next_state_1=B_0;                 //½øÈëËø¶¨×´Ì¬
                        LOCK=1'b1;
                        SAVE_LIGHT=1'b0;
                        OPEN=1'b0;
=======
                        next_state_1=B_3;                 //è¿›å…¥é”å®šçŠ¶æ€
                        LOCK=1;
>>>>>>> f3f7652d60cf34cbbff404440ef527375849e52b
                        end
end
B_2:                      //´æ´¢×´Ì¬
if(reset_1==1)               //½øÈë¸´Î»£¬ÊäÈë4Î»ÃÜÂë
begin
for(i=0;i<4;i=i+1)
RAM[i]=Code_1;
<<<<<<< HEAD
=======
if(RAM[
if((Valid_1==1)||(reset_1==1))
begin

for(i=0;i<5;i=i+1)
RAM_1[i]=Code_1;
if({RAM_1[3],RAM_1[2],RAM_1[1],RAM_1[0]}&&{RAM[3],RAM[2],RAM[1],RAM[0]})
if(RAM_1[4]==4'b1010)                                              //è¾“å…¥åˆå§‹å¯†ç å’Œ"*"é”®è¿›å…¥å­˜å‚¨çŠ¶æ€
begin
SAVE_LIGHT=1;
/*
for(i=0;i<10;i=i+1)                                                  //å°†å¯†ç é‡ç½®å­˜å…¥RAMå¯„å­˜å™¨
RAM[i]=Code_1;
*/
if({RAM[3],RAM[2],RAM[1],RAM[0]}=={RAM[8],RAM[7],RAM[6],RAM[5]})
begin
if((RAM[4]==4'b1011)&&(RAM[9]==4'b1011))
SAVE_LIGHT=0;
>>>>>>> f3f7652d60cf34cbbff404440ef527375849e52b
end
else
begin                          //½øÈë´æ´¢
count=0;
SAVE_LIGHT=1'b1;
 LOCK=1'b1;
 OPEN=1'b0;
for(i=0;i<10;i=i+1)                    //ÊäÈëÁ½±éÃÜÂë
begin
RAM[i]=Code_1;
end
<<<<<<< HEAD
while (!((RAM[1]&RAM[6])&&(RAM[2]&RAM[7])&&(RAM[3]&RAM[8]))&&(RAM[4]&RAM[9])&&(RAM[0]&4'b1011)&&(RAM[4]&4'b1011))   //ÈôÁ½±éÊäÈë²»Í¬£¬ÖØĞÂÊäÈë¡£Ã¿´ÎÊäÈë¶¼ÒÔ"#"½áÊø
begin
for(i=0;i<10;i=i+1)
begin
RAM[i]=Code_1;
count=count+1;
if(count>7)                                 //count¼ÆËã´íÎó´ÎÊı
break;
=======
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
 begin                                                 //å­çŠ¶æ€æœºï¼Œä»¥æ—¶é’Ÿä¿¡å·ä¸Šå‡æ²¿ä½é‡‡æ ·Code_1
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
if(RAM_1[4]==4'b1010)                                              //è¾“å…¥åˆå§‹å¯†ç å’Œ"*"é”®è¿›å…¥å­˜å‚¨çŠ¶æ€
begin
SAVE_LIGHT<=1;
for(i=0;i<10;i=i+1)                                                  //å°†å¯†ç é‡ç½®å­˜å…¥RAMå¯„å­˜å™¨
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
>>>>>>> f3f7652d60cf34cbbff404440ef527375849e52b
end
end

SAVE_LIGHT=1'b0;   //ĞŞ¸ÄÍêÃÜÂë£¬´æ´¢Ö¸Ê¾µÆÃğ
 LOCK=1'b1;
 OPEN=1'b0;
 next_state_1=B_0;  //ĞŞ¸ÄÍêÃÜÂë½øÈëËø¶¨×´Ì¬
end
default: next_state_1=B_0;   //Ä¬ÈÏ½øÈëËø¶¨×´Ì¬
endcase

end
endmodule
