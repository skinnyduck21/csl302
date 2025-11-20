%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbol.h"

int yylex();
void yyerror(const char *s);

char currentType[20];
int currentScope = 0;

int temp_count = 1;
int label_count = 1;

char* new_temp() {
    char *temp = (char*)malloc(20);
    sprintf(temp, "t%d", temp_count++);
    return temp;
}

char* new_label() {
    char *label = (char*)malloc(20);
    sprintf(label, "L%d", label_count++);
    return label;
}

%}

%union {
    char *str;
    struct {
        char *name;
        char *true_label;
        char *false_label;
    } bool_expr;
    struct {
        char *begin_label;
    } marker;
}

%token <str> ID
%token <str> NUM
%token KW_PLUS KW_MINUS KW_STAR KW_DIVISION 
%token KW_PAREN_LEFT KW_PAREN_RIGHT
%token KW_AND KW_OR KW_NOT KW_EQUALS
%token KW_LT KW_GT KW_LTE KW_GTE KW_ISEQUAL KW_ISNOTEQUAL
%token KW_INT KW_FLOAT
%token KW_COMMA KW_SEMICOLON KW_COLON
%token KW_LBRACE KW_RBRACE
%token KW_SWITCH KW_CASE KW_DEFAULT
%token <str> KW_TRUE KW_FALSE
%left KW_OR
%left KW_AND
%nonassoc KW_ISEQUAL KW_ISNOTEQUAL KW_LT KW_GT KW_LTE KW_GTE
%left KW_PLUS KW_MINUS
%left KW_STAR KW_DIVISION
%right KW_NOT

%type <str> expr_ari
%type <bool_expr> expr_bool
%type <marker> M

%start program

%%
program:
      /* empty */
    | switch_stmt {}
    ;




/* Marker for label generation */
M: /* empty */ {
        $$.begin_label = new_label();
        printf("%s:\n", $$.begin_label);
    }
    ;


switch_stmt:
    KW_SWITCH KW_PAREN_LEFT expr_ari KW_PAREN_RIGHT KW_LBRACE case_list default_case KW_RBRACE {
        char* end_label = new_label();
        printf("goto %s\n", end_label);
        printf("%s:\n", end_label);
    }
    ;

case_list:
      case_stmt
    | case_list case_stmt
    ;

case_stmt:
      KW_CASE ID KW_COLON M stmt_ari {
        /* Case with short-circuit: if match, execute and break */
        char* next_case = new_label();
        printf("if switchVar == %s goto %s\n", $2, $4.begin_label);
        printf("goto %s\n", next_case);
        printf("%s:\n", next_case);
    }
    ;

default_case:
      KW_DEFAULT KW_COLON M stmt_ari {
        printf("goto %s\n", $3.begin_label);
    }
    ;

/* Arithmetic statements */
stmt_ari: ID KW_EQUALS expr_ari KW_SEMICOLON {
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



%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    printf("Enter switch statement:\n");
    yyparse();
    return 0;
}