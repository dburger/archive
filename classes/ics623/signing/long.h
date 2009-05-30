typedef unsigned long UL;

int add(UL *a, UL *b, int c);
int sub(UL *a, UL *b, int c);
int shl(UL *a, int b);

int mcmp(UL *a, UL *b);
void madd(UL *a, UL *b, UL *P);
void msub(UL *a, UL *b, UL *P);
void mshl(UL *a, UL *P);
void mexp(UL *a, UL *b, UL *result, UL *P);
void mmult(UL *a, UL *b, UL *result, UL *P);
void zeroUL(UL *a, int size);

int lehman_prime(UL *p, UL *s);
int divides(UL *a, UL b);
void copyUL(UL *a, UL *b, int size);
