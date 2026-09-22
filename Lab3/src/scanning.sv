// Lab 3 - Keypad Scanner
// Name: Joaquin Gonzalez-Salgado
// Date: September 17, 2026
// Email: jgonzalezsalgado@hmc.edu
module scanning(
    input  logic clk,
    input  logic reset,
    input  logic enable,      //1 = keep scanning, 0 = freeze on the current row
    output logic [3:0] rows
);
    localparam MAX   = 24_000;  //1 kHz row rate at 24 MHz
    localparam WIDTH = 15;

    logic [WIDTH-1:0] count;

    counter #(.MAX(MAX), .WIDTH(WIDTH))
        scanCounter (.clk(clk), .reset(reset), .enable(enable), .count(count));

    assign rows[3] = (count < MAX/4);
    assign rows[2] = (count >= MAX/4)   & (count < MAX/2);
    assign rows[1] = (count >= MAX/2)   & (count < 3*MAX/4);
    assign rows[0] = (count >= 3*MAX/4);
endmodule
