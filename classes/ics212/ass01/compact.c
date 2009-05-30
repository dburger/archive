#include <stdio.h>

#define IN 0
#define OUT 1

main() {

    int c,state;

    state = OUT;

    while ((c=getchar())!=EOF) {
        if (c==' ') {
	    if (state==IN) {
	        /* already printed the space*/
            } else {
                putchar(c);
                state = IN;
            }
        } else {
            state = OUT;
            putchar(c);
        }
    }

}
