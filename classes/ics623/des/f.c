/* This calculates the function f defined in  */
/* figure 2 of the ANSI standard for DES. The */
/* first parameter is R and the second is the */
/* round number to identify which key to use. */

#include "des.h"

long f(unsigned long r, int i)
{
	unsigned long lr, rr, rt, sint, soutt;

	e(r, &lr, &rr);

	lr ^= lkey[i];
	rr ^= rkey[i];

    sint = lr>>26;   /* first 6 bits */
	soutt = s[0][sint];
    rt = soutt;

    sint = (lr>>20)&0x3f; /* 2nd 6 bits */
	soutt = s[1][sint];
	rt = (rt<<4)|soutt;

    sint = (lr>>14)&0x3f; /* 3rd 6 bits */
	soutt = s[2][sint];
	rt = (rt<<4)|soutt;

    sint = (lr>>8)&0x3f; /* 4th 6 bits */
	soutt = s[3][sint];
	rt = (rt<<4)|soutt;

    sint = (rr>>26)&0x3f; /* 5th 6 bits */
	soutt = s[4][sint];
	rt = (rt<<4)|soutt;

    sint = (rr>>20)&0x3f; /* 6th 6 bits */
	soutt = s[5][sint];
	rt = (rt<<4)|soutt;

    sint = (rr>>14)&0x3f; /* 7th 6 bits */
	soutt = s[6][sint];
	rt = (rt<<4)|soutt;

    sint = (rr>>8)&0x3f; /* 8th 6 bits */
	soutt = s[7][sint];
	rt = (rt<<4)|soutt;
    
	if(TEST) printf("Sin:%08x %08x Sout:%08x\n",
		lr, rr, rt);
    return p(rt);
}
