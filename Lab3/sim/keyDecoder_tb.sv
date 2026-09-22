// Lab 3 - Keypad Scanner
// Name: Joaquin Gonzalez-Salgado
// Date: September 17, 2026
// Email: jgonzalezsalgado@hmc.edu
`timescale 1 ns/1 ns
module keyDecoder_tb();

    logic [3:0] rows;
    logic [3:0] cols;
    logic [3:0] sNew;
    logic anyKey;
    logic oneKey;

    keyDecoder dut (
        .rows(rows),
        .cols(cols),
        .sNew(sNew),
        .anyKey(anyKey),
        .oneKey(oneKey)
    );

    initial begin
        //IDLE - no columns pulled low
        rows = 4'b0001; cols = 4'b1111; #10;
        assert (anyKey == 0 && oneKey == 0)
            $display("PASSED! No press reports anyKey/oneKey low at time: %0t.", $time);
        else
            $error("FAILED! Idle columns are not reported correctly at time: %0t.", $time);

        //Full decode table, one row at a time
        rows = 4'b0001; cols = 4'b1110; #10;
        assert (sNew == 4'h1 && anyKey == 1 && oneKey == 1)
            $display("PASSED! Row 0 col 0 decodes to 1 at time: %0t.", $time);
        else
            $error("FAILED! Row 0 col 0 decode incorrect at time: %0t.", $time);

        rows = 4'b0001; cols = 4'b1101; #10;
        assert (sNew == 4'h2 && anyKey == 1 && oneKey == 1)
            $display("PASSED! Row 0 col 1 decodes to 2 at time: %0t.", $time);
        else
            $error("FAILED! Row 0 col 1 decode incorrect at time: %0t.", $time);

        rows = 4'b0001; cols = 4'b1011; #10;
        assert (sNew == 4'h3 && anyKey == 1 && oneKey == 1)
            $display("PASSED! Row 0 col 2 decodes to 3 at time: %0t.", $time);
        else
            $error("FAILED! Row 0 col 2 decode incorrect at time: %0t.", $time);

        rows = 4'b0001; cols = 4'b0111; #10;
        assert (sNew == 4'ha && anyKey == 1 && oneKey == 1)
            $display("PASSED! Row 0 col 3 decodes to A at time: %0t.", $time);
        else
            $error("FAILED! Row 0 col 3 decode incorrect at time: %0t.", $time);

        rows = 4'b0010; cols = 4'b1110; #10;
        assert (sNew == 4'h4)
            $display("PASSED! Row 1 col 0 decodes to 4 at time: %0t.", $time);
        else
            $error("FAILED! Row 1 col 0 decode incorrect at time: %0t.", $time);

        rows = 4'b0010; cols = 4'b1101; #10;
        assert (sNew == 4'h5)
            $display("PASSED! Row 1 col 1 decodes to 5 at time: %0t.", $time);
        else
            $error("FAILED! Row 1 col 1 decode incorrect at time: %0t.", $time);

        rows = 4'b0010; cols = 4'b1011; #10;
        assert (sNew == 4'h6)
            $display("PASSED! Row 1 col 2 decodes to 6 at time: %0t.", $time);
        else
            $error("FAILED! Row 1 col 2 decode incorrect at time: %0t.", $time);

        rows = 4'b0010; cols = 4'b0111; #10;
        assert (sNew == 4'hb)
            $display("PASSED! Row 1 col 3 decodes to B at time: %0t.", $time);
        else
            $error("FAILED! Row 1 col 3 decode incorrect at time: %0t.", $time);

        rows = 4'b0100; cols = 4'b1110; #10;
        assert (sNew == 4'h7)
            $display("PASSED! Row 2 col 0 decodes to 7 at time: %0t.", $time);
        else
            $error("FAILED! Row 2 col 0 decode incorrect at time: %0t.", $time);

        rows = 4'b0100; cols = 4'b1101; #10;
        assert (sNew == 4'h8)
            $display("PASSED! Row 2 col 1 decodes to 8 at time: %0t.", $time);
        else
            $error("FAILED! Row 2 col 1 decode incorrect at time: %0t.", $time);

        rows = 4'b0100; cols = 4'b1011; #10;
        assert (sNew == 4'h9)
            $display("PASSED! Row 2 col 2 decodes to 9 at time: %0t.", $time);
        else
            $error("FAILED! Row 2 col 2 decode incorrect at time: %0t.", $time);

        rows = 4'b0100; cols = 4'b0111; #10;
        assert (sNew == 4'hc)
            $display("PASSED! Row 2 col 3 decodes to C at time: %0t.", $time);
        else
            $error("FAILED! Row 2 col 3 decode incorrect at time: %0t.", $time);

        rows = 4'b1000; cols = 4'b1110; #10;
        assert (sNew == 4'he)
            $display("PASSED! Row 3 col 0 decodes to E at time: %0t.", $time);
        else
            $error("FAILED! Row 3 col 0 decode incorrect at time: %0t.", $time);

        rows = 4'b1000; cols = 4'b1101; #10;
        assert (sNew == 4'h0)
            $display("PASSED! Row 3 col 1 decodes to 0 at time: %0t.", $time);
        else
            $error("FAILED! Row 3 col 1 decode incorrect at time: %0t.", $time);

        rows = 4'b1000; cols = 4'b1011; #10;
        assert (sNew == 4'hf)
            $display("PASSED! Row 3 col 2 decodes to F at time: %0t.", $time);
        else
            $error("FAILED! Row 3 col 2 decode incorrect at time: %0t.", $time);

        rows = 4'b1000; cols = 4'b0111; #10;
        assert (sNew == 4'hd)
            $display("PASSED! Row 3 col 3 decodes to D at time: %0t.", $time);
        else
            $error("FAILED! Row 3 col 3 decode incorrect at time: %0t.", $time);

        //MULTI-KEY - two columns low on the same row is not a valid single press
        rows = 4'b0001; cols = 4'b1100; #10;
        assert (anyKey == 1 && oneKey == 0 && sNew == 4'h0)
            $display("PASSED! Two columns low reports anyKey but not oneKey at time: %0t.", $time);
        else
            $error("FAILED! Multi-column press not reported correctly at time: %0t.", $time);

        //All columns low (every key on the row pressed at once)
        rows = 4'b0001; cols = 4'b0000; #10;
        assert (anyKey == 1 && oneKey == 0 && sNew == 4'h0)
            $display("PASSED! All columns low reports anyKey but not oneKey at time: %0t.", $time);
        else
            $error("FAILED! All-column press not reported correctly at time: %0t.", $time);

        //No row selected (scanner between rows) with a column low is not in the
        //table, so key should default low
        rows = 4'b0000; cols = 4'b1110; #10;
        assert (sNew == 4'h0)
            $display("PASSED! An unselected row defaults key to 0 at time: %0t.", $time);
        else
            $error("FAILED! An unselected row does not default correctly at time: %0t.", $time);

        $display("All tests completed at %0t.", $time);
        #100 $finish;
    end
endmodule
