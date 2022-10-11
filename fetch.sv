//PC is a global variable.
module fetch(input logic[23:0] instructioncode[], output logic[23:0] instruction)
    instruction=instructioncode[PC];
    PC=PC+1;
endmodule