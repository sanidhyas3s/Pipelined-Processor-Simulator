module Clock(output clk);
    reg clk;
    initial
        clk = 0;
    always begin
        #5 clk = ~clk;
    end

    always //force halt
        #10000 $finish;
endmodule