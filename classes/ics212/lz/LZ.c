/* LZ.c */
/*********************************************************/
/*                                                       */
/*               Ziv-Lempel Data Compression             */
/*                                                       */
/*        There are many variations of this compression  */
/*   method. This is one simple one. This program        */
/*   remembers W previous bytes and looks for a copy of  */
/*   the next few bytes coming in in the previous data.  */
/*   If it finds it, then it records the length and the  */
/*   location, and this requires fewer bits than the     */
/*   original data. If the character is not found, then  */
/*   one byte is sent, with a length of zero indicated.  */
/*        In the program, the array a stores input bytes.*/
/*   The data already processed are in a[0] to a[W-1],   */
/*   and the data about to be processed are in a[W] to   */
/*   a[W+U-1], which is the same as b[0] to b[U-1]. Thus */
/*   the bytes in b[0], b[1], . . . are compared with    */
/*   previous bytes to search for a match. Note that the */
/*   matching part of the previous bytes can overlap the */
/*   the bytes being processed.                          */
/*                                                       */
/*********************************************************/
#include "LZ.h"
int a[W+U], *b;
void main(int argc, char *argv[])
{
    int i,  /* for loops                                */
        k,  /* # of bytes matched, while searching      */
        r,  /* position where longest match is found    */
        s,  /* number of bytes in longest match         */
        t,  /* number of unprocessed bytes in b[]       */
        b2,b3; /* number of pairs with s=1 and s>1 resp.*/
    int c;  /* input character                          */
    long length, filelen;/* output & input file lengths */
    FILE *ifp, *ofp; /* input and output file pointers  */
    if(argc!=3) {
        printf("Input and output file names expected.\n");
        exit(0);
    }
    ifp = fopen(argv[1],"rb");  /* input file  */
    if(ifp==NULL) {
        printf("Input file (%s) not found.\n",argv[1]);
        exit(0);
    }
    ofp = fopen(argv[2],"wb");  /* output file */
    if(ofp==NULL) {
        printf("Output file (%s) couldn't be opened.\n");
        exit(0);
    }
    b2 = b3 = 0;
    length = filelen = 0;
    for(i = 0; i<W; i++) a[i] = ' ';  /* initialize to blank spaces */
    b = a+W; /* b points to unprocessed data buffer of U bytes      */
    t = 0;   
    for(;;) {
        while(t<U && (c = getc(ifp))!=EOF) {
            b[t++] = c;
            filelen++;
        }
        if(t==0) break; /* no more data to process  */
        r = 0;
        s = 1;
        for(i = 0; i<W; i++) { /* search for pattern at b[0] in a[k] */
            for(k = 0; k<t && a[k+i]==b[k]; k++);
            if(k>s) { s = k;  r = i; } /* save longest match found   */
        }
        if(PRINT) { /* only for debugging or understanding program   */
            for(i = W-32; i<W+U; i++) {
                if((i%8)==0) printf("  ");
                printf("%c",pr(a[i]));
            }
            if(s>1) printf("  %2d %03x %d\n", s, r, t);
            else    printf("  %2d--%c  %d\n", s, pr(b[0]), t);
        }
        write(s, r, ofp); /* write two bytes to output file */
        if(s>1) b3++;
        else b2++;
        length += 2;
        t -= s;
        for(i = 0; i<W+U-s; i++) a[i] = a[i+s];/* shift left s places.*/
    }
    
    printf("Before %ld bytes--after 2*(%d+%d) = %d bytes\n",
        filelen, b2, b3, length);
    fclose(ifp);
    fclose(ofp);
    return;
}
/* only for appearance of debug printing */
char pr(int i) 
{ 
    if(i==CR || i==LF) return '@';
    else if(i==EOF) return '$';
    else return i;
}
