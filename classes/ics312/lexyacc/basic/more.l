%{
#include <stdio.h>
%}
DIGIT [0-9]
INTEGER {DIGIT}+
OPERATOR [-+*/%^]
FIXEDPOINT {INTEGER}"."{INTEGER}
CHARACTER [a-zA-Z_]
VARIABLE {CHARACTER}({CHARACTER}|{DIGIT})*
LPAREN [(]
RPAREN [)]
%%

{INTEGER}        {
                     printf("INTEGER is \"%s\"\n",yytext);
                 }

{OPERATOR}       {
                     printf("OPERATOR is \"%s\"\n",yytext);
                 }

{FIXEDPOINT}     {
                     printf("FIXEDPOINT is \"%s\"\n",yytext);
                 }

{VARIABLE}       {
                     printf("VARIABLE is \"%s\"\n",yytext);
                 }

{LPAREN}         {
                     printf("LPAREN is \"%s\"\n",yytext);
                 }

{RPAREN}         {
                     printf("RPAREN is \"%s\"\n",yytext);
                 }

[ \t\n]          ;

.                ;

%%

int yywrap(void) {
    return 1;
}
















