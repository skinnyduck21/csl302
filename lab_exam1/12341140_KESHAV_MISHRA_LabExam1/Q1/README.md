The Q2 directory consists of the following 3 files:

(1) README.md
(2) input.txt
(3) 1.l

(1) README.md
This file is README.md

(2) input.txt
This is a simple text file which consists of some text. We will pass this file as an argument to test our sol.l file.

(3)
This is the Lex file.

Use the following commands in the 12341140_lab3 directory to run it:

lex 1.l
gcc lex.yy.c
./a.out < input.txt


Content of input.txt:
40000000
50000000
10000000




Expected Output:
EMPL_CON
OTHER
PHD_STUDENT


