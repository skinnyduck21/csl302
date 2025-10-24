%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbol.h"

int tempCount = 0;
int scope = 0;

char* newTemp() {
    char* temp = (char*)malloc(10);
    sprintf(temp, "t%d", tempCount++);
    return temp;
}

void yyerror(const char *s);
int yylex();

%}

/* ---------- TYPE DECLARATIONS ---------- */
%union {
    char* str;
}

/* ---------- TOKENS ---------- */
%token <str> ID
%token <str> INT_CONST FLOAT_CONST
%token INT FLOAT TRUE FALSE OR AND NOT
%token LT GT LE GE EQ NE

/* ---------- NONTERMINAL TYPES ---------- */
%type <str> E TYPE relop idlist

%%

program:
      decls stmts
    ;

decls:
      /* empty */
    | decls decl
    ;

decl:
      TYPE idlist ';'
    ;

TYPE:
      INT     { $$ = "int"; }
    | FLOAT   { $$ = "float"; }
    ;

idlist:
      ID {
            if (lookupSymbol($1))
                printf("Error: Redeclaration of variable %s\n", $1);
            else
                insertSymbol($1, $<str>0, scope);
        }
    | idlist ',' ID {
            if (lookupSymbol($3))
                printf("Error: Redeclaration of variable %s\n", $3);
            else
                insertSymbol($3, $<str>0, scope);
        }
    ;

stmts:
      /* empty */
    | stmts stmt
    ;

stmt:
      E ';' { printf("Result: %s\n", $1); }
    ;

E:
      E OR E {
            char* temp = newTemp();
            printf("%s = %s or %s\n", temp, $1, $3);
            $$ = temp;
      }
    | E AND E {
            char* temp = newTemp();
            printf("%s = %s and %s\n", temp, $1, $3);
            $$ = temp;
      }
    | NOT E {
            char* temp = newTemp();
            printf("%s = not %s\n", temp, $2);
            $$ = temp;
      }
    | E relop E {
            char* temp = newTemp();
            printf("%s = %s %s %s\n", temp, $1, $2, $3);
            $$ = temp;
      }
    | '(' E ')' { $$ = $2; }
    | ID {
            if (!lookupSymbol($1))
                printf("Error: Undeclared variable %s\n", $1);
            $$ = $1;
      }
    | INT_CONST {
            $$ = $1;
      }
    | FLOAT_CONST {
            $$ = $1;
      }
    | TRUE { $$ = "true"; }
    | FALSE { $$ = "false"; }
    ;

relop:
      LT { $$ = "<"; }
    | GT { $$ = ">"; }
    | LE { $$ = "<="; }
    | GE { $$ = ">="; }
    | EQ { $$ = "=="; }
    | NE { $$ = "!="; }
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
