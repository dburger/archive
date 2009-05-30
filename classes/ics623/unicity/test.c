#include <stdio.h>

int main(int argc, char *argv[]) {

  char key[] = {65,66,67,68,69,70,71,72};
  int n,j,k,r,s,temp;
  while (1) {
  n = 7;
  j = n-1;
  while (key[j]>key[j+1])
    j-=1;

  k=n;

  while (key[j]>key[k])
    k-=1;

  r=n;
  s=j+1;
  temp=key[k];
  key[k]=key[j];
  key[j]=temp;

  while (r>s) {
    temp = key[r];
    key[r] = key[s];
    key[s] = temp;
    r-=1;
    s+=1;
  }

  printf("%c %c %c %c %c %c %c %c %c %c %c\n",key[0],key[1],key[2],key[3],
         key[4],key[5],key[2],key[5],key[6],key[7],key[2]);

  }
}












