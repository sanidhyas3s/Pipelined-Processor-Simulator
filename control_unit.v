// `include "fetch_unit.v"

module control_unit(
    input clk,
    input [23:0] instruction,
    output reg RegDst,
    output reg Jump,
    output reg Branch,
    output reg MemRead,
    output reg MemtoReg,
    output reg[3:0] ALUOp,
    output reg[3:0] Opcode,
    output reg MemWrite,
    output reg ALUSrc,
    output reg RegWrite
);

always @(posedge clk) begin
    #6
    Opcode = instruction[23:20];
    case(Opcode)
            4'b0001 :   begin                     //R-type instruction
                        RegDst = 1'b1;
                        RegWrite = 1'b1;
                        ALUSrc = 1'b0;
                        MemWrite = 1'b0;
                        MemRead = 1'b0;
                        MemtoReg = 1'b0;
                        Jump = 1'b0;
                        Branch = 1'b0;
                        ALUOp = instruction[3:0];
            end 
           
            4'b0010 :   begin                     //I-type instruction
                        RegDst = 1'b0;
                        RegWrite = 1'b1;
                        ALUSrc = 1'b1;
                        MemWrite = 1'b0;
                        MemRead = 1'b0;
                        MemtoReg = 1'b0;
                        Jump = 1'b0;
                        Branch = 1'b0;
                        ALUOp = instruction[3:0];
                    end
            4'b1000 :   begin                     //Branch instruction
                        RegDst = 1'b0;
                        RegWrite = 1'b0;
                        ALUSrc = 1'b0;
                        MemWrite = 1'b0;
                        MemRead = 1'b0;
                        MemtoReg = 1'b0;
                        Jump = 1'b0;
                        Branch = 1'b1;
                        ALUOp = 4'b0010;        //subtraction to take place in ALU
                    end
            4'b0100 :   begin                     //Jump instruction
                        RegDst = 1'b0;
                        RegWrite = 1'b1;
                        ALUSrc = 1'b1;
                        MemWrite = 1'b0;
                        MemRead = 1'b0;
                        MemtoReg = 1'b0;
                        Jump = 1'b1;
                        Branch = 1'b0;
                    end
            4'b1100 :   begin                     //Load instruction
                        RegDst = 1'b0;
                        RegWrite = 1'b1;
                        ALUSrc = 1'b0;
                        MemWrite = 1'b0;
                        MemRead = 1'b1;
                        MemtoReg = 1'b1;
                        Jump = 1'b0;
                        Branch = 1'b0;
                        ALUOp = 4'b0001;        //Addition to take place in ALU
                    end
            4'b0011 :   begin                     //Store instruction
                        RegDst = 1'b0;
                        RegWrite = 1'b0;
                        ALUSrc = 1'b0;
                        MemWrite = 1'b1;
                        MemRead = 1'b0;
                        MemtoReg = 1'b0;
                        Jump = 1'b0;
                        Branch = 1'b0;
                        ALUOp = 4'b0001;
                    end
        endcase
end
endmodule