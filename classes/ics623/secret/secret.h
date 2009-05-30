typedef unsigned long ul;

void zeroUL(ul *a, int size);
void copyUL(ul *a, ul *b, int size);
void makedegpolyx(ul *a, ul *result, int size);
void shlx(ul *a, int size, int c);
void shrx(ul *a, int size, int c);
void xorx(ul *a, ul *b, ul *result, int size);
int andx(ul *a, ul *b, int size);
void multXgfx(ul *a, ul *m, ul *result, int size);
void addgfx(ul *a, ul *b, ul *result, int size);
void multgfx(ul *a, ul *b, ul *m, ul *result, int size);
