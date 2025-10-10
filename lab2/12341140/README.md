The directory 12341140 consists of the following 4 files:

(1) README.md
(2) input.txt
(3) 3_custom.l
(4) 4_wc.l

(1) README.md
This file is README.md

(2) input.txt
This is a simple text file which consists of some english text. We will pass this file as an argument to test our 4_wc.l file.

(3) 3_custom.l
This is the lex file that reads the character stream from the user and it prints the tokens given in the question pdf. Also if tomething not a token is entered, the code just ignores it.

Use the following commands to run it:

lex 3_custom.l 
gcc lex.yy.c 
./a.out


Sample input and output:
Keshav Mishra
NAME
(123) 456-6789
PHONE_NUMBER
keshavm@iitbhilai.ac.in
EMAIL
9999 8888 7777 6666
CREDIT_CARD

Use control C to stop the execution.

(4) 4_wc.l
This is the lex code that outputs the number of lines, words, characters and then the file name like the wc command. We will pass the input.txt file as argument.

Use the following commands to run it:

lex 4_wc.l 
gcc lex.yy.c 
./a.out input.txt


Contents of input.txt:
Hello world
This is Lex
This is second lab
Fourth task

Expected Output:
3 11 54 input.txt
