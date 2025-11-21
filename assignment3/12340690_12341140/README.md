CSL302: Compiler Design - Assignment 3
Intermediate Code Generation
Team Members:

Name: Divyansh Dubey

Roll No: 12340690

Name: Keshav Mishra

Roll No: 12341140

Project Description
This project implements an Intermediate Code Generator using Flex (Lex) and Bison (Yacc). It takes a high-level C-like source program as input and generates:

A Symbol Table showing variable names, types, scopes, and array dimensions.

Three-Address Code (TAC) representing the program logic.

The solution handles variable declarations, arithmetic operations, array manipulations, and control flow statements (if-else, while).

File Structure
lex.l: Lexical analyzer specification to identify tokens.

yacc.y: Bison parser specification to define grammar and drive code generation.

symbol.c: Implementation of the Symbol Table and TAC generation logic (Label stack, temp variables).

symbol.h: Header file defining structures and function prototypes.

input1.txt: Sample test cases.

test_cases: A directory with 12 more test cases.


Compilation and Execution Instructions
To compile and run the project, follow these steps in your terminal:

1. Generate the Lexical Analyzer:

lex lex.l

2. Generate the Parser:

yacc -d yacc.y

3. Compile the C Source Files:

gcc lex.yy.c y.tab.c symbol.c

4. Run the Compiler: You can pass the input file as an argument:

./a.out < input1.txt
./a.out < test_cases/input2a.txt
./a.out < test_cases/input2b.txt
./a.out < test_cases/input2c.txt
./a.out < test_cases/input2d.txt
./a.out < test_cases/input2e.txt
./a.out < test_cases/input2f.txt
./a.out < test_cases/input2g.txt
./a.out < test_cases/input2h.txt
./a.out < test_cases/input2i.txt
./a.out < test_cases/input2j.txt
./a.out < test_cases/input2k.txt
./a.out < test_cases/input2l.txt



Test Cases Overview
Our comprehensive tests include:

input1.txt: 
  - Basic functionality with arithmetic, arrays, if-else, and while loops
  - Demonstrates proper TAC generation and symbol table tracking

input2a.txt: All arithmetic operators (+, -, *, /, %)
input2b.txt: All comparison operators (<, >, <=, >=, ==, !=)
input2c.txt: Logical AND (&&) and OR (||) operators
input2d.txt: Unary NOT (!) operator
input2e.txt: Error handling - duplicate variable declaration
input2f.txt: Error handling - undeclared variable usage
input2g.txt: Nested if-else with correct else-binding
input2h.txt: Nested while loops with proper label management
input2i.txt: Complex expression with operator precedence
input2j.txt: Array operations with computed indices
input2k.txt: Break statement in loops
input2l.txt: Nested block scoping

Features Implemented
As per the assignment requirements, the following semantics are supported:

Symbol Table: Tracks identifiers with support for nested scopes.

Declarations: Checks that identifiers are declared before use and prevents duplicate declarations within the same scope.

Control Flow:

if and if-else statements (handles nested blocks).

while loops.

Note: Logical && and || operators are treated as standard binary operators (no short-circuit evaluation) as per instructions.

Arrays: Support for array declaration int arr[10]; and access/assignment.

TAC for array write: arr[index] = value

TAC for array read: result = arr[index]

Functions: Logic is implemented within the main function.
