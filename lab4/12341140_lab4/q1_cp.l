%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void cp(char *src,char *dst) {
    if(src==NULL || dst==NULL || strlen(src)==0 || strlen(dst)==0) {
        printf("Error: cp requires source and destination filenames\n");
        return;
    }
    FILE *f1=fopen(src,"r");
    if(!f1) { printf("Error: cannot open %s\n", src); return; }
    FILE *f2=fopen(dst,"w");
    if(!f2) { printf("Error: cannot open %s\n", dst); fclose(f1); return; }
    char buf[1024];
    while(fgets(buf,sizeof(buf),f1)) {
        fputs(buf,f2);
    }
    fclose(f1);
    fclose(f2);
    printf("File copied from %s to %s\n",src,dst);
}
%}

%%
cp[ \t]+[a-zA-Z0-9_.\/]+[ \t]+[a-zA-Z0-9_.\/]+ {
    char src[100], dst[100];
    if(sscanf(yytext+3,"%s %s",src,dst)==2)
        cp(src,dst);
    else
        cp("","");
}
cp                          { cp("",""); }
\n    { /* ignore newline */ }
.     { /* ignore anything else */ }
%%

int yywrap() { return 1; }

int main() {
    yylex();
    return 0;
}
