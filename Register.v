// `include "Registers_glb.v"

module Register(
    input clk,
    input [3:0] rs,
    input [3:0] rt,
    input [3:0] rd,
    input [7:0] imm,
    input stall_in, RegDst_in, Jump_in, Branch_in, MemRead_in, MemtoReg_in, MemWrite_in, ALUSrc_in, RegWrite_in,
    output reg stall_out, RegDst_out, Jump_out, Branch_out, MemRead_out, MemtoReg_out, MemWrite_out, ALUSrc_out, RegWrite_out,
    output integer read_data1,
    output integer read_data2,
    output integer imm_value
);

    integer rs_index=0;
    integer i=0;
    integer rt_index=0;

    always @(posedge clk ) begin
        #7
        stall_out = stall_in;
        if(!stall_in) begin
            RegDst_out = RegDst_in;
            Jump_out = Jump_in;
            Branch_out = Branch_in;
            MemRead_out = MemRead_in;
            MemtoReg_out = MemtoReg_in;
            MemWrite_out = MemWrite_in;
            ALUSrc_out = ALUSrc_in;
            RegWrite_out = RegWrite_in;
            if(RegDst_in && RegWrite_in && !Branch_in && !MemWrite_in)
            begin
                rs_index = rs;
                read_data1=Registers_glb.Registers[rs_index];
                rt_index = rt;
                read_data2=Registers_glb.Registers[rt_index];
            end

            if(!RegDst_in && RegWrite_in && !Branch_in && !MemWrite_in)
            begin
                rs_index = rs;
                rt_index = rt;
                read_data1=Registers_glb.Registers[rt_index];
                imm_value = imm;
            end

            if(!RegDst_in && !RegWrite_in && Branch_in && !MemWrite_in)
            begin
                rs_index = rs;
                read_data1=Registers_glb.Registers[rs_index];
                rt_index = rt;
                read_data2=Registers_glb.Registers[rt_index];
            end

            if(!RegDst_in && !RegWrite_in && !Branch_in && MemWrite_in)
            begin                          
                rs_index = rs;
                read_data1 = Registers_glb.Registers[rs_index];
            end
        end
    end
endmodule