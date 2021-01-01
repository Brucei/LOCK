`timescale 1ns/1ns
module keypad1_tb;
	
	reg clk;
	reg rst_n;
	reg [3:0] row;
	reg [15:0] myrand;

	wire key_flag;
	wire [3:0] key_value;
	wire [2:0] col;
	
	keypad1 keypad1(
		.clk(clk),
		.rst_n(rst_n),
		.row(row),
		
		.col(col),
		.key_flag_r(key_flag),
		.key_value(key_value)
	);
	
	initial clk = 1;
	always #10 clk = ~clk;
	
	initial begin
		rst_n = 0;
		row = 4'b1111;
		#201;
		rst_n = 1;
		#300;
		press;
		
		#1000;
		press;
		
		#1000;
		press;
		
		#1000;
		press;
		
		#2000;
		$stop;	
	end 
	

	
	task press;
	begin
		repeat(30) begin
			myrand = {$random}%1023;
			#myrand row[1] = ~row[1];
		end 
		
		row = 4'b1101;
		#21_000;
				
		repeat(30) begin
			myrand = {$random}%1023;
			#myrand row[1] = ~row[1];
		end 
		
		row = 4'b1111;
		#21_000;
	end
	endtask 

endmodule 