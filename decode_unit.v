// `include "clock.v"

module decode_unit(
    input clk,
    input  wire[23:0] instruction,
    output reg stall,
    output reg[3:0] rs, 
    output reg[3:0] rt,
    output reg[3:0] rd, 
    output reg[3:0] shamt,
    output reg[3:0] funct,
    output reg[11:0] badr,
    output reg[7:0] imm,
    output reg[19:0] jadr,
    output reg[15:0] lsadr,
    output reg[3:0] Opcode
    );
    initial begin
        stall = 0;
    end
    always @ (posedge clk) begin
        #6
        if(jump_stall.js==4)
            jump_stall.js=jump_stall.js-1;
        else begin
            Opcode = instruction[23:20];
            if(instruction == 24'b0 || instruction == 24'bx)
            begin
                #16 
                $display("Program Halted.");
                $finish;
            end
            case(Opcode)
                4'b0001 : 
                begin
                    rd = instruction[19:16];
                    rt = instruction[15:12];
                    rs = instruction[11:8];
                    if(!Registers_glb.Availability[rs] | !Registers_glb.Availability[rt])
                        stall = 1'b1;
                    else begin
                        stall = 1'b0;
                        Registers_glb.Availability[rd] = 0;
                    end
                    shamt = instruction[7:4];
                    funct = instruction[3:0];
                end
                
                4'b0010 : 
                begin
                    rs = instruction[19:16];
                    rt = instruction[15:12];
                    if(!Registers_glb.Availability[rt])
                        stall = 1'b1;                
                    else
                        stall = 1'b0;
                    imm = instruction[11:4];
                    funct = instruction[3:0];
                    Registers_glb.Availability[rs] = 0;
                end

                4'b1000 :
                begin
                    rs = instruction[19:16];
                    rt = instruction[15:12];
                    badr= instruction[11:0];
                    funct= 4'b0010;
                    if(!Registers_glb.Availability[rs] | !Registers_glb.Availability[rt])
                        stall = 1'b1;
                    else begin
                        stall = 1'b0;
                        jump_stall.js = 4;
                    end
                end

                4'b0100 : 
                begin
                    jadr = instruction[19:0];
                    jump_stall.js = 4;
                end

                4'b1100 : 
                begin
                    rs = instruction[19:16];
                    lsadr= instruction[15:0];
                    Registers_glb.Availability[rs] = 0;
                end
                
                4'b0011 :
                begin
                    rs = instruction[19:16];
                    lsadr= instruction[15:0];
                    if(!Registers_glb.Availability[rs])
                        stall = 1'b1;
                    else
                        stall = 1'b0;
                end
            endcase
            if(stall)
                Program_Counter.PC = Program_Counter.PC - 1;
        end
    end
endmodule