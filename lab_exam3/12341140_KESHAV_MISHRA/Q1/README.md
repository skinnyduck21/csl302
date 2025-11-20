Files included:

(i) lex.l
Contains the Lex code.

(ii) yacc.y
Contains the Yacc code.

(iii) input.txt

(viii) README.md
This file provides compilation and execution steps.

Steps for compiling and running:

lex lex.l
yacc -d yacc.y
gcc lex.yy.c y.tab.c
./a.out < input.txt

Sample Input:
a+b

Sample Output:
a b +
