// Lab 2 - Multiplexed 7-Segment Display
// Name: Joaquin Gonzalez-Salgado
// Date: September 10, 2026
// Email: jgonzalezsalgado@hmc.edu
module lab2_jg(
    input  logic       reset,
    input  logic [3:0] s1,
    input  logic [3:0] s2,
    input  logic [3:0] cols,
    output logic [3:0] rows,
    output logic [3:0] led,
    output logic       active,
    output logic       inactive,
    output logic [6:0] seg
);
    localparam MUX_MAX    = 50_000;      
    localparam MUX_WIDTH  = 18;
    localparam SCAN_MAX   = 12_000_000;  
    localparam SCAN_WIDTH = 24;

    logic                 clk;
    logic                 state;
    logic [3:0]           s;
    logic [MUX_WIDTH-1:0] muxCount;

    HSOSC #(.CLKHF_DIV(2'b01))
        hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));

    counter #(.MAX(MUX_MAX), .WIDTH(MUX_WIDTH))
        muxCounter (.clk(clk), .reset(reset), .enable(1'b1), .count(muxCount));

    scanning #(.MAX(SCAN_MAX), .WIDTH(SCAN_WIDTH))
        scanner (.clk(clk), .reset(reset), .enable(1'b1), .rows(rows));

    sevenSegment segment (.s(s), .seg(seg));

    assign state    = (muxCount >= MUX_MAX/2);
    assign s        = state ? s2 : s1;
    assign active   = state;    // PNP base: low turns digit on
    assign inactive = ~state;
    assign led      = ~cols;     // pullups: column goes low on press
endmodule