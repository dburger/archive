#include <stdio.h>

struct byteCount {
    int byte;
    int count;
};

void qsort(struct byteCount *bc[], int left, int right);

int main(int argc, char *argv[]) {

    int c, i;
    FILE *fp;
    struct byteCount *bc[256];

    if (argc < 2) {
      printf("Proper usage is %s filename\n",argv[0]);
      exit(0);
    }

    fp = fopen(argv[1], "rb");
    if (fp==NULL) {
        printf("Unable to open %s\n",argv[1]);
        exit(0);
    }

    for (i=0;i<256;i++) {
        bc[i] = (struct byteCount *)malloc(sizeof(struct byteCount));
        bc[i]->count = 0;
        bc[i]->byte = i;
    }

    while((c=getc(fp))!=EOF) {
        bc[c]->count++;
    }

    fclose(fp);

    qsort(bc,0,255);

    for (i=0;i<256 && bc[i]->count!=0;i++) {
        printf("%3d -- %3d",bc[i]->byte,bc[i]->count);
        if ((i%4)==3 || bc[i+1]->count==0)
            putchar('\n');
        else
            putchar('\t');
    }

}

void qsort(struct byteCount *bc[], int left, int right) {
    int i, last;
    void swap(struct byteCount *bc[], int i, int j);

    if (left>=right)
        return;
    swap(bc,left,(left + right)/2);
    last = left;
    for (i=left+1;i<=right;i++)
        if (bc[i]->count > bc[left]->count)
            swap(bc,++last,i);
    swap(bc,left,last);
    qsort(bc,left,last-1);
    qsort(bc,last+1,right);
}

void swap(struct byteCount *bc[], int i, int j) {
    struct byteCount *temp_bc = bc[i];
    bc[i] = bc[j];
    bc[j] = temp_bc;
}
