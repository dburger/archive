#include <stdio.h>

#define IN 1
#define OUT 0

main() {

    int c, state;

    state = OUT;

    while ((c=getchar())!=EOF) {
        if (state==IN) {
    	    if (c==' ' || c=='\n' || c=='\t') {
                printf("\n");
                state = OUT;
	    } else
                putchar(c);
        } else {
	    if (c!=' ' || c!='\n' || c!='\t') {
                state = IN;
                putchar(c);
            }
	}
    }
}
