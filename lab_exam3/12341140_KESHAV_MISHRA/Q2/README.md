Files included:

(i) lex.l
Contains the Lex code.

(ii) yacc.y
Contains the Yacc code.

(iii) symbol.c
Implements the symbol table functions used for inserting and looking up variables during parsing.

(iv) symbol.h
Header file for the symbol table — includes structure definitions and function declarations.

(v) input.txt
Contains the sample input.

(vi) README.md
This file provides compilation and execution steps.

Steps for compiling and running:


lex lex.l
yacc -d yacc.y
gcc lex.yy.c y.tab.c
./a.out < input.txt

Sample Input:

switch(a+b){case v1:a=b+c;case v2:z=z+z;default:a=d+e;}


Sample Output:

Enter switch statement:
t1 = a + b
L1:
t2 = b + c
a = t2
if switchVar == v1 goto L1
goto L2
L2:
L3:
t3 = z + z
z = t3
if switchVar == v2 goto L3
goto L4
L4:
L5:
t4 = d + e
a = t4
goto L5
goto L6
L6:
