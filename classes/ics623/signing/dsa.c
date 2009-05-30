/*=============================================================================
Assignment: DSA
Author:     David J. Burger
Language:   ANSI C running on UHUNIX2 (Solaris)

Class:      ICS 623
Instructor: Dr. Peterson
Due Date:   12/02/01
===============================================================================
File:         dsa.c

Description:  this file contains the main entry point for a proram that
              demonstrates DSA.  It can be compiled
              by running make with the included makefile.  It is executed by
              typing ./dsa
=============================================================================*/

#include <stdio.h>

#include "long.h"
#include "sha1.h"

  UL p[] = {
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x76ba9c0d, 0xd6af4e18, 0x8bcce75b, 0xcb7a0ce9,
    0xb6c3128d, 0x2b4c21cc, 0x2adb4821, 0xba53ea2a,
    0x1b181203, 0x42bfbfad, 0x89bee4d5, 0xeb9b0544,
    0xceec5cef, 0xee03b004, 0xb410ee20, 0xe48928ab
  };

  UL q[] = {
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0xef049282,
    0xe49accee, 0xe5675b4a, 0x7fde735a, 0x9df5f9bb
  };

  UL f[] = {
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x3f951178, 0x18a9fade, 0x0a023be4,
    0xcc97ebec, 0x1dd9e632, 0x6e7a4738, 0x3a0e053e,
    0x8d4725f8, 0x724eb4e8, 0xf2f7eaa6, 0xe946012f
  };

  UL g[] = {
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x689b967d, 0xacf08055, 0x69698747, 0x29c6fe28,
    0x817ea51d, 0x6262070d, 0x6788431c, 0x0d3a1cf9,
    0xaf67c036, 0xab46bf2d, 0xc18782d1, 0x8eeea38f,
    0x950a2d17, 0x32ad274f, 0xaacf9708, 0x259b9912
  };

  UL x[] = {
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x2e7b63f6,
    0x8866d06c, 0xe7924f61, 0x675ac266, 0xccb6f684
  };

  UL h[] = {
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x2615c94b,
    0x736a7aa1, 0x6faea1d2, 0xf17b72fb, 0x1f9873dd
  };

  UL k[] = {
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x4431b782,
    0x3ab50c2a, 0x60b7acd9, 0x10d63af1, 0x000041a7
  };

  UL myk[] = {
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0xE246EC75,
    0x7BC2AEF4, 0xFD73BA34, 0x2009ACBD, 0x10FA58F6
  };

  char stuff[] = "Here is a lot of text to sign...well, once again I will \
    be signing a hash of this text.  Signing a hash is the way it works with \
    DSA.  The hash algorithm used is the sha1 standard.  I will be using the \
    hash routine that I wrote to has a char array.  It seems to work quite \
    well.";

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
    fprintf(fp,"0x%08x",p[i]);
    if ((i+1)%size==0)
      fprintf(fp,"\n");
    else if ((i+1)%4==0)
      fprintf(fp,",\n");
    else
      fprintf(fp,", ");
  }
  fprintf(fp,"\n");
}

/*=============================================================================
Function main

Purpose:  this is the main entry point of the program.  It verifies the DSA
          computations that Dr. Peterson showed us and then I use DSA on some
          text of my own.
          
Parameters:
          not used
          
Returns:  nothing, DSA is demonstrated
=============================================================================*/
int main(int argc, char *argv[]) {

  UL y[32], r[32], qminus1[32], fminus1[32], pminus1[32], temp1[32], temp2[32],
    one[32], kprime[32], s[32], hcopy[32], res1[32], res2[32], w[32], u1[32],
    u2[32], v[32], mykprime[32];

  UL hash[32], hashcopy[32];
  struct hash *texthash;

  /* make a one to work with */
  zeroUL(one,32);
  one[31] = 1;

  /* first demonstrate that Dr. Peterson's example works as shown */

  printf("=========================================================\n");
  printf("Verifying Dr. Peterson's results:\n\n");

  mexp(g,x,y,p); /* here we compute public key y */

  printf("Public key y is:\n");
  fprintUL(stdout,y,32);

  /* and now determine r */
  mexp(g,k,r,p);
  mmult(one,r,r,q);

  printf("r is:\n");
  fprintUL(stdout,r,32);

  /* now calculate kprime */
  copyUL(q,qminus1,32);
  copyUL(f,fminus1,32);
  copyUL(p,pminus1,32);
  msub(qminus1,one,p);
  msub(fminus1,one,p);
  msub(pminus1,one,p);

  mmult(qminus1,fminus1,temp1,p);

  msub(temp1,one,p);

  mexp(k,temp1,kprime,q);

  printf("k' is:\n");
  fprintUL(stdout,kprime,32);

  /* now we get the s */
  mmult(x,r,temp1,q);
  madd(temp1,h,q);

  mmult(kprime,temp1,s,q);

  printf("s is:\n");
  fprintUL(stdout,s,32);

  /* calculate w=sprime */
  mmult(qminus1,fminus1,temp1,p);
  msub(temp1,one,p);
  
  mexp(s,temp1,w,q);

  printf("w is:\n");
  fprintUL(stdout,w,32);

  /* calculate u1 */
  mmult(h,w,u1,q);

  printf("u1 is:\n");
  fprintUL(stdout,u1,32);

  /* calculate u2 */
  mmult(r,w,u2,q);

  printf("u2 is:\n");
  fprintUL(stdout,u2,32);

  /* now calculate v */
  mexp(g,u1,temp1,p);
  mexp(y,u2,temp2,p);
  mmult(temp1,temp2,temp1,p);

  mmult(one,temp1,v,q);
                     
  printf("v is:\n");
  fprintUL(stdout,v,32);

  if (mcmp(r,v)==0)
    printf("v==r, Signature verifies!\n");
  else
    printf("v!=r, Signature does not verify!\n");
  printf("=========================================================\n\n");

  printf("Now working on some text of my own, I will sign the hash.\n\n");

  /* first get the hash we are going to sign */
  texthash = (struct hash *)malloc(sizeof(struct hash));

  sha1Mem(stuff,strlen(stuff),texthash);

  zeroUL(hash,32);
  hash[31] = texthash->H4;
  hash[30] = texthash->H3;
  hash[29] = texthash->H2;
  hash[28] = texthash->H1;
  hash[27] = texthash->H0;

  printf("Hash that we will sign:\n");
  fprintUL(stdout,hash,32);

  printf("Determining if chosen myk is relatively prime to q...\n");
  
  mexp(myk,qminus1,temp1,q);

  if (mcmp(temp1,one)==0)
    printf("myk is relatively prime to q!\n\n");
  else {
    printf("Chosen myk is not relatively prime to q, please \
            choose another myk.\n");
    exit(0);
  }

  mexp(g,x,y,p); /* here we compute public key y */

  printf("Public key y is:\n");
  fprintUL(stdout,y,32);

  /* and now determine r */
  mexp(g,myk,r,p);
  mmult(one,r,r,q);

  printf("r is:\n");
  fprintUL(stdout,r,32);

  /* calculate mykprime */
  copyUL(qminus1,temp1,32);
  msub(temp1,one,q);
  mexp(myk,temp1,mykprime,q);

  /* calculate s */
  mmult(x,r,temp1,q);
  madd(temp1,hash,q);

  mmult(mykprime,temp1,s,q);

  printf("s is:\n");
  fprintUL(stdout,s,32);

  /* calculate w=sprime */
  mmult(qminus1,fminus1,temp1,p);
  msub(temp1,one,p);
  
  mexp(s,temp1,w,q);

  printf("w is:\n");
  fprintUL(stdout,w,32);

  /* calculate u1 */
  mmult(hash,w,u1,q);

  printf("u1 is:\n");
  fprintUL(stdout,u1,32);

  /* calculate u2 */
  mmult(r,w,u2,q);

  printf("u2 is:\n");
  fprintUL(stdout,u2,32);

  /* now calculate v */
  mexp(g,u1,temp1,p);
  mexp(y,u2,temp2,p);
  mmult(temp1,temp2,temp1,p);

  mmult(one,temp1,v,q);
                     
  printf("v is:\n");
  fprintUL(stdout,v,32);

  if (mcmp(r,v)==0)
    printf("v==r, Signature verifies!\n");
  else
    printf("v!=r, Signature does not verify!\n");

}
