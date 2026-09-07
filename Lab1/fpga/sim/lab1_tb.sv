`timescale 1 ns/1 ns
module lab1_tb();

    logic        reset;
    logic [3:0]  s;
    logic [2:0]  led;
    logic [6:0]  seg;

    lab1_jg dut (
        .reset(reset),
        .s(s),
        .led(led),
        .seg(seg)
    );

    // generate clock
    initial begin
        reset = 1;
        #22 reset = 0;

        // S0 XOR S1
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

        // S1 & S2
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

        //Seven Segment Display Outputs
        s = 4'h0; #10;
        assert (seg == 7'b1000000)
            $display("PASSED! The led controller behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The led controller behaves incorrectly at time: %0t.", $time);

        s = 4'h1; #10;
        assert (seg == 7'b1111001)
            $display("PASSED! The led controller behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The led controller behaves incorrectly at time: %0t.", $time);

        s = 4'h2; #10;
        assert (seg == 7'b0100100)
            $display("PASSED! The led controller behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The led controller behaves incorrectly at time: %0t.", $time);

        s = 4'h3; #10;
        assert (seg == 7'b1100000)
            $display("PASSED! The led controller behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The led controller behaves incorrectly at time: %0t.", $time);

        s = 4'h4; #10;
        assert (seg == 7'b0011001)
            $display("PASSED! The led controller behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The led controller behaves incorrectly at time: %0t.", $time);

        s = 4'h5; #10;
        assert (seg == 7'b0010010)
            $display("PASSED! The led controller behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The led controller behaves incorrectly at time: %0t.", $time);

        s = 4'h6; #10;
        assert (seg == 7'b0000010)
            $display("PASSED! The led controller behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The led controller behaves incorrectly at time: %0t.", $time);

        s = 4'h7; #10;
        assert (seg == 7'b1111000)
            $display("PASSED! The led controller behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The led controller behaves incorrectly at time: %0t.", $time);

        s = 4'h8; #10;
        assert (seg == 7'b0000000)
            $display("PASSED! The led controller behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The led controller behaves incorrectly at time: %0t.", $time);

        s = 4'h9; #10;
        assert (seg == 7'b0110000)
            $display("PASSED! The led controller behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The led controller behaves incorrectly at time: %0t.", $time);

        s = 4'ha; #10;
        assert (seg == 7'b0001000)
            $display("PASSED! The led controller behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The led controller behaves incorrectly at time: %0t.", $time);

        s = 4'hb; #10;
        assert (seg == 7'b0000011)
            $display("PASSED! The led controller behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The led controller behaves incorrectly at time: %0t.", $time);

        s = 4'hc; #10;
        assert (seg == 7'b0100110)
            $display("PASSED! The led controller behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The led controller behaves incorrectly at time: %0t.", $time);

        s = 4'hd; #10;
        assert (seg == 7'b1000001)
            $display("PASSED! The led controller behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The led controller behaves incorrectly at time: %0t.", $time);

        s = 4'he; #10;
        assert (seg == 7'b0000110)
            $display("PASSED! The led controller behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The led controller behaves incorrectly at time: %0t.", $time);

        s = 4'hf; #10;
        assert (seg == 7'b0001100)
            $display("PASSED! The led controller behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The led controller behaves incorrectly at time: %0t.", $time);

        $display("All tests completed at %0t.", $time);
        #100 $stop;
    end
endmodule