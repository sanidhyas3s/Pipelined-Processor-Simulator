`include "decode_unit.v"
`include "ALU.v"
`include "DataMemory.v"
`include "WriteBack.v"
`include "fetch_unit.v"
`include "Register.v"

module pipeline(
    input clk,
    input [23:0][99:0] instructioncode,
    input [3:0] ALU_Control_Signal,
    input RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite,
    output [23:0] instruction,
    output reg[3:0] ALUOp
);

integer pc;

wire[3:0] ALUOp1;
wire[31:0] read_data1;
wire[31:0] read_data2;
wire[31:0] imm_value;
wire[15:0] alu_output1, alu_output2;
wire[3:0] Opcode;
wire[15:0] memory_read;
wire[3:0] rs_dr, rt_dr, rd_dr, funct, rs_em, rt_em, rd_em, rs_mw, rt_mw, rd_mw;
wire[11:0] badr;
wire[7:0] imm, imm_dr;
wire[19:0] jadr;
wire[15:0] lsadr1, lsadr2;
wire stall1, RegDst1,Jump1, Branch1, MemRead1, MemtoReg1, MemWrite1, ALUSrc1, RegWrite1;
wire stall2, RegDst2, Jump2, Branch2, MemRead2, MemtoReg2, MemWrite2, ALUSrc2, RegWrite2;
wire stall3, RegDst3, MemRead3, MemtoReg3, MemWrite3, RegWrite3;
wire stall4, RegDst4, MemtoReg4, RegWrite4;
wire zero;
(* keep="soft" *) wire[3:0] shamt;

//---------------------------------------------------Instruction Fetch Unit----------------------------------------------------------------------------------------

fetch fetch (.clk(clk), .instruction(instruction));

//---------------------------------------------------Instruction Decode Unit---------------------------------------------------------------------------------------

decode_unit decode_unit (.clk(clk), .stall(stall1), .instruction(instruction), .rs(rs_dr), .rt(rt_dr), .rd(rd_dr), .shamt(shamt), .funct(ALUOp1), .badr(badr), .imm(imm_dr), .jadr(jadr), .lsadr(lsadr1), .Opcode(Opcode) /*, .RegDst_in(RegDst), .Jump_in(Jump), .Branch_in(Branch), .MemRead_in(MemRead), .MemtoReg_in(MemtoReg), .MemWrite_in(MemWrite), .ALUSrc_in(ALUSrc), .RegWrite_in(RegWrite), .RegDst_out(RegDst1), .Jump_out(Jump1), .Branch_out(Branch1), .MemRead_out(MemRead1), .MemtoReg_out(MemtoReg1), .MemWrite_out(MemWrite1), .ALUSrc_out(ALUSrc1), .RegWrite_out(RegWrite1)*/);
Register Register (.clk(clk), .stall_in(stall1), .stall_out(stall2),.rs(rs_dr), .rt(rt_dr), .rd(rd_dr), .imm(imm_dr), .imm_value(imm_value), .read_data1(read_data1), .read_data2(read_data2), .RegDst_in(RegDst), .Jump_in(Jump), .Branch_in(Branch), .MemRead_in(MemRead), .MemtoReg_in(MemtoReg), .MemWrite_in(MemWrite), .ALUSrc_in(ALUSrc), .RegWrite_in(RegWrite), .RegDst_out(RegDst2), .Jump_out(Jump2), .Branch_out(Branch2), .MemRead_out(MemRead2), .MemtoReg_out(MemtoReg2), .MemWrite_out(MemWrite2), .ALUSrc_out(ALUSrc2), .RegWrite_out(RegWrite2));

//---------------------------------------------------Execution Unit------------------------------------------------------------------------------------------------

ALU ALU (.clk(clk), .stall_in(stall2), .stall_out(stall3), .ALUOp(ALUOp1), .read_data1(read_data1), .read_data2(read_data2), .imm_value(imm_value), .badr(badr), .jadr(jadr), .result(alu_output1), .Zero(zero), .rs_in(rs_dr), .rt_in(rt_dr), .rd_in(rd_dr), .lsadr_in(lsadr1), .rs_out(rs_em), .rt_out(rt_em), .rd_out(rd_em), .lsadr_out(lsadr2), .Jump(Jump2), .Branch(Branch2), .ALUSrc(ALUSrc2), .RegDst_in(RegDst2), .MemRead_in(MemRead2), .MemtoReg_in(MemtoReg2), .MemWrite_in(MemWrite2), .RegWrite_in(RegWrite2), .RegDst_out(RegDst3), .MemRead_out(MemRead3), .MemtoReg_out(MemtoReg3), .MemWrite_out(MemWrite3), .RegWrite_out(RegWrite3));
//ALU_Control_Signal ignored for now

//---------------------------------------------------Memory Access Unit--------------------------------------------------------------------------------------------

DataMemory DataMemory (.clk(clk), .stall_in(stall3), .stall_out(stall4), .read_data1(read_data2), .lsadr(lsadr2), .read_data3(memory_read), .rs_in(rs_em), .rt_in(rt_em), .rd_in(rd_em), .result_in(alu_output1), .rs_out(rs_mw), .rt_out(rt_mw), .rd_out(rd_mw), .result_out(alu_output2), .MemWrite(MemWrite3), .MemRead(MemRead3), .RegDst_in(RegDst3), .RegWrite_in(RegWrite3), .MemtoReg_in(MemtoReg3), .RegDst_out(RegDst4), .RegWrite_out(RegWrite4), .MemtoReg_out(MemtoReg4));

//---------------------------------------------------Writeback Unit------------------------------------------------------------------------------------------------

Writeback Writeback (.clk(clk), .stall(stall4), .rs(rs_mw), .rt(rt_mw), .rd(rd_mw), .alu_result(alu_output2), .read_data(memory_read), .RegDst(RegDst4), .RegWrite(RegWrite4), .MemtoReg(MemtoReg4));

endmodule