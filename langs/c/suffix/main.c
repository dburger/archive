/* suffix tree from pearls */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int mycomp(const void *a, const void *b) {
  char *x = *(char * const *)a;
  char *y = *(char * const *)b;
  return strcmp(x,y);
}

int main(int argc, char *argv[]) {
  int buff_size=10,suff_size=200,n=0,w=0,c,i,last=' ';
  char *buff=(char *)malloc(buff_size);
  char *suff[suff_size];
  while ((c=getc(stdin))!=EOF) {
    buff[n]=c;
    if (last==' ' && c!=' ')
      suff[w++]=buff+n;
    last=c;
    if (++n==buff_size) {
      buff_size*=2;
      realloc(buff,buff_size);
    }
  }
  buff[n]=0;
  qsort(suff,w,sizeof(char *),mycomp);
  for (i=0;i<w;i++)
    printf("%d: %s\n",i,suff[i]);
} 


