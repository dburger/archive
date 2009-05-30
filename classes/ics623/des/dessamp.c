/*=============================================================================
Assignment:  DES 8 bit CFB mode decryption of the ciphertext supplied by Dr.
             Peterson.  The hex results and ascii results of the ciphertext
             are displayed on the screen.

Author:      David J. Burger
Language:    ANSI C running on UHUNIX2 (Solaris)
Compile:     by running "make" with supplied makefile

Execute:     ./dessamp

Class:       ICS 623
Instructor:  Dr. Peterson
Due Date:    09/10/01
=============================================================================*/
#include "des.h"

unsigned long lk = 0x843d0d08;    /* key  */
unsigned long rk = 0x34b2c4fa;

unsigned long liv = 0xcd647403;   /* initial vector */
unsigned long riv = 0xbc90c4c4;

/* the supplied ciphertext from Dr. Peterson */
unsigned long cipher[] = {0xe8d87407, 0xb3372ec6, 0x6159db44, 0x52705849,
                          0x88125b8b, 0xbfce80bd, 0xac3e87f2, 0x1ca983fd,
                          0xfc87c9fa, 0x39444844, 0x0b0803a6, 0x6142d0e0,
                          0x8a89b9cd, 0x98db0648, 0xf68abb1e, 0xb1ea4dbb,
                          0x46384dd5, 0xf95ab017, 0x03644738, 0xfcce447d,
                          0x19000000};

int realBytes = 81; /* the number of bytes that are real...not padding */

/* array to hold decrypted plain text */
unsigned long plain[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                         0, 0, 0, 0, 0, 0, 0, 0, 0};

unsigned long ltemp, rtemp, enciphByte, cryptByte; /* working long buffers */

unsigned long lkey[17];  /* calculated key schedule */
unsigned long rkey[17];

unsigned long getByteFromULong(unsigned long l, int byte);

int main(void) 
{
	int i,j; /* loop counters */
    int bytesOut = 0; /* to keep track of deciphered bytes written out */

	keycalc();  //calculate the 16 keys

    printf("Deciphering.......\n");
    for (i=0;i<21;i++) /* for the 21 longs of data */
        for (j=0;j<4;j++) { /* cycle through 4 bytes of a long */
            desc(liv,riv,&ltemp,&rtemp); /* run it through des */
            
            cryptByte = getByteFromULong(ltemp,3); /* grab the high byte */

            enciphByte = getByteFromULong(cipher[i],(3-j)); /* get crypt byte*/
            cryptByte = (cryptByte ^ enciphByte); /* xor them together */

            /* shift the initial vector adding the enciphByte */
            liv = (liv << 8) | getByteFromULong(riv,3);
            riv = (riv << 8) | enciphByte;

            /* add the decrypted byte to the plain text */
            plain[i] = (plain[i] | (cryptByte << (3 - j)*8));

        }
    /* output the results of the decryption */
    printf("Hex          ASCII\n");
	for(i = 0; i<21; i++) {
        printf(" %08x     ", plain[i]);
        for (j=3;j>=0;j--) {
            printf("%c",getByteFromULong(plain[i],j));
            if (++bytesOut==realBytes) break;/*don't print deciphered padding*/
        }
        printf("\n");
    }
}

/* this function will return byte 0, 1, 2, or 3 from long l */
/* the return value consists of the byte isolated at byte 0 */
/* of the returned unsigned long                            */
unsigned long getByteFromULong(unsigned long l, int byte) {
    if (byte<0 || byte >3) return 0;
    return (l >> (byte*8)) & 0x000000ff;
}
