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

    always_ff @(posedge clk) begin
        if (!reset)               count <= 0;
        else if (clear)           count <= 0;
        else if (count == MAX-1)  count <= 0;
        else                      count <= count + 1;
    end

    assign done = (count == MAX-1);
endmodule