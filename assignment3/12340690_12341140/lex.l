/* lex.l */
%option noyywrap yylineno

%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    #include "y.tab.h"
    
    static char* sdup(const char* s) {
        if (!s) return NULL;
        char* p = malloc(strlen(s) + 1);
        if (p) strcpy(p, s);
        return p;
    }
%}

WS          [ \t\r]+
ID          [A-Za-z_][A-Za-z0-9_]*
INT         [0-9]+
DOUBLE      [0-9]+\.[0-9]+

%%

{WS}                ;
\n                  ;
"//"[^\n]*          ;

"int"               { return KW_INT; }
"double"            { return KW_DOUBLE; }
"bool"              { return KW_BOOL; }
"string"            { return KW_STRING; }
"void"              { return KW_VOID; }
"if"                { return KW_IF; }
"else"              { return KW_ELSE; }
"while"             { return KW_WHILE; }
"for"               { return KW_FOR; }
"do"                { return KW_DO; }
"return"            { return KW_RETURN; }
"break"             { return KW_BREAK; }
"Print"             { return KW_PRINT; }
"null"              { return KW_NULL; }
"readInteger"       { return KW_READINTEGER; }
"readline"          { return KW_READLINE; }

\"([^"\\]|\\.)*\"   { yylval.str = sdup(yytext); return STRING_LITERAL; }
{DOUBLE}            { yylval.dval = atof(yytext); return DOUBLE_LITERAL; }
{INT}               { yylval.ival = atoi(yytext); return INT_LITERAL_DEC; }
{ID}                { yylval.str = sdup(yytext); return IDENTIFIER; }

"+"                 { return OP_PLUS; }
"-"                 { return OP_MINUS; }
"*"                 { return OP_STAR; }
"/"                 { return OP_SLASH; }
"%"                 { return OP_MOD; }
"=="                { return OP_EQ; }
"!="                { return OP_NEQ; }
"<"                 { return OP_LT; }
">"                 { return OP_GT; }
"<="                { return OP_LE; }
">="                { return OP_GE; }
"&&"                { return OP_ANDAND; }
"||"                { return OP_OROR; }
"!"                 { return OP_NOT; }
"="                 { return OP_ASSIGN; }

";"                 { return SYM_SEMI; }
","                 { return SYM_COMMA; }
"."                 { return SYM_DOT; }
"["                 { return SYM_LBRACK; }
"]"                 { return SYM_RBRACK; }
"("                 { return SYM_LPAREN; }
")"                 { return SYM_RPAREN; }
"{"                 { return SYM_LBRACE; }
"}"                 { return SYM_RBRACE; }

.                   { return ERROR_INVALID_TOKEN; }
%%