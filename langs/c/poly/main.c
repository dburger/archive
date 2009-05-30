#include <stdio.h>

int evalpoly(int x, int p[], int len) {
  int sum=0;
  while (--len>=0) {
    sum*=x;
    sum+=p[len];
    printf("sum is %d\n",sum);
  }
  return sum;
}

int main(int argc, char *argv[]) {
  int p[] = {1,2,3};
  int res = evalpoly(atoi(argv[1]),p,3);
  printf("the result is %d\n",res);
}



