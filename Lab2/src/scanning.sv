// Lab 2 - Multiplexed 7-Segment Display
// Name: Joaquin Gonzalez-Salgado
// Date: September 10, 2026
// Email: jgonzalezsalgado@hmc.edu
module scanning #(parameter MAX   = 12_000_000,   //2Hz counter
                  parameter WIDTH = 24)
(
    input  logic clk,
    input  logic reset,
    input  logic enable,
    output logic [3:0] rows
);
    logic [WIDTH-1:0] count;

    counter #(.MAX(MAX), .WIDTH(WIDTH))
        scanCounter (.clk(clk), .reset(reset), .enable(enable), .count(count));

    //row assignments
    assign rows[3] = (count < MAX/4);
    assign rows[2] = (count >= MAX/4) & (count < MAX/2);
    assign rows[1] = (count >= MAX/2) & (count < 3*MAX/4);
    assign rows[0] = (count >= 3*MAX/4);
endmodule