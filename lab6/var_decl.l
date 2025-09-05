%{
#include "y.tab.h"
#include <string.h>
%}

%%
"int"       { return INT; }
"float"     { return FLOAT; }
"char"      { return CHAR; }
"for"       { return FOR; }
"if"        { return IF; }
"then"      { return THEN; }
"else"      { return ELSE; }
"elif"      { return ELIF; }
"switch"    { return SWITCH; }
"case"      { return CASE; }
"do"        { return DO; }
"while"     { return WHILE; }
"=="        { return EQ; }
"!="        { return NE; }
"<="        { return LE; }
">="        { return GE; }
"<"         { return LT; }
">"         { return GT; }
[a-zA-Z_][a-zA-Z0-9_]*    { yylval.str = strdup(yytext); return IDENTIFIER; }
[0-9]+      { yylval.str = strdup(yytext); return NUMBER; }
";"         { return SEMICOLON; }
","         { return COMMA; }
":"         { return COLON; }
"="         { return ASSIGN; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return MUL; }
"/"         { return DIV; }
"("         { return LPAREN; }
")"         { return RPAREN; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }
[ \t\n]+    ;
.           { return yytext[0]; }
%%

int yywrap(void) {
    return 1;
}
