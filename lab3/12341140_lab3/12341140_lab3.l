%{
    #include <stdio.h>
%}

%%

"#define"|"#include"|"#ifdef"|"#ifndef"|"#if"|"#else"|"#elif"|"#endif"|"#undef"|"#pragma"|"#error"|"#line" {printf("%s\tKEYWORD\n",yytext);}

\"([^"\\]|\\.)*\"   { printf("%s\tSTRING_LITERAL\n", yytext); }


[a-zA-Z0-9_]+\.c   { printf("%s\tFILENAME\n", yytext); }
[a-zA-Z0-9_]+\.h   { printf("%s\tFILENAME\n", yytext); }

0[xX][0-9a-fA-F]+   { printf("%s\tHEX_INTEGER\n", yytext); }
[0-9]*\.[0-9]+      { printf("%s\tFLOAT\n", yytext); }
[0-9]+              { printf("%s\tINTEGER\n", yytext); }

"=="                { printf("%s\tEQ_OPERATOR\n", yytext); }
[+\-*/]             { printf("%s\tOPERATOR\n", yytext); }


@@.*                { printf("%s\tCOMMENT_SINGLE\n", yytext); }
\"\"\"([^"]|\n)*\"\"\"  { printf("%s\tCOMMENT_MULTIPLE\n", yytext); }


\$[A-Z][A-Z0-9]*        { printf("%s\tIDENTIFIER\n", yytext); }

[ \t\n]+            { }

.                   { printf("%s", yytext); } 

%%

int yywrap(void) { return 1; }

int main() {
    yylex();
    return 0;
}