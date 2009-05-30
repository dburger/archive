/* This does the ECB example from the FIPS standard  */
/* document "DES Modes of Operation. (P. 13)     WP  */ 
#include "des.h"

unsigned long lk = 0x01234567;    /* key  */
unsigned long rk = 0x89abcdef;

unsigned long lkey[17];  /* calculated key schedule */
unsigned long rkey[17];

/* cleartext is "Now is the time for all "*/
unsigned long lc[3] = {0x4e6f7720, 0x68652074, 0x666f7220};
unsigned long rc[3] = {0x69732074, 0x696d6520, 0x616c6c20};
unsigned long le[3], re[3];              /* ciphertext */
unsigned long ld[3], rd[3];   /* deciphered ciphertext */

unsigned long l, r;
void main(void) 
{
	int i;
	keycalc();  //calculate the 16 keys

    printf("Enciphering\n");
	for(i = 0; i<3; i++) desc(lc[i], rc[i], &le[i], &re[i]);

	printf("Key:        %08x %08x\n", lk, rk);
	for(i = 0; i<3; i++) printf("PlainText:  %08x %08x\n", lc[i], rc[i]);
	for(i = 0; i<3; i++) printf("Cyphertext: %08x %08x\n", le[i], re[i]);

	printf("\n\nDeciphering\n");
	for(i = 0; i<3; i++) desd(le[i], re[i], &ld[i], &rd[i]);
	printf("Key:        %08x %08x\n", lk, rk);
	for(i = 0; i<3; i++) printf("Cyphertext: %08x %08x\n", le[i], re[i]);
	for(i = 0; i<3; i++) printf("Plaintext : %08x %08x\n", ld[i], rd[i]);

	printf("Finished\n");
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
