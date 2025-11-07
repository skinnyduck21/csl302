#ifndef SYMBOL_H
#define SYMBOL_H
#define TABLE_SIZE 211
typedef struct Symbol {
    char name[32], type[16];
    int scope;
    struct Symbol* next;
} Symbol;
extern Symbol* symbolTable[TABLE_SIZE];
unsigned int hash(char*);
void insertSymbol(char*,char*,int);
Symbol* lookupSymbol(char*);
#endif
