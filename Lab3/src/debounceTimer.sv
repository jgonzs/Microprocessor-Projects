// Lab 3 - Keypad Scanner
// Name: Joaquin Gonzalez-Salgado
// Date: September 17, 2026
// Email: jgonzalezsalgado@hmc.edu
module debounceTimer(
    input  logic clk,
    input  logic reset,
    input  logic clear,   //synchronous clear from the FSM, active high
    output logic done
);
    logic [18:0] count;   //20 ms

    always_ff @(posedge clk) begin
        if (!reset)                 count <= 0;
        else if (clear)             count <= 0;
        else if (count == 479999)   count <= 0;
        else                        count <= count + 1;
    end

    assign done = (count == 479_999);
endmodule
