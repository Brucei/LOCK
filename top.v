`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/02 11:49:37
// Design Name: 
// Module Name: top
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


module top(
   clk             ,   

    rst_n           ,   

    key_col         ,
    key_row         ,

    seg_sel         ,   
   segment             
      );

    input               clk                 ;
   input               rst_n               ;
    input [3:0]         key_col             ;

    output[5:0]         seg_sel             ;
   output[7:0]         segment             ;
   output[3:0]         key_row             ;

   wire  [5:0]         seg_sel             ;
    wire  [7:0]         segment             ;
    wire  [3:0]         key_row             ;

    wire  [3:0]         key_out             ;
    wire                key_vld             ;
    wire  [6*5-1:0]     seg_dout            ;
    wire  [5:0]         seg_dout_vld        ;

   
    key_scan u_key_scan(
        .clk                (clk           ),     
        .rst_n              (rst_n         ),     
      .key_col            (key_col       ),
     .key_row            (key_row       ),
       .key_out            (key_out       ),
       .key_vld            (key_vld       )
    );


   control u_ctrl(
        .clk                (clk            ),      
        .rst_n              (rst_n          ),      
                                     
        .key_num            (key_out        ),      
        .key_vld            (key_vld        ),       
                                     
        .seg_dout           (seg_dout       ),       
       .seg_dout_vld       (seg_dout_vld   )        
    );


    seg_display u_segment(
      .clk                (clk            ),       
        .rst_n              (rst_n          ),       

      .din                (seg_dout       ),       
       .din_vld            (seg_dout_vld   ),       

      .segment            (segment        ),       
     .seg_sel            (seg_sel        )        
  );


    endmodule

