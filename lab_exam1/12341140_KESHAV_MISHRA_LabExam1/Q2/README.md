The Q2 directory consists of the following 3 files:

(1) README.md
(2) input.txt
(3) sol.l

(1) README.md
This file is README.md

(2) input.txt
This is a simple text file which consists of some text. We will pass this file as an argument to test our sol.l file.

(3)
This is the Lex file.

Use the following commands in the 12341140_lab3 directory to run it:

lex sol.l
gcc lex.yy.c
./a.out < input.txt


Content of input.txt:
START: MOV R1, #10    ; load 10 into R1  
ADD R2, R1       ; R2 = R2 + R1  
SUB R3,  #5
JMP START
HALT



Expected Output:
LABEL       :   START
DELIMETER   :   :
OPCODE      :   MOV
REGISTER    :   R1
DELIMETER   :   ,
IMMEDIATE   :   #10
REGISTER    :   R1
OPCODE      :   ADD
REGISTER    :   R2
DELIMETER   :   ,
REGISTER    :   R1
REGISTER    :   R2
REGISTER    :   R2
REGISTER    :   R1
OPCODE      :   SUB
REGISTER    :   R3
DELIMETER   :   ,
IMMEDIATE   :   #5
OPCODE      :   JMP
LABEL       :   START
OPCODE      :   HALT

