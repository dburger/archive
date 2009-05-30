/*=============================================================================
Assignment: El Gamal digital signatures
Author:     David J. Burger
Language:   ANSI C running on UHUNIX2 (Solaris)

Class:      ICS 623
Instructor: Dr. Peterson
Due Date:   12/02/01
===============================================================================
File:         egds.c

Description:  this file contains the main entry point for a proram that
              demonstrates El Gamal digital signatures.  It can be compiled
              by running make with the included makefile.  It is executed by
              typing ./egds
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
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000002
  };

  UL x[] = {
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x74c0e013, 0xbfb6842a, 0x679f43ba, 0x09179d7c,
    0xed643c8c, 0x4fc38516, 0xad569042, 0x0e1935f6,
    0x9925b0b4, 0x797447f8, 0xc1212912, 0x680fbfcc,
    0xe1f91f72, 0xaa7fe944, 0xb3abc6ce, 0x32895a88
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
    0x03cd3747, 0x06d7d4b3, 0x046cdbe2, 0x6a5d128c,
    0x427c3c55, 0x31169898, 0x77a4044d, 0x56f32f43,
    0x56e509fe, 0x06058ed8, 0x1c06dac8, 0x4431b782,
    0x3ab50c2a, 0x60b7acd9, 0x10d63af1, 0x000041a7
  };

  UL myk[] = {
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x02EA3892, 0x7BD2E392, 0x083ECA91, 0xFE392AF0,
    0xDA95BC39, 0x2EBA9561, 0xAAE8CD37, 0x3E8BCDA9,
    0x087BE63C, 0x1E9BCAE9, 0x35EA2393, 0x38EFC712,
    0xA97EF22E, 0xD974EFAB, 0x39BEACDA, 0x38EAC983
  };

  char stuff[] = "This is the stuff I would like to sign.  Well, actually I \
    am not going to sign this text but a hash of this text.  That is what is \
    usually done so that the computation can be done much faster.  I guess \
    that is about all I have to say, so this will be the end of my jabber.";

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

Purpose:  main entry point of program.  Demonstrates El Gamal by verifying the
          results demonstrated by Dr. Peterson and then uses El Gamal to sign
          and verify a document of my own.
          
Parameters:
     not used
               
Returns:  nothing, performs El Gamal digital signatures
=============================================================================*/
int main(int argc, char *argv[]) {

  UL y[32], r[32], qminus1[32], fminus1[32], pminus1[32], temp1[32], temp2[32],
    one[32], kprime[32], s[32], hcopy[32], res1[32], res2[32], mykprime[32];

  UL hash[32], hashcopy[32];
  struct hash *texthash;

  printf("=========================================================\n");
  printf("Verifying Dr. Peterson's results:\n\n");

  mexp(g,x,y,p); /* here we compute public key y */

  printf("Public key y is:\n");
  fprintUL(stdout,y,32);

  /* now finding kprime */
  zeroUL(one,32);
  one[31] = 1;

  copyUL(q,qminus1,32);
  copyUL(f,fminus1,32);
  copyUL(p,pminus1,32);
  msub(qminus1,one,p);
  msub(fminus1,one,p);
  msub(pminus1,one,p);

  mmult(qminus1,fminus1,temp1,p);

  msub(temp1,one,p);

  mexp(k,temp1,kprime,pminus1);

  printf("k':\n");
  fprintUL(stdout,kprime,32);

  mexp(g,k,r,p); /* and now determine r */

  printf("r is:\n");
  fprintUL(stdout,r,32);

  /* and now we find s */
  mmult(x,r,temp1,pminus1);

  copyUL(h,hcopy,32);

  msub(hcopy,temp1,pminus1);

  mmult(kprime,hcopy,s,pminus1);

  printf("s is:\n");
  fprintUL(stdout,s,32);

  /* now for verification */
  mexp(y,r,temp1,p);
  mexp(r,s,temp2,p);

  mmult(temp1,temp2,res1,p);

  printf("res1:\n");
  fprintUL(stdout,res1,32);

  mexp(g,h,res2,p);

  printf("res2:\n");
  fprintUL(stdout,res2,32);

  if (mcmp(res1,res2)==0)
    printf("Signature verifies!\n");
  else
    printf("Signature does not verify!\n");
  printf("=========================================================\n");

  printf("Now working on some text of my own, I will sign the hash.\n\n");

  texthash = (struct hash *)malloc(sizeof(struct hash));
  sha1Mem(stuff,strlen(stuff),texthash);

  zeroUL(hash,32);
  hash[31] = texthash->H4;
  hash[30] = texthash->H3;
  hash[29] = texthash->H2;
  hash[28] = texthash->H1;
  hash[27] = texthash->H0;

  printf("SHA1 hash of text:\n");
  fprintUL(stdout,hash,32);

  printf("Determining if chosen myk is relatively prime to p - 1...\n");
  mmult(qminus1,fminus1,temp1,pminus1);

  mexp(myk,temp1,temp2,pminus1);

  if (mcmp(temp2,one)==0)
    printf("myk is relatively prime to p - 1!\n\n");
  else {
    printf("Chosen myk is not relatively prime to p - 1, please \
            choose another myk.\n");
    exit(0);
  }

  printf("Public key y is:\n");
  fprintUL(stdout,y,32);

  /* determine mykprime */

  mmult(qminus1,fminus1,temp1,p);

  msub(temp1,one,p);

  mexp(myk,temp1,mykprime,pminus1);

  mexp(g,myk,r,p); /* and now determine r */

  printf("r is:\n");
  fprintUL(stdout,r,32);

  /* find the s for this message */
  mmult(x,r,temp1,pminus1);

  copyUL(hash,hashcopy,32);

  msub(hashcopy,temp1,pminus1);

  mmult(mykprime,hashcopy,s,pminus1);

  printf("s is:\n");
  fprintUL(stdout,s,32);

  /* now for verification */
  mexp(y,r,temp1,p);
  mexp(r,s,temp2,p);

  mmult(temp1,temp2,res1,p);

  printf("res1:\n");
  fprintUL(stdout,res1,32);

  mexp(g,hash,res2,p);

  printf("res2:\n");
  fprintUL(stdout,res2,32);

  if (mcmp(res1,res2)==0)
    printf("Signature verifies!\n");
  else
    printf("Signature does not verify!\n");

}
