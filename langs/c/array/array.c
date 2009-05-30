#include <stdio.h>

void arrayrev(char *a, int size) {

  int i;
  char temp;
  if (size<=0) return;
  for (i=0;i<=size/2;i++) {
    temp = a[i];
    a[i] = a[size-1-i];
    a[size-1-i] = temp;
  }

}

void arrayshr(char *a, int size, int shift) {

  arrayrev(a,shift);
  arrayrev(a+shift,size-shift);
  arrayrev(a,size);

}

void arrayprn(char *a, int size) {

  int i;
  for (i=0;i<size;i++)
    printf("%c",a[i]);
  printf("\n");

}

int main(int argc, char *argv) {

  char stuff[] = "abcdefghij";
  arrayprn(stuff, 10);
  arrayshr(stuff, 10, 3);
  arrayprn(stuff, 10);

}
