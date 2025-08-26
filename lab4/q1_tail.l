%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAXLINES 1000
char *lines[MAXLINES];

void tail(char *fname) {
    if(fname == NULL || strlen(fname)==0) {
        printf("Error: tail requires a filename\n");
        return;
    }
    FILE *fp = fopen(fname,"r");
    if(!fp) { printf("Error: cannot open %s\n", fname); return; }
    char buf[1024];
    int count=0;
    while(fgets(buf,sizeof(buf),fp)) {
        lines[count] = strdup(buf);
        count++;
    }
    int start = (count>10) ? count-10 : 0;
    for(int i=start;i<count;i++) {
        printf("%s", lines[i]);
        free(lines[i]);
    }
    fclose(fp);
}
%}

%%
tail[ \t]+[a-zA-Z0-9_.\/]+   { tail(yytext+5); }
tail                        { tail(""); }
\n    { /* ignore newline */ }
.     { /* ignore anything else */ }
%%

int yywrap() { return 1; }

int main() {
    yylex();
    return 0;
}
