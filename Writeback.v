// `include "Registers_glb.v"
// `include "clock.v"

module Writeback(
    input clk,
    input [3:0] rs,
    input [3:0] rt,
    input [3:0] rd,
    input [15:0] alu_result,
    input [15:0] read_data,
    input RegDst,
    input RegWrite,
    input MemtoReg,
    input stall
);
integer rs_int;
integer rt_int;
integer rd_int;
integer a;

always @(posedge clk) begin
    #0
    if(jump_stall.js==1)
        jump_stall.js=jump_stall.js-1;
    else begin
        if(!stall) begin
            if(RegWrite==1'b1)
                begin
                    case(MemtoReg)
                        1'b1:
                        begin
                            rs_int = rs;
                            Registers_glb.Registers[rs_int] = read_data;
                            Registers_glb.Availability[rs_int] = 1;
                        end
                        default:
                            begin
                                case(RegDst)
                                    1'b1:
                                    begin
                                        rd_int = rd;
                                        Registers_glb.Registers[rd_int] = alu_result;
                                        Registers_glb.Availability[rd_int] = 1;
                                    end
                                    1'b0:
                                    begin
                                        rs_int = rs;
                                        Registers_glb.Registers[rs_int] = alu_result;
                                        Registers_glb.Availability[rs_int] = 1;
                                    end
                                endcase
                            end
                    endcase
                end
        end
    end
    for(a=0;a<16;a++)begin
        $display("Register",a,Registers_glb.Registers[a]);
    end
    $display("");
end
endmodule