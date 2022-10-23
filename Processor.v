`include "datapath.v"
`include "control_unit.v"
`include "ALU_Control.v"
`include "clock.v"
`include "Program_Counter.v"
`include "Registers_glb.v"
`include "jump_stall.v"

module Processor();

    wire RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, clk;
    wire[3:0] ALU_Control_Signal, AluOp;
    wire[23:0] instruction;

    Clock Clock (.clk(clk));

    control_unit control_unit (.clk(clk),.instruction(instruction), .RegDst(RegDst), .Jump(Jump), .Branch(Branch), .MemRead(MemRead), .MemtoReg(MemtoReg), .ALUOp(AluOp), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite));

    pipeline pipeline (.clk(clk), .instruction(instruction), .ALU_Control_Signal(ALU_Control_Signal), .RegDst(RegDst), .Jump(Jump), .Branch(Branch), .MemRead(MemRead), .MemtoReg(MemtoReg), .ALUOp(AluOp), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite));

    // ALU_Control ALU_Control (.clk(clk),.ALUOp(AluOp), .ALU_Control_Signal(ALU_Control_Signal));
endmodule