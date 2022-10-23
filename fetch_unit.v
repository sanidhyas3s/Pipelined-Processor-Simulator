// `include "Program_Counter.v"
// `include "clock.v"

module fetch(
    input clk,  
    output reg[23:0] instruction
);
    integer fd;

    reg [23:0] ic[99:0];
    initial begin
        //binary code is read from code.bin
        $readmemb("code.bin",ic);
    end

    always @ (posedge clk) begin
        #8
        instruction = ic[Program_Counter.PC];
        Program_Counter.PC = Program_Counter.PC + 1;
    end
endmodule