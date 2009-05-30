/*=============================================================================
Assignment: rsa
Author:     David J. Burger
Language:   ANSI C running on UHUNIX2 (Solaris)
Compile:    by running "make" with included makefile

Class:      ICS 623
Instructor: Dr. Peterson
Due Date:   11/05/01
===============================================================================
File:         main.c

Description:  this file contains the main entry point for this RSA program.  It
              computes the RSA decryption of the given ciphertext use the
              supplied key
=============================================================================*/
#include <stdio.h>

#include "long.h"

UL cipher[] = { 0x0f543ddc, 0xc5ab44e0, 0x37ed8da8, 0xe0d87e80, 0x8a0f6f14,
                0x71cd8be1, 0x01582d91, 0x75371229, 0xf7d8223e, 0xb4d7ded6,
                0xc5cd35e9, 0x0a8998f3, 0xbaa5debb, 0xf963ded7, 0xdb538ba0,
                0x65527be9, 0x20ee521c, 0x424e7cbb, 0x0b5c0a05, 0x61d10944,
                0xecd3722f, 0xbce909b9, 0xea4a7076, 0x26b826f5, 0xa42b5916,
                0xd28e2268, 0x349205a7, 0x4fd98503, 0x35dc3424, 0x6d1c0667,
                0xab264bf2, 0xf77e5b4b };

UL n[] =      { 0x1c4b4dc3, 0xe9bb2e22, 0x02af1bab, 0xe0e07b04, 0xa9dab449,
                0x47bc8601, 0x31d74f2c, 0xe0d0e68c, 0xd7d301db, 0x44412414,
                0xfe681822, 0x89b3f506, 0x556a7435, 0x6bb9449a, 0x0367358b,
                0xdb805cec, 0x3c815e5a, 0x160e58c0, 0x81f4ecca, 0x29417d67,
                0x5ca447e3, 0x4b07b475, 0x45cc0dbe, 0xeb27cf00, 0x60f0146e,
                0x38bd3e05, 0x6da1928d, 0x5b946384, 0x2312e2d7, 0xdaf4de29,
                0x809a31d3, 0x2273ce99 };


UL e[] =      { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
                0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
                0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
                0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
                0x00000000, 0x00000000, 0x00000000, 0x00000000, 0xd917256f,
                0x7e9ac81a, 0xe3c763e4, 0x376f8290, 0x79e4d85e, 0x9f3941d6,
                0x68119a44, 0x01a71bbd };

UL p[] =      { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
                0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
                0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
                0x00000000, 0x5e99ba54, 0x53d370e8, 0x0c09bee4, 0xed5f4e3c,
                0xdb61bb89, 0x18855c18, 0xe20e4b99, 0x0404f764, 0xa93d7da9,
                0x44c80acd, 0x240adb5c, 0x7c2fc474, 0x64fe6f18, 0xfde38821,
                0x95e92691, 0x82c21caf };

UL a[] =      { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
                0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
                0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
                0x00000000, 0x2f4cdd2a, 0x29e9b874, 0x0604df72, 0x76afa71e,
                0x6db0ddc4, 0x8c42ae0c, 0x710725cc, 0x82027bb2, 0x549ebed4,
                0xa2640566, 0x92056dae, 0x3e17e23a, 0x327f378c, 0x7ef1c410,
                0xcaf49348, 0xc1610e57 };

UL q[] =      { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
                0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
                0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
                0x00000000, 0x4c9139d8, 0xcaa6cbd8, 0xc26e1ae1, 0x168244b8,
                0xb7d55411, 0x365f8021, 0x9a3d6b88, 0xe7ca6b19, 0x57372e71,
                0x323d4fa1, 0xf0d122b1, 0x7ebe12fc, 0x1a30dff0, 0x1432e84c,
                0xa794b5e8, 0x2505eb37 };

UL b[] =      { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
                0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
                0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000,
                0x00000000, 0x26489cec, 0x655365ec, 0x61370d70, 0x8b41225c,
                0x5beaaa08, 0x9b2fc010, 0xcd1eb5c4, 0x73e5358c, 0xab9b9738,
                0x991ea7d0, 0xf8689158, 0xbf5f097e, 0x0d186ff8, 0x0a197426,
                0x53ca5af4, 0x1282f59b };

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
    if ((i+1)%8==0)
      fprintf(fp,"\n");
    else
      fprintf(fp," ");
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

/*=============================================================================
Function main

Purpose:  main entry point in program, performs rsa
          
Parameters:
          int argc - count of arguments passed to program
          char *argv - array of pointers to command line strings
                    
Returns:  nothing, rsa computation performed and result output to screen
=============================================================================*/
int main(int argc, char *argv[]) {
  UL s[32], d[32], one[32], t[32], plain[32];

  /* make a one */
  zeroUL(one,32);  
  one[31] = 1;

  /* first we calculate s = phi(n)             */
  /*                      = phi(pq)            */
  /*                      = phi(p)phi(q)       */
  /*                      = (p-1)(p-1)         */
  /*                      = (2a+1-1)(2b+1-1)   */
  /*                      = (2a)(2b)           */
  /*                      = 4ab                */
  /*                      so ab and two shifts */
  mmult(a,b,s,n);
  mshl(s,n);
  mshl(s,n);

  /* now calculate phi(s) = phi(4ab)           */
  /*                      = phi(4)phi(a)phi(b) */
  /*                      = 2(a-1)(b-1)        */
  /*               so (a-1)(b-1) and one shift */
  sub(a,one,sub(a+16,one+16,0));
  sub(b,one,sub(b+16,one+16,0));
  mmult(a,b,t,s);
  mshl(t,s);

  /* now calculate d = e^phi(s)-1 */
  sub(t,one,sub(t+16,one+16,0));
  mexp(e,t,d,s);

  mexp(cipher,d,plain,n);

  fprintUL(stdout,plain,32);

  fprintASCII(stdout,plain,32);

}

/* NOTE                                                    */
/* to encrypt you would merely do cipher = plain ^ e  mod n*/
/* or mexp(plain,e,cipher,n);                              */
