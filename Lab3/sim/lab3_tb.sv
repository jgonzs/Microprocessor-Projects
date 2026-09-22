// Lab 3 - Keypad Scanner
// Name: Joaquin Gonzalez-Salgado
// Date: September 17, 2026
// Email: jgonzalezsalgado@hmc.edu
`timescale 1 ns/1 ns
module lab3_tb();

    logic reset;
    logic [3:0] cols;
    logic [3:0] rows;
    logic [3:0] led;
    logic active;
    logic inactive;
    logic [6:0] seg;

    lab3_jg dut (
        .reset(reset),
        .cols(cols),
        .rows(rows),
        .led(led),
        .active(active),
        .inactive(inactive),
        .seg(seg)
    );

    //The top module makes its own clock with HSOSC, so the testbench does not
    //drive one. We mirror it up to this level as 'clk' so it shows in the
    //waveform and so the code below can wait on its edges.
    logic clk;
    assign clk = dut.clk;

    //Does HSOSC work? Same trick as lab1_tb/lab2_tb: count edges on dut's clock
    logic [31:0] clk_count = 0;
    always_ff @(posedge clk)
        clk_count <= clk_count + 1;

    initial begin
        cols  = 4'b1111;   //idle keypad, columns pulled high
        reset = 0;
        #100;

        assert (clk_count > 0)
            $display("PASSED! The HSOSC works as intended at time: %0t.", $time);
        else
            $error("FAILED! The HSOSC does not work as intended at time: %0t.", $time);

        //RESET FEATURE
        assert (dut.s1 == 4'h0 && dut.s2 == 4'h0)
            $display("PASSED! Reset clears both stored digits at time: %0t.", $time);
        else
            $error("FAILED! Reset does not clear the digits at time: %0t.", $time);

        assert (rows == 4'b1000)
            $display("PASSED! Reset parks the scanner on row 3 at time: %0t.", $time);
        else
            $error("FAILED! Reset does not park the scanner correctly at time: %0t.", $time);

        assert (active == 0 && inactive == 1 && seg == 7'b1000000)
            $display("PASSED! Reset drives digit 1 showing 0 at time: %0t.", $time);
        else
            $error("FAILED! Reset does not drive the display correctly at time: %0t.", $time);

        //FIRST KEY - row 3, column 2 decodes to F (see keyDecoder.sv's table)
        reset = 1;
        cols  = 4'b1011;
        repeat (500_000) @(posedge clk); #1;
        assert (dut.s2 == 4'hf && dut.s1 == 4'h0)
            $display("PASSED! The first key (F) debounces and loads s2 at time: %0t.", $time);
        else
            $error("FAILED! The first key did not register correctly at time: %0t.", $time);

        assert (dut.keypadFSM.state == 2'd2)   //HOLD
            $display("PASSED! The FSM holds the first key at time: %0t.", $time);
        else
            $error("FAILED! The FSM did not reach HOLD for the first key at time: %0t.", $time);

        //RELEASE - every column reads high again
        cols = 4'b1111;
        repeat (500_000) @(posedge clk); #1;
        assert (dut.keypadFSM.state == 2'd0)   //IDLE
            $display("PASSED! The FSM returns to IDLE after release at time: %0t.", $time);
        else
            $error("FAILED! The FSM did not return to IDLE after release at time: %0t.", $time);

        //SECOND KEY - row 3, column 1 decodes to 0; F should shift to leftDigit
        wait (rows == 4'b1000);
        cols = 4'b1101;
        repeat (500_000) @(posedge clk); #1;
        assert (dut.s2 == 4'h0 && dut.s1 == 4'hf)
            $display("PASSED! The second key (0) shifts F into s1 at time: %0t.", $time);
        else
            $error("FAILED! The second key did not shift the digits correctly at time: %0t.", $time);

        //DEBUG LEDs mirror the synchronized, inverted columns
        assert (led == ~dut.colsSync)
            $display("PASSED! The debug LEDs mirror the synchronized columns at time: %0t.", $time);
        else
            $error("FAILED! The debug LEDs do not mirror the columns at time: %0t.", $time);

        //MULTIPLEXING - active and inactive are always complementary
        assert (active == ~inactive)
            $display("PASSED! active and inactive stay complementary at time: %0t.", $time);
        else
            $error("FAILED! active and inactive are not complementary at time: %0t.", $time);

        $display("All tests completed at %0t.", $time);
        #100 $stop;
    end
endmodule
