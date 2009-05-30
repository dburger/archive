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

/*=============================================================================
Function printUL

Purpose:  prints the hex value of an array of size unsigned longs
          
Parameters:
          *p - array containing the unsigned longs
          size - number of unsigned longs to print from the array
          
Returns:  nothing, outputs hex values of the unsigned longs on the screen
=============================================================================*/
void printUL(UL *p, int size) {
    int i;
    for (i=0;i<size;i++) {
        printf("%08x",p[i]);
        if (i!=0 && (i+1)%8==0)
            printf("\n");
        else
            printf(" ");
    }
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
Function main

Purpose:  main entry point to program.  Demonstrates various long arithmetic
          operations as described in the assignment notes.
          
Parameters:
          argc - number of command line parameters passed to program
          *argv[] - array of pointers to command line strings
          
Returns:  nothing, arithmetic operations on long numbers are performed
=============================================================================*/
int main(int argc, char *argv[]) {
  
  int i,j; /* used as counters */

  UL P[] = { 0x79bb6329, 0x178e36f8, 0xad8199a4, 0xc396028d, 
             0xffdbfc5d, 0xc6ca1f85, 0x511b0c61, 0x02b750d0, 
             0x6ad206b9, 0x901d2a81, 0x64e7576c, 0x36660938, 
             0x59fe0e70, 0x03ef65b5, 0xda9f1c1c, 0xffa5bf00, 
             0xb63f7338, 0x1a2605b1, 0x8c2de924, 0xede9bbe1, 
             0xc27a570d, 0xc449b2cd, 0xa8e6bc21, 0x781112c0, 
             0x80e9d6bc, 0x6f88d739, 0xf2f7dfd4, 0xb2c24f99, 
             0x5d6d4ca1, 0xdc497fe8, 0x8a2e2814, 0x6b73f64f };


  UL m[32], t[32], result[32], power[32], m20[32], m25[32], m45[32];
  
  printf("powers using multiplication:\n");
  zeroUL(m,32);
  m[31] = 0x08d2d931;
  zeroUL(result,32);
  result[31] = 1;
  for (i=1;i<50;i++) {
    printf("m^%d==\n",i);
    mmult(result,m,result,P);
    printUL(result,32);
    if (i==20) copyUL(result,m20,32);
    if (i==25) copyUL(result,m25,32);
    if (i==45) copyUL(result,m45,32);
  }

  printf("m^20 * m^25==");
  mmult(m20,m25,result,P);
  if (mcmp(result,m45)==0) printf("m^45\n");
  printUL(result,32);

  printf("m^25 * m^20==");
  mmult(m25,m20,result,P);
  if (mcmp(result,m45)==0) printf("m^45\n");
  printUL(result,32);

  zeroUL(t,32);
  zeroUL(m,32);
  m[31] = 0x08d2d931;  
  printf("powers using exponentiation:\n");
  for (i=0;i<50;i++) {
    printf("m^%d==\n",i);
    mexp(m,t,result,P);
    printUL(result,32);
    t[31]++;
  }

  zeroUL(t,32);
  t[31] = 1;
  copyUL(P,power,32);
  msub(power,t,P);
  printf("(m^45)^P-1==");
  mexp(m45,power,result,P);
  if (mcmp(t,result)==0) printf("1\n");
  printUL(result,32);

  msub(power,t,P);
  printf("(m^20)^P-2 * m^20==");
  mexp(m20,power,result,P);
  mmult(m20,result,result,P);
  if (mcmp(result,t)==0) printf("1\n");
  printUL(result,32);
 

}
