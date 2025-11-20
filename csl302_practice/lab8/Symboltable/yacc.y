%{
	#include <stdio.h>
	#include <stdlib.h>
	#include "symbol.h"

	int yylex();
	void yyerror(const char* s) { fprintf(stderr, "%s\n", s); }

	char currentType[20];
	int currentScope = 0;
%}

%union {
    char* str;
}

%token <str> ID
%token INT FLOAT CHAR

%%

program:
        program declaration
        | declaration
        ;

declaration:
        type id_list ';'
        ;

type:
        INT   { strcpy(currentType, "int"); }
      | FLOAT { strcpy(currentType, "float"); }
      | CHAR  { strcpy(currentType, "char"); }
      ;

id_list:
        ID               { insertSymbol($1, currentType, currentScope); }
      | id_list ',' ID   { insertSymbol($3, currentType, currentScope); }
      ;

%%

int main() {
    yyparse();
    return 0;
}

