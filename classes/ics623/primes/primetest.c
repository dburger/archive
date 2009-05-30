/*=============================================================================
Assignment: prime tester
Author:     David J. Burger
Language:   ANSI C running on UHUNIX2 (Solaris)
Compile:    by running "make" with included makefile

Class:      ICS 623
Instructor: Dr. Peterson
Due Date:   11/05/01
===============================================================================
File:         primetest.c

Description:  this file contains functions used to determine whether or not a
              large number is prime using the Lehman test.
=============================================================================*/

#include "long.h"

  UL samp_primes[][32] = { { 0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 313 },
                           { 0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 383 },
                           { 0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 491 },
                           { 0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 503 },
                           { 0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 617 },
                           { 0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 809 },
                           { 0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 829 },
                           { 0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 911 },
                           { 0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 947 },
                           { 0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0, 0, 997 } };


/*=============================================================================
Function lehman_prime

Purpose:  this function determines whether p is prime where p = 2s + 1 using
          the Lehman method
          
Parameters:
          *p - number to determine if prime contained in 32 element UL array
          *s - p = 2s + 1, contained in 32 element UL array
          
Returns:  returns 1 if prime, 0 otherwise
=============================================================================*/
int lehman_prime(UL *p, UL *s) {
  UL small_primes[] = { 3,5,7,11,13,17,19,23,29,31 };
  UL result[32],one[32],negone[32];
  int i,numone=0;

  /* check for divisibility by the small primes */
  for (i=0;i<10;i++)
    if (divides(p,small_primes[i])) return 0;

  /* make a one value */
  zeroUL(one,32);
  one[31] = 1;

  /* make a negative one value */
  copyUL(p,negone,32);
  sub(negone,one,sub(negone+16,one+16,0));

  /* test the 3 digit primes to see if results are 1 and -1 */
  for (i=0;i<10;i++) {
    mexp(samp_primes[i],s,result,p);
    if (mcmp(result,one)==0) numone++;
    if (!(mcmp(result,one)==0 || mcmp(result,negone)==0)) return 0;
  }
  /* if not all of them were one, return 1, it is a prime */
  return numone!=10;
}

/*=============================================================================
Function divides

Purpose:  used to determine if a 32 bit unsigned long will divide a 1024 bit
          unsigned long evenly
          
Parameters:
          *a - dividend array holding 32 UL values making a 1024 bit number
          b - divisor
          
Returns:  1 if divisible, 0 otherwise
=============================================================================*/
int divides(UL *a, UL b) {
  int i;
  UL t[33];
  t[0] = 0;
  copyUL(a,t+1,32);
  for (i=0;i<1024;i++) {
    if (t[0]>=b) t[0]-=b;
    if (t[32] & 0x80000000)
      shl(t,shl(t+16,1));
    else
      shl(t,shl(t+16,0));
    t[32]<<=1;
  }
  if (t[0]>=b) t[0]-=b;
  return t[0]==0;
}








