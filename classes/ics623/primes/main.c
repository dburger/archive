/*=============================================================================
Assignment: long arithmetic
Author:     David J. Burger
Language:   ANSI C running on UHUNIX2 (Solaris)
Compile:    by running "make" with included makefile

Class:      ICS 623
Instructor: Dr. Peterson
Due Date:   11/05/01
===============================================================================
File:         main.c

Description:  this program demonstrates various long arithmetic functions
              performing the computations described in the assignment notes
=============================================================================*/
#include <stdio.h>

#include "long.h"
#include "primetest.h"

/*=============================================================================
Function fprintUL

Purpose:  prints the hex value of an array of size unsigned longs
          
Parameters:
          *p - array containing the unsigned longs
          size - number of unsigned longs to print from the array
          
Returns:  nothing, outputs hex values of the unsigned longs on the screen
=============================================================================*/
void fprintUL(FILE *fp, UL *p, int size) {
    int i;
    for (i=0;i<size;i++) {
        fprintf(fp,"%08x",p[i]);
        if (i!=0 && (i+1)%8==0)
            fprintf(fp,"\n");
        else
            fprintf(fp," ");
    }
    fprintf(fp,"\n");
}

/*=============================================================================
Function copyUL

Purpose:  copies size unsigned long values from a to b
          
Parameters:
          *a - array containing unsigned longs to copy
          *b - array to copy to
          size - number of unsigned longs to copy from a to b
          
Returns:  nothing, size values are copied from a to b
=============================================================================*/
void copyUL(UL *a, UL *b, int size) {
  while (--size>=0) b[size] = a[size];
}

/*=============================================================================
Function irandom

Purpose:  used to randomize through the 32 bits of an unsigned long
          
Parameters:  none
          
Returns:  returns a randomized unsigned long
=============================================================================*/
#define A 16807
#define M -1
#define Q 127773
#define R 2836
long seed;
UL irandom(void) {
  UL lo, hi;
  hi = R*(seed/Q);
  lo = A*(seed%Q);
  if (lo>hi)
    seed = lo-hi;
  else
    seed = (M-hi) + lo;
  return(seed);
}

/*=============================================================================
Function main

Purpose:  main entry point to program.  Demonstrates various long arithmetic
          operations as described in the assignment notes.
          
Parameters:
          argc - number of command line parameters passed to program
          *argv[] - array of pointers to command line strings
          
Returns:  nothing, arithmetic operations on long numbers are performed
=============================================================================*/
int main(int argc, char *argv[]) {
  
  int attempts,firstlevel,secondlevel; /* used as counters */

  int i; /* used in loops */

  UL q[32], s[32], p[32], two[32]; /* used to hold the numbers */

  FILE *fp; /* this is the file we write the second level primes to */

  attempts = firstlevel = secondlevel = 0;

  /* randomize our starting point */
  seed = 0x479320ea;
  for (i=0;i<32;i++) {
    q[i] = irandom();
  }

  q[32]|=1; /* make sure first bit is a one */
  q[0]&=0x0fffffff; /* clear top four bits */
  q[0]|=0x10000000; /* make 1021 bit 1 */

  /* make a 2 for incrementing to the net odd */
  zeroUL(two,32);
  two[31] = 2;

  while(1) {
    /* make s = 2q + 1 */
    copyUL(q,s,32);
    shl(s,shl(s+16,1));
    attempts++;
    if (lehman_prime(s,q)) {
      firstlevel++;
      /* make p = 2s + 1 */
      copyUL(s,p,32);
      shl(p,shl(p+16,1));
      if (lehman_prime(p,s)) {
        secondlevel++;
        if (argc>1)
          if ((fp=fopen(argv[1],"a"))!=NULL) {
            fprintUL(fp,p,32);
            fclose(fp);
          }
      }
    }
    /* add two to get to the next prime */
    add(q,two,add(q+16,two+16,0));
    printf("attempts: %d  first level: %d  second level: %d\n",attempts,firstlevel,secondlevel);
  }

}
