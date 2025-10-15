%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Global variables/functions (minimal) */
void print_token(const char* token, const char* type) {
    printf("<%s, %s, %s>\n", token, type, yytext);
}
%}

/* Definitions Section */
YEAR     [0-9][0-9]
D8_STUD  [1-2]      /* Student D8: 1 (Dependent) or 2 (Self) */
D8_EMP   [0-9]      /* Employee D8: 0 (Self), 1-9 (Dependent) */
DIGIT    [0-9]

%%
/* Rules Section - Organized by D1 value and D4-D7 range */

/* ---------------------------------------------------------------------- */
/* D1 = 1 (Regular Student)                                               */
/* D8 must be [1-2]                                                       */
/* ---------------------------------------------------------------------- */

/* Ph.D. Students: D4-D7 = 0000-1999 (0[0-9]{3} | 1[0-9]{3}) */
[1]{YEAR}(0{3}{DIGIT}|0{2}{DIGIT}{2}|0{1}{DIGIT}{3}|1{DIGIT}{3}){D8_STUD} {
    print_token("PHD.STUDENT", "Regular Student", yytext);
}

/* Master Students: D4-D7 = 2000-2999 (2[0-9]{3}) */
[1]{YEAR}2{DIGIT}{3}{D8_STUD} {
    print_token("MASTER.STUDENT", "Regular Student", yytext);
}

/* UG Students: D4-D7 = 4000-9999 ([4-9]{DIGIT}{3}) */
[1]{YEAR}[4-9]{DIGIT}{3}{D8_STUD} {
    print_token("UG.STUDENT", "Regular Student", yytext);
}


/* ---------------------------------------------------------------------- */
/* D1 = 2 (Visiting Student) - Same serial logic as D1=1                  */
/* D8 must be [1-2]                                                       */
/* ---------------------------------------------------------------------- */

/* Ph.D. Students (Visiting): D4-D7 = 0000-1999 */
[2]{YEAR}(0{3}{DIGIT}|0{2}{DIGIT}{2}|0{1}{DIGIT}{3}|1{DIGIT}{3}){D8_STUD} {
    print_token("PHD.STUDENT", "Visiting Student", yytext);
}

/* Master Students (Visiting): D4-D7 = 2000-2999 */
[2]{YEAR}2{DIGIT}{3}{D8_STUD} {
    print_token("MASTER.STUDENT", "Visiting Student", yytext);
}

/* UG Students (Visiting): D4-D7 = 4000-9999 */
[2]{YEAR}[4-9]{DIGIT}{3}{D8_STUD} {
    print_token("UG.STUDENT", "Visiting Student", yytext);
}

/* ---------------------------------------------------------------------- */
/* D1 = 3 (Regular Employee) and D1 = 4 (Contract Employee)               */
/* D8 must be [0-9]                                                       */
/* ---------------------------------------------------------------------- */

/* Regular Employee - Self (D8=0) */
[3]{YEAR}{DIGIT}{4}0 {
    print_token("EMPL.REG", "Regular Employee - Self", yytext);
}

/* Regular Employee - Dependent (D8=1-9) */
[3]{YEAR}{DIGIT}{4}[1-9] {
    print_token("EMPL.REG_DEP", "Dependent of Regular Employee", yytext);
}

/* Contract Employee - Self (D8=0) */
[4]{YEAR}{DIGIT}{4}0 {
    print_token("EMPL.CON", "Contract Employee - Self", yytext);
}

/* Contract Employee - Dependent (D8=1-9) */
[4]{YEAR}{DIGIT}{4}[1-9] {
    print_token("EMPL.CON_DEP", "Dependent of Contract Employee", yytext);
}

/* ---------------------------------------------------------------------- */
/* D1 = 5-9 (Other Categories)                                            */
/* D8 must be [0-9]                                                       */
/* ---------------------------------------------------------------------- */

/* Other categories (D1=5-9) */
[5-9]{YEAR}{DIGIT}{4}{D8_EMP} {
    print_token("OTHER", "Other Category Type", yytext);
}

/* ---------------------------------------------------------------------- */
/* INVALID Cases (Highest priority as specific invalid rules)             */
/* ---------------------------------------------------------------------- */

/* Invalid D1=0 (D1 is 0) */
0{DIGIT}{7} {
    print_token("INVALID", "Invalid Type of Card Holder (D1=0)", yytext);
}

/* Invalid D8 for Student (D1=1 or 2, D8 is 0 or 3-9) */
[1-2]{YEAR}{DIGIT}{4}[03-9] {
    print_token("INVALID", "Invalid D8 value for Student", yytext);
}

/* Invalid Serial Number Range for Students (D1=1 or 2, D4-D7 = 3000-3999) */
[1-2]{YEAR}3{DIGIT}{3}{D8_STUD} {
    print_token("INVALID", "Invalid Serial Number Range for Student (3xxx)", yytext);
}

/* Invalid Length or Invalid Characters */

/* Catches any non-digit character */
[^0-9\n]+ {
    print_token("INVALID", "Invalid characters", yytext);
}

/* Catches incorrect length ID (less than or more than 8 digits) */
{DIGIT}{1,7} | {DIGIT}{9,} {
    print_token("INVALID", "Incorrect Length", yytext);
}

/* Catch and ignore whitespace and newline outside of an 8-digit block */
[ \t\r]+  { /* Ignore whitespace */ }
\n        { /* Ignore newline */ }

/* Catch any remaining single character that wasn't matched above */
.         {
    print_token("INVALID", "Invalid characters", yytext);
}

%%

/* User Code Section */
int main() {
    printf("Enter 8-digit IT Bhilai ID Cards:\n");
    yylex();
    return 0;
}

/* Required by Lex/Flex. */
int yywrap() {
    return 1;
}