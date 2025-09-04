Assignment 1 - Compiler Design  
--------------------------------

This zip file contains the solution for Assignment 1 of the Compiler Design course.  
The implementation includes a simple lexical analyzer written using LEX.

Files included:
---------------
1. lexical_analyzer.l   →  Source code of the lexical analyzer (LEX file)
2. test.txt             →  Sample input file to test the analyzer
3. README.txt           →  Instructions and details about the code submitted

How to Compile and Run:
------------------------
1. Run the following command to generate the C source code from the LEX file:
   
   lex lexical_analyzer.l

2. Compile the generated C file using GCC:
   
   gcc lex.yy.c

3. Execute the compiled program by redirecting input from the test file:
   
   ./a.out < test.txt

Expected Output:
----------------
- The analyzer processes the tokens from test.txt and outputs the recognized tokens and their classifications according to the rules defined in lexical_analyzer.l.
