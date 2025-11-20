%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);
%}

%token INT FLOAT CHAR
%token IDENTIFIER
%token SEMICOLON

%union {
    /* yylval is of union type */
    char* str; /* So here, tokens can hold a char* string, for identifiers and datatype names */
}

%start program              /* parsing begins here */
%type <str> IDENTIFIER      /* identifier holds string value */
%type <str> datatype        /* datatype also holds string */




%%
program:
    declarations
    ;

declarations:
    declarations declaration
    | declaration
    ;

declaration:
    datatype IDENTIFIER SEMICOLON {
        printf("Declared variable: %s of type %s\n", $2, $1);
        free($2);
        free($1);
    }
    ;

datatype:
    INT     { $$ = strdup("int");         /* $$ is the value of the non-terminal on the left, that is datatype, this block would not be necessary if we did not want to print its value int he above part */}
    | FLOAT { $$ = strdup("float"); }
    | CHAR  { $$ = strdup("char"); }
    ;
%%

int main() {
    printf("Enter variable declarations:\n");
    yyparse();  /* Calls yylex() fuction repeatedly to get tokens */
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

