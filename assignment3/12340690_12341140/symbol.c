/* symbol.c - COMPLETE VERSION */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "symbol.h"

Symbol* symbolTable[TABLE_SIZE] = {0};
int currentScope = 0;
int tempVarCount = 0;
int labelCount = 0;

TAC* tacHead = NULL;
TAC* tacTail = NULL;

/* --- Label Stack Implementation --- */
#define MAX_LABELS 100
struct {
    char l1[50];
    char l2[50];
} labelStack[MAX_LABELS];
int labelTop = -1;

void pushLabels(char* l1, char* l2) {
    if (labelTop < MAX_LABELS - 1) {
        labelTop++;
        strncpy(labelStack[labelTop].l1, l1, 49);
        strncpy(labelStack[labelTop].l2, l2, 49);
    }
}

void popLabels(void) {
    if (labelTop >= 0) labelTop--;
}

char* getLabel1(void) {
    return (labelTop >= 0) ? labelStack[labelTop].l1 : "";
}

char* getLabel2(void) {
    return (labelTop >= 0) ? labelStack[labelTop].l2 : "";
}

/* --- Symbol Table Logic --- */
unsigned int hash(char *str) {
    unsigned int h = 0;
    while (*str) {
        h = (h << 5) + h + (unsigned char)*str;
        str++;
    }
    return h % TABLE_SIZE;
}

int symbolExists(char* name) {
    unsigned int idx = hash(name);
    Symbol* sym = symbolTable[idx];
    while (sym != NULL) {
        if (strcmp(sym->name, name) == 0) return 1;
        sym = sym->next;
    }
    return 0;
}

int isTemporary(char* name) {
    // t0, t1... or 0, 1, 5 (constants)
    return ((name[0] == 't' && isdigit(name[1])) || isdigit(name[0]));
}

void insertSymbol(char* name, char* type, int scope, int isArray, int arraySize) {
    // Simple duplicate check
    if (symbolExists(name)) {
        Symbol* check = lookupSymbol(name);
        if(check && check->scope == scope) {
            // In a real compiler, we'd print error here. 
            // For this assignment, we prevent crashing.
            return; 
        }
    }
    
    unsigned int idx = hash(name);
    Symbol* sym = (Symbol*)malloc(sizeof(Symbol));
    strncpy(sym->name, name, MAX_ID_LEN - 1);
    sym->name[MAX_ID_LEN - 1] = '\0';
    strncpy(sym->type, type, 49);
    sym->scope = scope;
    sym->isArray = isArray;
    sym->arraySize = arraySize;
    sym->next = symbolTable[idx];
    symbolTable[idx] = sym;
}

Symbol* lookupSymbol(char* name) {
    if (isTemporary(name)) return (Symbol*)1; 
    
    unsigned int idx = hash(name);
    Symbol* sym = symbolTable[idx];
    while (sym != NULL) {
        if (strcmp(sym->name, name) == 0) return sym;
        sym = sym->next;
    }
    return NULL;
}

void pushScope(void) {
    currentScope++;
    if (currentScope >= MAX_SCOPE) currentScope = MAX_SCOPE - 1;
}

void popScope(void) {
    if (currentScope > 0) currentScope--;
}

void printSymbolTable(void) {
    printf("\n========== SYMBOL TABLE ==========\n");
    printf("%-20s %-10s %-10s %-10s %-10s\n", "Name", "Type", "Scope", "IsArray", "ArraySize");
    printf("----------------------------------------------------------\n");
    for (int i = 0; i < TABLE_SIZE; i++) {
        Symbol* sym = symbolTable[i];
        while (sym != NULL) {
            printf("%-20s %-10s %-10d %-10s %-10d\n", 
                   sym->name, sym->type, sym->scope,
                   sym->isArray ? "Yes" : "No", sym->arraySize);
            sym = sym->next;
        }
    }
    printf("==================================\n\n");
}

/* --- TAC Logic --- */
void emitTAC(const char* op, const char* arg1, const char* arg2, const char* result) {
    TAC* newTac = (TAC*)malloc(sizeof(TAC));
    strncpy(newTac->op, op, 19);
    strncpy(newTac->arg1, arg1 ? arg1 : "", 255);
    strncpy(newTac->arg2, arg2 ? arg2 : "", 255);
    strncpy(newTac->result, result ? result : "", 255);
    newTac->next = NULL;
    
    if (tacHead == NULL) tacHead = newTac;
    else tacTail->next = newTac;
    tacTail = newTac;
}

char* newTemp(void) {
    char buffer[256];
    snprintf(buffer, 256, "t%d", tempVarCount++);
    return strdup(buffer);
}

char* newLabel(void) {
    char buffer[256];
    snprintf(buffer, 256, "L%d", labelCount++);
    return strdup(buffer);
}

void printTAC(void) {
    printf("\n========== THREE-ADDRESS CODE ==========\n");
    TAC* tac = tacHead;
    int count = 1;
    while (tac != NULL) {
        printf("%3d: ", count++);
        
        if (strcmp(tac->op, "=") == 0) {
            printf("%s = %s\n", tac->result, tac->arg1);
        }
        else if (strcmp(tac->op, "[]=") == 0) {
            printf("%s[%s] = %s\n", tac->arg1, tac->arg2, tac->result);
        }
        else if (strcmp(tac->op, "=[]") == 0) {
            printf("%s = %s[%s]\n", tac->result, tac->arg1, tac->arg2);
        }
        else if (strcmp(tac->op, "label") == 0) {
            printf("%s:\n", tac->arg1);
        }
        else if (strcmp(tac->op, "goto") == 0) {
            printf("goto %s\n", tac->arg1);
        }
        else if (strcmp(tac->op, "if_false") == 0) {
            printf("if_false %s goto %s\n", tac->arg1, tac->arg2);
        }
        else if (strcmp(tac->op, "call") == 0) {
            printf("%s = call %s\n", tac->result, tac->arg1);
        }
        else if (strcmp(tac->op, "return") == 0) {
            if (strlen(tac->arg1) > 0)
                printf("return %s\n", tac->arg1);
            else
                printf("return\n");
        }
        else if (strcmp(tac->op, "break") == 0) {
            printf("break\n");
        }
        else if (strcmp(tac->op, "!") == 0) {
            printf("%s = ! %s\n", tac->result, tac->arg1);
        }
        else if (strcmp(tac->op, "&&") == 0) {
            printf("%s = %s && %s\n", tac->result, tac->arg1, tac->arg2);
        }
        else if (strcmp(tac->op, "||") == 0) {
            printf("%s = %s || %s\n", tac->result, tac->arg1, tac->arg2);
        }
        else if (strcmp(tac->op, "==") == 0) {
            printf("%s = %s == %s\n", tac->result, tac->arg1, tac->arg2);
        }
        else if (strcmp(tac->op, "!=") == 0) {
            printf("%s = %s != %s\n", tac->result, tac->arg1, tac->arg2);
        }
        else if (strcmp(tac->op, "<=") == 0) {
            printf("%s = %s <= %s\n", tac->result, tac->arg1, tac->arg2);
        }
        else if (strcmp(tac->op, ">=") == 0) {
            printf("%s = %s >= %s\n", tac->result, tac->arg1, tac->arg2);
        }
        else {
            // General binary ops: result = arg1 op arg2
            printf("%s = %s %s %s\n", tac->result, tac->arg1, tac->op, tac->arg2);
        }
        
        tac = tac->next;
    }
    printf("==========================================\n\n");
}

void freeTAC(void) {
    TAC* tac = tacHead;
    while (tac != NULL) {
        TAC* temp = tac;
        tac = tac->next;
        free(temp);
    }
    tacHead = NULL;
    tacTail = NULL;
}