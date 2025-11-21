/* symbol.h */
#ifndef SYMBOL_H
#define SYMBOL_H

#define MAX_ID_LEN 256
#define TABLE_SIZE 100
#define MAX_SCOPE 100

/* Symbol Table Entry */
typedef struct Symbol {
    char name[MAX_ID_LEN];
    char type[50];
    int scope;
    int isArray;
    int arraySize;
    struct Symbol* next;
} Symbol;

/* Three Address Code Entry */
typedef struct TAC {
    char op[20];
    char arg1[256];
    char arg2[256];
    char result[256];
    struct TAC* next;
} TAC;

/* Globals */
extern Symbol* symbolTable[TABLE_SIZE];
extern int currentScope;
extern int tempVarCount;
extern int labelCount;

/* Symbol operations */
void insertSymbol(char* name, char* type, int scope, int isArray, int arraySize);
Symbol* lookupSymbol(char* name);
void pushScope(void);
void popScope(void);
int symbolExists(char* name);
void printSymbolTable(void);

/* TAC operations */
void emitTAC(const char* op, const char* arg1, const char* arg2, const char* result);
void printTAC(void);
char* newTemp(void);
char* newLabel(void);
void freeTAC(void);

/* Label Stack (For if/while nesting) */
void pushLabels(char* l1, char* l2);
void popLabels(void);
char* getLabel1(void);
char* getLabel2(void);

#endif