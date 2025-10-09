%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
%}

/* Tokens from Lex */
%token MOV ADD SUB MUL DIV LOAD STORE JMP CMP HALT
%token REGISTER IMMEDIATE LABEL COMMA COLON ERROR

%%
program:
        /* empty */
        | statements
        ;

statements:
        statements statement
        | statement
        ;

statement:
        labeled_statement
        | simple_statement
        ;

labeled_statement:
        LABEL COLON simple_statement
        ;

simple_statement:
        arithmetic_stmt
        | conditional_stmt
        | memory_stmt
        | halt_stmt
        ;

arithmetic_stmt:
        MOV REGISTER COMMA operand
        | ADD REGISTER COMMA operand
        | SUB REGISTER COMMA operand
        | MUL REGISTER COMMA operand
        | DIV REGISTER COMMA operand
        ;

operand:
        REGISTER
        | IMMEDIATE
        ;

conditional_stmt:
        JMP LABEL
        | CMP REGISTER COMMA operand
        ;

memory_stmt:
        LOAD REGISTER COMMA IMMEDIATE
        | STORE REGISTER COMMA IMMEDIATE
        ;

halt_stmt:
        HALT
        ;

%%

void yyerror(const char *s) {
    printf("Syntax Error: %s\n", s);
}

int main() {
    if (yyparse() == 0)
        printf("The above program is syntactically correct.\n");
    return 0;
}
