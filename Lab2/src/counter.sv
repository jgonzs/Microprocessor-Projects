// counter.sv — reused from Lab 1
module counter #(parameter MAX   = 12_000_000,
                 parameter WIDTH = 24)
(
    input  logic clk,
    input  logic reset,  
    input  logic enable, 
    output logic [WIDTH-1:0] count
);
    always_ff @(posedge clk) begin
        if (!reset)             count <= 0;
        else if (enable) begin
            if (count == MAX-1) count <= 0;
            else                count <= count + 1;
        end
    end
endmodule