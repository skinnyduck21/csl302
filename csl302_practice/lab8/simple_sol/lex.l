%{
	#include "y.tab.h"
	#include <stdlib.h>
	#include <string.h>
%}

%%
"int"					{ return KW_INT; }
"float"					{ return KW_FLOAT; }
","						{ return KW_COMMA; }
";"						{ return KW_SEMICOLON; }
"and"					{ return KW_AND; }
"or"     				{ return KW_OR; }
"not"					{ return KW_NOT; }
"true"					{ return KW_TRUE; }
"false"					{ return KW_FALSE; }
[0-9]+                  { yylval.str = strdup(yytext); return NUM; }
[a-zA-Z][a-zA-Z0-9]*    { yylval.str = strdup(yytext); return ID; }
"+"						{ return KW_PLUS; }
"-"						{ return KW_MINUS; }
"*"						{ return KW_STAR; }
"/"						{ return KW_DIVISION; }
"("						{ return KW_PAREN_LEFT; }
")"						{ return KW_PAREN_RIGHT; }
"="						{ return KW_EQUALS; }
"<"						{ return KW_LT; }
">"						{ return KW_GT; }
"<="					{ return KW_LTE; }
">="					{ return KW_GTE; }
"=="					{ return KW_ISEQUAL; }
"!="					{ return KW_ISNOTEQUAL; }
[ \t\n] 					;   
. 						return yytext[0];
%%

int yywrap() {
    return 1;
}
