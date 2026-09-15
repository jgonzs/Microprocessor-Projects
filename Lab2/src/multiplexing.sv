// Lab 2 - Multiplexed 7-Segment Display
// Name: Joaquin Gonzalez-Salgado
// Date: September 14, 2026
// Email: jgonzalezsalgado@hmc.edu
module multiplexing #(parameter MAX   = 50_000,   //480Hz
                      parameter WIDTH = 18)
(
    input  logic clk,
    input  logic reset,
    input  logic enable,
    output logic state
);
    logic [WIDTH-1:0] count;

    counter #(.MAX(MAX), .WIDTH(WIDTH))
        muxCounter (.clk(clk), .reset(reset), .enable(enable), .count(count));

    assign state = (count >= MAX/2);
endmodule