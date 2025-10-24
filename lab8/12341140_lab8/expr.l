%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbol.h"
#include "y.tab.h"
%}

%%
"int"               { return INT; }
"float"             { return FLOAT; }
"true"              { yylval.str = strdup("true"); return TRUE; }
"false"             { yylval.str = strdup("false"); return FALSE; }
"or"                { return OR; }
"and"               { return AND; }
"not"               { return NOT; }

"<="                { return LE; }
">="                { return GE; }
"=="                { return EQ; }
"!="                { return NE; }
"<"                 { return LT; }
">"                 { return GT; }

[0-9]+"."[0-9]+     { yylval.str = strdup(yytext); return FLOAT_CONST; }
[0-9]+              { yylval.str = strdup(yytext); return INT_CONST; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return ID; }

";"                 { return ';'; }
","                 { return ','; }
"="                 { return '='; }
"("                 { return '('; }
")"                 { return ')'; }

[ \t\n]+            ;
.                   ;
%%

int yywrap() { return 1; }
