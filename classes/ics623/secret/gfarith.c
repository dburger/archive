/*=============================================================================
Assignment: secret sharing
Author:     David J. Burger
Language:   ANSI C running on UHUNIX2 (Solaris)
Compile:    by running "make" with included makefile

Class:      ICS 623
Instructor: Dr. Peterson
Due Date:   12/07/01
===============================================================================
File:         gfarith.c

Description:  this file contains the functions necessary for doing arithmetic
              in a Galois Field.  The functions are abstracted so that you can
              choose the size of the polynomials used in the field.
=============================================================================*/

#include "secret.h"

/*=============================================================================
Function zeroUL

Purpose:  zero's out the value of an unsigned long array
          
Parameters:
          *a - unsigned long array to zero out
          size - size of the arry
          
Returns:  nothing, unsigned long array a is zeroed out
=============================================================================*/
void zeroUL(ul *a, int size) {
  while (--size>=0) a[size] = 0;
}

/*=============================================================================
Function copyUL

Purpose:  copies the values in unsigned long array a to b
          
Parameters:
          *a - array to copy
          *b - array to copy to
          size - number of unsigned longs to copy from array a to array b
          
Returns:  nothing, b becomes a copy of a
=============================================================================*/
void copyUL(ul *a, ul *b, int size) {
  while (--size>=0) b[size] = a[size];
}

/*=============================================================================
Function shlx

Purpose:  left shift of unsigned long array
          
Parameters:
          *a - array to shift
          size - size of the array
          c - value to shift into the left most bit
          
Returns:  nothing, array a is shifted left by one bit
=============================================================================*/
void shlx(ul *a, int size, int c) {
  int i;
  for (i=0;i<size-1;i++) {
    a[i] = (a[i]<<1) | a[i+1]>>31;
  }
  a[size-1] = (a[size-1]<<1) | c;
}

/*=============================================================================
Function shrx

Purpose:  right shift of unsigned long array
          
Parameters:
          *a - array to shift
          size - size of the array
          c - value to shift into the right most bit
          
Returns:  nothing, array a is shifted right by one bit
=============================================================================*/
void shrx(ul *a, int size, int c) {
  int i;
  for (i=size-1;i>0;i--) {
    a[i] = (a[i]>>1) | a[i-1]<<31;
  }
  a[0] = (a[0]>>1) | (c<<31);
}

/*=============================================================================
Function xorx

Purpose:  xor's two unsigned long array's putting the result in result
          
Parameters:
          *a - first operand
          *b - second operand
          *result - where to put the result
          size - size of the arrays
          
Returns:  nothing, result contains a ^ b
=============================================================================*/
void xorx(ul *a, ul *b, ul *result, int size) {
  int i;
  ul t[size];
  for (i=0;i<size;i++)
    t[i] = a[i] ^ b[i];
  copyUL(t,result,size);
}

/*=============================================================================
Function andx

Purpose:  determines whether or not a and b share any common 1 bits
          
Parameters:
          *a - first operand
          *b - second operand
          size - size of the array
          
Returns:  true if a and b have a common one bit, false otherwise
=============================================================================*/
int andx(ul *a, ul *b, int size) {
  int i;
  for (i=0;i<size;i++)
    if (a[i] & b[i]) return 1;
  return 0;
}

/*=============================================================================
Function multXgfx

Purpose:  multiple a polynomials of a Galois Field by X
          
Parameters:
          *a - first operand
          *m - the modulus
          *result - where to put the result          
          size - size of the array
          
Returns:  nothing, result contains a * X mod m
=============================================================================*/
void multXgfx(ul *a, ul *m, ul *result, int size) {
  ul mask[size];
  zeroUL(mask,size);
  mask[0] = 0x80000000;
  copyUL(a,result,size);
  shlx(result,size,0);
  if (andx(result,mask,size)) xorx(result,m,result,size);
}

/*=============================================================================
Function addgfx

Purpose:  add two polynomial of a Galois Field
          
Parameters:
          *a - first operand
          *b - second operand
          *result - where to put the result
          size - size of the array
          
Returns:  nothing, a + b is placed in result
=============================================================================*/
void addgfx(ul *a, ul *b, ul *result, int size) {
  int i;
  ul t[size];
  for (i=0;i<size;i++)
    t[i] = a[i] ^ b[i];
  copyUL(t,result,size);
}

/*=============================================================================
Function multgfx

Purpose:  multiplication of two polynomials of a Galois Field
          
Parameters:
          *a - first operand
          *b - second operand
          *m - the modulus
          *result - where to put the result
          size - size of the array
          
Returns:  nothing, a * b mod m is placed in result
=============================================================================*/
void multgfx(ul *a, ul *b, ul *m, ul *result, int size) {
  ul mask[size];
  int i,j;
  ul t[size];
  zeroUL(t,size);
  zeroUL(mask,size);
  mask[0] = 0x80000000;
  for (i=0;i<size;i++) {
    for (j=0;j<32;j++) {
      multXgfx(t,m,t,size);
      if (andx(b,mask,size)) addgfx(t,a,t,size);
      shrx(mask,size,0);
    }
  }
  copyUL(t,result,size);
}

/*=============================================================================
Function expgfx

Purpose:  exponentiation of a polynomial of a Galois Field
          
Parameters:
          *a - base operand
          *b - exponent operand
          *m - the modulus
          *result - where to put the result
          size - size of the array
          
Returns:  nothing, a to the power b mod m is placed in result
=============================================================================*/
void expgfx(ul *a, ul*b, ul *m, ul *result, int size) {
  int i,j;
  ul mask[size];
  ul t[size];
  zeroUL(t,size);
  t[size-1] = 1;
  zeroUL(mask,size);
  mask[0] = 0x80000000;
  for (i=0;i<size;i++) {
    for (j=0;j<32;j++) {
      multgfx(t,t,m,t,size);
      if (andx(b,mask,size)) multgfx(t,a,m,t,size);
      shrx(mask,size,0);
    }
  }
  copyUL(t,result,size);
}
