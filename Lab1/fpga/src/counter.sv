// Lab 1 - FPGA & MCU Setup & Testing
// Name: Joaquin Gonzalez-Salgado
// Date: September 1, 2026
// Email: jgonzalezsalgado@hmc.edu 
module counter(
    input   logic   clk,
    input   logic   reset,
    input   logic   enable,
    output  logic [23:0] count
);


//Counter, with end frequency of 2.40Hz
	always_ff @(posedge clk) 
	begin
			if(reset == 0)  count <= 0;
			else if(enable) begin
                if(count == 10000000) count <= 0;
                else count <= count + 1;
            end
	end

endmodule