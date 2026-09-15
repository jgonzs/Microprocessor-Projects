// Lab 2 - Multiplexed 7-Segment Display
// Name: Joaquin Gonzalez-Salgado
// Date: September 14, 2026
// Email: jgonzalezsalgado@hmc.edu
`timescale 1 ns/1 ns
module lab2_tb();

    //Note, smaller so that it is easier to read in sim.
    localparam MUX_MAX = 8;
    localparam MUX_WIDTH = 3;
    localparam SCAN_MAX = 8;
    localparam SCAN_WIDTH = 3;

    logic reset;
    logic enable;
    logic [3:0] s1;
    logic [3:0] s2;
    logic [3:0] cols;
    logic [3:0] rows;
    logic [3:0] led;
    logic active;
    logic inactive;
    logic [6:0] seg;

    lab2_jg #(.MUX_MAX(MUX_MAX),   .MUX_WIDTH(MUX_WIDTH),
              .SCAN_MAX(SCAN_MAX), .SCAN_WIDTH(SCAN_WIDTH))
    dut (
        .reset(reset),
        .enable(enable),
        .s1(s1),
        .s2(s2),
        .cols(cols),
        .rows(rows),
        .led(led),
        .active(active),
        .inactive(inactive),
        .seg(seg)
    );

    //The top module makes its own clock with HSOSC, so the testbench does not drive
    //one. We mirror it up to this level as 'clk' so it shows in the waveform next to
    //the rest of the testbench signals and so the code below can wait on its edges.
    logic clk;
    assign clk = dut.clk;

    //Does HSOSC work?
    //Same trick as lab1_tb: count edges on the dut's clock
    logic [31:0] clk_count = 0;
    always_ff @(posedge clk)
        clk_count <= clk_count + 1;

    //Used to prove the mux counter freezes when enable is low
    logic [MUX_WIDTH-1:0] frozen;

    initial begin
        s1 = 4'h3; s2 = 4'ha; cols = 4'b1111;
        reset = 0; enable = 1;
        #100;

        //Let's check on the clock first!!!
        //If this assert passes, HSOSC does in fact produce a clock.
        assert (clk_count > 0)
            $display("PASSED! The HSOSC works as intended at time: %0t.", $time);
        else
            $error("FAILED! The HSOSC does not work as intended at time: %0t.", $time);

        //MULTIPLEXING - reset state
        //In reset the mux counter is 0, so state = 0 and digit 1 is the one driven
        assert (active == 0 && inactive == 1)
            $display("PASSED! Reset selects digit 1 (active=0, inactive=1) at time: %0t.", $time);
        else
            $error("FAILED! Reset does not select digit 1 at time: %0t.", $time);

        assert (dut.s == s1)
            $display("PASSED! Digit 1 drives s1 during reset at time: %0t.", $time);
        else
            $error("FAILED! Digit 1 does not drive s1 during reset at time: %0t.", $time);

        //MULTIPLEXING - release reset, counter runs 0..7
        //Counts 0-3 are digit 1, counts 4-7 are digit 2
        reset = 1;
        @(posedge clk);          //count 1
        repeat (3) @(posedge clk);  //count 4
        #1;
        assert (active == 1 && inactive == 0)
            $display("PASSED! Multiplexer switched to digit 2 at time: %0t.", $time);
        else
            $error("FAILED! Multiplexer did not switch to digit 2 at time: %0t.", $time);

        assert (dut.s == s2)
            $display("PASSED! Digit 2 drives s2 at time: %0t.", $time);
        else
            $error("FAILED! Digit 2 does not drive s2 at time: %0t.", $time);

        //active and inactive must always be opposites, only one digit on at a time
        assert (active == ~inactive)
            $display("PASSED! active and inactive are complementary at time: %0t.", $time);
        else
            $error("FAILED! active and inactive are not complementary at time: %0t.", $time);

        //MULTIPLEXING - four more clocks wraps the counter back to 0, digit 1 again
        repeat (4) @(posedge clk);
        #1;
        assert (active == 0 && inactive == 1)
            $display("PASSED! Multiplexer switched back to digit 1 at time: %0t.", $time);
        else
            $error("FAILED! Multiplexer did not switch back to digit 1 at time: %0t.", $time);

        assert (dut.s == s1)
            $display("PASSED! Digit 1 drives s1 again at time: %0t.", $time);
        else
            $error("FAILED! Digit 1 does not drive s1 again at time: %0t.", $time);

        //ENABLE - counters should freeze when enable is off
        //Sample the mux counter, wait some clocks, it should not have moved
        enable = 0;
        @(posedge clk); #1;
        frozen = dut.muxer.count;
        repeat (20) @(posedge clk);
        #1;
        assert (dut.muxer.count == frozen)
            $display("PASSED! Mux counter freezes with enable off at time: %0t.", $time);
        else
            $error("FAILED! Mux counter moved with enable off at time: %0t.", $time);
        enable = 1;

        //Are connections to submodules correct??
        //Reset should zero both the mux and the scan counters straight away
        reset = 0;
        @(posedge clk); #1;
        assert (dut.muxer.count == 0 && dut.scanner.count == 0)
            $display("PASSED! Reset connects to both counters at time: %0t.", $time);
        else
            $error("FAILED! Reset does not connect to both counters at time: %0t.", $time);
        reset = 1;

        //LED DRIVING (columns)
        //Columns have pullups, so an unpressed column reads 1 and a pressed column reads 0.
        //The led output is the inverse, so a pressed column lights its led.
        cols = 4'b1111; #10;
        assert (led == 4'b0000)
            $display("PASSED! No column pressed -> no LEDs at time: %0t.", $time);
        else
            $error("FAILED! LEDs on with no column pressed at time: %0t.", $time);

        cols = 4'b1110; #10;
        assert (led == 4'b0001)
            $display("PASSED! Column 0 pressed -> led[0] at time: %0t.", $time);
        else
            $error("FAILED! Column 0 press not reflected at time: %0t.", $time);

        cols = 4'b1101; #10;
        assert (led == 4'b0010)
            $display("PASSED! Column 1 pressed -> led[1] at time: %0t.", $time);
        else
            $error("FAILED! Column 1 press not reflected at time: %0t.", $time);

        cols = 4'b1011; #10;
        assert (led == 4'b0100)
            $display("PASSED! Column 2 pressed -> led[2] at time: %0t.", $time);
        else
            $error("FAILED! Column 2 press not reflected at time: %0t.", $time);

        cols = 4'b0111; #10;
        assert (led == 4'b1000)
            $display("PASSED! Column 3 pressed -> led[3] at time: %0t.", $time);
        else
            $error("FAILED! Column 3 press not reflected at time: %0t.", $time);

        //Multiple columns at once, each led should follow its own column
        cols = 4'b1010; #10;
        assert (led == 4'b0101)
            $display("PASSED! Columns 0 and 2 pressed -> led[0] and led[2] at time: %0t.", $time);
        else
            $error("FAILED! Multi-column press not reflected at time: %0t.", $time);

        cols = 4'b0000; #10;
        assert (led == 4'b1111)
            $display("PASSED! All columns pressed -> all LEDs at time: %0t.", $time);
        else
            $error("FAILED! All-press not reflected at time: %0t.", $time);

        $display("All tests completed at %0t.", $time);
        #100 $stop;
    end
endmodule