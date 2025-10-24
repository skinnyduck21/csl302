Files included:

(i) expr.l  
Consists of the Lex code for tokenizing keywords, identifiers, constants, and operators.

(ii) expr.y
Consists of the Yacc code for parsing boolean and relational expressions, handling variable declarations, and generating Three Address Code (TAC).

(iii) symbol.c
Implements the symbol table functions for insertion and lookup operations.

(iv) symbol.h
Header file for the symbol table, containing structure definitions and function declarations.

(v) input.txt  
Contains sample input to test the Lex and Yacc code.

(vi) README.md  
This is the present file.

---

Steps for compiling and running:

yacc -d expr.y
lex expr.l
gcc y.tab.c lex.yy.c symbol.c
./a.out < input.txt


Content of input.txt:
int a, b;
float c;
a < b;
a and b;
not a;
true or false;

Expected Output:
Inserted: a, Type: int, Scope: 0
Inserted: b, Type: int, Scope: 0
Inserted: c, Type: float, Scope: 0
t0 = a < b
Result: t0
t1 = a and b
Result: t1
t2 = not a
Result: t2
t3 = true or false
Result: t3
