// `include "clock.v"

module ALU(
    input clk,
    input ALUSrc,
    input Jump,
    input Branch,
    input [3:0] rs_in,
    input [3:0] rt_in,
    input [3:0] rd_in,
    input [3:0] ALUOp,
    input [31:0] read_data1,
    input [31:0] read_data2,
    input [31:0] imm_value,
    input [11:0] badr,
    input [19:0] jadr,
    input [15:0] lsadr_in,
    input stall_in, RegDst_in, MemRead_in, MemtoReg_in, MemWrite_in, RegWrite_in,
    output reg stall_out, RegDst_out, MemRead_out, MemtoReg_out, MemWrite_out, RegWrite_out,
    output reg [3:0] rs_out,
    output reg [3:0] rt_out,
    output reg [3:0] rd_out,
    output reg [15:0] read_data2_out,
    output reg [15:0] imm_value_out,
    output reg [15:0] lsadr_out,
    output reg[15:0] result, 
    output reg Zero
);

reg [15:0] read_data;
integer fd;

always @(posedge clk) begin
    #4
    if(jump_stall.js==3)
        jump_stall.js=jump_stall.js-1;
    else begin
    stall_out = stall_in;
    if(!stall_in) begin
        RegDst_out = RegDst_in;
        MemRead_out = MemRead_in;
        MemtoReg_out = MemtoReg_in;
        MemWrite_out = MemWrite_in;
        RegWrite_out = RegWrite_in;
        rs_out = rs_in;
        rt_out = rt_in;
        rd_out = rd_in;
        read_data2_out = read_data2;
        imm_value_out = imm_value;
        lsadr_out = lsadr_in;

        case(ALUSrc)
            1'b1 :  read_data = imm_value;
            1'b0 :  read_data = read_data2;
        endcase

        case(ALUOp)
            4'b0001 :  result = read_data1 + read_data;
            4'b0010 : 
            begin
                result = read_data - read_data1;
                if(ALUSrc)
                    result = -result; 
                Zero = (read_data1-read_data==0)?1'b1 : 1'b0;
            end
            4'b0100 : result = read_data1 & read_data;
            4'b1000 : result = read_data1 | read_data;
            4'b1111 : result = read_data1 * read_data;
        endcase   
        if(Jump) 
            Program_Counter.PC = jadr; //Effective Address Calculation not needed as Absolute Addresses are used
        if(Branch) begin
            if(Zero) begin
                Program_Counter.PC = badr;
            end
            else
                Program_Counter.PC = Program_Counter.PC - 1;
        end
    end
    end
end
endmodule