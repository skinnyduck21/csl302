%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);
%}

%union {
    char* str;
}

%token INT FLOAT CHAR FOR IF THEN ELSE ELIF SWITCH CASE DO WHILE
%token <str> IDENTIFIER NUMBER
%token SEMICOLON COMMA ASSIGN COLON
%token PLUS MINUS MUL DIV
%token LT GT LE GE EQ NE
%token LPAREN RPAREN LBRACE RBRACE

%left PLUS MINUS
%left MUL DIV
%left LT GT LE GE
%left EQ NE
%right UMINUS

%type <str> datatype

%start program

%%
program:
    stmts
    ;

stmts:
    stmts stmt
    | /* empty */
    ;

stmt:
    simple_stmt
    | compound_stmt
    ;

simple_stmt:
    declaration SEMICOLON
    | assignment SEMICOLON
    ;

compound_stmt:
    for_loop
    | if_then
    | if_then_else
    | if_then_elif
    | switch_stmt
    | while_stmt
    | do_while_stmt
    | block
    ;

block:
    LBRACE stmts RBRACE
    ;

declaration:
    datatype id_list {
        printf("Declaration of type %s completed.\n", $1);
        free($1);
    }
    ;

id_list:
    IDENTIFIER { printf("  variable: %s\n", $1); free($1); }
    | id_list COMMA IDENTIFIER { printf("  variable: %s\n", $3); free($3); }
    ;

assignment:
    IDENTIFIER ASSIGN expr { printf("Assignment: %s = ...\n", $1); free($1); }
    ;

for_loop:
    FOR LPAREN assignment SEMICOLON expr SEMICOLON assignment RPAREN stmt {
        printf("For loop detected.\n");
    }
    ;

if_then:
    IF LPAREN expr RPAREN THEN block {
        printf("If-Then detected.\n");
    }
    ;

if_then_else:
    IF LPAREN expr RPAREN THEN block ELSE block {
        printf("If-Then-Else detected.\n");
    }
    ;

if_then_elif:
    IF LPAREN expr RPAREN THEN block elif_parts ELSE block {
        printf("If-Then-Elif detected.\n");
    }
    ;

elif_parts:
    ELIF LPAREN expr RPAREN THEN block
    | elif_parts ELIF LPAREN expr RPAREN THEN block
    ;


switch_stmt:
    SWITCH LPAREN expr RPAREN LBRACE case_list RBRACE {
        printf("Switch detected.\n");
    }
    ;

case_list:
    case_list CASE NUMBER COLON stmts { printf("  case %s detected.\n", $3); free($3); }
    | CASE NUMBER COLON stmts { printf("  case %s detected.\n", $2); free($2); }
    ;

while_stmt:
    WHILE LPAREN expr RPAREN block {
        printf("While loop detected.\n");
    }
    ;

do_while_stmt:
    DO block WHILE LPAREN expr RPAREN SEMICOLON {
        printf("Do-While loop detected.\n");
    }
    ;

expr:
    expr PLUS expr
    | expr MINUS expr
    | expr MUL expr
    | expr DIV expr
    | expr LT expr
    | expr GT expr
    | expr LE expr
    | expr GE expr
    | expr EQ expr
    | expr NE expr
    | LPAREN expr RPAREN
    | MINUS expr %prec UMINUS
    | IDENTIFIER { free($1); }
    | NUMBER { free($1); }
    ;

datatype:
    INT     { $$ = strdup("int"); }
    | FLOAT { $$ = strdup("float"); }
    | CHAR  { $$ = strdup("char"); }
    ;
%%

int main() {
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
