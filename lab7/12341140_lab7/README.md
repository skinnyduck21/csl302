Files included:

(i) asm.l
Consists the lex code

(ii) asm.y
Consists the yacc code

(iii) README.md
This is the present file

(iv) input.txt
Contains sample input to test the lex code



Steps for compiling and running:

lex asm.l 
yacc -d asm.y
gcc lex.yy.c y.tab.c
./a.out < input.txt



Content of input.txt:
START: MOV R1 , #10 ; load 10 into R1
ADD R2 , R1 ; R2 = R2 + R1
SUB R3 , #5
JMP START
HALT

Expected Output:
The above program is syntactically correct.


Another example input:
MOV R1 , $10

Expected Output:
Syntax Error: syntax error
