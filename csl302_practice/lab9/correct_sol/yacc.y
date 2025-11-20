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
%token <str> KW_TRUE KW_FALSE
%token KW_INT KW_FLOAT
%token KW_COMMA KW_SEMICOLON KW_COLON
%token KW_IF KW_THEN KW_ELSE KW_WHILE KW_DO KW_LBRACE KW_RBRACE

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
    | statements
    ;

statements:
      statements stmt
    | statements decl
    | decl
    | stmt
    ;

stmt:
      stmt_ari { }
    | stmt_bool { }
    | stmt_if { }
    | stmt_while { }
    ;

/* Marker for label generation */
M: /* empty */ {
        $$.begin_label = new_label();
        printf("%s:\n", $$.begin_label);
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

/* Boolean statements */
stmt_bool: ID KW_EQUALS expr_bool KW_SEMICOLON {
        char* end_label = new_label();
        printf("%s:\n", $3.true_label);
        printf("%s = 1\n", $1);
        printf("goto %s\n", end_label);
        printf("%s:\n", $3.false_label);
        printf("%s = 0\n", $1);
        printf("%s:\n", end_label);
    }
    ;

/* Short-circuit evaluation for boolean expressions */
expr_bool:
      expr_ari KW_GT expr_ari {
        char* temp = new_temp();
        char* true_label = new_label();
        char* false_label = new_label();
        printf("%s = %s > %s\n", temp, $1, $3);
        printf("if %s goto %s\n", temp, true_label);
        printf("goto %s\n", false_label);
        $$.name = temp;
        $$.true_label = true_label;
        $$.false_label = false_label;
    }
    | expr_ari KW_GTE expr_ari {
        char* temp = new_temp();
        char* true_label = new_label();
        char* false_label = new_label();
        printf("%s = %s >= %s\n", temp, $1, $3);
        printf("if %s goto %s\n", temp, true_label);
        printf("goto %s\n", false_label);
        $$.name = temp;
        $$.true_label = true_label;
        $$.false_label = false_label;
    }
    | expr_ari KW_LT expr_ari {
        char* temp = new_temp();
        char* true_label = new_label();
        char* false_label = new_label();
        printf("%s = %s < %s\n", temp, $1, $3);
        printf("if %s goto %s\n", temp, true_label);
        printf("goto %s\n", false_label);
        $$.name = temp;
        $$.true_label = true_label;
        $$.false_label = false_label;
    }
    | expr_ari KW_LTE expr_ari {
        char* temp = new_temp();
        char* true_label = new_label();
        char* false_label = new_label();
        printf("%s = %s <= %s\n", temp, $1, $3);
        printf("if %s goto %s\n", temp, true_label);
        printf("goto %s\n", false_label);
        $$.name = temp;
        $$.true_label = true_label;
        $$.false_label = false_label;
    }
    | expr_ari KW_ISEQUAL expr_ari {
        char* temp = new_temp();
        char* true_label = new_label();
        char* false_label = new_label();
        printf("%s = %s == %s\n", temp, $1, $3);
        printf("if %s goto %s\n", temp, true_label);
        printf("goto %s\n", false_label);
        $$.name = temp;
        $$.true_label = true_label;
        $$.false_label = false_label;
    }
    | expr_ari KW_ISNOTEQUAL expr_ari {
        char* temp = new_temp();
        char* true_label = new_label();
        char* false_label = new_label();
        printf("%s = %s != %s\n", temp, $1, $3);
        printf("if %s goto %s\n", temp, true_label);
        printf("goto %s\n", false_label);
        $$.name = temp;
        $$.true_label = true_label;
        $$.false_label = false_label;
    }
    | expr_bool KW_OR M expr_bool {
        /* Short-circuit OR: if left is true, skip right evaluation 
           E1 OR E2:
           - Evaluate E1
           - If E1 is true, jump to true_label (skip E2)
           - Else (E1 false), evaluate E2
           - If E2 is true, jump to true_label
           - Else jump to false_label
        */
        printf("if %s goto %s\n", $1.name, $1.true_label);
        printf("goto %s\n", $1.false_label);
        printf("%s:\n", $1.false_label);  // If E1 is false, evaluate E2
        printf("if %s goto %s\n", $4.name, $4.true_label);
        printf("goto %s\n", $4.false_label);
        
        $$.name = $4.name;  // Result stored in E2's temp
        $$.true_label = $1.true_label;  // Both can jump to same true label
        $$.false_label = $4.false_label;
    }
    | expr_bool KW_AND M expr_bool {
        /* Short-circuit AND: if left is false, skip right evaluation 
           E1 AND E2:
           - Evaluate E1
           - If E1 is false, jump to false_label (skip E2)
           - Else (E1 true), evaluate E2
           - If E2 is true, jump to true_label
           - Else jump to false_label
        */
        printf("if %s goto %s\n", $1.name, $1.true_label);
        printf("goto %s\n", $1.false_label);
        printf("%s:\n", $1.true_label);  // If E1 is true, evaluate E2
        printf("if %s goto %s\n", $4.name, $4.true_label);
        printf("goto %s\n", $4.false_label);
        
        $$.name = $4.name;  // Result stored in E2's temp
        $$.true_label = $4.true_label;
        $$.false_label = $1.false_label;  // Both can jump to same false label
    }
    | KW_NOT expr_bool {
        /* NOT: swap true and false labels */
        char* temp = new_temp();
        printf("%s = not %s\n", temp, $2.name);
        $$.name = temp;
        $$.true_label = $2.false_label;  // Swap labels
        $$.false_label = $2.true_label;
    }
    | KW_PAREN_LEFT expr_bool KW_PAREN_RIGHT {
        $$ = $2;
    }
    | KW_TRUE {
        char* temp = new_temp();
        char* true_label = new_label();
        char* false_label = new_label();
        printf("%s = 1\n", temp);
        printf("goto %s\n", true_label);
        $$.name = temp;
        $$.true_label = true_label;
        $$.false_label = false_label;
    }
    | KW_FALSE {
        char* temp = new_temp();
        char* true_label = new_label();
        char* false_label = new_label();
        printf("%s = 0\n", temp);
        printf("goto %s\n", false_label);
        $$.name = temp;
        $$.true_label = true_label;
        $$.false_label = false_label;
    }
    ;

/* IF-THEN statement */
stmt_if: KW_IF expr_bool KW_THEN M KW_LBRACE statements KW_RBRACE {
        /* IF E THEN S1
           - Evaluate E
           - If E is true, execute S1
           - If E is false, skip S1
        */
        char* end_label = new_label();
        printf("if %s goto %s\n", $2.name, $2.true_label);
        printf("goto %s\n", $2.false_label);
        printf("%s:\n", $2.true_label);
        // S1 statements already printed
        printf("goto %s\n", end_label);
        printf("%s:\n", $2.false_label);
        printf("%s:\n", end_label);
    }
    | KW_IF expr_bool KW_THEN M KW_LBRACE statements KW_RBRACE KW_ELSE M KW_LBRACE statements KW_RBRACE {
        /* IF E THEN S1 ELSE S2
           - Evaluate E
           - If E is true, execute S1 and skip S2
           - If E is false, skip S1 and execute S2
        */
        char* end_label = new_label();
        printf("if %s goto %s\n", $2.name, $2.true_label);
        printf("goto %s\n", $2.false_label);
        printf("%s:\n", $2.true_label);
        // S1 statements already printed
        printf("goto %s\n", end_label);
        printf("%s:\n", $2.false_label);
        // S2 statements already printed
        printf("%s:\n", end_label);
    }
    ;

/* WHILE loop */
stmt_while: KW_WHILE M expr_bool KW_DO M KW_LBRACE statements KW_RBRACE {
        /* WHILE E DO S
           L1: Evaluate E
               If E is true, execute S and goto L1
               If E is false, exit loop
        */
        printf("if %s goto %s\n", $3.name, $3.true_label);
        printf("goto %s\n", $3.false_label);
        printf("%s:\n", $3.true_label);
        // S statements already printed
        printf("goto %s\n", $2.begin_label);  // Jump back to loop start
        printf("%s:\n", $3.false_label);
    }
    ;

decl:
      type idlist KW_SEMICOLON
    ;

type:
      KW_INT { strcpy(currentType, "int"); }
    | KW_FLOAT { strcpy(currentType, "float"); }
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
    | idlist KW_COMMA ID {
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
    printf("Enter statements (declarations, arithmetic, boolean, if-then, if-then-else, while):\n");
    printf("Example 1: int a, b;\n");
    printf("Example 2: a = 5;\n");
    printf("Example 3: b = a > 5 and a < 10;\n");
    printf("Example 4: if a > 5 then { a = a + 1; }\n");
    printf("Example 5: if a > 5 then { a = 1; } else { a = 0; }\n");
    printf("Example 6: while a < 10 do { a = a + 1; }\n\n");
    yyparse();
    return 0;
}