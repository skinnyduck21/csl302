%{
	#include "y.tab.h"
	#include <stdlib.h>
	#include <string.h>
%}

%%
[0-9]+                  { yylval.str = strdup(yytext); return NUM; }
[a-zA-Z][a-zA-Z0-9]*    { yylval.str = strdup(yytext); return ID; }
"+"						{ return KW_PLUS; }
"-"						{ return KW_MINUS; }
"*"						{ return KW_STAR; }
"/"						{ return KW_DIVISION; }
[ \t\n] 					;   
. 						return yytext[0];
%%

int yywrap() {
    return 1;
}
