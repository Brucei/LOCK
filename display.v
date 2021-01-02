module seg_display(
    clk     ,       
   rst_n   ,       
    din     ,       
   din_vld ,      
    segment ,       
    seg_sel         
   );

    parameter SEGMENT_NUM   = 6             ;   
    parameter W_DATA        = 5             ;   

    parameter SEGMENT_WID   = 8             ;   
   parameter TIME_300US    = 15_000         ;   

    parameter SEG_DATA_0    = 7'b100_0000   ;   
    parameter SEG_DATA_1    = 7'b111_1001   ;
    parameter SEG_DATA_2    = 7'b010_0100   ;
    parameter SEG_DATA_3    = 7'b011_0000   ;
    parameter SEG_DATA_4    = 7'b001_1001   ;
       parameter SEG_DATA_5    = 7'b001_0010   ;
    parameter SEG_DATA_6    = 7'b000_0010   ;
    parameter SEG_DATA_7    = 7'b111_1000   ;
    parameter SEG_DATA_8    = 7'b000_0000   ;
   parameter SEG_DATA_9    = 7'b001_0000   ;  

   parameter SEG_CHAR_O    = 7'b010_0011   ;  
   parameter SEG_CHAR_P    = 7'b000_1100   ;  
    parameter SEG_CHAR_E    = 7'b000_0110   ;  
    parameter SEG_CHAR_N    = 7'b010_1011   ;  
    parameter SEG_CHAR_L    = 7'b100_0111   ;  
   parameter SEG_CHAR_C    = 7'b100_0110   ;  
    parameter SEG_CHAR_K    = 7'b000_0101   ;  
    parameter SEG_CHAR_D    = 7'b010_0001   ;  
    parameter SEG_CHAR_R    = 7'b010_1111   ;  
    parameter SEG_NONE_DIS  = 7'b111_1111   ;  

    input                           clk         ;
    input                           rst_n       ;
    input [SEGMENT_NUM*W_DATA-1:0]  din         ;
    input [SEGMENT_NUM-1:0]         din_vld     ;

   output[SEGMENT_WID-1:0]         segment     ;
    output[SEGMENT_NUM-1:0]         seg_sel     ;

   reg   [SEGMENT_WID-1:0]         segment     ;
    reg   [SEGMENT_NUM-1:0]         seg_sel     ;

    reg   [W_DATA-1:0]              segment_pre ;
    reg   [SEGMENT_NUM*W_DATA-1:0]  din_get     ;
        reg   [14:0]                    cnt_300us   ;
        reg   [2:0]                     cnt_sel     ;
   wire                            dot         ;


wire        add_cnt_300us ;
wire        end_cnt_300us ;
always @(posedge clk or negedge rst_n) begin 
    if (rst_n==0) begin
        cnt_300us <= 0; 
    end
    else if(add_cnt_300us) begin
        if(end_cnt_300us)
           cnt_300us <= 0; 
       else
           cnt_300us <= cnt_300us+1 ;
   end
end
assign add_cnt_300us =1;
assign end_cnt_300us = add_cnt_300us  && cnt_300us == TIME_300US-1 ;

  

wire        add_cnt_sel ;
wire        end_cnt_sel ;
always @(posedge clk or negedge rst_n) begin 
    if (rst_n==0) begin
        cnt_sel <= 0;   
        end
    else if(add_cnt_sel) begin
        if(end_cnt_sel)          
          cnt_sel <= 0; 
       else

            cnt_sel <= cnt_sel+1 ;
   end
end
assign add_cnt_sel = end_cnt_300us;
assign end_cnt_sel = add_cnt_sel  && cnt_sel == SEGMENT_NUM-1 ;


reg     [SEGMENT_NUM-1:0]   din_vvld;
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        din_vvld <= 0 ;
    end
    else begin
        din_vvld <= din_vld ;
   end
end


reg [ 2:0]  cnt     ;
wire        add_cnt ;
wire        end_cnt ;
always @(posedge clk or negedge rst_n) begin 
    if (rst_n==0) begin
        cnt <= 0; 
    end
    else if(add_cnt) begin
       if(end_cnt)
           cnt <= 0; 
       else
            cnt <= cnt+1 ;
   end
end
assign add_cnt = 1;
assign end_cnt = add_cnt  && cnt == SEGMENT_NUM-1 ;

always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        din_get <= 0;
    end
   else if(din_vvld[cnt])begin
        din_get[W_DATA*(cnt+1)-1 -:W_DATA] <= din[W_DATA*(cnt+1)-1 -:W_DATA];
    end
end


    always  @(*)begin
        segment_pre = din_get[W_DATA*(cnt_sel+1)-1 -:W_DATA];
    end

   always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
           segment <= {dot,SEG_NONE_DIS};
       end
        else if(add_cnt_300us  && cnt_300us ==10-1)begin
           case(segment_pre)
                5'h00: segment <= {dot,SEG_DATA_0};
               5'h01: segment <= {dot,SEG_DATA_1};
                5'h02: segment <= {dot,SEG_DATA_2};
                5'h03: segment <= {dot,SEG_DATA_3};
                5'h04: segment <= {dot,SEG_DATA_4};
               5'h05: segment <= {dot,SEG_DATA_5};
               5'h06: segment <= {dot,SEG_DATA_6};
                5'h07: segment <= {dot,SEG_DATA_7};
                5'h08: segment <= {dot,SEG_DATA_8};
                5'h09: segment <= {dot,SEG_DATA_9};
                5'h10: segment <= {dot,SEG_CHAR_O};
                5'h11: segment <= {dot,SEG_CHAR_P};
                5'h12: segment <= {dot,SEG_CHAR_E};
                5'h13: segment <= {dot,SEG_CHAR_N};
                5'h14: segment <= {dot,SEG_CHAR_L};
              5'h15: segment <= {dot,SEG_CHAR_C};
                5'h16: segment <= {dot,SEG_CHAR_K};
               5'h17: segment <= {dot,SEG_CHAR_D};
                5'h18: segment <= {dot,SEG_CHAR_R};
               5'h1F: segment <= {dot,SEG_NONE_DIS};
             default:segment <= {dot,SEG_NONE_DIS};
           endcase
        end
    end
    assign dot = 1'b1; 

    always@(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            seg_sel <= {SEGMENT_NUM{1'b0}};
        end
        else begin
            seg_sel <= ~(1'b1<<cnt_sel);
        end
    end


    endmodule
