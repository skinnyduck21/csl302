/* syntax_analyzer.y */
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    extern int yylineno;
    extern int yylex(void);
    void yyerror(const char *s);

    static int found_main = 0;
%}

%union {
    char  *str;
    int    ival;
    double dval;
    int    bval;
}

/* tokens */
%token COMMENT_SINGLE COMMENT_MULTI OP_BRACKETS OP_BACKSLASH

%token KW_VOID KW_INT KW_DOUBLE KW_BOOL KW_STRING KW_CLASS KW_INTERFACE
%token KW_EXTENDS KW_IMPLEMENTS KW_FOR KW_WHILE KW_DO KW_IF KW_ELSE KW_RETURN KW_BREAK
%token KW_NULL KW_THIS KW_READINTEGER KW_READLINE KW_PRINT KW_NEW KW_NEWARRAY

%token <str> IDENTIFIER
%token <ival> INT_LITERAL_DEC
%token <str> INT_LITERAL_HEX
%token <dval> DOUBLE_LITERAL
%token <str> STRING_LITERAL
%token <bval> BOOLEAN_LITERAL

%token OP_ANDAND OP_OROR OP_EQ OP_NEQ OP_LE OP_GE
%token OP_PLUS OP_MINUS OP_STAR OP_SLASH OP_MOD
%token OP_LT OP_GT OP_ASSIGN OP_NOT
%token SYM_SEMI SYM_COMMA SYM_DOT SYM_LBRACK SYM_RBRACK SYM_LPAREN SYM_RPAREN SYM_LBRACE SYM_RBRACE

%token ERROR_UNTERMINATED_COMMENT ERROR_UNTERMINATED_STRING ERROR_IDENTIFIER_TOO_LONG ERROR_INVALID_TOKEN

%right OP_ASSIGN
%left OP_OROR
%left OP_ANDAND
%left OP_EQ OP_NEQ
%left OP_LT OP_LE OP_GT OP_GE
%left OP_PLUS OP_MINUS
%left OP_STAR OP_SLASH OP_MOD
%right OP_NOT
%right UMINUS

%start program
%type <str> type_spec

%%

program:
      decl_list
      {
          if (!found_main)
              fprintf(stderr, "ERROR: No valid void main() found.\n");
          else
              printf("No syntax errors.\n");
      }
    ;

decl_list:
      /* empty */
    | decl_list declaration
    ;

declaration:
      var_decl
    | fun_decl
    | class_decl
    ;

var_decl:
      type_spec IDENTIFIER SYM_SEMI
    | IDENTIFIER KW_NEWARRAY SYM_LPAREN INT_LITERAL_DEC SYM_COMMA type_spec SYM_RPAREN SYM_SEMI
    ;

fun_decl:
      type_spec IDENTIFIER SYM_LPAREN formal_params SYM_RPAREN stmt_block
      {
          if ($1 && $2 && strcmp($1, "void") == 0 && strcmp($2, "main") == 0)
              found_main = 1;
      }
    ;

class_decl:
      KW_CLASS IDENTIFIER SYM_LBRACE class_fields SYM_RBRACE
    ;

class_fields:
      /* empty */
    | class_fields class_field
    ;

class_field:
      var_decl
    | fun_decl
    ;

type_spec:
      KW_INT      { $$ = strdup("int"); }
    | KW_DOUBLE   { $$ = strdup("double"); }
    | KW_BOOL     { $$ = strdup("bool"); }
    | KW_STRING   { $$ = strdup("string"); }
    | KW_VOID     { $$ = strdup("void"); }
    | IDENTIFIER  { $$ = strdup($1); }  
    ;

formal_params:
      /* empty */
    | param_list
    ;

param_list:
      param_decl
    | param_list SYM_COMMA param_decl
    ;

param_decl:
      type_spec IDENTIFIER
    ;

stmt:
      expr_stmt
    | if_stmt
    | while_stmt
    | do_while_stmt
    | for_stmt
    | break_stmt
    | return_stmt
    | stmt_block
    | var_decl
    ;

stmt_block:
      SYM_LBRACE block_items SYM_RBRACE
    ;

block_items:
      /* empty */
    | block_items block_item
    ;

block_item:
      var_decl
    | stmt
    ;

expr_stmt:
      expression SYM_SEMI
    ;

if_stmt:
      KW_IF SYM_LPAREN expression SYM_RPAREN stmt
    | KW_IF SYM_LPAREN expression SYM_RPAREN stmt KW_ELSE stmt
    ;

while_stmt:
      KW_WHILE SYM_LPAREN expression SYM_RPAREN stmt
    ;

do_while_stmt:
      KW_DO stmt KW_WHILE SYM_LPAREN expression SYM_RPAREN SYM_SEMI
    ;

for_stmt:
      KW_FOR SYM_LPAREN optional_expr SYM_SEMI optional_expr SYM_SEMI optional_expr SYM_RPAREN stmt
    ;

optional_expr:
      /* empty */
    | expression
    ;

break_stmt:
      KW_BREAK SYM_SEMI
    ;

return_stmt:
      KW_RETURN expression SYM_SEMI
    ;

primary:
      IDENTIFIER
    | INT_LITERAL_DEC
    | INT_LITERAL_HEX
    | DOUBLE_LITERAL
    | STRING_LITERAL
    | BOOLEAN_LITERAL
    | KW_NULL
    | KW_THIS
    | SYM_LPAREN expression SYM_RPAREN
    | KW_NEW SYM_LPAREN IDENTIFIER SYM_RPAREN
    ;

postfix:
      primary
    | postfix SYM_DOT IDENTIFIER
    | postfix SYM_LBRACK expression SYM_RBRACK
    | postfix SYM_LPAREN actual_params SYM_RPAREN
    ;

unary:
      OP_NOT unary
    | OP_MINUS unary %prec UMINUS
    | postfix
    ;

mul_expr:
      unary
    | mul_expr OP_STAR unary
    | mul_expr OP_SLASH unary
    | mul_expr OP_MOD unary
    ;

add_expr:
      mul_expr
    | add_expr OP_PLUS mul_expr
    | add_expr OP_MINUS mul_expr
    ;

rel_expr:
      add_expr
    | rel_expr OP_LT add_expr
    | rel_expr OP_LE add_expr
    | rel_expr OP_GT add_expr
    | rel_expr OP_GE add_expr
    ;

eq_expr:
      rel_expr
    | eq_expr OP_EQ rel_expr
    | eq_expr OP_NEQ rel_expr
    ;

and_expr:
      eq_expr
    | and_expr OP_ANDAND eq_expr
    ;

or_expr:
      and_expr
    | or_expr OP_OROR and_expr
    ;

assignment_expr:
      or_expr
    | postfix OP_ASSIGN assignment_expr
    ;

expression:
      assignment_expr
    ;

actual_params:
      /* empty */
    | actual_list
    ;

actual_list:
      expression
    | actual_list SYM_COMMA expression
    ;

%%

void yyerror(const char *s){
    fprintf(stderr, "Syntax error at line %d\n", yylineno);
}

int main(void){
    if (yyparse() == 0) {
        /* success message printed in program rule */
    }
    return 0;
}
