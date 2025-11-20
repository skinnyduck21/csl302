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
%token KW_INT KW_FLOAT
%token KW_COMMA KW_SEMICOLON
%type <str> expr_ari expr_bool

%start program

%%
program:
      /* empty */
    | statements
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

stmt:
stmt_ari
|
stmt_bool
;

stmt_ari: ID KW_EQUALS expr_ari {
        printf("%s = %s\n", $1, $3);
    }
    ;

expr_ari: expr_ari KW_PLUS expr_ari {
        char *temp = new_temp();
        printf("%s = %s + %s\n", temp, $1, $3);
        $$ = temp;
    }
    | expr_ari KW_MINUS expr_ari {
        char *temp = new_temp();
        printf("%s = %s - %s\n", temp, $1, $3);
        $$ = temp;
    }
    | expr_ari KW_STAR expr_ari {
        char *temp = new_temp();
        printf("%s = %s * %s\n", temp, $1, $3);
        $$ = temp;
    }
    | expr_ari KW_DIVISION expr_ari {
        char *temp = new_temp();
        printf("%s = %s / %s\n", temp, $1, $3);
        $$ = temp;
    }
    | KW_PAREN_LEFT expr_ari KW_PAREN_RIGHT {
        $$ = $2;
    }
    | ID {
        $$ = $1;
    }
    | NUM {
        $$ = $1;
    }
    ;

stmt_bool: ID KW_EQUALS expr_bool {
    printf("%s = %s\n", $1, $3);
}
;

expr_bool:
expr_ari KW_GT expr_ari {
    char* temp = new_temp();
    printf("%s = %s > %s\n", temp, $1, $3);
    $$ = temp;
}
|
expr_ari KW_GTE expr_ari {
    char* temp = new_temp();
    printf("%s = %s >= %s\n", temp, $1, $3);
    $$ = temp;
}
|
expr_ari KW_LT expr_ari {
    char* temp = new_temp();
    printf("%s = %s < %s\n", temp, $1, $3);
    $$ = temp;
}
|
expr_ari KW_LTE expr_ari {
    char* temp = new_temp();
    printf("%s = %s <= %s\n", temp, $1, $3);
    $$ = temp;
}
|
expr_ari KW_ISEQUAL expr_ari {
    char* temp = new_temp();
    printf("%s = %s == %s\n", temp, $1, $3);
    $$ = temp;
}
|
expr_ari KW_ISNOTEQUAL expr_ari {
    char* temp = new_temp();
    printf("%s = %s != %s\n", temp, $1, $3);
    $$ = temp;
}
|
expr_bool KW_OR expr_bool {
    char* temp = new_temp();
    printf("%s = %s or %s\n", temp, $1, $3);
    $$ = temp;
}
|
expr_bool KW_AND expr_bool {
    char* temp = new_temp();
    printf("%s = %s and %s\n", temp, $1, $3);
    $$ = temp;
}
|
KW_NOT expr_bool {
    char* temp = new_temp();
    printf("%s = not %s\n", temp, $2);
    $$ = temp;
}
|
KW_PAREN_LEFT expr_bool KW_PAREN_RIGHT {
    $$ = $2;
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
type idlist KW_SEMICOLON
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
        printf("Variable %s declared as %s\n", $1, currentType);
    }
}
|
idlist KW_COMMA ID {
    if(lookupSymbol($3) != NULL) {
        yyerror("Redeclaration error");
    }
    else {
        insertSymbol($3, currentType, currentScope);
        printf("Variable %s declared as %s\n", $3, currentType);
    } 
}
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    printf("Enter expression or declaration:\n");
    printf("Example 1: int a, b, c;\n");
    printf("Example 2: float x, y;\n");
    printf("Example 3: a = 5 + 3;\n");
    printf("Example 4: b = 10 > 5;\n");
    printf("Example 5: c = true and false;\n\n");
    yyparse();
    return 0;
}