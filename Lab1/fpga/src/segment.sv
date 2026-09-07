// Lab 1 - FPGA & MCU Setup & Testing
// Name: Joaquin Gonzalez-Salgado
// Date: September 1, 2026
// Email: jgonzalezsalgado@hmc.edu

module segment(
    input   logic [3:0] s, //4-bit input from switches
	output  logic [6:0] seg //7 bit output for A-F on the Seven Segment
);

    always_comb begin
        case(s)
            4'h0: seg = 7'b1000000; //0
            4'h1: seg = 7'b1111001; //1
            4'h2: seg = 7'b0100100; //2
            4'h3: seg = 7'b0110000; //3
            4'h4: seg = 7'b0011001; //4
            4'h5: seg = 7'b0010010; //5
            4'h6: seg = 7'b0000010; //6
            4'h7: seg = 7'b1111000; //7
            4'h8: seg = 7'b0000000; //8
            4'h9: seg = 7'b0011000; //9
            4'ha: seg = 7'b0001000; //A
            4'hb: seg = 7'b0000011; //B
            4'hc: seg = 7'b1000110; //C
            4'hd: seg = 7'b0100001; //D
            4'he: seg = 7'b0000110; //E
            4'hf: seg = 7'b0001110; //F
            default: seg = 7'b1111111;
        endcase
    end
endmodule