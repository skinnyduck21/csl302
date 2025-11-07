Files included:

(i) expr.l
Contains the Lex code for tokenizing keywords, identifiers, constants, operators, and control statements (if, else, while, etc.).

(ii) expr.y
Contains the Yacc code for parsing arithmetic, relational, and boolean expressions, as well as control structures.
Generates Three Address Code (TAC) using backpatching for if, if–else, while, and function calls.

(iii) symbol.c
Implements the symbol table functions used for inserting and looking up variables during parsing.

(iv) symbol.h
Header file for the symbol table — includes structure definitions and function declarations.

(v) attr.h
Defines attribute structures used in backpatching (truelist, falselist, nextlist, etc.).

(vi) input.txt
Demonstrates TAC generation for if–then–else statements.

(vii) README.md
This file provides compilation and execution steps.

Steps for compiling and running:
yacc -d expr.y
lex expr.l
gcc lex.yy.c y.tab.c symbol.c
./a.out < input.txt

Contents of Input File (input.txt):
int a;
int b;
a = 10;
b = 20;
if (a < b) then
{
    a = a + b;
}


Sample Output:
0: a = 10
1: b = 20
2: if a < b goto 4
3: goto 8
4: t0 = a + b
5: a = t0
