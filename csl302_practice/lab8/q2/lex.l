%{
	#include "y.tab.h"
	#include <stdlib.h>
	#include <string.h>
%}

%%
"and"					{ return KW_AND; }
"or"     				{ return KW_OR; }
"not"					{ return KW_NOT; }
"true"					{ yylval.str = strdup(yytext); return KW_TRUE; }
"false"					{ yylval.str = strdup(yytext); return KW_FALSE; }
[0-9]+                  { yylval.str = strdup(yytext); return NUM; }
[a-zA-Z][a-zA-Z0-9]*    { yylval.str = strdup(yytext); return ID; }
"+"						{ return KW_PLUS; }
"-"						{ return KW_MINUS; }
"*"						{ return KW_STAR; }
"/"						{ return KW_DIVISION; }
"("						{ return KW_PAREN_LEFT; }
")"						{ return KW_PAREN_RIGHT; }
"="						{ return KW_EQUAL; }
"<"						{ return KW_LT; }
">"						{ return KW_GT; }
"<="					{ return KW_LTE; }
">="					{ return KW_GTE; }
"=="					{ return KW_ISITEQUAL; }
"!="					{ return KW_ISNOTEQUAL; }
[ \t\n] 					;   
. 						return yytext[0];
%%

int yywrap() {
    return 1;
}
