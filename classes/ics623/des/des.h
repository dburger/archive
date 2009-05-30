#include <stdio.h>
#define F 0
#define T 1
#define TEST F
extern char s[16][64];
extern unsigned long lkey[17];
extern unsigned long rkey[17];
extern unsigned long lk, rk;

void ip(unsigned long li, unsigned long ri, 
        unsigned long *lo, unsigned long *ro);
void ipinv(unsigned long li, unsigned long ri, 
           unsigned long *lo, unsigned long *ro);
void e(unsigned long ri, unsigned long *lo, unsigned long *ro);
unsigned long p(unsigned long li);
void pc1(unsigned long li, unsigned long ri, 
         unsigned long *lo, unsigned long *ro);
void pc2(unsigned long li, unsigned long ri, 
         unsigned long *lo, unsigned long *ro);
void keycalc(void);
long f(unsigned long, int);

void desc(unsigned long lc, unsigned long rc, 
		  unsigned long *le, unsigned long *re);
void desd(unsigned long le, unsigned long re, 
		  unsigned long *ld, unsigned long *rd);
