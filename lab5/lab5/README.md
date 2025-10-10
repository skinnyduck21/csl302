There are 3 files in this folder:

(i) var_decl.l
Consists the lex code for all 3 parts

(ii) var_decl.y
Consists the yacc code for all 3 parts

(iii) README.md
This is the present file


Steps for compiling and running:

lex var_decl.l
yacc -d var_decl.y
gcc lex.yy.c y.tab.c
./a.out


Sample Input 1:

int a, b, c;

Sample Output 1:

  variable: a
  variable: b
  variable: c
Declaration of type int completed.


Sample Input 2:

float x, y;

Sample Output 2:

  variable: x
  variable: y
Declaration of type float completed.


Sample Input 3:

a = b + c * 5 - x;

Sample Output 3:

Assignment: a = ...


Sample Input 4:

for (a=0; a<10; a=a+1) b = b + 1;

Sample Output 4:

Assignment: a = ...
Assignment: a = ...
Assignment: b = ...
For loop detected.

