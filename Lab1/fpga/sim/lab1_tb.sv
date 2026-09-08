`timescale 1 ns/1 ns
module lab1_tb();

    logic reset;
    logic enable;
    logic [3:0] s;
    logic [2:0] led;
    logic [6:0] seg;

    lab1_jg dut (
        .reset(reset), 
        .enable(enable),
        .s(s), 
        .led(led), 
        .seg(seg) 
        );

    //Does HSOSC work?
    //In this test, we're going to route the clock directly from the dut, giving us the HSOSC output
    //Then, to show that it works, we can add an asser that shows that the edges of the clock is greater than 0!
    logic [31:0] clk_count = 0;
    always @(posedge dut.clk)
        clk_count = clk_count + 1;

    initial begin
        reset = 1; enable = 1; #22; reset = 0;

        //LED LOGIC!!!
        //S0 XOR S1
        s = 4'b0000; #10;
        assert (led[0] == 0)
            $display("PASSED! The led controller behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The led controller behaves incorrectly at time: %0t.", $time);

        s = 4'b0001; #10;
        assert (led[0] == 1)
            $display("PASSED! The led controller behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The led controller behaves incorrectly at time: %0t.", $time);

        s = 4'b0010; #10;
        assert (led[0] == 1)
            $display("PASSED! The led controller behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The led controller behaves incorrectly at time: %0t.", $time);

        s = 4'b0011; #10;
        assert (led[0] == 0)
            $display("PASSED! The led controller behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The led controller behaves incorrectly at time: %0t.", $time);

        //S1 & S2
        s = 4'b0000; #10;
        assert (led[1] == 0)
            $display("PASSED! The led controller behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The led controller behaves incorrectly at time: %0t.", $time);

        s = 4'b0100; #10;
        assert (led[1] == 0)
            $display("PASSED! The led controller behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The led controller behaves incorrectly at time: %0t.", $time);

        s = 4'b1000; #10;
        assert (led[1] == 0)
            $display("PASSED! The led controller behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The led controller behaves incorrectly at time: %0t.", $time);

        s = 4'b1100; #10;
        assert (led[1] == 1)
            $display("PASSED! The led controller behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The led controller behaves incorrectly at time: %0t.", $time);
  
        //Let's now check on the clock count!!!
        //If this assert passes, HSOSC does in fact produce a clock.
        assert (clk_count > 0)
            $display("PASSED! The HSOSC works as intended at time: %0t.", $time);
        else
            $error("FAILED! The HSOSC does not work as intended at time: %0t.", $time);

        //Are connections to submodules correct??
        //We can do this by setting enable on, running the clock, and seeing if the count is greater than 0
        //Again, we use dut.count and dut.clk to directly source from the sv file, and not a new logic component
        reset = 1;
        enable = 0;
        @(posedge dut.clk); #1;
        assert (dut.count > 0)
            $display("PASSED! The counter increases due to the clock at time: %0t.", $time);
        else
            $error("FAILED! The counter does not increase due to the clock at time: %0t.", $time);

        //Same thing with reset, but if rest is on count should remain 0.
        reset = 0;
        @(posedge dut.clk); #1;
        assert (dut.count == 0)
            $display("PASSED! Reset connects with counter at time: %0t.", $time);
        else
            $error("FAILED! Reset does not connec with counter at time: %0t.", $time);
        
        $display("All tests completed at %0t.", $time);
        #100 $stop;
    end
endmodule