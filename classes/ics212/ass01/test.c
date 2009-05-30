#include <stdio.h>

main() {

    int c;
    while ((c=getchar())!=EOF) {

        if (c>='a' && c<='z')
            c='A'+c-'a';
        else if (c>='A' && c<='Z')
            c='a'+c-'A';

        putchar(c);

    }
    
}
