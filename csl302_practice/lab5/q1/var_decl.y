%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);
%}

%token INT FLOAT CHAR
%token IDENTIFIER
%token SEMICOLON COMMA

%union {
    char* str; 
}

%start program              


%%
program:
    declarations
    ;

declarations:
    declarations declaration
    | declaration
    ;

declaration:
    datatype variable_identifiers SEMICOLON;
    ;

variable_identifiers:
    t IDENTIFIER
    | IDENTIFIER
    ;

t:
    t IDENTIFIER COMMA
    | IDENTIFIER COMMA
    ;

datatype:
    INT        
    | FLOAT     
    | CHAR  
    ;
%%

int main() {
    printf("Enter variable declarations:\n");
    yyparse();
    printf("Valid declarations\n");
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

