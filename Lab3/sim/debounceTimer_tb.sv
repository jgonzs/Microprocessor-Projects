// Lab 3 - Keypad Scanner
// Name: Joaquin Gonzalez-Salgado
// Date: September 17, 2026
// Email: jgonzalezsalgado@hmc.edu
`timescale 1 ns/1 ns
module debounceTimer_tb();

    //Matches the MAX hardcoded inside debounceTimer.sv (20 ms at 24 MHz)
    localparam MAX = 480_000;

    logic clk;
    logic reset;
    logic clear;
    logic done;

    debounceTimer dut (
        .clk(clk),
        .reset(reset),
        .clear(clear),
        .done(done)
    );

    //generate clock as shown in lab manual
    always
        begin
            clk = 1; #5;
            clk = 0; #5;
        end

    initial begin
        //RESET FEATURE
        reset = 0;
        clear = 0;
        #1;
        assert (dut.count == 0 && done == 0)
            $display("PASSED! The debounce timer resets to zero at time: %0t.", $time);
        else
            $error("FAILED! The debounce timer does not reset correctly at time: %0t.", $time);

        //CLEAR FEATURE - held at zero even once the top-level reset is released
        reset = 1;
        clear = 1;
        @(posedge clk); #1;
        assert (dut.count == 0 && done == 0)
            $display("PASSED! Clear holds the timer at zero at time: %0t.", $time);
        else
            $error("FAILED! Clear does not hold the timer at time: %0t.", $time);

        repeat (5) @(posedge clk); #1;
        assert (dut.count == 0 && done == 0)
            $display("PASSED! Clear continues to hold the timer at time: %0t.", $time);
        else
            $error("FAILED! The timer moved while clear was held at time: %0t.", $time);

        //RELEASE CLEAR - timer counts freely, one count per clock
        clear = 0;
        @(posedge clk); #1;
        assert (dut.count == 1)
            $display("PASSED! The timer starts counting once clear is released at time: %0t.", $time);
        else
            $error("FAILED! The timer did not start counting at time: %0t.", $time);

        repeat (9) @(posedge clk); #1;
        assert (dut.count == 10)
            $display("PASSED! The timer counts one per clock at time: %0t.", $time);
        else
            $error("FAILED! The timer count rate is incorrect at time: %0t.", $time);

        //CLEAR mid-count snaps the timer back to zero
        clear = 1;
        @(posedge clk); #1;
        assert (dut.count == 0 && done == 0)
            $display("PASSED! Clear resets the timer mid-count at time: %0t.", $time);
        else
            $error("FAILED! Clear did not reset the timer mid-count at time: %0t.", $time);

        //RUN TO EXPIRATION - done asserts exactly after MAX clocks
        clear = 0;
        repeat (MAX-1) @(posedge clk); #1;
        assert (dut.count == MAX-1 && done == 1)
            $display("PASSED! The debounce timer expires after MAX clocks at time: %0t.", $time);
        else
            $error("FAILED! The debounce timer did not expire correctly at time: %0t.", $time);

        //One more clock wraps the counter and deasserts done
        @(posedge clk); #1;
        assert (dut.count == 0 && done == 0)
            $display("PASSED! The timer wraps and done deasserts at time: %0t.", $time);
        else
            $error("FAILED! The timer did not wrap correctly at time: %0t.", $time);

        //RESET mid-run overrides clear and zeroes the timer immediately
        repeat (5) @(posedge clk); #1;
        reset = 0;
        @(posedge clk); #1;
        assert (dut.count == 0 && done == 0)
            $display("PASSED! Reset zeroes the timer mid-run at time: %0t.", $time);
        else
            $error("FAILED! Reset does not zero the timer mid-run at time: %0t.", $time);

        $display("All tests completed at %0t.", $time);
        #100 $stop;
    end
endmodule
