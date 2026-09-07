// Lab 1 - FPGA & MCU Setup & Testing
// Name: Joaquin Gonzalez-Salgado
// Date: September 1, 2026
// Email: jgonzalezsalgado@hmc.edu 
module counter #(parameter MAX ,
                 parameter WIDTH) 
(
    input   logic   clk,
    input   logic   reset,
    input   logic   enable,
    output  logic   [WIDTH-1:0] count
);


//Counter, with end frequency of 2.40Hz
	always_ff @(posedge clk) 
	begin
			if(reset == 0)  count <= 0;
			else if(enable == 0) begin
                if(count == MAX) count <= 0;
                else count <= count + 1;
            end
	end

endmodule