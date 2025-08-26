The 12341140_lab3 directory consists of the following 4 files:

(1) README.md
(2) input.txt
(3) 12341140_lab3.l

(1) README.md
This file is README.md

(2) input.txt
This is a simple text file which consists of some text. We will pass this file as an argument to test our 12341140_lab3.l file.

(3)
This is the Lex file that reads a character stream from a file or user input and prints the tokens corresponding to the subset of C preprocessor features as specified in the question pdf. Any whitespace is ignored, and characters that do not match any token are printed as it is.

Use the following commands in the 12341140_lab3 directory to run it:

lex 12341140_lab3.l
gcc lex.yy.c
./a.out < input.txt


Content of input.txt:
#define MAX 100
#include "header.h"
$COUNT == 10
@@ single line comment
"""
This is a
multi-line comment
"""
main.c
0x1F
3.14


Expected Output:
#define	KEYWORD
MAX100	INTEGER
#include	KEYWORD
"header.h"	STRING_LITERAL
$COUNT	IDENTIFIER
==	EQ_OPERATOR
10	INTEGER
@@ single line comment	COMMENT_SINGLE
"""
This is a
multi-line comment
"""	COMMENT_MULTIPLE
main.c	FILENAME
0x1F	HEX_INTEGER
3.14	FLOAT
