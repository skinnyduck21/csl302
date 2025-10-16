%{ 
	#include<stdio.h>
%}



%%


[;][a-zA-Z0-9]*                                                                    {}        
"MOV"|"ADD"|"SUB"|"MUL"|"DIV"|"LOAD"|"STORE"|"JMP"|"CMP"|"HALT"                    { printf("OPCODE      :   %s\n", yytext); }
[A-Z]+                                                                             { printf("LABEL       :   %s\n", yytext); }
R[0-9]                                                                             { printf("REGISTER    :   %s\n", yytext); }  
((#[0-9]+)|(#[\-][0-9]+))                                                                     { printf("IMMEDIATE   :   %s\n", yytext); }     
[,;:]                                                                              { printf("DELIMETER   :   %s\n", yytext); }                             
[ \t\n]+                                                                           { }
.                                                                                  {  }
%%   



int yywrap(void){return 1;}   
int main() 
{    
    yylex();   
    return 0; 
}

