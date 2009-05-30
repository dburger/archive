#include "des.h"

/* The following calculates the sixteen  */
/* pairs of keys, placing them in lkey[] */
/* and rkey[].                           */

unsigned long lshift(unsigned long a)
/* rotate the high order 28 bits of a    */
/* left one position                     */
{
	return (a<<1) | ((a>>27)&0x10);
}

void keycalc(void)
{
	unsigned long c, d;

	pc1(lk, rk, &c, &d);
	c = lshift(c);
	d = lshift(d);
	pc2(c, d, lkey+1, rkey+1);
	c = lshift(c);
	d = lshift(d);
	pc2(c, d, lkey+2, rkey+2);
	c = lshift(lshift(c));
	d = lshift(lshift(d));
	pc2(c, d, lkey+3, rkey+3);
	c = lshift(lshift(c));
	d = lshift(lshift(d));
	pc2(c, d, lkey+4, rkey+4);
	c = lshift(lshift(c));
	d = lshift(lshift(d));
	pc2(c, d, lkey+5, rkey+5);
	c = lshift(lshift(c));
	d = lshift(lshift(d));
	pc2(c, d, lkey+6, rkey+6);
	c = lshift(lshift(c));
	d = lshift(lshift(d));
	pc2(c, d, lkey+7, rkey+7);
	c = lshift(lshift(c));
	d = lshift(lshift(d));
	pc2(c, d, lkey+8, rkey+8);
	c = lshift(c);
	d = lshift(d);
	pc2(c, d, lkey+9, rkey+9);
	c = lshift(lshift(c));
	d = lshift(lshift(d));
	pc2(c, d, lkey+10, rkey+10);
	c = lshift(lshift(c));
	d = lshift(lshift(d));
	pc2(c, d, lkey+11, rkey+11);
	c = lshift(lshift(c));
	d = lshift(lshift(d));
	pc2(c, d, lkey+12, rkey+12);
	c = lshift(lshift(c));
	d = lshift(lshift(d));
	pc2(c, d, lkey+13, rkey+13);
	c = lshift(lshift(c));
	d = lshift(lshift(d));
	pc2(c, d, lkey+14, rkey+14);
	c = lshift(lshift(c));
	d = lshift(lshift(d));
	pc2(c, d, lkey+15, rkey+15);
	c = lshift(c);
	d = lshift(d);
	pc2(c, d, lkey+16, rkey+16);
}









