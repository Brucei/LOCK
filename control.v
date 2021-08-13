module control(
    clk             ,
    rst_n           ,

    key_num         ,
    key_vld         ,

    seg_dout        , 
    seg_dout_vld     
    
    );

   parameter PASSWORD_INI     = 16'h2345    ; 
    parameter CHAR_O           = 5'h10       ; 
    parameter CHAR_P           = 5'h11       ; 
    parameter CHAR_E           = 5'h12       ; 
    parameter CHAR_N           = 5'h13       ; 
    parameter CHAR_L           = 5'h14       ; 
    parameter CHAR_C           = 5'h15       ; 
    parameter CHAR_K           = 5'h16       ; 
    parameter CHAR_D           = 5'h17       ; 
    parameter CHAR_R           = 5'h18       ; 
    parameter NONE_DIS         = 5'h1F       ; 

    parameter C_10S_WID        = 29          ;
    parameter C_10S_NUM        = 500_000_000 ;
    parameter C_2S_WID         = 27          ;
  parameter C_2S_NUM         = 100_000_000 ;
    parameter C_PWD_WID        = 3           ;

    input               clk                 ;
    input               rst_n               ;
    input [3:0]         key_num             ;
    input               key_vld             ;

    output[6*5-1:0]     seg_dout            ;
    output[5:0]         seg_dout_vld        ;

   reg   [6*5-1:0]     seg_dout            ;
      wire  [5:0]         seg_dout_vld        ;

    reg   [1:0]         state_c   /* synthesis preserve */          ;
   reg   [1:0]         state_n             ;
    reg                 lock_stata_flag     ;
    reg                 password_correct_twice  ;
    
   reg   [C_2S_WID-1:0]    cnt_2s          ; 
    reg   [C_10S_WID-1:0]   cnt_10s_nvld    ;
    reg   [C_PWD_WID-1:0]   cnt_password    ;
    
   reg   [15:0]            password        ;
    
    parameter LOCKED    = 2'b00             ;
    parameter OPEN      = 2'b01             ;
    parameter PASSWORD  = 2'b10             ;
    parameter ERROR     = 2'b11             ;

    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            state_c <= LOCKED;
        end
        else begin
            state_c <= state_n;   
               end
    end

    always@(*)begin
        case(state_c)
            LOCKED:begin
               if(locked2password_switch)begin
                   state_n = PASSWORD;
                end
                else begin
                   state_n = state_c;
                end
            end
            OPEN:begin
                if(open2password_switch)begin
                  state_n = PASSWORD;
                end
                else begin
                    state_n = state_c;
                end
           end            
            PASSWORD:begin
                if(password2locked_switch0)begin
                   state_n = LOCKED;
                end
                else if(password2open_switch0 || password2open_switch1)begin
                    state_n = OPEN;
                end
                else if(password2error_switch || password2locked_switch1)begin
                    state_n = ERROR;
                end
                else begin
                    state_n = state_c;
                end
            end
            ERROR:begin
                if(error2locked_switch0 )begin
                   state_n = LOCKED;
                end
                else begin
                    state_n = state_c;
                end
            end
            default:begin
              state_n = LOCKED;
            end
        endcase
    end
    assign locked2password_switch    = state_c==LOCKED   &&  lock_stata_flag && key_num<10 && key_vld;
    assign open2password_switch      = state_c==OPEN     && !lock_stata_flag && key_num<10 && key_vld;
    assign password2locked_switch0   = state_c==PASSWORD &&  lock_stata_flag && end_cnt_10s_nvld;
    assign password2locked_switch1   = state_c==PASSWORD &&  lock_stata_flag && confirm && password!=PASSWORD_INI ;
   assign password2open_switch0     = state_c==PASSWORD &&  lock_stata_flag && confirm && password==PASSWORD_INI &&  password_correct_twice;
    assign password2open_switch1     = state_c==PASSWORD && !lock_stata_flag && end_cnt_10s_nvld;
   assign password2error_switch     = state_c==PASSWORD && !lock_stata_flag && confirm && password!=PASSWORD_INI;
    assign error2locked_switch0      = state_c==ERROR    &&  end_cnt_2s;


    always  @(posedge clk or negedge rst_n)begin
      if(rst_n==1'b0)begin
           lock_stata_flag <= 1;
       end
       else if(password2locked_switch0 || password2locked_switch1 || error2locked_switch0)begin
            lock_stata_flag <= 1;
        end
        else if(password2open_switch0 || password2open_switch1 )begin
          lock_stata_flag <= 0;
      end
 end
   
   always  @(posedge clk or negedge rst_n)begin
       if(rst_n==1'b0)begin
           cnt_10s_nvld <= 0;
       end
        else if(end_cnt_10s_nvld)begin
            cnt_10s_nvld <= 0;
      end
        else if(add_cnt_10s_nvld)begin
            cnt_10s_nvld <= cnt_10s_nvld + 1;
        end
   end
   
   assign add_cnt_10s_nvld = state_c==PASSWORD;
    assign end_cnt_10s_nvld = add_cnt_10s_nvld && cnt_10s_nvld==C_10S_NUM-1;

   assign confirm = key_num==10 && key_vld;

    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
           password_correct_twice <= 0;
       end
       else if(state_c==PASSWORD && lock_stata_flag && confirm && password==PASSWORD_INI && !password_correct_twice)begin
           password_correct_twice <= 1;
      end
       else if(password2locked_switch0 || password2locked_switch1 || password2open_switch0 || password2open_switch1 || password2error_switch)begin
            password_correct_twice <= 0;
      end
    end
    
   always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
         cnt_2s <= 0;
        end
       else if(end_cnt_2s )begin
           cnt_2s <= 0;
        end
       else if(add_cnt_2s )begin
           cnt_2s <= cnt_2s + 1;
        end
  end
   assign add_cnt_2s = state_c==ERROR;
    assign end_cnt_2s = add_cnt_2s && cnt_2s==C_2S_NUM-1;


   always  @(posedge clk or negedge rst_n)begin
       if(rst_n==1'b0)begin
           seg_dout <= 0;
       end
      else if(state_c==OPEN)begin
           seg_dout <= {NONE_DIS,NONE_DIS,CHAR_O,CHAR_P,CHAR_E,CHAR_N};
        end
        else if(state_c==LOCKED)begin
            seg_dout <= {CHAR_L,CHAR_O,CHAR_C,CHAR_K,CHAR_E,CHAR_D};
        end
        else if(state_c==ERROR)begin
            seg_dout <= {NONE_DIS,CHAR_E,CHAR_R,CHAR_R,CHAR_O,CHAR_R};
        end
        else if(state_c==PASSWORD)begin
           if(cnt_password==0)
                seg_dout <= {NONE_DIS,NONE_DIS,NONE_DIS,NONE_DIS,NONE_DIS,NONE_DIS};
           else if(cnt_password==1)
               seg_dout <= {NONE_DIS,NONE_DIS,NONE_DIS,NONE_DIS,NONE_DIS,{1'b0,password[3:0]}};
           else if(cnt_password==2)
              seg_dout <= {NONE_DIS,NONE_DIS,NONE_DIS,NONE_DIS,{1'b0,password[7:4]},{1'b0,password[3:0]}};
            else if(cnt_password==3)
                seg_dout <= {NONE_DIS,NONE_DIS,NONE_DIS,{1'b0,password[11:8]},{1'b0,password[7:4]},{1'b0,password[3:0]}};
            else if(cnt_password==4)
                seg_dout <= {NONE_DIS,NONE_DIS,{1'b0,password[15:12]},{1'b0,password[11:8]},{1'b0,password[7:4]},{1'b0,password[3:0]}};
        end
    end
    
  assign seg_dout_vld = 6'b11_1111;

 
   always  @(posedge clk or negedge rst_n)begin
       if(rst_n==1'b0)begin
          cnt_password <= 0;
       end
       else if(end_cnt_password)begin
           cnt_password <= 0;
        end
       else if(add_cnt_password)begin
            cnt_password <= cnt_password + 1;
       end
   end
   assign add_cnt_password = state_c!=ERROR && key_num<10 && key_vld && cnt_password<4;
   assign end_cnt_password = confirm || end_cnt_10s_nvld;

   always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            password <= 16'h0000;
       end
        else if(add_cnt_password)begin
           password <= {password[11:0],key_num};
       end
   end


  endmodule
