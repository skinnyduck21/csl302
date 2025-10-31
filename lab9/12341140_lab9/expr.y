%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbol.h"

int yylex();
void yyerror(const char *s);

int tempCount = 0;
int labelCount = 0;

char *newtemp() {
    char *buf = malloc(10);
    sprintf(buf, "t%d", tempCount++);
    return buf;
}

char *newlabel() {
    char *buf = malloc(10);
    sprintf(buf, "L%d", labelCount++);
    return buf;
}
%}

%union {
    char *str;
}

/* Declare typed tokens */
%token <str> ID NUM RELOP
%token INT FLOAT IF THEN ELSE WHILE DO
%type <str> expr bool stmt

%start program

%%

program
    : decls stmts
    ;

decls
    : decls decl
    | /* empty */
    ;

decl
    : INT ID ';' { insertSymbol($2, "int", 0); }
    | FLOAT ID ';' { insertSymbol($2, "float", 0); }
    ;

stmts
    : stmts stmt
    | stmt
    ;

stmt
    : ID '=' expr ';' {
        printf("%s = %s\n", $1, $3);
    }
    | IF bool THEN stmt {
        char *ltrue = newlabel();
        char *lend = newlabel();
        printf("if %s goto %s\n", $2, ltrue);
        printf("goto %s\n", lend);
        printf("%s:\n", ltrue);
        printf("// THEN block\n");
        printf("%s:\n", lend);
    }
    | IF bool THEN stmt ELSE stmt {
        char *ltrue = newlabel();
        char *lfalse = newlabel();
        char *lend = newlabel();
        printf("if %s goto %s\n", $2, ltrue);
        printf("goto %s\n", lfalse);
        printf("%s:\n", ltrue);
        printf("// THEN block\n");
        printf("goto %s\n", lend);
        printf("%s:\n", lfalse);
        printf("// ELSE block\n");
        printf("%s:\n", lend);
    }
    | WHILE bool DO stmt {
        char *lstart = newlabel();
        char *ltrue = newlabel();
        char *lend = newlabel();
        printf("%s:\n", lstart);
        printf("if %s goto %s\n", $2, ltrue);
        printf("goto %s\n", lend);
        printf("%s:\n", ltrue);
        printf("// loop body\n");
        printf("goto %s\n", lstart);
        printf("%s:\n", lend);
    }
    ;

expr
    : expr '+' expr {
        char *t = newtemp();
        printf("%s = %s + %s\n", t, $1, $3);
        $$ = t;
    }
    | expr '-' expr {
        char *t = newtemp();
        printf("%s = %s - %s\n", t, $1, $3);
        $$ = t;
    }
    | expr '*' expr {
        char *t = newtemp();
        printf("%s = %s * %s\n", t, $1, $3);
        $$ = t;
    }
    | expr '/' expr {
        char *t = newtemp();
        printf("%s = %s / %s\n", t, $1, $3);
        $$ = t;
    }
    | '(' expr ')' { $$ = $2; }
    | NUM { $$ = $1; }
    | ID  { $$ = $1; }
    ;

bool
    : expr RELOP expr {
        char *t = newtemp();
        printf("%s = %s %s %s\n", t, $1, $2, $3);
        $$ = t;
    }
    ;

%%
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    for (int i = 0; i < TABLE_SIZE; i++)
        symbolTable[i] = NULL;

    printf("Enter your input:\n");
    yyparse();
    return 0;
}
