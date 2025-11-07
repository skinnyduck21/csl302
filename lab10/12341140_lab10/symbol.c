#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbol.h"

Symbol* symbolTable[TABLE_SIZE] = {NULL};

unsigned int hash(char *str) {
    unsigned int h=0; while(*str) h=(h<<2)+*str++; return h%TABLE_SIZE;
}

void insertSymbol(char* name,char* type,int scope){
    if(lookupSymbol(name)) return;
    unsigned idx=hash(name);
    Symbol* s=malloc(sizeof(Symbol));
    strcpy(s->name,name); strcpy(s->type,type); s->scope=scope;
    s->next=symbolTable[idx]; symbolTable[idx]=s;
}
Symbol* lookupSymbol(char* name){
    unsigned idx=hash(name); Symbol* s=symbolTable[idx];
    while(s){ if(strcmp(s->name,name)==0) return s; s=s->next; }
    return NULL;
}
