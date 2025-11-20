%{
/*
This section is directly copied from lex file to lex.yy.c file
*/
#include "y.tab.h"
#include<string.h>
%}

%%
"int"                       { 
                                /*
                                This tells parser that INT token is found
                                */
                                return INT; 
                            }
"float"                     { return FLOAT; }
"char"                      { return CHAR; }
[a-zA-Z_][a-zA-Z0-9_]*      { 
                                /*
                                yylval is a global variable shared between lexer and parser, passes value from lexer to parser, it's type is defined by us in the .y file using something like following:
                                %union {
                                    char* str;
                                    int num;
                                    float fval;
                                }
                                %token <str> IDENTIFIER
                                
                                strdup() duplicates a string by allocating memory and copying it

                                yytext(gloabal character array) automatically contains the matched string
                                */
                                yylval.str = strdup(yytext); return IDENTIFIER; 
                            }
";"                         { return SEMICOLON; }
[ \t\n]+                    ;
.                           { return yytext[0]; }
%%

int yywrap() {
    /* This function tells Flex to stop scanning
       when the end of input (EOF) is reached. */
    return 1;
}
