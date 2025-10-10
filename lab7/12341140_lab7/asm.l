%{
#include "y.tab.h"
#include <stdio.h>
#include <string.h>

void yyerror(const char *s);
%}

/* Regular expressions */
%%
MOV              { return MOV; }
ADD              { return ADD; }
SUB              { return SUB; }
MUL              { return MUL; }
DIV              { return DIV; }
LOAD             { return LOAD; }
STORE            { return STORE; }
JMP              { return JMP; }
CMP              { return CMP; }
HALT|HLT         { return HALT; }

R[0-9]           { return REGISTER; }

#[-]?[0-9]+     { return IMMEDIATE; }

[A-Z]+           { return LABEL; }

","              { return COMMA; }
":"              { return COLON; }

";".*            { /* comment - ignore */ }

[ \t\r\n]+       { /* skip whitespace */ }

.                { return ERROR; }
%%

int yywrap() { return 1; }
