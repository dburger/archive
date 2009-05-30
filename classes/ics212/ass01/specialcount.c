#include <stdio.h>

main() {

    int c,count;

    while ((c=getchar())!=EOF) {
        if (c==' ' || c=='\t' || c=='\n')
            count++;
    }

    printf("Special count:  %d\n",count);

}
