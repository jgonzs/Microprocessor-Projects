// Lab 3 - Keypad Scanner
// Name: Joaquin Gonzalez-Salgado
// Date: September 17, 2026
// Email: jgonzalezsalgado@hmc.edu
module debounceTimer(
    input  logic clk,
    input  logic reset,
    input  logic clear, //clear from FSM
    output logic done
);
    localparam MAX = 480000; //20 ms, for the button bounce!
    localparam WIDTH = 19;

    logic [WIDTH-1:0] count;

    counter #(.MAX(MAX), .WIDTH(WIDTH))
        debounceCounter (.clk(clk), .reset(reset), .enable(1'b1), .clear(clear), .count(count));

    assign done = (count == MAX-1);
endmodule