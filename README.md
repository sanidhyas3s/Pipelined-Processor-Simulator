# Pipelined Processor Simulator
A Simulator for our own customised Assembly Language through a Pipelined Processor

## Requirements
- C++ and Verilog should be installed in order to run all needed files.

## Steps to write and run code
1. Write your program in `code.txt` file as per the instruction set mentioned below, in the same directory as all the source code files.
2. Now compile and run the `assemble.cpp` file. This will convert the code in `code.txt` to `code.bin` (Machine Language code for the written program).
3. Now compile and run the `Processor.v` file, the register values after each clock-cycle is displayed in the output.

## Instruction Set and other details

Start/Begin - `{`

End/Halt - `}`

Addition - `+ R1 R2 R3` 

Subtraction - `- R1 R2 R3`

And - `& R1 R2 R3` 

Or - `| R1 R2 R3`

Multiply - `* R1 R2 R3`

Add immediate - `+i R1 R2 1`

Subtract immediate - `-i R1 R2 1`

Load - `> R1 5`

Store - `< R1 5`

^= Jump if equal - `^= R1 R2 1`

^ Jump - `^ 1`

- All addresses in jump are absolute addresses (0-indexed) starting after the `{`.
- Comments can be written without any syntax before `{` and after `}`.
- Total 16 registers are present (`R0` to `R15`).

## Contributors
Anikesh Parashar, Sanidhya Singh, Sahil Safy, Tanmay Shrivastav, Prerna, Ayushka Sahu.

Made as Course Project for CSN221 (IITR)

