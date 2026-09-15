// Lab 2 - Multiplexed 7-Segment Display
// Name: Joaquin Gonzalez-Salgado
// Date: September 10, 2026
// Email: jgonzalezsalgado@hmc.edu
//
// multiplexing: toggles which digit is shown. Uses a parametrized instance
// of the Lab 1 counter; 'state' is low for the first half of the period
// (show s1) and high for the second half (show s2).
module multiplexing #(parameter MAX   = 50_000,   // 24 MHz / 480 Hz
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