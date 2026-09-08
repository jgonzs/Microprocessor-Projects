// Lab 1 - FPGA & MCU Setup & Testing
// Name: Joaquin Gonzalez-Salgado
// Date: September 1, 2026
// Email: jgonzalezsalgado@hmc.edu 
`timescale 1 ns/1 ns
module counter_tb();

    logic   clk;
    logic   reset;
    logic   enable;
    
    //This width is 3 bits, read comment below
    logic   [2:0] count;

    //Note, I used smaller numbers for the testbench.
    //I decided to have the counter go to 5, which is a bit width of 3 bits (4 < 5 < 8)
    //Theoretically, any MAX and WIDTH can be used and be correct 
    //(except for Widths that are too small for the Max)
    counter #(.MAX(5), .WIDTH(3)) dut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .count(count)
    );

    //generate clock as shown in lab manual
    always
        begin
            clk = 1; #5
            clk = 0; #5;
        end

    initial begin
        //Reset is pushed, so count should be 0
        reset  = 0;
        enable = 1;
        @(posedge clk); #1;
        assert (count == 0)
            $display("PASSED! The counter resets as desired at time: %0t.", $time);
        else
            $error("FAILED! The counter behaves incorrectly at time: %0t.", $time);

        //Reset still psuhed, takes priority over enable pushed (if, else if statement)
        enable = 0;
        @(posedge clk); #1;
        assert (count == 0)
            $display("PASSED! The counter behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The counter behaves incorrectly at time: %0t.", $time);

        //Reset is not pushed, but enable is not pushed either so count should be 0
        reset  = 1;
        enable = 1;
        @(posedge clk); #1;
        assert (count == 0)
            $display("PASSED! The counter behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The counter behaves incorrectly at time: %0t.", $time);

        //Nothing has changed, no change to count
        @(posedge clk); #1;
        assert (count == 0)
            $display("PASSED! The counter behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The counter behaves incorrectly at time: %0t.", $time);

        //Enable is now on! start counting
        enable = 0;
        @(posedge clk); #1;
        assert (count == 1)
            $display("PASSED! The counter increments as desired at time: %0t.", $time);
        else
            $error("FAILED! The counter behaves incorrectly at time: %0t.", $time);

        //Enable is still on, count +1
        @(posedge clk); #1;
        assert (count == 2)
            $display("PASSED! The counter increments as desired at time: %0t.", $time);
        else
            $error("FAILED! The counter behaves incorrectly at time: %0t.", $time);

        //Enable is still on, count +1
        @(posedge clk); #1;
        assert (count == 3)
            $display("PASSED! The counter increments as desired at time: %0t.", $time);
        else
            $error("FAILED! The counter behaves incorrectly at time: %0t.", $time);

        //Enable is still on, count +1
        @(posedge clk); #1;
        assert (count == 4)
            $display("PASSED! The counter increments as desired at time: %0t.", $time);
        else
            $error("FAILED! The counter behaves incorrectly at time: %0t.", $time);

        ////Enable is still on, count +1, however maximum count has been reached (for simplicity, I'm not waiting for 10 million)
        @(posedge clk); #1;
        assert (count == 5)
            $display("PASSED! The counter reaches MAX as desired at time: %0t.", $time);
        else
            $error("FAILED! The counter behaves incorrectly at time: %0t.", $time);

        //Now that max has been reached, it should go back to 0
        @(posedge clk); #1;
        assert (count == 0)
            $display("PASSED! The counter rolls over at MAX as desired at time: %0t.", $time);
        else
            $error("FAILED! The counter behaves incorrectly at time: %0t.", $time);

        //Now let's have the clock tick to add 1 to count (enable is still pressed)
        @(posedge clk); #1;

        //And reset after. This should make the count drop back to 0. That should be all the necessary tests!
        reset = 0;
        @(posedge clk); #1;
        assert (count == 0)
            $display("PASSED! The counter resets mid-count as desired at time: %0t.", $time);
        else
            $error("FAILED! The counter behaves incorrectly at time: %0t.", $time);

        $display("All tests completed at %0t.", $time);
        #100 $stop;
        
        //That's all!
    end
endmodule