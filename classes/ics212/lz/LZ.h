/* LZ.h */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define  W  4096
#define  U  16
#define  CR  13
#define  LF  10
/*If PRINT is true, then intermediate results are printed*/
#define  PRINT  1
char pr(int);
void write(int r, int s, FILE *f);
extern int a[W+U], *b;
