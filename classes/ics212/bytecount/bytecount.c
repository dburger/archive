#include <stdio.h>

/*
    01/24/01
    bytecount.c by David J. Burger for ICS 212
    This program reports the frequency distribution
    of the bytes in a file in a table format.
    It is called like this:
    bytecount filename
*/

void modbubblesort(int a[], int b[], int n);

int main(int argc, char *argv[]) {

    int c, i, nchars=0;
    FILE *fp;

    /* b, the array that will keep track of the byte
       counts and s an array that will be used for
       sorting purposes */
    int b[256], s[256];

    /* check to see if they provided a source file */ 
    if (argc<2) {
        printf("Proper use is %s filename.\n", argv[0]);
        exit(0);
    }

    /* attempt to open the source file */
    fp = fopen(argv[1], "rb");
    if (fp==NULL) {
        printf("Could not open %s.\n",argv[1]);
        exit(0);
    }

    /* initialize the arrays */
    for (i=0;i<256;i++) b[i]=0;
    for (i=0;i<256;i++) s[i]=i;

    /* read the character data and keep track in b */
    while((c=getc(fp))!=EOF) {
        b[c]++;
        nchars++;
    }

    fclose(fp);

    /* sort the array of byte counts and perform the same swaps
       on array s to keep track of which byte value has what count */
    modbubblesort(b,s,256);



    /* this is the routine that outputs the results. */
    i = 0;
    while (i<=255 && b[i]>0) {
        if ((s[i]>=32) && (s[i]<=126))
            printf("%3d(%c) %d",s[i],s[i],b[i]);
        else
            printf("%3d    %d",s[i],b[i]);
        if ((i%4)==3 || b[i+1]==0)
            putchar('\n');
        else
            putchar('\t');
        i++;
    }

    printf("Total number of characters = %d.\n", nchars);
}

/* a modified bubblesort routine, modified to accept
   a second array that it performs the same swaps on
   while it sorts according to the values in the first
   array. This bubble sort sorts in descending order. */
void modbubblesort(int a[], int b[], int n) {

    int sorted = 0;
    int i, pass, temp;

    for (pass=1;(pass<n) && !sorted;++pass) {
        sorted = 1;
        for (i=0;i<n-pass;i++)
	    if (a[i]<a[i+1]) {
                temp = a[i];
                a[i] = a[i+1];
                a[i+1] = temp;

                temp = b[i];
                b[i] = b[i+1];
                b[i+1] = temp;
                sorted = 0;
            }
    }
}
    
    







