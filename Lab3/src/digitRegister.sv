// Lab 3 - Keypad Scanner
// Name: Joaquin Gonzalez-Salgado
// Date: September 17, 2026
// Email: jgonzalezsalgado@hmc.edu
module digitRegister(
    input  logic clk,
    input  logic reset,
    input  logic enable,
    input  logic [3:0] sNew,
    output logic [3:0] s1,
    output logic [3:0] s2
);
    always_ff @(posedge clk) begin
        if (!reset) begin
            s1 <= 4'h0;
            s2 <= 4'h0;
        end
        else if (enable) begin
            s1 <= s2;
            s2 <= sNew;
        end
    end
endmodule
