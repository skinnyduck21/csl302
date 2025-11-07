%{
#include "attr.h"
#include "y.tab.h"
#include <string.h>
#include <stdlib.h>
%}

%%
"int"           { return INT; }
"float"         { return FLOAT; }
"if"            { return IF; }
"then"          { return THEN; }
"else"          { return ELSE; }
"while"         { return WHILE; }
"do"            { return DO; }
"and"|"&&"      { return AND; }
"or"|"||"       { return OR; }
"not"|"!"       { return NOT; }

"=="|"!="|"<="|">="|"<"|">"  { yylval.str = strdup(yytext); return RELOP; }

[0-9]+           { yylval.str = strdup(yytext); return NUM; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return ID; }

"="              { return '='; }
";"              { return ';'; }
","              { return ','; }
"("              { return '('; }
")"              { return ')'; }
"{"              { return '{'; }
"}"              { return '}'; }
"+"              { return '+'; }
"-"              { return '-'; }
"*"              { return '*'; }
"/"              { return '/'; }

[ \t\r\n]+       { /* skip whitespace */ }
.                { fprintf(stderr, "Unknown token: %s\n", yytext); }

%%
int yywrap() { return 1; }
