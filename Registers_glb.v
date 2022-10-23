module Registers_glb();
    integer Registers[15:0];
    integer Availability[15:0];
    integer a;
    initial begin
        for(a=0;a<16;a++)begin
            Registers[a]=0;
            Availability[a]=1;
        end
    end
endmodule