/* write.c */
/* Write a pair of bytes to the output file */
#include "LZ.h"
void write(int s, int r, FILE *f)
{
    unsigned int e;  /* r and s together in 2 bytes */
    if(s>1) {  /* write data to output file  */
        e = ((s-1)<<12)|r;  /* combine r and s-1 into two-bytes   */
        putc(e>>8, f);    /* write those two bytes and c,       */
        putc(e&0xff, f);  /* with the one with s-1 in it first. */
    }
    else {
        putc(0, f);    /* if match zero or 1 byte, write a zero */
        putc(b[0], f); /* & one byte of data.                   */
        s = 1;
    }
}
