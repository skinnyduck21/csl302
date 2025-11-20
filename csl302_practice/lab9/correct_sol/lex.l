%{
	#include "y.tab.h"
	#include <stdlib.h>
	#include <string.h>
%}

%%
"int"					{ return KW_INT; }
"float"					{ return KW_FLOAT; }
"and"					{ return KW_AND; }
"or"     				{ return KW_OR; }
"not"					{ return KW_NOT; }
"true"					{ return KW_TRUE; }
"false"					{ return KW_FALSE; }
"if"					{ return KW_IF; }
"then"					{ return KW_THEN; }
"else"					{ return KW_ELSE; }
"while"					{ return KW_WHILE; }
"do"					{ return KW_DO; }
[0-9]+                  { yylval.str = strdup(yytext); return NUM; }
[a-zA-Z][a-zA-Z0-9]*    { yylval.str = strdup(yytext); return ID; }
"+"						{ return KW_PLUS; }
"-"						{ return KW_MINUS; }
"*"						{ return KW_STAR; }
"/"						{ return KW_DIVISION; }
"("						{ return KW_PAREN_LEFT; }
")"						{ return KW_PAREN_RIGHT; }
"{"						{ return KW_LBRACE; }
"}"						{ return KW_RBRACE; }
"="						{ return KW_EQUALS; }
"<"						{ return KW_LT; }
">"						{ return KW_GT; }
"<="					{ return KW_LTE; }
">="					{ return KW_GTE; }
"=="					{ return KW_ISEQUAL; }
"!="					{ return KW_ISNOTEQUAL; }
","						{ return KW_COMMA; }
";"						{ return KW_SEMICOLON; }
":"						{ return KW_COLON; }
[ \t\n] 					;   
. 						return yytext[0];
%%

int yywrap() {
    return 1;
}