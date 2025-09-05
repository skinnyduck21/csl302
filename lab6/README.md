Files included:

(i) var_decl.l
Consists the lex code

(ii) var_decl.y
Consists the yacc code

(iii) README.md
This is the present file

(iv) test_input.txt
Contains sample input to test the lex code



Steps for compiling and running:

lex var_decl.l
yacc -d var_decl.y
gcc lex.yy.c y.tab.c
./a.out < test_input.txt



Content of test_input.txt:

int a, b, c;
float x, y;

a = 5;
b = a + 3;
c = b * 2;

if (a < 10) then { 
    b = a; 
}

if (b > 5) then { 
    c = b; 
} else { 
    c = 0; 
}

if (a == 1) then { 
    a = 1; 
} elif (a == 2) then { 
    a = 2; 
} else { 
    a = 3; 
}

switch (a) {
  case 1: b = 10;
  case 2: b = 20;
  case 3: b = 30;
}

while (a < 5) { 
    a = a + 1; 
}

do { 
    b = b - 1; 
} while (b > 0);

for (c=0; c<3; c=c+1) 
    a = a + c;



Expected Output:

  variable: a
  variable: b
  variable: c
Declaration of type int completed.
  variable: x
  variable: y
Declaration of type float completed.
Assignment: a = ...
Assignment: b = ...
Assignment: c = ...
Assignment: b = ...
If-Then detected.
Assignment: c = ...
Assignment: c = ...
If-Then-Else detected.
Assignment: a = ...
Assignment: a = ...
Assignment: a = ...
If-Then-Elif detected.
Assignment: b = ...
  case 1 detected.
Assignment: b = ...
  case 2 detected.
Assignment: b = ...
  case 3 detected.
Switch detected.
Assignment: a = ...
While loop detected.
Assignment: b = ...
Do-While loop detected.
Assignment: c = ...
Assignment: c = ...
Assignment: a = ...
For loop detected.
