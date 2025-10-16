%{
#include "y.tab.h"
%}

%%

"goto"      { return KEY_GOTO; }
"if"        { return KEY_IF; }
[L][0-9]+   { return LABEL; }
[a-z]+      { return IDENTIFIER; }
[t][0-9]+   { return TEMP_VARIABLES; }
[0-9]+      { return CONSTANTS; }
"+"         { return OP_PLUS; }
"-"         { return OP_MINUS; }
"*"         { return OP_MUL; }
"/"         { return OP_DIV; }
"<"         { return OP_LESS; }
">"         { return OP_MORE; }
"="         { return OP_EQUAL; }
"!"         { return OP_NOTEQUAL; }
";"         { return SPECIAL_SEMICOLON; }
":"         { return SPECIAL_COLON; }
"["         { return SPECIAL_LEFT; }  
"]"         { return SPECIAL_RIGHT; }

[ \t\n]+    ;


.           { return yytext[0]; }

%%

int yywrap() {
    return 1;
}