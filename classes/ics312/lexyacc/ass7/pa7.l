/*
4/29/01
Lexer for recognizing tokens
of arithmetic expressions by
David J. Burger for
ICS 312 under the guidance of
Dr. Sughihara
*/
%{
#include "y.tab.h"
#include <stdio.h>
extern int yylval;
%}
NONZERODIGIT [1-9]
DIGIT [0-9] 
INTEGER {DIGIT}|{NONZERODIGIT}{DIGIT}*
FIXEDPOINT {INTEGER}*"."{DIGIT}+
VARIABLE {CHARACTER}({CHARACTER}|{DIGIT})*
CHARACTER [a-zA-Z_]
OPERATOR [\-\+\*\/()%]
%%

{FIXEDPOINT}     {
                     yylval = strdupx(yytext);
                     return CONSTANT;
                 }


{INTEGER}        {
                     yylval = strdupx(yytext);
                     return CONSTANT;
                 }

{OPERATOR}|"\n"    {
                     return *yytext;
                 }

{VARIABLE}       {
                     yylval = (int)yytext;
                     return VARIABLE;
                 }

[ \t]            ;

.                ;

%%

int yywrap(void) {
    return 1;
}
