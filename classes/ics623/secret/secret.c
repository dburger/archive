/*=============================================================================
Assignment: secret sharing
Author:     David J. Burger
Language:   ANSI C running on UHUNIX2 (Solaris)
Compile:    by running "make" with included makefile

Class:      ICS 623
Instructor: Dr. Peterson
Due Date:   12/07/01
===============================================================================
File:         secret.c

Description:  this program demonstrates the concept of secret sharing in which
              the m equations, m unknowns principal is used to provide secrecy
=============================================================================*/

#include <stdio.h>

#include "secret.h"

#define NUM 8

/*=============================================================================
Function printUL

Purpose:  prints the hex value of an array of size unsigned longs
          
Parameters:
          *p - array containing the unsigned longs
          size - number of unsigned longs to print from the array
          
Returns:  nothing, outputs hex values of the unsigned longs on the screen
=============================================================================*/
void printUL(ul *p, int size) {
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
Function fprintASCII

Purpose:  prints the char value of the bytes in an array of size unsigned
          longs
          
Parameters:
          *p - array containing the unsigned longs
          size - number of unsigned longs to print from the array
          
Returns:  nothing, outputs char values of the bytes in the unsigned longs
=============================================================================*/
void printASCII(ul *p, int size) {
  unsigned char text[4];
  int i,j;
  for (i=0;i<size;i++) {
    memcpy(text,&p[i],4);
    for (j=3;j>=0;j--) {
      printf("%c",text[j]);
    }
    if ((i+1)%4==0) printf("\n");
  }
  printf("\n");
}

/*=============================================================================
Function main

Purpose:  main entry point of program.  Computes the secret using the supplied
          points
          
Parameters:
          standard c command line arguments not used
                    
Returns:  nothing, prints out hex and ascii value of the secret
=============================================================================*/
int main(int argc, char *argv[]) {
  ul mod[8]; /* to hold the modulus */

  ul X1[8]; /* everyone's points */
  ul X2[8];
  ul X3[8];
  ul X4[8];

  ul Y1[8]; /* the y values produces by the x's */
  ul Y2[8];
  ul Y3[8];
  ul Y4[8];

  ul term1[8]; /* terms of the calculation */
  ul term2[8];
  ul term3[8];
  ul term4[8];

  ul one[8]; /* used as exponents in the calculation */
  ul two[8];
  ul three[8];

  ul num[8]; /* temporary numerator */
  ul den[8]; /* temporary denominator */
  ul temp1[8]; /* temps */
  ul temp2[8];
  ul temp3[8];

  ul exp[8]; /* exponent for finding inverse */

  ul result[8]; /* used for holding the .... result! */


  /* set up 2^255-2 */
  exp[0] = 0x7FFFFFFF;
  exp[1] = 0xFFFFFFFF;
  exp[2] = 0xFFFFFFFF;
  exp[3] = 0xFFFFFFFF;
  exp[4] = 0xFFFFFFFF;
  exp[5] = 0xFFFFFFFF;
  exp[6] = 0xFFFFFFFF;
  exp[7] = 0xFFFFFFFE;

  /* set up our modulus */
  zeroUL(mod,8);
  mod[0] = 0x80000000;
  mod[5] = 0x00040000;
  mod[7] = 0x00000001;

  /* set up one two three */
  zeroUL(one,8);
  zeroUL(two,8);
  zeroUL(three,8);
  one[7] = 1;
  two[7] = 2;
  three[7] = 3;

  /* My point */
  zeroUL(X1,8);
  X1[7] = 2;
  Y1[0] = 0x5dd293ac;
  Y1[1] = 0xc5fba8be; 
  Y1[2] = 0x12d5edcd;
  Y1[3] = 0xdccd50b5;
  Y1[4] = 0x2becf3f2;
  Y1[5] = 0x59ec0d4e;
  Y1[6] = 0x2cb949ee;
  Y1[7] = 0x3c34f626;

  /* Lisa Van Keulen's point */
  zeroUL(X2,8);
  X2[7] = 1;
  Y2[0] = 0x2e709eba;
  Y2[1] = 0xa75f2c77; 
  Y2[2] = 0xcfc99788;
  Y2[3] = 0xa83214e2;
  Y2[4] = 0xf925828a;
  Y2[5] = 0xa059397d;
  Y2[6] = 0xdede97cf;
  Y2[7] = 0xc0461ae5;

  /* Rui's point */
  zeroUL(X3,8);
  X3[7] = 4;
  Y3[0] = 0x7cef973a;
  Y3[1] = 0x619e0b5d; 
  Y3[2] = 0x56c37fae;
  Y3[3] = 0x6777b5f6;
  Y3[4] = 0x327af70e;
  Y3[5] = 0x8870a071;
  Y3[6] = 0xaf7790e2;
  Y3[7] = 0xc2e19697;

  /* Jian's point */
  zeroUL(X4,8);
  X4[7] = 7;
  Y4[0] = 0x17a67bdd;
  Y4[1] = 0x4538792b; 
  Y4[2] = 0xb5bf7055;
  Y4[3] = 0xa5733c95;
  Y4[4] = 0x60ab006e;
  Y4[5] = 0x00a4abee;
  Y4[6] = 0xe443adc1;
  Y4[7] = 0xc8bcafea;

  /* recover term 1*/
  multgfx(Y1,X2,mod,temp1,8);
  multgfx(temp1,X3,mod,temp1,8);
  multgfx(temp1,X4,mod,num,8); /* first numerator */

  addgfx(X1,X2,temp1,8);
  addgfx(X1,X3,temp2,8);
  addgfx(X1,X4,temp3,8);
  multgfx(temp1,temp2,mod,den,8);
  multgfx(den,temp3,mod,den,8);
  expgfx(den,exp,mod,den,8); /* change to inverse */

  multgfx(num,den,mod,term1,8);

  /* recover term 2*/
  multgfx(Y2,X1,mod,temp1,8);
  multgfx(temp1,X3,mod,temp1,8);
  multgfx(temp1,X4,mod,num,8); /* first numerator */

  addgfx(X2,X1,temp1,8);
  addgfx(X2,X3,temp2,8);
  addgfx(X2,X4,temp3,8);
  multgfx(temp1,temp2,mod,den,8);
  multgfx(den,temp3,mod,den,8);
  expgfx(den,exp,mod,den,8); /* change to inverse */

  multgfx(num,den,mod,term2,8);

  /* recover term 3 */
  multgfx(Y3,X1,mod,temp1,8);
  multgfx(temp1,X2,mod,temp1,8);
  multgfx(temp1,X4,mod,num,8); /* first numerator */

  addgfx(X3,X1,temp1,8);
  addgfx(X3,X2,temp2,8);
  addgfx(X3,X4,temp3,8);
  multgfx(temp1,temp2,mod,den,8);
  multgfx(den,temp3,mod,den,8);
  expgfx(den,exp,mod,den,8); /* change to inverse */

  multgfx(num,den,mod,term3,8);

  /* recover term 4*/
  multgfx(Y4,X1,mod,temp1,8);
  multgfx(temp1,X2,mod,temp1,8);
  multgfx(temp1,X3,mod,num,8); /* first numerator */

  addgfx(X4,X1,temp1,8);
  addgfx(X4,X2,temp2,8);
  addgfx(X4,X3,temp3,8);
  multgfx(temp1,temp2,mod,den,8);
  multgfx(den,temp3,mod,den,8);
  expgfx(den,exp,mod,den,8); /* change to inverse */

  multgfx(num,den,mod,term4,8);

  /* add them all together */
  addgfx(term1,term2,result,8);
  addgfx(result,term3,result,8);
  addgfx(result,term4,result,8);

  printf("RESULT:\n");
  printUL(result,8);
  printASCII(result,8);

}
