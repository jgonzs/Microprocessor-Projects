// Lab 3 - Keypad Scanner
// Name: Joaquin Gonzalez-Salgado
// Date: September 17, 2026
// Email: jgonzalezsalgado@hmc.edu
module synchronizer(
    input  logic clk,
    input  logic reset,
    input  logic [3:0] d,
    output logic [3:0] q
);
    logic [3:0] mid;

    always_ff @(posedge clk) begin
        if (!reset) begin
            mid <= 4'b1111;
            q   <= 4'b1111;
        end
        else begin
            mid <= d;
            q   <= mid;
        end
    end
endmodule
