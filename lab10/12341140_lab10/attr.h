// attr.h
#ifndef ATTR_H
#define ATTR_H

typedef struct List {
    int index;
    struct List *next;
} List;

typedef struct {
    char *place;
    List *truelist;
    List *falselist;
    List *nextlist;
    int instr;
} Attr;

#endif
