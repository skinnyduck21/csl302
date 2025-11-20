%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbol.h"

int yylex();

char currentType[20];
int currentScope = 0;

int temp_count = 1;

char* new_temp() {
    char *temp = (char*)malloc(20);
    sprintf(temp, "t%d", temp_count++);
    return temp;
}

void yyerror(const char *s);
int yylex(void);

%}

%union {
    char *str;
}

%token <str> ID
%token <str> NUM
%token KW_PLUS KW_MINUS KW_STAR KW_DIVISION 
%token KW_PAREN_LEFT KW_PAREN_RIGHT
%token KW_AND KW_OR KW_NOT KW_EQUALS
%token KW_LT KW_GT KW_LTE KW_GTE KW_ISEQUAL KW_ISNOTEQUAL
%token <str> KW_TRUE KW_FALSE
%type <str> expr
%token KW_INT KW_FLOAT
%token KW_COMMA KW_SEMICOLON

%start program

%%
program: 

|
statements
;

statements:
statements stmt
|
statements decl
|
decl
|
stmt
;

stmt: ID KW_EQUALS expr {
        printf("%s = %s\n", $1, $3);
        printf("\n------\n\n");
    }
    ;

expr: expr KW_PLUS expr {
        char *temp = new_temp();
        printf("%s = %s + %s\n", temp, $1, $3);
        $$ = temp;
    }
    | expr KW_MINUS expr {
        char *temp = new_temp();
        printf("%s = %s - %s\n", temp, $1, $3);
        $$ = temp;
    }
    | expr KW_STAR expr {
        char *temp = new_temp();
        printf("%s = %s * %s\n", temp, $1, $3);
        $$ = temp;
    }
    | expr KW_DIVISION expr {
        char *temp = new_temp();
        printf("%s = %s / %s\n", temp, $1, $3);
        $$ = temp;
    }
    | KW_PAREN_LEFT expr KW_PAREN_RIGHT {
        $$ = $2;
    }
    | ID {
        $$ = $1;
    }
    | NUM {
        $$ = $1;
    }
    |
    expr KW_LT expr {
        char *temp = new_temp();
        printf("%s = %s < %s\n", temp, $1, $3);
        $$ = temp;
    }
    |
    expr KW_GT expr {
        char *temp = new_temp();
        printf("%s = %s > %s\n", temp, $1, $3);
        $$ = temp;
    }
    |
    expr KW_LTE expr {
        char *temp = new_temp();
        printf("%s = %s <= %s\n", temp, $1, $3);
        $$ = temp;
    }
    |
    expr KW_GTE expr {
        char *temp = new_temp();
        printf("%s = %s >= %s\n", temp, $1, $3);
        $$ = temp;
    }
    |
    expr KW_ISEQUAL expr {
        char *temp = new_temp();
        printf("%s = %s == %s\n", temp, $1, $3);
        $$ = temp;
    }
    |
    expr KW_ISNOTEQUAL expr {
        char *temp = new_temp();
        printf("%s = %s != %s\n", temp, $1, $3);
        $$ = temp;
    }
    |
    expr KW_OR expr {
        char *temp = new_temp();
        printf("%s = %s or %s\n", temp, $1, $3);
        $$ = temp;
    }
    |
    expr KW_AND expr {
        char *temp = new_temp();
        printf("%s = %s and %s\n", temp, $1, $3);
        $$ = temp;
    }
    |
    KW_NOT expr {
        char *temp = new_temp();
        printf("%s = not %s\n", temp, $2);
        $$ = temp;
    }
    |
    KW_TRUE {
        $$ = strdup("true"); 
    }
    |
    KW_FALSE {
        $$ = strdup("false"); 
    }
    ;


decl:
type idlist KW_SEMICOLON;
;

type:
KW_INT { strcpy(currentType, "int"); }
|
KW_FLOAT { strcpy(currentType, "float"); }
;

idlist:
ID {
    if(lookupSymbol($1) != NULL) {
        yyerror("Redeclaration error");
    }
    else {
        insertSymbol($1, currentType, currentScope);
    }
}
|
idlist KW_COMMA ID {
    if(lookupSymbol($3) != NULL) {
        yyerror("Redeclaration error");
    }
    else {
        insertSymbol($3, currentType, currentScope);
    } 
}
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    printf("Enter expression (e.g., a = b + c * d):\n");
    yyparse();
    return 0;
}

