// `include "clock.v"

module ALU_Control(
    input clk,
    input[3:0] ALUOp,
    output reg[3:0] ALU_Control_Signal
);

always @ (posedge clk) begin
    #7 //just after control unit but in the same cycle
    ALU_Control_Signal = ALUOp ;
end

endmodule