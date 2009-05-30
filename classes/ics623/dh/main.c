/*=============================================================================
Assignment: Diffie-Hellman key exchange
Author:     David J. Burger
Language:   ANSI C running on UHUNIX2 (Solaris)

Class:      ICS 623
Instructor: Dr. Peterson
Due Date:   11/21/01
===============================================================================
File:         main.c

Description:  this file does all the computations for computing and Diffie-
              Hellman key exchange and then decrypting some cipher-text using
              the key as a one time pad
=============================================================================*/

#include <stdio.h>

#include "long.h"

UL p[] = { 0x79bb6329, 0x178e36f8, 0xad8199a4, 0xc396028d, 
           0xffdbfc5d, 0xc6ca1f85, 0x511b0c61, 0x02b750d0, 
           0x6ad206b9, 0x901d2a81, 0x64e7576c, 0x36660938, 
           0x59fe0e70, 0x03ef65b5, 0xda9f1c1c, 0xffa5bf00, 
           0xb63f7338, 0x1a2605b1, 0x8c2de924, 0xede9bbe1, 
           0xc27a570d, 0xc449b2cd, 0xa8e6bc21, 0x781112c0, 
           0x80e9d6bc, 0x6f88d739, 0xf2f7dfd4, 0xb2c24f99, 
           0x5d6d4ca1, 0xdc497fe8, 0x8a2e2814, 0x6b73f64f };

UL x[] = { 0x1c56075c, 0x63fd2f57, 0x032f2c0a, 0x0df44628,
           0x2029f340, 0x2220ff3f, 0x2455929a, 0x6e0bcf18,
           0x49496919, 0x72930de5, 0x14757027, 0x2a161aef,
           0x1142567f, 0x1a3cb4b3, 0x077b613a, 0x352c2aac,
           0x66a59d79, 0x0305a795, 0x683d28bf, 0x073e4910,
           0x0a2ebd27, 0x028450aa, 0x3ccbca30, 0x6747347e,
           0x73c7712a, 0x2ad6b7c8, 0x76bbc170, 0x2098dcf6,
           0x13d2ab32, 0x6be569c8, 0x228400cf, 0x085127bd };

UL Y[] = { 0x78630e88, 0xe6b3e20b, 0x67d05edc, 0xe382cae6,
           0x2317b98b, 0xb40a4acc, 0x9bffde78, 0x20c079e9,
           0x6319f7f9, 0xa0c74cf3, 0x055e756d, 0xea178594,
           0x71f2018e, 0xce64eeb8, 0x3d63f2b2, 0x7bd853ea,
           0xf6845007, 0x7c20c7d5, 0x64ebdf37, 0x17257cca,
           0xda3b9018, 0x75a5d300, 0x7eea4514, 0xfba0bba5,
           0xcfb0d415, 0x450c8859, 0x0fd6c403, 0xad4178df,
           0x2b5ec194, 0x602bc4a0, 0x3c771758, 0x14ff6738 };

UL M[] = { 0x14110917, 0x298f0198, 0xc80377e2, 0xeedf9ffd,
           0x1dc3e28a, 0xba6cd6e2, 0x9a4886a9, 0x23193eea,
           0x694d9620, 0x1cbfb462, 0xa6638023, 0xd22fe52e,
           0x830c2750, 0xabc188f5, 0x484137a3, 0xc0f1f283,
           0xd582f6b1, 0xcbaa2a16, 0x9da96e43, 0xc5e1277b,
           0x3b01528f, 0x1f8ae2dd, 0x4568770c, 0xd8eca391,
           0xa36604b1, 0xe66abcde, 0xf4f00348, 0x949ce003,
           0xf9cdf328, 0x6d7133dc, 0x1b14b234, 0x5c1d5ab1 };

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
Function fprintASCII

Purpose:  prints the char value of the bytes in an array of size unsigned
          longs
          
Parameters:
          *p - array containing the unsigned longs
          size - number of unsigned longs to print from the array
          
Returns:  nothing, outputs char values of the bytes in the unsigned longs
=============================================================================*/
void fprintASCII(FILE *fp, UL *p, int size) {
  unsigned char text[4];
  int i,j;
  for (i=0;i<size;i++) {
    memcpy(text,&p[i],4);
    for (j=0;j<4;j++) {
      fprintf(fp,"%c",text[j]);
    }
    if ((i+1)%4==0) fprintf(fp,"\n");
  }
  fprintf(fp,"\n");
}

int main(int argc, char *argv[]) {

  UL twenty_three[32];
  UL X[32];
  UL key[32];
  UL plain[32];
  
  int i;

  /* set up twenty_three to contain 23 */
  zeroUL(twenty_three,32);
  twenty_three[31] = 23;

  /* calculate X */
  mexp(twenty_three,x,X,p);

  printf("My X:\n");
  fprintUL(stdout,X,32);

  /* calculate the key */
  mexp(Y,x,key,p);

  printf("The key:\n");
  fprintUL(stdout,key,32);

  /* decode the message */
  for (i=0;i<32;i++)
    plain[i] = M[i] ^ key[i];
  
  printf("Plain hex:\n");
  fprintUL(stdout,plain,32);

  printf("Plain ASCII:\n");
  fprintASCII(stdout,plain,32);

}
