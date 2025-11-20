%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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
%token KW_AND KW_OR KW_NOT KW_EQUAL
%token KW_LT KW_GT KW_LTE KW_GTE KW_ISITEQUAL KW_ISNOTEQUAL
%token <str> KW_TRUE KW_FALSE
%type <str> expr_ari expr_bool


%start program

%%
program:

|
statements
;

statements:
statements stmt
|
stmt
;

stmt:
stmt_ari   
| 
stmt_bool
;

stmt_ari: ID KW_EQUAL expr_ari {
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

stmt_bool: ID KW_EQUAL expr_bool {
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
expr_ari KW_ISITEQUAL expr_ari {
    char* temp = new_temp();
    printf("%s = %s == %s\n", temp, $1, $3);
    $$ = temp;
}
|
expr_ari KW_ISNOTEQUAL expr_ari {
    char* temp = new_temp();
    printf("%s = %s == %s\n", temp, $1, $3);
    $$ = temp;
}
|
expr_bool KW_ISITEQUAL expr_bool {
    char* temp = new_temp();
    printf("%s = %s == %s\n", temp, $1, $3);
    $$ = temp;
}
|
expr_bool KW_ISNOTEQUAL expr_bool {
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
KW_TRUE {
    $$ = $1;
}
|
KW_FALSE {
    $$ = $1;
}


%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    printf("Enter expression (e.g., a = b + c * d):\n");
    yyparse();
    return 0;
}

