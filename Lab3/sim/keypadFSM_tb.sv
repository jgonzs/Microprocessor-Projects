// Lab 3 - Keypad Scanner
// Name: Joaquin Gonzalez-Salgado
// Date: September 17, 2026
// Email: jgonzalezsalgado@hmc.edu
`timescale 1 ns/1 ns
module keypadFSM_tb();

    //State encoding matches the declaration order in keypadFSM.sv:
    //IDLE=0, DEBOUNCE=1, HOLD=2
    localparam IDLE     = 2'd0;
    localparam DEBOUNCE = 2'd1;
    localparam HOLD     = 2'd2;

    logic clk;
    logic reset;
    logic anyKey;
    logic oneKey;
    logic sameKey;
    logic dbDone;
    logic scanEn;
    logic dbClear;
    logic newKey;

    keypadFSM dut (
        .clk(clk),
        .reset(reset),
        .anyKey(anyKey),
        .oneKey(oneKey),
        .sameKey(sameKey),
        .dbDone(dbDone),
        .scanEn(scanEn),
        .dbClear(dbClear),
        .newKey(newKey)
    );

    //generate clock as shown in lab manual
    always
        begin
            clk = 1; #5;
            clk = 0; #5;
        end

    initial begin
        //RESET FEATURE
        reset   = 0;
        anyKey  = 0;
        oneKey  = 0;
        sameKey = 0;
        dbDone  = 0;
        #1;
        assert (dut.state == IDLE && scanEn == 1 && dbClear == 1 && newKey == 0)
            $display("PASSED! The FSM resets to IDLE and scans as desired at time: %0t.", $time);
        else
            $error("FAILED! The FSM does not reset correctly at time: %0t.", $time);

        //IDLE - no key pressed, stays IDLE
        reset = 1;
        @(posedge clk); #1;
        assert (dut.state == IDLE)
            $display("PASSED! The FSM stays IDLE with no key pressed at time: %0t.", $time);
        else
            $error("FAILED! The FSM left IDLE unexpectedly at time: %0t.", $time);

        //IDLE -> DEBOUNCE on a valid single press
        anyKey = 1; oneKey = 1; sameKey = 0;
        @(posedge clk); #1;
        assert (dut.state == DEBOUNCE && scanEn == 0 && dbClear == 0)
            $display("PASSED! IDLE -> DEBOUNCE on a key press at time: %0t.", $time);
        else
            $error("FAILED! IDLE -> DEBOUNCE transition incorrect at time: %0t.", $time);

        //DEBOUNCE -> IDLE if the press does not hold (contact bounce)
        oneKey = 0; anyKey = 0;
        @(posedge clk); #1;
        assert (dut.state == IDLE)
            $display("PASSED! DEBOUNCE -> IDLE on a bounced press at time: %0t.", $time);
        else
            $error("FAILED! DEBOUNCE -> IDLE transition incorrect at time: %0t.", $time);

        //Re-enter DEBOUNCE and hold there while the timer is not done
        anyKey = 1; oneKey = 1; dbDone = 0;
        @(posedge clk); #1;
        assert (dut.state == DEBOUNCE)
            $display("PASSED! IDLE -> DEBOUNCE again at time: %0t.", $time);
        else
            $error("FAILED! IDLE -> DEBOUNCE transition incorrect at time: %0t.", $time);

        @(posedge clk); #1;
        assert (dut.state == DEBOUNCE && newKey == 0)
            $display("PASSED! DEBOUNCE holds while dbDone is low at time: %0t.", $time);
        else
            $error("FAILED! DEBOUNCE did not hold as desired at time: %0t.", $time);

        //DEBOUNCE -> HOLD once the debounce timer expires; newKey pulses first
        dbDone = 1;
        #1;
        assert (newKey == 1)
            $display("PASSED! newKey pulses combinationally when dbDone arrives at time: %0t.", $time);
        else
            $error("FAILED! newKey did not pulse as desired at time: %0t.", $time);

        @(posedge clk); #1;
        assert (dut.state == HOLD && dbClear == 1 && scanEn == 0)
            $display("PASSED! DEBOUNCE -> HOLD once debounced at time: %0t.", $time);
        else
            $error("FAILED! DEBOUNCE -> HOLD transition incorrect at time: %0t.", $time);

        //HOLD holds while the same key stays pressed (sameKey reflects that the
        //decoded key still equals the digit already stored for this slot)
        dbDone = 0; sameKey = 1;
        @(posedge clk); #1;
        assert (dut.state == HOLD)
            $display("PASSED! HOLD holds on the same key at time: %0t.", $time);
        else
            $error("FAILED! HOLD did not hold on the same key at time: %0t.", $time);

        //HOLD -> DEBOUNCE if a different key appears on the same row while
        //anyKey never drops (finger rolls from one key to the next without a
        //clean release) - this is the rollover case
        sameKey = 0;
        @(posedge clk); #1;
        assert (dut.state == DEBOUNCE && scanEn == 0 && dbClear == 0)
            $display("PASSED! HOLD -> DEBOUNCE on a rollover to a different key at time: %0t.", $time);
        else
            $error("FAILED! HOLD -> DEBOUNCE rollover transition incorrect at time: %0t.", $time);

        //Debounce the rollover key and return to HOLD
        dbDone = 1;
        #1;
        assert (newKey == 1)
            $display("PASSED! newKey pulses for the rollover key at time: %0t.", $time);
        else
            $error("FAILED! newKey did not pulse for the rollover key at time: %0t.", $time);

        @(posedge clk); #1;
        assert (dut.state == HOLD && dbClear == 1 && scanEn == 0)
            $display("PASSED! DEBOUNCE -> HOLD for the rollover key at time: %0t.", $time);
        else
            $error("FAILED! DEBOUNCE -> HOLD transition incorrect at time: %0t.", $time);

        //HOLD -> IDLE as soon as every column reads high again (no separate
        //release-debounce state)
        dbDone = 0; sameKey = 1; anyKey = 0; oneKey = 0;
        @(posedge clk); #1;
        assert (dut.state == IDLE && scanEn == 1 && dbClear == 1)
            $display("PASSED! HOLD -> IDLE immediately on release at time: %0t.", $time);
        else
            $error("FAILED! HOLD -> IDLE transition incorrect at time: %0t.", $time);

        //RESET mid-sequence - reset is synchronous, so it takes effect on the
        //next clock edge, not immediately
        anyKey = 1; oneKey = 1; dbDone = 0;
        @(posedge clk); #1;
        assert (dut.state == DEBOUNCE)
            $display("PASSED! IDLE -> DEBOUNCE once more before the reset check at time: %0t.", $time);
        else
            $error("FAILED! IDLE -> DEBOUNCE transition incorrect at time: %0t.", $time);

        reset = 0;
        @(posedge clk); #1;
        assert (dut.state == IDLE)
            $display("PASSED! The FSM resets mid-sequence as desired at time: %0t.", $time);
        else
            $error("FAILED! The FSM does not reset mid-sequence at time: %0t.", $time);

        $display("All tests completed at %0t.", $time);
        #100 $stop;
    end
endmodule
