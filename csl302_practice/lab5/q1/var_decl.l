%{
#include "var_decl.tab.h"
#include<string.h>
%}

%%
"int"                       { return INT; }
"float"                     { return FLOAT; }
"char"                      { return CHAR; }
[a-zA-Z_][a-zA-Z0-9_]*      { yylval.str = strdup(yytext); return IDENTIFIER; }
","                         { return COMMA;  }
";"                         { return SEMICOLON; }
[ \t\n]+                    ;
.                           { return yytext[0]; }
%%

int yywrap() {
    return 1;
}
