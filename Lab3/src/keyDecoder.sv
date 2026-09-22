// Lab 3 - Keypad Scanner
// Name: Joaquin Gonzalez-Salgado
// Date: September 17, 2026
// Email: jgonzalezsalgado@hmc.edu
module keyDecoder(
    input  logic [3:0] rows,
    input  logic [3:0] cols,
    output logic [3:0] sNew,
    output logic anyKey,
    output logic oneKey
);
    assign anyKey = (cols != 4'b1111);
    assign oneKey = (cols == 4'b1110) | (cols == 4'b1101) |
                    (cols == 4'b1011) | (cols == 4'b0111);

    always_comb begin
        case({rows, cols})
            8'b0001_1110: sNew = 4'h1;
            8'b0001_1101: sNew = 4'h2;
            8'b0001_1011: sNew = 4'h3;
            8'b0001_0111: sNew = 4'ha;
            8'b0010_1110: sNew = 4'h4;
            8'b0010_1101: sNew = 4'h5;
            8'b0010_1011: sNew = 4'h6;
            8'b0010_0111: sNew = 4'hb;
            8'b0100_1110: sNew = 4'h7;
            8'b0100_1101: sNew = 4'h8;
            8'b0100_1011: sNew = 4'h9;
            8'b0100_0111: sNew = 4'hc;
            8'b1000_1110: sNew = 4'he;
            8'b1000_1101: sNew = 4'h0;
            8'b1000_1011: sNew = 4'hf;
            8'b1000_0111: sNew = 4'hd;
            default:      sNew = 4'h0;
        endcase
    end
endmodule
