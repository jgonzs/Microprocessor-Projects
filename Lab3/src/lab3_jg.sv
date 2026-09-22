// Lab 3 - Keypad Scanner
// Name: Joaquin Gonzalez-Salgado
// Date: September 17, 2026
// Email: jgonzalezsalgado@hmc.edu
module lab3_jg(
    input  logic reset,
    input  logic [3:0] cols,
    output logic [3:0] rows,
    output logic [3:0] led,
    output logic active,
    output logic inactive,
    output logic [6:0] seg
);
    logic clk;
    logic state;
    logic scanEn;
    logic anyKey, oneKey, sameKey;
    logic dbClear, dbDone;
    logic newKey;
    logic [3:0] colsSync;
    logic [3:0] sNew;
    logic [3:0] s1;
    logic [3:0] s2;
    logic [3:0] s;

    HSOSC #(.CLKHF_DIV(2'b01))
        hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk));

    synchronizer synchronizer(.clk(clk), .reset(reset), .d(cols), .q(colsSync));

    scanning scanning(.clk(clk), .reset(reset), .enable(scanEn), .rows(rows));

    keyDecoder keyDecoder(.rows(rows), .cols(colsSync), .sNew(sNew),
    .anyKey(anyKey), .oneKey(oneKey));

    debounceTimer debounceTimer(.clk(clk), .reset(reset), .clear(dbClear), .done(dbDone));

    keypadFSM keypadFSM(.clk(clk), .reset(reset), .anyKey(anyKey), .oneKey(oneKey), .sameKey(sameKey), .dbDone(dbDone),
    .scanEn(scanEn), .dbClear(dbClear), .newKey(newKey));

    digitRegister digitRegister(.clk(clk), .reset(reset), .enable(newKey), .sNew(sNew),
    .s1(s1), .s2(s2));

    multiplexing multiplexing(.clk(clk), .reset(reset), .enable(1'b1), .state(state));

    sevenSegment sevenSegment(.s(s), .seg(seg));

    assign sameKey  = (sNew == s2);
    assign s = state ? s2 : s1;  //multiplexing operation
    assign active = state;    //common anode 1
    assign inactive = ~state; //common anode 2
    assign led = ~colsSync;  //for debug!!
endmodule
