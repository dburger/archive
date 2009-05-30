#include <stdio.h>

typedef unsigned long UL;

#define BITS_PER_WORD 32
#define BPW_2_POWER 5
#define MAX_VAL 10000000
#define ELMS 1 + MAX_VAL / 32 

// need to get rid of these fives
void clear(UL *a, int num) {
  a[num>>BPW_2_POWER] &= ~(0x80000000>>(num%BITS_PER_WORD));
}

void set(UL *a, int num) {
  a[num>>BPW_2_POWER] |= (0x80000000>>(num%BITS_PER_WORD));
}

int get(UL *a, int num) {
  return (a[num>>BPW_2_POWER] & (0x80000000>>(num%BITS_PER_WORD)));
}

int main(int argc, char *argv[]) {

  #define BUFF_SIZE 20

  FILE *fp;
  char inbuffer[BUFF_SIZE];
  UL nums[ELMS];
  int i, j, num, element, bit;
  
  if (argc<3) {
    printf("Program usage is %s source destination\n",argv[0]);
    exit(0);
  }

  if ((fp=fopen(argv[1],"r"))==NULL) {
    printf("Unable to open %s.\n",argv[1]);
    exit(0);
  }

  for (i=0;i<MAX_VAL;i++)
    clear(nums,i);

  while ((fgets(inbuffer,BUFF_SIZE,fp)!=NULL)) {
    num = atoi(inbuffer);
    set(nums,num);
  }

  // iterate through the array writing out the file
  for (i=0;i<MAX_VAL;i++)
    if (get(nums,i))
      printf("%d\n",i);

  fclose(fp);
  
}
