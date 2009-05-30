
#include "des.h"

unsigned long lkey[17];
unsigned long rkey[17];

unsigned long l, r;

/* DES encipher. lc-rc is the plaintext and    */
/* le-re point to the ciphertext.              */
void desc(unsigned long lc, unsigned long rc, 
		  unsigned long *le, unsigned long *re)
{
    unsigned long l, r, s, t;
	int i;
	/* Encipher */
    ip(lc, rc, &l, &r);
	for(i = 1; i<=16; i++) {
    	if(TEST) printf("Starting step %d L=%08x R=%08x K%d=%08x %08x\n",
		    i, l, r, i, lkey[i], rkey[i]);
		t = f(r, i);
		s = r;
		r = t^l;
		l = s;
		if(TEST) printf("f(R,K)=%08x\n", t);
		if(TEST) printf("after step %d    L=%08x R=%08x\n\n", i, l, r);
    }
	ipinv(r, l, le, re);
}

/* DES Decipher. le-re is the ciphertext and   */
/* ld-rd is the deciphered plaintext.          */
void desd(unsigned long le, unsigned long re, 
		  unsigned long *ld, unsigned long *rd)
{
    unsigned long l, r, s, t;
	int i;
	/* Decipher */
    ip(le, re, &r, &l);
	for(i = 16; i>0; i--) {
    	if(TEST) printf("Starting step %d L=%08x R=%08x K%d=%08x %08x\n",
		    i, l, r, i, lkey[i], rkey[i]);
		t = f(l, i);
		s = l;
		l = t^r;
		r = s;
		if(TEST) printf("f(R,K)=%08x\n", t);
		if(TEST) printf("after step %d    L=%08x R=%08x\n\n", i, l, r);
    }
    ipinv(l, r, ld, rd);
}

 
