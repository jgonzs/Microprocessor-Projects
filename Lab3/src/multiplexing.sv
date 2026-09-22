// Lab 3 - Keypad Scanner
// Name: Joaquin Gonzalez-Salgado
// Date: September 17, 2026
// Email: jgonzalezsalgado@hmc.edu
module multiplexing(
    input  logic clk,
    input  logic reset,
    input  logic enable,
    output logic state
);
    localparam MAX = 50_000; //480 Hz 
    localparam WIDTH = 18;

    logic [WIDTH-1:0] count;

    counter #(.MAX(MAX), .WIDTH(WIDTH))
        muxCounter (.clk(clk), .reset(reset), .enable(enable), .count(count));

    assign state = (count >= MAX/2);
endmodule
