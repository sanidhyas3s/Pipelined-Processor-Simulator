#include <iostream>
#include <fstream>
#include <map>
#include <bitset>

int main()
{
    std::ifstream sourcecode("code.txt");//source code file in assembly
    std::ofstream bincode("code.bin");//destination file of assembled code in binary (machine language)
    
    //mapping of operations and operands to instruction code binary
    std::map<std::string,std::string> opcodemap = {{"<","0011"},{">","1100"},
                                        {"+","0001"},{"-","0001"},{"&","0001"},{"|","0001"},{"*","0001"},
                                        {"+i","0010"},{"-i","0010"},
                                        {"^","0100"},
                                        {"^=","1000"}};//{"^!","1001"}
    std::map<std::string,std::string> regmap = {{"R0","0000"},{"R1","0001"},{"R2","0010"},{"R3","0011"},
                                        {"R4","0100"},{"R5","0101"},{"R6","0110"},{"R7","0111"},
                                        {"R8","1000"},{"R9","1001"},{"R10","1010"},{"R11","1011"},
                                        {"R12","1100"},{"R13","1101"},{"R14","1110"},{"R15","1111"}};
    std::map<std::string,std::string> funcmap = {{"+","0001"},{"+i","0001"},{"-","0010"},{"-i","0010"},{"&","0100"},{"|","1000"},{"*","1111"}};

    if(sourcecode.is_open()) 
    {  
        std::string line;
        do
        {
            sourcecode>>line;
        }while(line!="{");
        sourcecode>>line;
        while(line!="}")
        {
            std::string ic = opcodemap[line];
            if(opcodemap[line]=="0001") 
            {//R-Type : operation reg reg reg
                std::string saved=line;
                sourcecode>>line;
                ic=ic+regmap[line];
                sourcecode>>line;
                ic=ic+regmap[line];
                sourcecode>>line;
                ic=ic+regmap[line];
                ic=ic+"0000";
                ic=ic+funcmap[saved];
            }
            else if(opcodemap[line]=="0010") 
            {//I-Type : operation reg reg immediate
                std::string saved=line;
                sourcecode>>line;
                ic=ic+regmap[line];
                sourcecode>>line;
                ic=ic+regmap[line];
                int i;
                sourcecode>>i;
                ic=ic+(std::bitset<8>(i).to_string());
                ic=ic+funcmap[saved];
            }
            else if(opcodemap[line]=="0011" || opcodemap[line]== "1100")
            {//Load and Store : operation reg address
                sourcecode>>line;
                ic=ic+regmap[line];
                int i;
                sourcecode>>i;
                ic=ic+(std::bitset<16>(i).to_string());
            }
            else if(opcodemap[line]== "1000" || opcodemap[line]== "1001") 
            {//Branch : operation reg reg address
                sourcecode>>line;
                ic=ic+regmap[line];
                sourcecode>>line;
                ic=ic+regmap[line];
                int i;
                sourcecode>>i;
                ic=ic+(std::bitset<12>(i).to_string());
            }
            else if(opcodemap[line]== "0100") 
            {//Jump : jump address
                int i;
                sourcecode>>i;
                ic=ic+(std::bitset<20>(i).to_string());
            }
            bincode<<ic<<std::endl;
            sourcecode>>line;
        }
        bincode<<"000000000000000000000000";
        sourcecode.close();
        bincode.close();
    }
    else
    {//In case the source code file does not exist
        std::cout<<"Code File Not Found";
        return 1;
    }
    return 0;
}