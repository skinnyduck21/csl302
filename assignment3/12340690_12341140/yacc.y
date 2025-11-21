/* yacc.y - CORRECTED VERSION */
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "symbol.h"
    
    extern int yylineno;
    extern int yylex(void);
    void yyerror(const char *s);
    
    int hasError = 0;
    char* currentFunctionName = NULL;
%}

%union {
    int ival;
    double dval;
    char* str;
    struct {
        char* addr;     /* Location of value (t0, x, etc.) */
        char* code;
    } expr;
    struct {
        char* base;     /* Name of array or variable */
        char* index;    /* Index temp variable (NULL if simple variable) */
    } target;
}

/* Tokens */
%token KW_VOID KW_INT KW_DOUBLE KW_BOOL KW_STRING
%token KW_FOR KW_WHILE KW_DO KW_IF KW_ELSE KW_RETURN KW_BREAK
%token KW_NULL KW_READINTEGER KW_READLINE KW_PRINT

%token <str> IDENTIFIER STRING_LITERAL
%token <ival> INT_LITERAL_DEC
%token <str> INT_LITERAL_HEX
%token <dval> DOUBLE_LITERAL
%token BOOLEAN_LITERAL 

%token OP_PLUS OP_MINUS OP_STAR OP_SLASH OP_MOD
%token OP_LT OP_GT OP_LE OP_GE OP_EQ OP_NEQ
%token OP_ANDAND OP_OROR OP_NOT OP_ASSIGN

%token SYM_SEMI SYM_COMMA SYM_DOT
%token SYM_LBRACK SYM_RBRACK SYM_LPAREN SYM_RPAREN SYM_LBRACE SYM_RBRACE

%token ERROR_INVALID_TOKEN

%type <expr> expr constant opt_expr call
%type <target> lvalue
%type <str> type
%type <str> stmt 

/* Precedence */
%right OP_ASSIGN
%left OP_OROR
%left OP_ANDAND
%left OP_EQ OP_NEQ
%left OP_LT OP_LE OP_GT OP_GE
%left OP_PLUS OP_MINUS
%left OP_STAR OP_SLASH OP_MOD
%right OP_NOT UMINUS
%left SYM_LBRACK SYM_DOT
%nonassoc KW_ELSE 

%%

program:
    /* empty */
    | decl_list
    ;

decl_list:
    decl
    | decl_list decl
    ;

decl:
    var_decl
    | function_decl
    ;

var_decl:
    type IDENTIFIER SYM_SEMI {
        insertSymbol($2, $1, currentScope, 0, 0);
        free($2);
        free($1);
    }
    | type IDENTIFIER SYM_LBRACK INT_LITERAL_DEC SYM_RBRACK SYM_SEMI {
        insertSymbol($2, $1, currentScope, 1, $4);
        free($2);
        free($1);
    }
    ;

type:
    KW_INT { $$ = strdup("int"); }
    | KW_DOUBLE { $$ = strdup("double"); }
    | KW_BOOL { $$ = strdup("bool"); }
    | KW_STRING { $$ = strdup("string"); }
    | KW_VOID { $$ = strdup("void"); }
    ;

function_decl:
    type IDENTIFIER {
        currentFunctionName = strdup($2);
        insertSymbol($2, $1, currentScope, 0, 0);
    } SYM_LPAREN formals SYM_RPAREN SYM_LBRACE {
        pushScope();
    } block_item_list SYM_RBRACE {
        popScope();
        free(currentFunctionName);
        currentFunctionName = NULL;
        free($2);
        free($1);
    }
    ;

formals:
    /* empty */
    | formal_list
    ;

formal_list:
    formal
    | formal_list SYM_COMMA formal
    ;

formal:
    type IDENTIFIER {
        insertSymbol($2, $1, currentScope, 0, 0);
        free($2);
        free($1);
    }
    | type IDENTIFIER SYM_LBRACK SYM_RBRACK {
        insertSymbol($2, $1, currentScope, 1, -1);
        free($2);
        free($1);
    }
    ;

block_item_list:
    /* empty */
    | block_item_list block_item
    ;

block_item:
    var_decl
    | stmt
    ;

stmt:
    expr SYM_SEMI {
        if ($1.addr) free($1.addr);
        $$ = NULL;
    }
    | SYM_SEMI {
        $$ = NULL;
    }
    | KW_RETURN opt_expr SYM_SEMI {
        emitTAC("return", $2.addr ? $2.addr : "", "", "");
        if ($2.addr) free($2.addr);
        $$ = NULL;
    }
    | KW_BREAK SYM_SEMI {
        emitTAC("break", "", "", "");
        $$ = NULL;
    }
    | KW_PRINT SYM_LPAREN expr_list SYM_RPAREN SYM_SEMI {
        $$ = NULL;
    }
    | SYM_LBRACE {
        pushScope();
    } block_item_list SYM_RBRACE {
        popScope();
        $$ = NULL;
    }
    
    /* IF STATEMENT with Correct Logic */
    | KW_IF SYM_LPAREN expr SYM_RPAREN {
        char* l_else = newLabel();
        char* l_end = newLabel();
        pushLabels(l_else, l_end);
        emitTAC("if_false", $3.addr, l_else, "");
        free($3.addr);
    } stmt opt_else {
        char* l_end = getLabel2();
        emitTAC("label", l_end, "", "");
        popLabels();
        $$ = NULL;
    }
    
    /* WHILE STATEMENT with Correct Logic */
    | KW_WHILE {
        char* l_start = newLabel();
        char* l_end = newLabel();
        pushLabels(l_start, l_end);
        emitTAC("label", l_start, "", "");
    } SYM_LPAREN expr SYM_RPAREN {
        char* l_end = getLabel2();
        emitTAC("if_false", $4.addr, l_end, "");
        free($4.addr);
    } stmt {
        char* l_start = getLabel1();
        char* l_end = getLabel2();
        emitTAC("goto", l_start, "", "");
        emitTAC("label", l_end, "", "");
        popLabels();
        $$ = NULL;
    }
    ;

opt_else:
    /* empty */ {
        char* l_else = getLabel1();
        emitTAC("label", l_else, "", "");
    }
    | KW_ELSE {
        char* l_else = getLabel1();
        char* l_end = getLabel2();
        emitTAC("goto", l_end, "", "");
        emitTAC("label", l_else, "", "");
    } stmt 
    ;

opt_expr:
    /* empty */ { $$.addr = NULL; }
    | expr { $$ = $1; }
    ;

expr:
    lvalue OP_ASSIGN expr {
        if ($1.index == NULL) {
            emitTAC("=", $3.addr, "", $1.base);
        } else {
            emitTAC("[]=", $1.base, $1.index, $3.addr);
        }
        $$.addr = strdup($1.base); 
        free($1.base); 
        if($1.index) free($1.index); 
        free($3.addr);
    }
    | expr OP_PLUS expr {
        char* temp = newTemp();
        emitTAC("+", $1.addr, $3.addr, temp);
        $$.addr = strdup(temp);
        free($1.addr); free($3.addr);
    }
    | expr OP_MINUS expr {
        char* temp = newTemp();
        emitTAC("-", $1.addr, $3.addr, temp);
        $$.addr = strdup(temp);
        free($1.addr); free($3.addr);
    }
    | expr OP_STAR expr {
        char* temp = newTemp();
        emitTAC("*", $1.addr, $3.addr, temp);
        $$.addr = strdup(temp);
        free($1.addr); free($3.addr);
    }
    | expr OP_SLASH expr {
        char* temp = newTemp();
        emitTAC("/", $1.addr, $3.addr, temp);
        $$.addr = strdup(temp);
        free($1.addr); free($3.addr);
    }
    | expr OP_MOD expr {
        char* temp = newTemp();
        emitTAC("%", $1.addr, $3.addr, temp);
        $$.addr = strdup(temp);
        free($1.addr); free($3.addr);
    }
    | expr OP_LT expr {
        char* temp = newTemp();
        emitTAC("<", $1.addr, $3.addr, temp);
        $$.addr = strdup(temp);
        free($1.addr); free($3.addr);
    }
    | expr OP_GT expr {
        char* temp = newTemp();
        emitTAC(">", $1.addr, $3.addr, temp);
        $$.addr = strdup(temp);
        free($1.addr); free($3.addr);
    }
    | expr OP_LE expr {
        char* temp = newTemp();
        emitTAC("<=", $1.addr, $3.addr, temp);
        $$.addr = strdup(temp);
        free($1.addr); free($3.addr);
    }
    | expr OP_GE expr {
        char* temp = newTemp();
        emitTAC(">=", $1.addr, $3.addr, temp);
        $$.addr = strdup(temp);
        free($1.addr); free($3.addr);
    }
    | expr OP_EQ expr {
        char* temp = newTemp();
        emitTAC("==", $1.addr, $3.addr, temp);
        $$.addr = strdup(temp);
        free($1.addr); free($3.addr);
    }
    | expr OP_NEQ expr {
        char* temp = newTemp();
        emitTAC("!=", $1.addr, $3.addr, temp);
        $$.addr = strdup(temp);
        free($1.addr); free($3.addr);
    }
    | expr OP_ANDAND expr {
        char* temp = newTemp();
        /* NO SHORT CIRCUIT: both operands evaluated */
        emitTAC("&&", $1.addr, $3.addr, temp);
        $$.addr = strdup(temp);
        free($1.addr); free($3.addr);
    }
    | expr OP_OROR expr {
        char* temp = newTemp();
        /* NO SHORT CIRCUIT: both operands evaluated */
        emitTAC("||", $1.addr, $3.addr, temp);
        $$.addr = strdup(temp);
        free($1.addr); free($3.addr);
    }
    | OP_NOT expr {
        char* temp = newTemp();
        emitTAC("!", $2.addr, "", temp);
        $$.addr = strdup(temp);
        free($2.addr);
    }
    | SYM_LPAREN expr SYM_RPAREN {
        $$ = $2;
    }
    | lvalue {
        if ($1.index == NULL) {
            $$.addr = strdup($1.base);
        } else {
            char* temp = newTemp();
            emitTAC("=[]", $1.base, $1.index, temp);
            $$.addr = strdup(temp);
        }
        free($1.base);
        if($1.index) free($1.index);
    }
    | call {
        $$.addr = $1.addr;
    }
    | constant {
        $$ = $1;
    }
    ;

lvalue:
    IDENTIFIER {
        Symbol* sym = lookupSymbol($1);
        if (!sym) fprintf(stderr, "Semantic Error: '%s' not declared\n", $1);
        $$.base = strdup($1);
        $$.index = NULL;
        free($1);
    }
    | IDENTIFIER SYM_LBRACK expr SYM_RBRACK {
        Symbol* sym = lookupSymbol($1);
        if (!sym) fprintf(stderr, "Semantic Error: '%s' not declared\n", $1);
        
        $$.base = strdup($1);
        $$.index = strdup($3.addr);
        free($1);
        free($3.addr);
    }
    ;

call:
    IDENTIFIER SYM_LPAREN actuals SYM_RPAREN {
        char* temp = newTemp();
        emitTAC("call", $1, "", temp);
        $$.addr = strdup(temp);
        free($1);
    }
    ;

actuals:
    /* empty */
    | expr_list
    ;

expr_list:
    expr {
        if ($1.addr) free($1.addr);
    }
    | expr_list SYM_COMMA expr {
        if ($3.addr) free($3.addr);
    }
    ;

constant:
    INT_LITERAL_DEC {
        char buffer[32];
        snprintf(buffer, 32, "%d", $1);
        $$.addr = strdup(buffer);
    }
    | DOUBLE_LITERAL {
        char buffer[32];
        snprintf(buffer, 32, "%f", $1);
        $$.addr = strdup(buffer);
    }
    | STRING_LITERAL {
        $$.addr = strdup($1);
        free($1);
    }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Syntax Error at line %d: %s\n", yylineno, s);
    hasError = 1;
}

int main(int argc, char **argv) {
    FILE *input = stdin;
    
    if (argc > 1) {
        input = fopen(argv[1], "r");
        if (!input) {
            fprintf(stderr, "Error: Cannot open file %s\n", argv[1]);
            return 1;
        }
        extern FILE *yyin;
        yyin = input;
    }
    
    printf("Starting compilation...\n");
    
    int result = yyparse();
    
    if (input != stdin) {
        fclose(input);
    }
    
    if (result == 0 && !hasError) {
        printf("Parsing completed successfully!\n");
        printSymbolTable();
        printTAC();
    } else {
        printf("\nCompilation failed with errors.\n");
        return 1;
    }
    
    freeTAC();
    return 0;
}