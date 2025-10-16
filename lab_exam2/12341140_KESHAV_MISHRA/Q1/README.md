The Q1 directory consists of the following files:

(1) README.md
(2) input1.txt
(3) input2.txt
(4) 1.l
(5) 1.y
(6) input3.txt

(1) README.md
This file is README.md

(2) input1.txt
This is a simple text file which consists of some text. We will pass this file as an argument to test our sol.l file.

(3) input1.txt
This is a simple text file which consists of some text. We will pass this file as an argument to test our sol.l file.

(4) 1.l
This is the Lex file.

(5) 1.y
This is the Yacc file.

(6) input3.txt
This has a wrong syntax input.

Use the following commands in the 12341140_lab3 directory to run it:

lex 1.l
yacc -d 1.y
gcc lex.yy.c y.tab.c
./a.out < input1.txt


Content of input1.txt:
if a < b goto L1
goto L2
L1: t1 = a + b
c = t1
goto L3
L2: t2 = a - b
c = t2


Expected Output:
Starting syntax analysis....
The program is syntactically correct.

--------------


For more tests covering the other cases use input2.txt:

./a.out < input2.txt

Content of input2.txt:
x = y[i]
x = *y
x = -y
x = y*z
x = y 
ab = bc

Expected output:
Starting syntax analysis....
The program is syntactically correct.

---------------

For wrong test case:
./a.out < input3.txt

Content of input3.txt:
dg ==== jkhxuih

Expected output:
Starting syntax analysis....
Error: Syntax error at token: syntax error
RESULT: SYNTAX ERROR DETECTED (1 errors).
