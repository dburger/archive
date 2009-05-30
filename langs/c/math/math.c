#include <stdio.h>
#include <math.h>
#include "math.h"

long gcd(long a, long b) {
  long rem = a % b;
  while(rem!=0) {
    a = b;
    b = rem;
    rem = a % b;
  }
  return b;
}

int relPrime(long a, long b) {
  return gcd(a,b)==1;
}

int isPrime(long a) {
  long maxCheck=sqrt(a);
  long sieve[maxCheck+1];
  long i,prime;
  /* zero and one not prime */
  if (a==0 || a==1) return 0;
  sieve[0]=sieve[1]=0;
  /* assume prime */
  for (i=2;i<=maxCheck;i++) sieve[i]=1;
  prime=2;
  while(prime<=maxCheck) {
    if (a%prime==0) return 0;
    /* mark all multiples of our prime as not prime */
    i=2;
    while (i*prime<=maxCheck) sieve[i++*prime]=0;
    /* find the next prime to check */
    while (prime<=maxCheck && sieve[++prime]==0);
  }
  return 1;
}

long fact(long a) {
  int res=1;
  while(a>1)
    res=res*a--;
  return res;
}

long nCr(long n, long r) {
  return nPr(n,r)/fact(r);
}

long nPr(long n, long r) {
  return fact(n)/fact(n-r);
}
