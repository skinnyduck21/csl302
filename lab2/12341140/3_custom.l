%{ 
	#include<stdio.h>
%}
%%
([A-Z][a-z]*[ ][A-Z][a-z]*)	                        {printf("NAME\n");}
\([0-9]{3}\)[ ][0-9]{3}-[0-9]{4}	                {printf("PHONE_NUMBER\n");}
[a-zA-Z][a-zA-Z0-9]*@[a-z]+\.[a-z]+\.[a-z]+   	    {printf("EMAIL\n");}
[0-9]{4}[ ][0-9]{4}[ ][0-9]{4}[ ][0-9]{4}	        {printf("CREDIT_CARD\n");}
.|\n                                                {}
%%   
int yywrap(void){return 1;}   
int main() 
{    
    yylex();   
    return 0; 
}

