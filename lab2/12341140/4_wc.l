%{ 
	#include<stdio.h>
	int lines = 0, words = 0, chars = 0;
%}
%%

[^ \t\n]+     {words++; chars += yyleng;}
\n            {lines++; chars++;}
.             {chars++;}
%%   
int yywrap(void){return 1;}   
int main(int argc, char **argv) 
{    
    if (argc == 2) {
        FILE *fp = fopen(argv[1], "r");
        if (!fp) {
            perror("File open error");
            return 1;
        }
        yyin = fp;
        yylex();
        fclose(fp);
        printf("%d %d %d %s\n", lines, words, chars, argv[1]);
    }
    else {
        printf("Usage: ./task4 <filename>\n");
    }
    return 0;
} 

