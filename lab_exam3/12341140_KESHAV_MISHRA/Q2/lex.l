%{
	#include "y.tab.h"
	#include <stdlib.h>
	#include <string.h>
%}

%%
"switch"				{ return KW_SWITCH; }
"default"				{ return KW_DEFAULT; }
"case"					{ return KW_CASE; }
[0-9]+                  { yylval.str = strdup(yytext); return NUM; }
[a-zA-Z][a-zA-Z0-9]*    { yylval.str = strdup(yytext); return ID; }
"+"						{ return KW_PLUS; }
"-"						{ return KW_MINUS; }
"*"						{ return KW_STAR; }
"/"						{ return KW_DIVISION; }
"("						{ return KW_PAREN_LEFT; }
")"						{ return KW_PAREN_RIGHT; }
"{"						{ return KW_LBRACE; }
"}"						{ return KW_RBRACE; }
"="						{ return KW_EQUALS; }
"<"						{ return KW_LT; }
">"						{ return KW_GT; }
"<="					{ return KW_LTE; }
">="					{ return KW_GTE; }
"=="					{ return KW_ISEQUAL; }
"!="					{ return KW_ISNOTEQUAL; }
";"						{ return KW_SEMICOLON; }
":"						{ return KW_COLON; }
[ \t\n] 					;   
. 						return yytext[0];
%%

int yywrap() {
    return 1;
}