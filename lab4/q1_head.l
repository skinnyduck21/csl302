%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void head(char *fname) {
    if(fname == NULL || strlen(fname)==0) {
        printf("Error: head requires a filename\n");
        return;
    }
    FILE *fp = fopen(fname,"r");
    if(!fp) { printf("Error: cannot open %s\n", fname); return; }
    char buf[1024];
    int count = 0;
    while(fgets(buf,sizeof(buf),fp) && count < 10) {
        printf("%s",buf);
        count++;
    }
    fclose(fp);
}
%}

%%
head[ \t]+[a-zA-Z0-9_.\/]+   { head(yytext+5); }
head                        { head(""); }
\n    { /* ignore newline */ }
.     { /* ignore anything else */ }
%%

int yywrap() { return 1; }

int main() {
    yylex();
    return 0;
}
