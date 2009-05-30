%{
#include <stdio.h>
%}
%%

.  ECHO;
\n ECHO;
%%

int yywrap(void) {
    return 1;
}


