/*=============================================================================
Assignment:  DES 8 bit CFB mode decryption.  This program does the encryption/
             decryption that Dr. Peterson's des1.c does, but it uses 8 bit
             CFB mode instead of ECB mode.

Author:      David J. Burger
Language:    ANSI C running on UHUNIX2 (Solaris)
Compile:     by running "make" with supplied makefile

Execute:     ./descfb

Class:       ICS 623
Instructor:  Dr. Peterson
Due Date:    09/10/01
=============================================================================*/
#include "des.h"

unsigned long lk = 0x01234567;    /* key  */
unsigned long rk = 0x89abcdef;

unsigned long liv = 0xcd647403;   /* initial vector */
unsigned long riv = 0xbc90c4c4;

/* cleartext is "Now is the time for all " */
unsigned long clear[6] = {0x4e6f7720, 0x69732074, 0x68652074,
                          0x696d6520, 0x666f7220, 0x616c6c20};

/* buffers to hold enciphered and deciphered text */
unsigned long enciph[6] = {0, 0, 0, 0, 0, 0};
unsigned long deciph[6] = {0, 0, 0, 0, 0, 0};

/* working buffers */
unsigned long ltemp, rtemp, clearByte, cryptByte;

unsigned long lkey[17];  /* calculated key schedule */
unsigned long rkey[17];

unsigned long getByteFromULong(unsigned long l, int byte);

int main(void) 
{
	int i,j; /* loop counters */

	keycalc();  //calculate the 16 keys

    //enciphering
    for (i=0;i<6;i++) /* the 6 long values */
        for (j=0;j<4;j++) { /* cycling the 4 bytes of the long */
            /* run the initial vector through desc */
            desc(liv,riv,&ltemp,&rtemp);

            cryptByte = getByteFromULong(ltemp,3); /* high byte out of des */
            clearByte = getByteFromULong(clear[i],(3-j)); /* clear byte */
            cryptByte = (cryptByte ^ clearByte); /* xor to get final encrypt */

            /* shifting the initial vector and adding the cryptByte */
            liv = (liv << 8) | getByteFromULong(riv,3);
            riv = (riv << 8) | cryptByte;

            /* adding another byte to the ciphered output */
            enciph[i] = (enciph[i] | (cryptByte  << (3 - j)*8));

        }
            
    liv = 0xcd647403;   /* initial vector are reset */
    riv = 0xbc90c4c4;   /* keys should still be ok  */

    //deciphering
    for (i=0;i<6;i++) /* once for each encrypted long value */
        for (j=0;j<4;j++) { /* once for each byte in the long */
            desc(liv,riv,&ltemp,&rtemp);

            cryptByte = getByteFromULong(ltemp,3); /* high byte out of des */
            clearByte = getByteFromULong(enciph[i],(3-j)); /* crypt byte */
            cryptByte = (cryptByte ^ clearByte); /* xor to get final decrypt */

            /* shifting the initial vector and adding the cryptByte */
            liv = (liv << 8) | getByteFromULong(riv,3);
            riv = (riv << 8) | clearByte;

            deciph[i] = (deciph[i] | (cryptByte  << (3 - j)*8));

        }

    /* output the results */
    printf("Key:        %08x %08x\n", lk, rk);
    printf("Plain text:\n");
    for(i = 0; i<6; i++) printf("            %08x\n", clear[i]);
    printf("Ciphertext:\n");
    for(i = 0; i<6; i++) printf("            %08x\n", enciph[i]);
    printf("Deciphertext:\n");
	for(i = 0; i<6; i++) printf("            %08x\n", deciph[i]);

	printf("Finished\n");
}

/* this function will return byte 0, 1, 2, or 3 from long l */
/* the return value consists of the byte isolated at byte 0 */
/* of the returned unsigned long                            */
unsigned long getByteFromULong(unsigned long l, int byte) {
    if (byte<0 || byte >3) return 0;
    return (l >> (byte*8)) & 0x000000ff;
}

/* Output
Enciphering
Key:        01234567 89abcdef
PlainText:  4e6f7720 69732074
PlainText:  68652074 696d6520
PlainText:  666f7220 616c6c20
Cyphertext: 3fa40e8a 984d4815
Cyphertext: 6a271787 ab8883f9
Cyphertext: 893d51ec 4b563b53


Deciphering
Key:        01234567 89abcdef
Cyphertext: 3fa40e8a 984d4815
Cyphertext: 6a271787 ab8883f9
Cyphertext: 893d51ec 4b563b53
Plaintext : 4e6f7720 69732074
Plaintext : 68652074 696d6520
Plaintext : 666f7220 616c6c20
Finished  */
