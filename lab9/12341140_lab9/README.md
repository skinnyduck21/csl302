Files included:

(i) expr.l
Contains the Lex code for tokenizing keywords, identifiers, constants, operators, and control statements(if, else, while, etc.).

(ii) expr.y
Contains the Yacc code for parsing arithmetic, relational, and boolean expressions, as well as control structures.
Generates Three Address Code (TAC) for if, if–else, and while statements.

(iii) symbol.c
Implements the symbol table functions used for inserting and looking up variables during parsing.

(iv) symbol.h
Header file for the symbol table — includes structure definitions and function declarations.

(v) input1.txt
Demonstrates TAC generation for an if–then statement.

(vi) input2.txt
Demonstrates TAC generation for an if–then–else statement.

(vii) input3.txt
Demonstrates TAC generation for a while loop.

(viii) README.md
This file provides compilation and execution steps.

Steps for compiling and running:
yacc -d expr.y
lex expr.l
gcc lex.yy.c y.tab.c symbol.c -o lab9
./lab9 < input1.txt
./lab9 < input2.txt
./lab9 < input3.txt

Contents of Input Files:
input1.txt (if–then)
int a;
int b;
a = 2;
b = 7;
if a < b then
    a = a + b;


input2.txt (if–then–else)
int a;
int b;
a = 10;
b = 20;
if a > b then
    a = a - b;
else
    a = b - a;

input3.txt (while loop)
int a;
a = 0;
while a < 3 do
    a = a + 1;


Sample Outputs
input1.txt
Inserted: a, Type: int, Scope: 0
Inserted: b, Type: int, Scope: 0
a = 2
b = 7
t0 = a < b
t1 = a + b
a = t1
if t0 goto L0
goto L1
L0:
// THEN block
L1:

input2.txt
Inserted: a, Type: int, Scope: 0
Inserted: b, Type: int, Scope: 0
a = 10
b = 20
t0 = a > b
t1 = a - b
a = t1
t2 = b - a
a = t2
if t0 goto L0
goto L1
L0:
// THEN block
goto L2
L1:
// ELSE block
L2:

input3.txt
Inserted: a, Type: int, Scope: 0
a = 0
t0 = a < 3
t1 = a + 1
a = t1
L0:
if t0 goto L1
goto L2
L1:
// loop body
goto L0
L2: