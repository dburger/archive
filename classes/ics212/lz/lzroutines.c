#include <stdio.h>

#define U 4096
#define W 16

void lzdecompress(char *src, char *dest) {

    /* index for loops */
    int i;

    /* for reading characters from the compressed file */
    int c, d;

    /* for the size of the block to copy */
    int s;

    /* for the address of the block to copy */
    int r;

    /* FILE pointers to the compressed and uncompressed files */
    FILE *cf, *uf;

    /* the array for the uncompressed block plus the working buffer */
    int a[U+W];

    /* the pointer to the working buffer area */
    int *b;

    cf = fopen(src,"rb");
    if (cf==NULL) {
        printf("Unable to open compressed file %s.",src);
        exit(0);
    }

    uf = fopen(dest,"wb");
    if (uf==NULL) {
        printf("Unable to create uncompressed file %s.",dest);
        exit(0);
    }

    /* b points to the working area */
    b = a + U;

    /* set the uncompressed area to blanks */
    for (i=0;i<U;i++)
        a[i] = ' ';

    while ((c=getc(cf))!=EOF) {
        d = getc(cf);
        if (c==0) {
            s = 1;
            *b = d;
        } else {
	  /* length of repeated block is calculated as value of
               of four high bits of low byte of c + 1 */
            s = (c >> 4) + 1;
            r = ((c & 0x0F) << 8) | d;
            /* copy the repeating block to b */
            for (i=0;i<s;i++)
                *(b+i) = a[r+i];
        }
        /* write the s bits at b to the uncompressed file */
        for (i=0;i<s;i++)
            putc(*(b+i),uf);
        /* shift everything over in the array by the size of
           the repeating block */
        for (i=0;i<U;i++)
            a[i] = a[i+s];
    }

    fclose(cf);
    fclose(uf);

}

















