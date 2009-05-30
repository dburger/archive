#include <stdio.h>

int main(int argc, char *argv[]) {

  int *p;

  p = (int *)malloc(sizeof(int));

  *p = 17;

  printf("The number is %d\n",*p);

}
