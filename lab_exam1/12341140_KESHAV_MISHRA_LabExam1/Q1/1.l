%{ 
	#include<stdio.h>
%}



%%


(1|2)[0-9]{2}[0000-1999][0]                                          { printf("PHD_STUDENT\n"); }   
(1|2)[0-9]{2}[0000-1999][1-9]                                        { printf("INVALID\n"); }        
(1|2)[0-9]{2}[2001-3999][0]                                          { printf("MASTER_STUDENT\n"); }   
(1|2)[0-9]{2}[2001-3999][1-9]                                        { printf("INVALID\n"); }
(1|2)[0-9]{2}[4000-9999][0]                                          { printf("UG_STUDENT\n"); }
(1|2)[0-9]{2}[4000-9999][1-9]                                        { printf("INVALID\n"); }
(3)[0-9]{2}[0000-9999][0]                                            { printf("EMPL_REG\n"); }   
(3)[0-9]{2}[0000-9999][1-9]                                          { printf("EMPL_REG_DEP\n"); }  
(4)[0-9]{2}[0000-9999][0]                                            { printf("EMPL_CON\n"); }  
(4)[0-9]{2}[0000-9999][1-9]                                          { printf("EMPL_CON_DEP\n"); }   
(5|6|7|8)[0-9]{2}[0000-9999][0-9]                                        { printf("OTHER\n"); }  
[ \t\n] {}
. {}
%%   



int yywrap(void){return 1;}   
int main() 
{    
    yylex();   
    return 0; 
}

