%{
#include "y.tab.h"
#define YYSTYPE int
YYSTYPE yylval;
%}

%%

[0-9]+     {
               yylval = atoi(yytext);
               return INTEGER;
           }

[-+*\n]     return *yytext;

[ \t]      ;

.          yyerror("invalid character");

%%

int yywrap(void) {
    return 1;
}


