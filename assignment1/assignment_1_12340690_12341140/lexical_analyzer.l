%option noyywrap yylineno nodefault
%option yymore

%{
    #include<stdio.h>
    #include<string.h>

    static void print_token(const char* kind, const char* text){
        printf("LINE %d: %-18s %s\n", yylineno, kind, text);
    }
%}

%x  MLCOMMENT

ID_START    [A-Za-z]
ID_CONT     [A-Za-z0-9_]
WS          [ \t\r]+
ID          {ID_START}{ID_CONT}*
INT         [0-9]+
HEX_INT     0[xX][0-9A-Fa-f]+
EXP         [Ee][+-]?{INT}

DBL         {INT}\.{INT}?{EXP}?

%%

{WS}                ;
\n                  ;

"//"[^\n]*          { print_token("COMMENT_SINGLE", yytext); }
"/*"                { BEGIN(MLCOMMENT); print_token("MULTI_LINE_COMMENT_START", "/*"); }
<MLCOMMENT>{
    "*/"            { print_token("MULTI_LINE_COMMENT_END", "*/"); BEGIN(INITIAL); }
    \n              { print_token("COMMENT_NEWLINE", "\\n"); }
    .               ;   /* consume anything */
    <<EOF>>         { print_token("ERROR(UnterminatedComment)", "/*"); BEGIN(INITIAL); }
}

\"[^\n\"]*\"        { print_token("STRING_LITERAL", yytext); }
\"[^\n\"]*\n        { print_token("ERROR(UnterminatedString)", yytext); }
"&&"                { print_token("OP_ANDAND", yytext); }
"||"                { print_token("OP_OROR", yytext); }
"=="                { print_token("OP_EQ", yytext); }
"!="                { print_token("OP_NEQ", yytext); }
"<="                { print_token("OP_LE", yytext); }
">="                { print_token("OP_GE", yytext); }
"\[\]"              { print_token("OP_BRACKETS", yytext); }  /* treat [] as single operator */
"void"              { print_token("KW_VOID", yytext); }
"int"               { print_token("KW_INT", yytext); }
"double"            { print_token("KW_DOUBLE", yytext); }
"bool"              { print_token("KW_BOOL", yytext); }
"string"            { print_token("KW_STRING", yytext); }
"class"             { print_token("KW_CLASS", yytext); }
"interface"         { print_token("KW_INTERFACE", yytext); }
"extends"           { print_token("KW_EXTENDS", yytext); }
"implements"        { print_token("KW_IMPLEMENTS", yytext); }
"for"               { print_token("KW_FOR", yytext); }
"while"             { print_token("KW_WHILE", yytext); }
"if"                { print_token("KW_IF", yytext); }
"else"              { print_token("KW_ELSE", yytext); }
"return"            { print_token("KW_RETURN", yytext); }
"break"             { print_token("KW_BREAK", yytext); }
"null"              { print_token("KW_NULL", yytext); }
"this"              { print_token("KW_THIS", yytext); }
"ReadInteger"       { print_token("KW_READINTEGER", yytext); }
"ReadLine"          { print_token("KW_READLINE", yytext); }
"Print"             { print_token("KW_PRINT", yytext); }
"New"               { print_token("KW_NEW", yytext); }
"NewArray"          { print_token("KW_NEWARRAY", yytext); }
"true"|"false"      { print_token("BOOLEAN_LITERAL", yytext); }  /* must precede {ID} */
{ID} {
        if (strlen(yytext) <= 31) {
            print_token("IDENTIFIER", yytext);
        } else {
            print_token("ERROR(IdentifierTooLong)", yytext);
        }
    }
{HEX_INT}           { print_token("INT_LITERAL_HEX", yytext); }
{DBL}               { print_token("DOUBLE_LITERAL", yytext); }
{INT}               { print_token("INT_LITERAL_DEC", yytext); }


"+"                 { print_token("OP_PLUS", yytext); }
"-"                 { print_token("OP_MINUS", yytext); }
"*"                 { print_token("OP_STAR", yytext); }
"/"                 { print_token("OP_SLASH", yytext); }
"%"                 { print_token("OP_MOD", yytext); }
"\\"                { print_token("OP_BACKSLASH", yytext); }
"<"                 { print_token("OP_LT", yytext); }
">"                 { print_token("OP_GT", yytext); }
"="                 { print_token("OP_ASSIGN", yytext); }
"!"                 { print_token("OP_NOT", yytext); }
";"                 { print_token("SYM_SEMI", yytext); }
","                 { print_token("SYM_COMMA", yytext); }
"\."                { print_token("SYM_DOT", yytext); }
"\["                { print_token("SYM_LBRACK", yytext); }
"\]"                { print_token("SYM_RBRACK", yytext); }
"\("                { print_token("SYM_LPAREN", yytext); }
"\)"                { print_token("SYM_RPAREN", yytext); }
.                   { print_token("ERROR(InvalidToken)", yytext); }

%%

int main(void){
    yylex();
    return 0;
}

