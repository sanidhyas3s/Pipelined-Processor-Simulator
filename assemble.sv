module assemble(input string code[$],output logic[23:0] instuctioncode[]);
    instructioncode = new[code.size()];
    inital begin
        foreach(code[i]) begin
            //splitting the line of code using spaces
            string elements[$];
            string word = "";
            foreach(lineofcode[i]) begin
                if(lineofcode[i]==" ") begin
                    elements.push_back(word);
                    word = "";
                end
                else begin
                    word = {word,lineofcode[i]};
                end
            end
            elements.push_back(word);
            //elements array now has the operation and operands separated
            //Mappings from Assembly Code to Instruction Code
            logic[4] opcodemap [string] =  {"<":4'b0011,">":4'b1100,
                                        "+":4'b0001,"-":4'b0001,"&":4'b0001,"|":4'b0001,
                                        "+i":4'b0010,"-i":4'b0010,
                                        "^":4'b0100,
                                        "^=":4'b1000,"^!":4'b1001} //,"^0":4'b1010,"^1":4'b1011};
        
            logic[4] regmap [string] = {"R0":4'b0000,"R1":4'b0001,"R2":4'b0010,"R3":4'b0011,
                                        "R4":4'b0100,"R5":4'b0101,"R6":4'b0110,"R7":4'b0111,
                                        "R8":4'b1000,"R9":4'b1001,"R10":4'b1010,"R11":4'b1011,
                                        "R12":4'b1100,"R13":4'b1101,"R14":4'b1110,"R15":4'b1111};

            logic[4] funcmap [string] = {"+":4'b0001,"+i":4'b0001,"-":4'b0010,"-i":4'b0010,"&":4'b0100,"|":4'b1000};

            //R-Type
            if(opcodemap[elements[0]]==4'b0001) begin
                instructioncode[i][3:0]=opcodemap[elements[0]];
                instructioncode[i][7:4]=regmap[elements[1]];
                instructioncode[i][11:8]=regmap[elements[2]];
                instructioncode[i][15:12]=regmap[elements[3]];
                instructioncode[i][19:16]=4'b0000;
                instructioncode[i][23:20]=funcmap[elements[0]];
            end
            //I-Type
            else if(opcodemap[elements[0]]==4'b0010) begin
                instructioncode[i][3:0]=opcodemap[elements[0]];
                instructioncode[i][7:4]=regmap[elements[1]];
                instructioncode[i][11:8]=regmap[elements[2]];
                int i = elements[3].atoi();
                instructioncode[i][19:12]=8'(i);
                instructioncode[i][23:20]=funcmap[elements[0]];
            end
            //Load and Store   
            else if(opcodemap[elements[0]]==4'b0011 || opcodemap[elements[0]]==4'b1100) begin
                instructioncode[i][3:0]=opcodemap[elements[0]];
                instructioncode[i][7:4]=regmap[elements[1]];
                int i = elements[2].atoi();
                instructioncode[i][23:8]=16'(i);
            end
            //Branch Instructions
            else if(opcodemap[elements[0]]&4'b1110==4'b1000) begin
                instructioncode[i][3:0]=opcodemap[elements[0]];
                instructioncode[i][7:4]=regmap[elements[1]];
                instructioncode[i][11:8]=regmap[elements[2]];
                int i = elements[3].atoi();
                instructioncode[i][23:12]=12'(i);
            end
            //Jump Instructions
            else if(opcodemap[elements[0]]==4'b0100) begin
                instructioncode[i][3:0]=opcodemap[elements[0]];
                int i = elements[1].atoi();
                instructioncode[i][23:4]=20'(i);
            end 
        end
    end
endmodule