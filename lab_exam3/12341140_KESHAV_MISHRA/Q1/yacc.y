%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


void yyerror(const char *s);
int yylex(void);

%}

%union {
    char *str;
}

%token <str> ID
%token <str> NUM
%token KW_PLUS KW_MINUS KW_STAR KW_DIVISION 


%type <str> expr_ari


%start program

%%
program:
expr_ari
;


expr_ari: expr_ari KW_PLUS expr_ari {
        printf("%s %s + ",  $1, $3);

    }
    | expr_ari KW_MINUS expr_ari {

        printf("%s %s - ", $1, $3);

    }
    | expr_ari KW_STAR expr_ari {
        printf("%s %s * ", $1, $3);
    }
    | expr_ari KW_DIVISION expr_ari {
 
        printf("%s %s / ", $1, $3);
 
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
    printf("Enter expression (e.g., a = b + c * d):\n");
    yyparse();
    return 0;
}

