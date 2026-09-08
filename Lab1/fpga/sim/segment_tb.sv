`timescale 1 ns/1 ns
module segment_tb();

    logic [3:0] s;
    logic [6:0] seg;

    segment dut(
        .s(s), 
        .seg(seg)
        );

    initial begin
        s = 4'h0; #10;
        assert (seg == 7'b1000000)
            $display("PASSED! The segment decoder behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The segment decoder behaves incorrectly at time: %0t.", $time);

        s = 4'h1; #10;
        assert (seg == 7'b1111001)
            $display("PASSED! The segment decoder behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The segment decoder behaves incorrectly at time: %0t.", $time);

        s = 4'h2; #10;
        assert (seg == 7'b0100100)
            $display("PASSED! The segment decoder behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The segment decoder behaves incorrectly at time: %0t.", $time);

        s = 4'h3; #10;
        assert (seg == 7'b0110000)
            $display("PASSED! The segment decoder behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The segment decoder behaves incorrectly at time: %0t.", $time);

        s = 4'h4; #10;
        assert (seg == 7'b0011001)
            $display("PASSED! The segment decoder behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The segment decoder behaves incorrectly at time: %0t.", $time);

        s = 4'h5; #10;
        assert (seg == 7'b0010010)
            $display("PASSED! The segment decoder behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The segment decoder behaves incorrectly at time: %0t.", $time);

        s = 4'h6; #10;
        assert (seg == 7'b0000010)
            $display("PASSED! The segment decoder behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The segment decoder behaves incorrectly at time: %0t.", $time);

        s = 4'h7; #10;
        assert (seg == 7'b1111000)
            $display("PASSED! The segment decoder behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The segment decoder behaves incorrectly at time: %0t.", $time);

        s = 4'h8; #10;
        assert (seg == 7'b0000000)
            $display("PASSED! The segment decoder behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The segment decoder behaves incorrectly at time: %0t.", $time);

        s = 4'h9; #10;
        assert (seg == 7'b0011000)
            $display("PASSED! The segment decoder behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The segment decoder behaves incorrectly at time: %0t.", $time);

        s = 4'ha; #10;
        assert (seg == 7'b0001000)
            $display("PASSED! The segment decoder behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The segment decoder behaves incorrectly at time: %0t.", $time);

        s = 4'hb; #10;
        assert (seg == 7'b0000011)
            $display("PASSED! The segment decoder behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The segment decoder behaves incorrectly at time: %0t.", $time);

        s = 4'hc; #10;
        assert (seg == 7'b1000110)
            $display("PASSED! The segment decoder behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The segment decoder behaves incorrectly at time: %0t.", $time);

        s = 4'hd; #10;
        assert (seg == 7'b0100001)
            $display("PASSED! The segment decoder behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The segment decoder behaves incorrectly at time: %0t.", $time);

        s = 4'he; #10;
        assert (seg == 7'b0000110)
            $display("PASSED! The segment decoder behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The segment decoder behaves incorrectly at time: %0t.", $time);

        s = 4'hf; #10;
        assert (seg == 7'b0001110)
            $display("PASSED! The segment decoder behaves as desired at time: %0t.", $time);
        else
            $error("FAILED! The segment decoder behaves incorrectly at time: %0t.", $time);

        $display("All tests completed at %0t.", $time);
        #100 $finish;
    end
endmodule