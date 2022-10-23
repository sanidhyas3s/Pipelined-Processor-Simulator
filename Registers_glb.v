module Registers_glb();
    integer Registers[15:0];
    reg[15:0] Availability;
    integer a;
    initial begin
        for(a=0;a<16;a++)begin
            Registers[a]=0;
            Availability[a]=1;
        end
    end
endmodule