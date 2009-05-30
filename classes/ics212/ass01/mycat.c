#include <stdio.h>

main() {

    int charCount;
    charCount = 0;
    while(getchar()!=EOF)
        charCount++;

    printf("Total character count:  %d\n", charCount);

}
