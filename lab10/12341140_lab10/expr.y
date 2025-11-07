%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbol.h"
#include "attr.h"

int yylex(void);
void yyerror(const char *s);

/* ---------- Quad Representation ---------- */
typedef struct {
    char op[16];
    char arg1[32];
    char arg2[32];
    char res[32];
    int target;
} Quad;

Quad Q[500];
int nextquad = 0;
int tempc = 0;

/* ---------- Utility ---------- */
char* newtemp() {
    char *t = malloc(8);
    sprintf(t, "t%d", tempc++);
    return t;
}

/* ---------- Backpatch Helpers ---------- */
List* makelist(int i) {
    List* p = malloc(sizeof(List));
    p->index = i; p->next = NULL; return p;
}
List* merge(List* a, List* b) {
    if(!a) return b; if(!b) return a;
    List *t=a; while(t->next) t=t->next; t->next=b; return a;
}
void backpatch(List* p, int target) {
    while(p) { Q[p->index].target = target; p=p->next; }
}

/* ---------- Emit Helpers ---------- */
void emit(const char* op,const char* a1,const char* a2,const char* res) {
    strcpy(Q[nextquad].op, op);
    if(a1) strcpy(Q[nextquad].arg1,a1); else Q[nextquad].arg1[0]=0;
    if(a2) strcpy(Q[nextquad].arg2,a2); else Q[nextquad].arg2[0]=0;
    if(res) strcpy(Q[nextquad].res,res); else Q[nextquad].res[0]=0;
    Q[nextquad].target=-1;
    nextquad++;
}

void print_quads() {
    for(int i=0;i<nextquad;i++) {
        if(!strcmp(Q[i].op,"if"))
            printf("%d: if %s goto %d\n",i,Q[i].arg1,Q[i].target);
        else if(!strcmp(Q[i].op,"goto"))
            printf("%d: goto %d\n",i,Q[i].target);
        else if(!strcmp(Q[i].op,"param"))
            printf("%d: param %s\n",i,Q[i].arg1);
        else if(!strcmp(Q[i].op,"call"))
            printf("%d: call %s, %s\n",i,Q[i].arg1,Q[i].arg2);
        else if(!strcmp(Q[i].op,"="))
            printf("%d: %s = %s\n",i,Q[i].res,Q[i].arg1);
        else if(strchr("+-*/",Q[i].op[0]))
            printf("%d: %s = %s %s %s\n",i,Q[i].res,Q[i].arg1,Q[i].op,Q[i].arg2);
    }
}
%}

%nonassoc IFX
%nonassoc ELSE

%union {
    char *str;
    Attr *attr;
    int ival;
}

%token <str> ID NUM RELOP
%token INT FLOAT IF THEN ELSE WHILE DO AND OR NOT
%type <attr> bool stmt stmts m n
%type <str> expr
%type <ival> arg_list opt_args

%left OR
%left AND
%right NOT
%left '+' '-'
%left '*' '/'
%nonassoc RELOP

%start program

%%

program
    : decls stmts END
        { backpatch($2->nextlist,nextquad); print_quads(); }
    ;

END
    : 
    | '\n'
    ;



decls
    : decls decl
    |
    ;

decl
    : INT ID ';'   { insertSymbol($2,"int",0); }
    | FLOAT ID ';' { insertSymbol($2,"float",0); }
    ;

stmts
    : stmts stmt { $$=$1; backpatch($1->nextlist,nextquad); $$->nextlist=$2->nextlist; }
    | stmt       { $$=$1; }
    ;

stmt
    : ID '=' expr ';' { emit("=",$3,NULL,$1); $$=calloc(1,sizeof(Attr)); }
    | IF bool THEN m stmt %prec IFX
        { backpatch($2->truelist,$4->instr);
          $$=calloc(1,sizeof(Attr)); $$->nextlist=merge($2->falselist,$5->nextlist); }
    | IF bool THEN m stmt n ELSE m stmt
        { backpatch($2->truelist,$4->instr);
          backpatch($2->falselist,$8->instr);
          $$=calloc(1,sizeof(Attr));
          $$->nextlist=merge($5->nextlist,merge($6->nextlist,$9->nextlist));
          backpatch($$->nextlist, nextquad); }
    | WHILE m bool DO m stmt
        { backpatch($3->truelist,$5->instr);
          emit("goto",NULL,NULL,NULL); backpatch(makelist(nextquad-1),$2->instr);
          $$=calloc(1,sizeof(Attr)); $$->nextlist=$3->falselist; }
    | '{' stmts '}' { $$=$2; }
    | ID '(' opt_args ')' ';'
        { char buf[8]; sprintf(buf,"%d",$3);
          emit("call",$1,buf,NULL); $$=calloc(1,sizeof(Attr)); }
    ;
m :  { $$=calloc(1,sizeof(Attr)); $$->instr=nextquad; };
n :  { $$=calloc(1,sizeof(Attr)); $$->nextlist=makelist(nextquad); emit("goto",NULL,NULL,NULL); };

bool
    : bool OR m bool { backpatch($1->falselist,$3->instr);
                       $$=calloc(1,sizeof(Attr));
                       $$->truelist=merge($1->truelist,$4->truelist);
                       $$->falselist=$4->falselist; }
    | bool AND m bool { backpatch($1->truelist,$3->instr);
                        $$=calloc(1,sizeof(Attr));
                        $$->truelist=$4->truelist;
                        $$->falselist=merge($1->falselist,$4->falselist); }
    | NOT bool { $$=calloc(1,sizeof(Attr));
                 $$->truelist=$2->falselist; $$->falselist=$2->truelist; }
    | '(' bool ')' { $$=$2; }
    | expr RELOP expr { $$=calloc(1,sizeof(Attr));
                        char cond[64]; sprintf(cond,"%s %s %s",$1,$2,$3);
                        emit("if",cond,NULL,NULL);
                        $$->truelist=makelist(nextquad-1);
                        emit("goto",NULL,NULL,NULL);
                        $$->falselist=makelist(nextquad-1); }
    ;

expr
    : expr '+' expr { char* t=newtemp(); emit("+",$1,$3,t); $$=t; }
    | expr '-' expr { char* t=newtemp(); emit("-",$1,$3,t); $$=t; }
    | expr '*' expr { char* t=newtemp(); emit("*",$1,$3,t); $$=t; }
    | expr '/' expr { char* t=newtemp(); emit("/",$1,$3,t); $$=t; }
    | '(' expr ')'  { $$=$2; }
    | NUM           { $$=$1; }
    | ID            { $$=$1; }
    ;

opt_args
    :  { $$=0; }
    | arg_list    { $$=$1; }
    ;

arg_list
    : expr { emit("param",$1,NULL,NULL); $$=1; }
    | arg_list ',' expr { emit("param",$3,NULL,NULL); $$=$1+1; }
    ;

%%

void yyerror(const char *s){ fprintf(stderr,"Error: %s\n",s); }

int main() {
    for(int i=0;i<TABLE_SIZE;i++) symbolTable[i]=NULL;
    yyparse();
    return 0;
}
