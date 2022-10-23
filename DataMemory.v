// `include "clock.v"
`include "Memory.v"

module DataMemory (
    input [3:0] rs_in,
    input [3:0] rt_in,
    input [3:0] rd_in,
    input [31:0] read_data1,
    input MemRead,
    input MemWrite, 
    input [15:0]lsadr,
    input [15:0] result_in, 
    input clk,
    input stall_in, RegDst_in, MemtoReg_in, RegWrite_in,
    output reg stall_out, RegDst_out, MemtoReg_out, RegWrite_out,
    output reg [3:0] rs_out,
    output reg [3:0] rt_out,
    output reg [3:0] rd_out,
    output reg[15:0] result_out,
    output reg[15:0] read_data3
);
    integer lsadr_int;
    always @ (posedge clk) begin
        #2
        if(jump_stall.js==2)
            jump_stall.js=jump_stall.js-1;
        else begin
        stall_out = stall_in;
        if(!stall_in) begin
            RegDst_out = RegDst_in;
            MemtoReg_out = MemtoReg_in;
            RegWrite_out = RegWrite_in;
            rs_out = rs_in;
            rt_out = rt_in;
            rd_out = rd_in;
            result_out = result_in;
            if(MemRead==1)
            begin
                lsadr_int = lsadr;
                read_data3 = Memory.Data[lsadr_int];
            end
            else if(MemWrite==1)
            begin
                lsadr_int = lsadr;
                Memory.Data[lsadr_int] = read_data1;
            end
        end
        end
    end 
endmodule