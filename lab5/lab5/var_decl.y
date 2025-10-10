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

%token INT FLOAT CHAR FOR
%token <str> IDENTIFIER NUMBER
%token SEMICOLON COMMA ASSIGN
%token PLUS MINUS MUL DIV
%token LT GT LE GE EQ NE
%token LPAREN RPAREN

%left PLUS MINUS
%left MUL DIV
%left LT GT LE GE EQ NE
%right UMINUS

%type <str> datatype

%start program

%%
program:
    statements
    ;

statements:
    statements statement
    | statement
    ;

statement:
    declaration
    | assignment SEMICOLON
    | for_loop
    ;

declaration:
    datatype id_list SEMICOLON {
        printf("Declaration of type %s completed.\n", $1);
        free($1);
    }
    ;

id_list:
    IDENTIFIER {
        printf("  variable: %s\n", $1);
        free($1);
    }
    | id_list COMMA IDENTIFIER {
        printf("  variable: %s\n", $3);
        free($3);
    }
    ;

assignment:
    IDENTIFIER ASSIGN expr {
        printf("Assignment: %s = ...\n", $1);
        free($1);
    }
    ;

for_loop:
    FOR LPAREN assignment SEMICOLON expr SEMICOLON assignment RPAREN assignment SEMICOLON {
        printf("For loop detected.\n");
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
