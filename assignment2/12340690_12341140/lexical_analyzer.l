%option noyywrap yylineno

%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    #include "y.tab.h"
    extern int yylineno;
    
    static char* sdup(const char* s){
        if(!s) return NULL;
        char* p = malloc(strlen(s) + 1);
        if (p) strcpy(p, s);
        return p;
    }
%}

ID_START    [A-Za-z]
ID_CONT     [A-Za-z0-9_]*
WS          [ \t\r]+
ID          {ID_START}{ID_CONT}
INT         [0-9]+
HEX_INT     0[xX][0-9A-Fa-f]+
EXP         [Ee][+-]?{INT}
DBL         ({INT}"."{INT}({EXP})?)|({INT}{EXP})

%%

{WS}                ;
\n                  ;

"//"[^\n]*          ; /* Single line comment - ignore */
"/*"([^*]|\*+[^*/])*\*+"/"    ; /* Multi-line comment - ignore */

\"([^\\\n"]|\\.)*\" {
    yylval.str = sdup(yytext);
    return STRING_LITERAL;
}

"&&"                { return OP_ANDAND; }
"||"                { return OP_OROR; }
"=="                { return OP_EQ; }
"!="                { return OP_NEQ; }
"<="                { return OP_LE; }
">="                { return OP_GE; }

"void"              { return KW_VOID; }
"int"               { return KW_INT; }
"double"            { return KW_DOUBLE; }
"bool"              { return KW_BOOL; }
"string"            { return KW_STRING; }
"class"             { return KW_CLASS; }
"interface"         { return KW_INTERFACE; }
"extends"           { return KW_EXTENDS; }
"implements"        { return KW_IMPLEMENTS; }
"for"               { return KW_FOR; }
"while"             { return KW_WHILE; }
"do"                { return KW_DO; }
"if"                { return KW_IF; }
"else"              { return KW_ELSE; }
"return"            { return KW_RETURN; }
"break"             { return KW_BREAK; }
"null"              { yylval.str = NULL; return KW_NULL; }
"this"              { return KW_THIS; }
"ReadInteger"       { return KW_READINTEGER; }
"ReadLine"          { return KW_READLINE; }
"Print"             { return KW_PRINT; }
"New"               { return KW_NEW; }
"NewArray"          { return KW_NEWARRAY; }

"true"              { yylval.bval = 1; return BOOLEAN_LITERAL; }
"false"             { yylval.bval = 0; return BOOLEAN_LITERAL; }

{ID} {
    if (strlen(yytext) <= 255) {
        yylval.str = sdup(yytext);
        return IDENTIFIER;
    } else {
        fprintf(stderr, "Error: Identifier too long at line %d\n", yylineno);
        yylval.str = sdup(yytext);
        return ERROR_IDENTIFIER_TOO_LONG;
    }
}

{HEX_INT}   { yylval.str = sdup(yytext); return INT_LITERAL_HEX; }
{DBL}       { yylval.dval = atof(yytext); return DOUBLE_LITERAL; }
{INT}       { yylval.ival = atoi(yytext); return INT_LITERAL_DEC; }

"+"         { return OP_PLUS; }
"-"         { return OP_MINUS; }
"*"         { return OP_STAR; }
"/"         { return OP_SLASH; }
"%"         { return OP_MOD; }
"<"         { return OP_LT; }
">"         { return OP_GT; }
"="         { return OP_ASSIGN; }
"!"         { return OP_NOT; }

";"         { return SYM_SEMI; }
","         { return SYM_COMMA; }
"."         { return SYM_DOT; }
"["         { return SYM_LBRACK; }
"]"         { return SYM_RBRACK; }
"("         { return SYM_LPAREN; }
")"         { return SYM_RPAREN; }
"{"         { return SYM_LBRACE; }
"}"         { return SYM_RBRACE; }

.           { 
    fprintf(stderr, "Error: Invalid token '%s' at line %d\n", yytext, yylineno);
    return ERROR_INVALID_TOKEN; 
}

%%
