%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void cat(char *fname) {
    if(fname == NULL || strlen(fname)==0) {
        printf("Error: cat requires a filename\n");
        return;
    }
    FILE *fp = fopen(fname,"r");
    if(!fp) { printf("Error: cannot open %s\n", fname); return; }
    char buf[1024];
    while(fgets(buf,sizeof(buf),fp)) {
        printf("%s",buf);
    }
    fclose(fp);
}
%}

%%
cat[ \t]+[a-zA-Z0-9_.\/]+    { cat(yytext+4); }
cat                         { cat(""); }
\n    { /* ignore newline */ }
.     { /* ignore anything else */ }
%%

int yywrap() { return 1; }

int main() {
    yylex();
    return 0;
}
