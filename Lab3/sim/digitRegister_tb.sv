// Lab 3 - Keypad Scanner
// Name: Joaquin Gonzalez-Salgado
// Date: September 17, 2026
// Email: jgonzalezsalgado@hmc.edu
`timescale 1 ns/1 ns
module digitRegister_tb();

    logic clk;
    logic reset;
    logic enable;
    logic [3:0] sNew;
    logic [3:0] s1;
    logic [3:0] s2;

    digitRegister dut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .sNew(sNew),
        .s1(s1),
        .s2(s2)
    );

    //generate clock as shown in lab manual
    always
        begin
            clk = 1; #5;
            clk = 0; #5;
        end

    initial begin
        //RESET FEATURE
        reset  = 0;
        enable = 0;
        sNew   = 4'h0;
        #10;
        assert (s1 == 4'h0 && s2 == 4'h0)
            $display("PASSED! The register resets to zero at time: %0t.", $time);
        else
            $error("FAILED! The register does not reset correctly at time: %0t.", $time);

        //ENABLE FEATURE - reset released, but enable off, so no change
        reset = 1;
        sNew   = 4'h5;
        #10;
        assert (s1 == 4'h0 && s2 == 4'h0)
            $display("PASSED! The register holds with enable off at time: %0t.", $time);
        else
            $error("FAILED! The register changed with enable off at time: %0t.", $time);

        //First key: s2 takes the new key, s1 stays 0
        enable = 1;
        #10;
        assert (s1 == 4'h0 && s2 == 4'h5)
            $display("PASSED! The first key loads s2 at time: %0t.", $time);
        else
            $error("FAILED! The first key did not load correctly at time: %0t.", $time);

        //Second key: old s2 shifts to s1, new key becomes s2
        sNew = 4'h9;
        #10;
        assert (s1 == 4'h5 && s2 == 4'h9)
            $display("PASSED! The second key shifts the digits at time: %0t.", $time);
        else
            $error("FAILED! The digits did not shift correctly at time: %0t.", $time);

        //ENABLE FEATURE - disable again, digits must hold even with a new key value
        enable = 0;
        sNew   = 4'h3;
        #10;
        assert (s1 == 4'h5 && s2 == 4'h9)
            $display("PASSED! The register holds a stable key with enable off at time: %0t.", $time);
        else
            $error("FAILED! The register changed with enable off at time: %0t.", $time);

        //Third key: shifts again once enable returns
        enable = 1;
        #10;
        assert (s1 == 4'h9 && s2 == 4'h3)
            $display("PASSED! The third key shifts the digits at time: %0t.", $time);
        else
            $error("FAILED! The digits did not shift correctly at time: %0t.", $time);

        //RESET mid-stream should zero both digits immediately
        reset = 0;
        #10;
        assert (s1 == 4'h0 && s2 == 4'h0)
            $display("PASSED! The register resets mid-stream as desired at time: %0t.", $time);
        else
            $error("FAILED! The register does not reset mid-stream at time: %0t.", $time);

        $display("All tests completed at %0t.", $time);
        #100 $stop;
    end
endmodule
