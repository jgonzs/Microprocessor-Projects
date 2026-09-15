// Lab 2 - Multiplexed 7-Segment Display
// Name: Joaquin Gonzalez-Salgado
// Date: September 14, 2026
// Email: jgonzalezsalgado@hmc.edu
`timescale 1 ns/1 ns
module scanning_tb();

    logic       clk;
    logic       reset;
    logic       enable;
    logic [3:0] rows;

    //Note, I used smaller numbers for the testbench (same trick as counter_tb).
    //Theoretically, any MAX and WIDTH can be used and be correct
    scanning #(.MAX(8), .WIDTH(3)) dut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .rows(rows)
    );

    //generate clock as shown in lab manual
    always
        begin
            clk = 1; #5;
            clk = 0; #5;
        end

    initial begin
        //RESET FEATURE
        //Reset is pushed (active low), so count is 0 and only the first row should be on
        reset  = 0;
        enable = 1;
        #12;
        assert (rows == 4'b1000)
            $display("PASSED! The scanner resets to row 3 as desired at time: %0t.", $time);
        else
            $error("FAILED! The scanner does not reset correctly at time: %0t.", $time);

        //Reset held for a few more clocks, rows should not move
        #20;
        assert (rows == 4'b1000)
            $display("PASSED! The scanner holds row 3 during reset at time: %0t.", $time);
        else
            $error("FAILED! The scanner moved while in reset at time: %0t.", $time);

        //ENABLE FEATURE
        //Reset released but enable off, so count should stay frozen at 0
        reset  = 1;
        enable = 0;
        #30;
        assert (rows == 4'b1000)
            $display("PASSED! The scanner holds when enable is off at time: %0t.", $time);
        else
            $error("FAILED! The scanner moved with enable off at time: %0t.", $time);

        //ALL FOUR TRANSITIONS
        //Enable on! Counter runs 0..7, each row should be lit for 2 clocks.
        //We are currently at count 0 (rows = 1000). Wait 2 clocks -> count 2 -> rows[2]
        enable = 1;
        #20;
        assert (rows == 4'b0100)
            $display("PASSED! Transition row 3 -> row 2 as desired at time: %0t.", $time);
        else
            $error("FAILED! Transition row 3 -> row 2 incorrect at time: %0t.", $time);

        //count 4 -> rows[1]
        #20;
        assert (rows == 4'b0010)
            $display("PASSED! Transition row 2 -> row 1 as desired at time: %0t.", $time);
        else
            $error("FAILED! Transition row 2 -> row 1 incorrect at time: %0t.", $time);

        //count 6 -> rows[0]
        #20;
        assert (rows == 4'b0001)
            $display("PASSED! Transition row 1 -> row 0 as desired at time: %0t.", $time);
        else
            $error("FAILED! Transition row 1 -> row 0 incorrect at time: %0t.", $time);

        //count wraps 7 -> 0 -> rows[3] again
        #20;
        assert (rows == 4'b1000)
            $display("PASSED! Transition row 0 -> row 3 (wrap) as desired at time: %0t.", $time);
        else
            $error("FAILED! Transition row 0 -> row 3 (wrap) incorrect at time: %0t.", $time);

        //Sanity: exactly one row is ever on (one-hot)
        assert ($onehot(rows))
            $display("PASSED! Rows are one-hot at time: %0t.", $time);
        else
            $error("FAILED! Rows are not one-hot at time: %0t.", $time);

        //ENABLE mid-scan: freeze on a row that is not the reset row
        #20;   // now at count 2 -> rows = 0100
        enable = 0;
        #30;
        assert (rows == 4'b0100)
            $display("PASSED! The scanner freezes mid-scan with enable off at time: %0t.", $time);
        else
            $error("FAILED! The scanner did not freeze mid-scan at time: %0t.", $time);

        //RESET mid-scan: should jump straight back to row 3
        reset = 0;
        #10;
        assert (rows == 4'b1000)
            $display("PASSED! The scanner resets mid-scan as desired at time: %0t.", $time);
        else
            $error("FAILED! The scanner does not reset mid-scan at time: %0t.", $time);

        $display("All tests completed at %0t.", $time);
        #100 $stop;
    end
endmodule