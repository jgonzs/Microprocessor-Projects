// Lab 1 - FPGA & MCU Setup & Testing
// Name: Joaquin Gonzalez-Salgado
// Date: September 1, 2026
// Email: jgonzalezsalgado@hmc.edu 
module lab1_jg(
	input 	logic	reset,
	input 	logic 	enable,
	input 	logic	[3:0] s,
	output 	logic	[2:0] led,
	output 	logic   [6:0] seg 
);

	//Verilog parameters to specify width and maximum count values
	localparam WIDTH = 24;
	localparam MAX = 10000000;
	
	//Required for instantiations
	logic clk;
	logic [WIDTH-1:0] count; 

	//Switch to LED Logic
	assign led[0] = s[0] ^ s[1]; //S0 XOR S1
	assign led[1] = s[2] & s[3]; //S2 AND S3
	assign led[2] = count[23]; //WIDTH-1

	// Internal high-speed oscillator (given in E155 tutorial)
	HSOSC #(.CLKHF_DIV(2'b01)) //48MHz --> 24 MHz
         hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));
	
	//Instantiated modules
	counter #(.MAX(MAX), .WIDTH(WIDTH))
	counter(.clk(clk), .reset(reset), .enable(enable), .count(count));
	segment segment(.s(s), .seg(seg));
endmodule