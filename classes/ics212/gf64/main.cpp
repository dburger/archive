#include <stdio.h>
#include "GF64.h"

void main()
{
    GF64 a = 0x27, b = 0x19, one = 0x01, zero = 0;
    GF64 u, v, w;

    printf("a=%02x  b=%02x  one=%02x\n\n", 
        a.GetE(), b.GetE(), one.GetE());

    u = a+b; v = a+one; w = b+zero;
    printf("a+b=%02x  a+one=%02x  b+zero=%02x\n\n", 
        u.GetE(), v.GetE(), w.GetE());

    u = a*b; v = a*one; w = b*zero;
    printf("a*b=%02x  a*one=%02x  b*zero=%02x\n\n", 
        u.GetE(), v.GetE(), w.GetE());

    u = a.inv(); v = b.inv(); w = one.inv();
    printf("a.inv()=%02x  b.inv()=%02x  one.inv()=%02x\n\n", 
        u.GetE(), v.GetE(), w.GetE());

    w = a*b*u*v; u *= a; v *= b;
    printf("a*a.inv()=%02x  b*b.inv()=%02x  a*b*a.inv()*b.inv()=%02x\n\n", 
        u.GetE(), v.GetE(), w.GetE());

    u = a/b; v = b/a; w = u*v; 
    printf("a/b=%02x  b/a=%02x  (a/b)*(b/a)=%02x\n\n", 
        u.GetE(), v.GetE(), w.GetE());

    u = v= w = a;
    u += b; v *= b; w /= b;
    printf("a+=b =%02x  a*=b =%02x  a/=b =%02x\n\n", 
        u.GetE(), v.GetE(), w.GetE());

    u = a.power(30); v = a.power(33); w = u.inv();
    printf("a.power(30)=%02x  a.power(33)=%02x  a.power(30).inv()=%02x\n\n", 
        u.GetE(), v.GetE(), w.GetE());
    u = a.power(63);
    printf("a to power 63 = %02x\n\n", u.GetE());

    GF64 h, sum = 0, sumsq = 0,  product = 1 ;  
    for(h = 0; h!=64; h++) sum += h;
    printf("Sum of all elements=%02x\n\n", sum.GetE());
    for(h = 0; h!=64; h++) sumsq += h*h;
    printf("Sum of squares=%02x\n\n", sumsq.GetE());
    for(h = 1; h!=64; h++) product *= h;
    printf("Product of all non-zero elements=%02x\n\n", product.GetE());



    /* root checks for Dr. Peterson */
    GF64 checkForRoot, p;
    for (h=1;h!=64;h++) {
        checkForRoot = h;
        p = h.power(3) + h + 1;
        printf("%d:  %d\n", h.GetE(),p.GetE());
    }
    GF64 x1 = 7;
    GF64 x2 = 18;
    GF64 x3 = 21;
    GF64 res;
    res = x1 + x2 + x3;
    if (res.GetE()==0)
        printf("First test worked.\n");
    res = x1*x2 + x1*x3 + x2*x3;
    if (res.GetE()==1)
        printf("Second test worked.\n");
    res = x1*x2*x3;
    if (res.GetE()==1)
        printf("Third test worked.\n");

}

