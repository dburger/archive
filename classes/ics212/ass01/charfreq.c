#include <stdio.h>

main() {

    int c, i;
    int freqtable[256];
    for (i=0;i<256;i++)
        freqtable[i]=0;

    while ((c=getchar())!=EOF) {
        freqtable[c]++;
    }

    for (i=0;i<256;i++) {
        if (freqtable[i]!=0)
            printf("%3d has frequency %d.\n",i,freqtable[i]);
    }
}
