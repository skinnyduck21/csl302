%{
#include <stdio.h>
#include <string.h>
%}

/* Definitions */
NAME    [A-Za-z0-9]+
EXT     (\.txt|\.dat)
DOTDOT  \.\.
PATH    (\/({NAME}|{DOTDOT}))+
FILE    (\/({NAME}|{DOTDOT}))*\/?{NAME}{EXT}

%%
^{PATH}\/?$         { printf("VALID PATH\n"); }
^{FILE}$            { printf("VALID PATH\n"); }
.*                  { printf("INVALID PATH\n"); }
%%

int yywrap() {
    return 1;
}

int main() {
    yylex();
    return 0;
}
