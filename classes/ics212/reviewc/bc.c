#include <stdio.h>

struct ByteData {
  int theByte;
  int byteCount;
};

void sort(struct ByteData bd[], int left, int right);

void swap(struct ByteData bd[], int i, int j);

int main(int argc, char *argv[]) {


    int c,n;
    FILE *fp;
    struct ByteData theBytes[256];

    if (argc<2) {
      printf("Proper usage is %s filename.\n",argv[0]);
      exit(0);
    }

    if (!(fp=fopen(argv[1],"rb"))) {
      printf("Unable to open input file %s.\n",argv[1]);
      exit(0);
    }

    for (n=0;n<256;n++) {
      theBytes[n].theByte = n;
      theBytes[n].byteCount = 0;
    }

    while((c=getc(fp))!=EOF)
      theBytes[c].byteCount++;


    sort(theBytes,0,255);

    for (n=0;n<256;n++) {
      printf("%c  %3d\n",theBytes[n].theByte,theBytes[n].byteCount);
    }

}

void sort(struct ByteData bd[], int left, int right) {
    int i,last;
    if (left >= right)
      return;
    swap(bd,left,(left+right)/2);
    last = left;
    for (i=left+1;i<=right;i++)
      if (bd[i].byteCount<bd[left].byteCount)
        swap(bd,++last,i);
    swap(bd,left,last);
    sort(bd,left,last-1);
    sort(bd,last+1,right);
}

void swap(struct ByteData bd[], int i, int j) {
    struct ByteData temp = bd[i];
    bd[i] = bd[j];
    bd[j] = temp;
}










