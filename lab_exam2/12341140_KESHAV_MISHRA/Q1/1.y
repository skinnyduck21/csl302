%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *s);
int yylex(void);


int syntax_error_count = 0;
%}



%token IDENTIFIER TEMP_VARIABLES CONSTANTS
%token OP_PLUS OP_MINUS OP_MUL OP_DIV OP_LESS OP_MORE OP_EQUAL OP_NOTEQUAL
%token SPECIAL_LEFT SPECIAL_RIGHT SPECIAL_SEMICOLON SPECIAL_COLON
%token KEY_GOTO KEY_IF
%token LABEL


%left PLUS MINUS
%left MUL DIV
%left LT GT LE GE EQ NE
%right UMINUS

%start program

%%

program:
    |
    statements
    ;

statements:
    statements statement
    | statement
    ;

statement:
    LABEL SPECIAL_COLON arithmetic_statement
    | LABEL SPECIAL_COLON conditional_statement
    | arithmetic_statement
    | conditional_statement
    ;

arithmetic_statement:
    x OP_EQUAL y
    | x OP_EQUAL y op1 z
    | x OP_EQUAL op2 y
    | x OP_EQUAL y SPECIAL_LEFT i SPECIAL_RIGHT
    | x OP_EQUAL OP_MUL y
    ;

conditional_statement:
    KEY_IF x relop y KEY_GOTO LABEL
    | KEY_GOTO LABEL;


op1:
    OP_PLUS
    | OP_MINUS
    | OP_MUL
    | OP_DIV
    ;



op2: 
    OP_MINUS
    | OP_NOTEQUAL
    ;




x:
    IDENTIFIER
    | TEMP_VARIABLES
    ;
y: 
    IDENTIFIER
    | TEMP_VARIABLES
    ;
z:
    IDENTIFIER
    | TEMP_VARIABLES
    ;

i:
    IDENTIFIER
    | TEMP_VARIABLES
    ;

relop:
    OP_MORE
    | OP_LESS
    | OP_LESS OP_EQUAL
    | OP_MORE OP_EQUAL
    | OP_EQUAL OP_EQUAL
    | OP_NOTEQUAL OP_EQUAL
    ;



%%

// Section 3: User Subroutines

int main() {
    printf("Starting syntax analysis....\n");
    yyparse();
    if (syntax_error_count == 0) {
        printf("The program is syntactically correct.\n");
    } else {
        printf("RESULT: SYNTAX ERROR DETECTED (%d errors).\n", syntax_error_count);
    }
    return 0;
}

void yyerror(const char *s) {
    // Only print a simple error and increment the counter
    fprintf(stderr, "Error: Syntax error at token: %s\n", s);
    syntax_error_count++;
}