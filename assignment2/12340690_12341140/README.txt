This project implements a Lexical Analyzer (lexical_analyzer.l) and a Syntax Analyzer (syntax_analyzer.y) using Lex and Yacc.
It analyzes assembly-like code and validates its syntax based on defined grammar rules.

testCase.txt contains a sample input program used for testing.

input.txt includes multiple test cases that can be appended to testCase.txt for extended testing.

To run the code:
lex lexical_analyzer.l 
yacc -d syntax_analyzer.y
gcc lex.yy.c y.tab.c
./a.out<testCase.txt

More testcases can be added from input.txt to testCase.txt to run
