/*=============================================================================
Assignment:  Implementation of secure hash algorithm (SHA-1).
             
Author:      David J. Burger
Language:    ANSI C running on UHUNIX2 (Solaris)
Compile:     by running "make" with supplied makefile

Execute:     ./shatest filename

Class:       ICS 623
Instructor:  Dr. Peterson
Due Date:    09/17/01
===============================================================================
File:         sha1.c

Description:  This file contains the algorithms to compute SHA-1 values.
              
Functions:    void sha1File(FILE *fp, struct hash *h) - computes the hash value
                  for the file of passed in FILE *fp.
                  
              void sha1Mem(char *buff, int len, struct hash *h) - computes the
                  hash value for the char *buff of length len.
=============================================================================*/
#include <stdio.h>
#include "sha1.h"

unsigned long circShiftLeft(unsigned long l, int bits);

static void sha1();

/* sha-1 variables */
static unsigned long A, B, C, D, E;
static unsigned long H0, H1, H2, H3, H4;
static unsigned long W[80], TEMP;

static unsigned long buffer[16]; /* buffer for reading from the file */

/*=============================================================================
Function sha1File

Purpose:  This function computes the hash value for the passed in file.
          
Parameters:
    FILE *fp (IN) - a FILE * to the file to deterine the hash value of
    struct hash *h (OUT) - a structure to return the hash value in

Returns:  struct hash *h contains the hash value
=============================================================================*/
void sha1File(FILE *fp, struct hash *h) {
    char *p; /* char pointer for working with the buffer */
    int bytesRead; /* the number of bytes read on fread call */
    unsigned long fileBitsLo = 0; /* keeps track of the file size */
    unsigned long fileBitsHi = 0;
    unsigned long fileBitsBefore;

    H0 = 0x67452301; /* init to SHA-1 initial values */
    H1 = 0xEFCDAB89;
    H2 = 0x98BADCFE;
    H3 = 0x10325476;
    H4 = 0xC3D2E1F0;

    while (!feof(fp)) {
        bytesRead = fread(buffer,1,sizeof(buffer),fp);
        fileBitsBefore = fileBitsLo;
        fileBitsLo+=bytesRead*8;
        if (fileBitsBefore>fileBitsLo) fileBitsHi++; /* carry */
        if (bytesRead==sizeof(buffer)) {
            sha1(); /* computing sha1 on buffer block */
        } else { /* we have a partial block */
            p = (char *)buffer;
            p[bytesRead] = 0x80; /* put the 1 bit after last byte read */
            memset(p+bytesRead+1,0,sizeof(buffer)-bytesRead-1); /* zero out  */
            if (sizeof(buffer)-bytesRead-1<8) { /* figure out if room for sze*/
                sha1(); /* no room for size in this block compute sha1()     */
                /* now make a new last block with the size */
                memset(p,0,sizeof(buffer));
                buffer[14] = fileBitsHi;
                h->sizeHi = fileBitsHi;
                buffer[15] = fileBitsLo;
                h->sizeLo = fileBitsLo;
                sha1(); /* compute sha1() for this last block */
            } else { /* room for size in the block */
                buffer[14] = fileBitsHi;
                h->sizeHi = fileBitsHi;
                buffer[15] = fileBitsLo; /* put the size in */
                h->sizeLo = fileBitsLo;
                sha1(); /* compute sha1() for this last block */
            }
        }
    }

    h->H0 = H0;
    h->H1 = H1;
    h->H2 = H2;
    h->H3 = H3;
    h->H4 = H4;

}

/*=============================================================================
Function sha1Mem

Purpose:  This function computes the hash value for the passed in buffer.
          
Parameters:
    char *buff (IN) - a char * to the buffer to determine the hash of
    int len (IN) - the length of the buffer
    struct hash *h (OUT) - a structure to return the hash value in

Returns:  struct hash *h contains the hash value
=============================================================================*/
void sha1Mem(char *buff, int len, struct hash *h) {
    char *p; /* char pointer for working with the buffer */
    int buffLeft = len;
    unsigned long bitsLo = 0; /* keeps track of the file size */
    unsigned long bitsHi = 0;
    unsigned long bitsBefore;

    H0 = 0x67452301; /* init to SHA-1 initial values */
    H1 = 0xEFCDAB89;
    H2 = 0x98BADCFE;
    H3 = 0x10325476;
    H4 = 0xC3D2E1F0;

    while (buffLeft>=sizeof(buffer)) {      /* loop through the buffer */
        memcpy(buffer,buff,sizeof(buffer)); /* a block at a time       */
        buff+=sizeof(buffer);               /* tracking file size */
        buffLeft-=sizeof(buffer);
        bitsBefore = bitsLo;
        bitsLo+=sizeof(buffer)*8;
        if (bitsBefore>bitsLo) bitsHi++; /* carry */
        sha1(); /* compute sha1() for this block */
    }

    /* we now have only a partial block left */
    memcpy(buffer,buff,buffLeft); /* copy partial block */
    bitsBefore = bitsLo;          /* tracking file size */
    bitsLo+=buffLeft*8;
    if (bitsBefore>bitsLo) bitsHi++;
    p = (char *)buffer;
    p[buffLeft] = 0x80; /* set the 1 bit */
    memset(p+buffLeft+1,0,sizeof(buffer)-buffLeft-1); /* zero out rest */
    if (sizeof(buffer)-buffLeft-1<8) { /* figure out if room for size */
        sha1(); /* no room for size in this block, compute sha1() for buffer */
        /* now make a new last block with the size */
        memset(p,0,sizeof(buffer));
        buffer[14] = bitsHi;
        h->sizeHi = bitsHi;
        buffer[15] = bitsLo;
        h->sizeLo = bitsLo;
        sha1(); /* compute sha1() for this last block */
    } else { /* room for size in the block */
        buffer[14] = bitsHi;
        h->sizeHi = bitsHi;
        buffer[15] = bitsLo; /* put the size in */
        h->sizeLo = bitsLo;
        sha1(); /* compute sha1() for this last block */
    }

    h->H0 = H0;
    h->H1 = H1;
    h->H2 = H2;
    h->H3 = H3;
    h->H4 = H4;

}

/*=============================================================================
Function circShiftLeft

Purpose:  This function does a left circular shift on unsigned long values
          
Parameters:
    unsigned long l (IN) - value to shift
    int bits (IN) - # of places to shift

Returns:  the value of unsigned long l shifted left int bits
=============================================================================*/
unsigned long circShiftLeft(unsigned long l, int bits) {
  return (l << bits) | (l >> 32 - bits);
}

/*=============================================================================
Function sha1

Purpose:  This function performs a sinle "cycle" of the sha-1 algorithm.  Code
          designed from specifications from the:
          American National Standard for Financial Services
          Public Key Cryptography for the Financial Services Industry:
          Part 2:  The Secure Hash Algorithm (SHA-1)
          (Revision of X9.30:2-1993)
          
Parameters:
    none
Returns:  nothing, however it adjusts the static variables to the proper values
          for the sha-1 computation
=============================================================================*/
void sha1() {
  int i,t;

  for (i=0;i<16;i++)
    W[i] = buffer[i];

  for (t=16;t<80;t++)
    W[t] = circShiftLeft(W[t-3] ^ W[t-8] ^ W[t-14] ^ W[t-16],1);

  A = H0;
  B = H1;
  C = H2;
  D = H3;
  E = H4;

  for (t=0;t<20;t++) {
    TEMP = circShiftLeft(A,5) + ((B&C)|(~B&D)) + E + W[t] + 0x5A827999;
    E = D;
    D = C;
    C = circShiftLeft(B,30);
    B = A;
    A = TEMP;
  }

  for (t=20;t<40;t++) {
    TEMP = circShiftLeft(A,5) + (B^C^D) + E + W[t] + 0x6ED9EBA1;
    E = D;
    D = C;
    C = circShiftLeft(B,30);
    B = A;
    A = TEMP;
  }

  for (t=40;t<60;t++) {
    TEMP = circShiftLeft(A,5) + ((B&C)|(B&D)|(C&D)) + E + W[t] + 0x8F1BBCDC;
    E = D;
    D = C;
    C = circShiftLeft(B,30);
    B = A;
    A = TEMP;
  }

  for (t=60;t<80;t++) {
    TEMP = circShiftLeft(A,5) + (B^C^D) + E + W[t] + 0xCA62C1D6;
    E = D;
    D = C;
    C = circShiftLeft(B,30);
    B = A;
    A = TEMP;
  }

  H0+=A;
  H1+=B;
  H2+=C;
  H3+=D;
  H4+=E;

}
