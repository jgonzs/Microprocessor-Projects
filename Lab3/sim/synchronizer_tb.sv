// Lab 3 - Keypad Scanner
// Name: Joaquin Gonzalez-Salgado
// Date: September 17, 2026
// Email: jgonzalezsalgado@hmc.edu
`timescale 1 ns/1 ns
module synchronizer_tb();

    logic clk;
    logic reset;
    logic [3:0] d;
    logic [3:0] q;

    synchronizer dut (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );

    //generate clock as shown in lab manual
    always
        begin
            clk = 1; #5;
            clk = 0; #5;
        end

    initial begin
        //RESET FEATURE
        //Reset is pushed (active low). Idle columns are pulled up, so both
        //flops should reset to all ones, not zero.
        reset = 0;
        d     = 4'b0000;
        #12;
        assert (q == 4'b1111)
            $display("PASSED! The synchronizer resets to all ones at time: %0t.", $time);
        else
            $error("FAILED! The synchronizer does not reset correctly at time: %0t.", $time);

        //Reset held, d should have no effect
        #20;
        assert (q == 4'b1111 && dut.mid == 4'b1111)
            $display("PASSED! The synchronizer holds during reset at time: %0t.", $time);
        else
            $error("FAILED! The synchronizer moved while in reset at time: %0t.", $time);

        //RELEASE - two-flop latency
        //d changes now; it should take two clock edges to reach q
        reset = 1;
        d     = 4'b0101;
        @(posedge clk); #1;
        assert (dut.mid == 4'b0101 && q == 4'b1111)
            $display("PASSED! d reaches the first flop after one edge at time: %0t.", $time);
        else
            $error("FAILED! First-flop timing is incorrect at time: %0t.", $time);

        @(posedge clk); #1;
        assert (q == 4'b0101)
            $display("PASSED! d reaches q after two edges at time: %0t.", $time);
        else
            $error("FAILED! Second-flop timing is incorrect at time: %0t.", $time);

        //Change d again to confirm the same two-cycle latency holds generally
        d = 4'b1010;
        @(posedge clk); #1;
        assert (dut.mid == 4'b1010 && q == 4'b0101)
            $display("PASSED! New d reaches the first flop, q unchanged at time: %0t.", $time);
        else
            $error("FAILED! First-flop timing is incorrect at time: %0t.", $time);

        @(posedge clk); #1;
        assert (q == 4'b1010)
            $display("PASSED! New d reaches q after two edges at time: %0t.", $time);
        else
            $error("FAILED! Second-flop timing is incorrect at time: %0t.", $time);

        //RESET mid-stream should snap both flops back to all ones immediately
        reset = 0;
        #1;
        assert (dut.mid == 4'b1111 && q == 4'b1111)
            $display("PASSED! The synchronizer resets mid-stream as desired at time: %0t.", $time);
        else
            $error("FAILED! The synchronizer does not reset mid-stream at time: %0t.", $time);

        $display("All tests completed at %0t.", $time);
        #100 $stop;
    end
endmodule
