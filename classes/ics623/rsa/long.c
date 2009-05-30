/*=============================================================================
Assignment: long arithmetic
Author:     David J. Burger
Language:   ANSI C running on UHUNIX2 (Solaris)

Class:      ICS 623
Instructor: Dr. Peterson
Due Date:   11/05/01
===============================================================================
File:         long.c

Description:  this file contains various long arithmetic functions.  The first
              functions in the file are those supplied by Dr. Peterson.
=============================================================================*/

#include "long.h"

/* This adds the 512-bit number that b points   */
/* to to the 512-bit number that a points to.   */
/* c is assumed to be 0 or 1, the carry in,     */
/* and is added to the sum. The carry out of    */
/* the highest-order word (1 or 0) is returned. */
int add(UL *a, UL *b, int c)
{
    UL t;
    t = a[15] + b[15];
    a[15] = t+c;
    c = t<b[15] || t==0xffffffff && c==1;
    t = a[14] + b[14];
    a[14] = t+c;
    c = t<b[14] || t==0xffffffff && c==1;
    t = a[13] + b[13];
    a[13] = t+c;
    c = t<b[13] || t==0xffffffff && c==1;
    t = a[12] + b[12];
    a[12] = t+c;
    c = t<b[12] || t==0xffffffff && c==1;
    t = a[11] + b[11];
    a[11] = t+c;
    c = t<b[11] || t==0xffffffff && c==1;
    t = a[10] + b[10];
    a[10] = t+c;
    c = t<b[10] || t==0xffffffff && c==1;
    t = a[9] + b[9];
    a[9] = t+c;
    c = t<b[9] || t==0xffffffff && c==1;
    t = a[8] + b[8];
    a[8] = t+c;
    c = t<b[8] || t==0xffffffff && c==1;
    t = a[7] + b[7];
    a[7] = t+c;
    c = t<b[7] || t==0xffffffff && c==1;
    t = a[6] + b[6];
    a[6] = t+c;
    c = t<b[6] || t==0xffffffff && c==1;
    t = a[5] + b[5];
    a[5] = t+c;
    c = t<b[5] || t==0xffffffff && c==1;
    t = a[4] + b[4];
    a[4] = t+c;
    c = t<b[4] || t==0xffffffff && c==1;
    t = a[3] + b[3];
    a[3] = t+c;
    c = t<b[3] || t==0xffffffff && c==1;
    t = a[2] + b[2];
    a[2] = t+c;
    c = t<b[2] || t==0xffffffff && c==1;
    t = a[1] + b[1];
    a[1] = t+c;
    c = t<b[1] || t==0xffffffff && c==1;
    t = a[0] + b[0];
    a[0] = t+c;
    c = t<b[0] || t==0xffffffff && c==1;
    return c;
}

/* This sutracts the 512-bit word that b points   */
/* to from the 512-bit number that a points to.   */
/* c (1 or 0) is subtracted from the result, and  */
/* if there is a borrow out of the high end, it   */
/* (1 or 0) is returned.                          */
int sub(UL *a, UL *c, int b1)
{
    int b2;
    b2 = a[15]<c[15] || a[15]==c[15] && b1==1;
    a[15] -= c[15]+b1;
    b1 = a[14]<c[14] || a[14]==c[14] && b2==1;
    a[14] -= c[14]+b2;
    b2 = a[13]<c[13] || a[13]==c[13] && b1==1;
    a[13] -= c[13]+b1;
    b1 = a[12]<c[12] || a[12]==c[12] && b2==1;
    a[12] -= c[12]+b2;
    b2 = a[11]<c[11] || a[11]==c[11] && b1==1;
    a[11] -= c[11]+b1;
    b1 = a[10]<c[10] || a[10]==c[10] && b2==1;
    a[10] -= c[10]+b2;
    b2 = a[9]<c[9] || a[9]==c[9] && b1==1;
    a[9] -= c[9]+b1;
    b1 = a[8]<c[8] || a[8]==c[8] && b2==1;
    a[8] -= c[8]+b2;
    b2 = a[7]<c[7] || a[7]==c[7] && b1==1;
    a[7] -= c[7]+b1;
    b1 = a[6]<c[6] || a[6]==c[6] && b2==1;
    a[6] -= c[6]+b2;
    b2 = a[5]<c[5] || a[5]==c[5] && b1==1;
    a[5] -= c[5]+b1;
    b1 = a[4]<c[4] || a[4]==c[4] && b2==1;
    a[4] -= c[4]+b2;
    b2 = a[3]<c[3] || a[3]==c[3] && b1==1;
    a[3] -= c[3]+b1;
    b1 = a[2]<c[2] || a[2]==c[2] && b2==1;
    a[2] -= c[2]+b2;
    b2 = a[1]<c[1] || a[1]==c[1] && b1==1;
    a[1] -= c[1]+b1;
    b1 = a[0]<c[0] || a[0]==c[0] && b2==1;
    a[0] -= c[0]+b2;
    return b1;
}

/* This shifts a left one bit. c (1 or 0)    */
/* is shifted into the lowest order position */
/* and the bit (1 or 0) shifted out of the   */
/* highest order position is returned.       */
int shl(UL *a, int c)
{
    int c1;
    c1 = a[0]>>31;
    a[0] = (a[0]<<1) | a[1]>>31;
    a[1] = (a[1]<<1) | a[2]>>31;
    a[2] = (a[2]<<1) | a[3]>>31;
    a[3] = (a[3]<<1) | a[4]>>31;
    a[4] = (a[4]<<1) | a[5]>>31;
    a[5] = (a[5]<<1) | a[6]>>31;
    a[6] = (a[6]<<1) | a[7]>>31;
    a[7] = (a[7]<<1) | a[8]>>31;
    a[8] = (a[8]<<1) | a[9]>>31;
    a[9] = (a[9]<<1) | a[10]>>31;
    a[10] = (a[10]<<1) | a[11]>>31;
    a[11] = (a[11]<<1) | a[12]>>31;
    a[12] = (a[12]<<1) | a[13]>>31;
    a[13] = (a[13]<<1) | a[14]>>31;
    a[14] = (a[14]<<1) | a[15]>>31;
    a[15] = (a[15]<<1) | c;
    return c1;
}

/* Here are several 1023-bit mod P functions: */

/* Return negative,if a<b, zero if */
/* a=b and positive if a>b.        */
int mcmp(UL *a, UL *b)
{
	int i;
	for(i = 0; i<32; i++) {
		if(a[i]>b[i]) return 1;
		if(a[i]<b[i]) return -1;
	}
	return 0;
}

/* add b to a */
void madd(UL *a, UL *b, UL *P)
{
	add(a, b, add(a+16, b+16, 0));
	if(mcmp(a, P)>=0) sub(a, P, sub(a+16, P+16, 0));
}

/* subtract b from a */
void msub(UL *a, UL *b, UL *P)
{
	if(sub(a, b, sub(a+16, b+16, 0))) 
		add(a, P, add(a+16, P+16, 0));
}

/* shift a left one bit  */
void mshl(UL *a, UL *P)
{
	shl(a, shl(a+16, 0));
	if(mcmp(a, P)>=0) sub(a, P, sub(a+16, P+16, 0));
}

/*=============================================================================
Function mmult

Purpose:  mutiply a by b mod P and put the result in result
          
Parameters:
          *a - first operator
          *b - second operator
          *result - where the result is placed
          *P - modulus
          
Returns:  nothing, result of multiplication is placed in result
=============================================================================*/
void mmult(UL *a, UL *b, UL *result, UL *P) {
  int i,j;
  UL mask;
  UL t[32];
  zeroUL(t,32);
  /* looping through the 32 words */
  for (i=0;i<32;i++) {
    mask = 0x80000000;
    /* looping through the 32 bits */
    for (j=0;j<32;j++) {
      mshl(t,P);
      if (b[i] & mask) madd(t,a,P);
      mask>>=1;
    }
  }

  /* answer is in t[], put in result */
  for (i=0;i<32;i++)
    result[i] = t[i];

}

/*=============================================================================
Function mexp

Purpose:  take a to the power b mod P and put result in result
          
Parameters:
          *a - base of exponentiation
          *b - exponent
          *result - where the result is placed
          *P - modulus
          
Returns:  nothing, result of exponentiation is placed in result
=============================================================================*/
void mexp(UL *a, UL *b, UL *result, UL *P) {
  int i,j;
  UL mask;
  UL t[32];
  zeroUL(t,32);
  t[31] = 1;
  /* looping through the 32 words */
  for (i=0;i<32;i++) {
    mask = 0x80000000;
    /* looping through the 32 bits */
    for (j=0;j<32;j++) {
      mmult(t,t,t,P);
      if (b[i] & mask) mmult(t,a,t,P);
      mask>>=1;
    }
  }

  /* answer is in t[], put in result */
  for (i=0;i<32;i++)
    result[i] = t[i];

}

/*=============================================================================
Function zeroUL

Purpose:  used to "zero out" the values in an unsigned long array
          
Parameters:
          *a - array to zero out
          size - number of values to zero out
          
Returns:  nothing, size values in a are set to 0
=============================================================================*/
void zeroUL(UL *a, int size) {
  while (--size>=0) a[size] = 0;
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
