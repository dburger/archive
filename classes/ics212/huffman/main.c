#include "huffman.h"

/* main.c created for ICS 212 by
   David J. Burger.
   This file contains the program that shows
   the huffman encoding for a given file.

   Creation date:  01/30/01
   Last modified:  02/10/01 */

/* the main entry point for the program.
   Input:  command line parameter, the name of the
           file you would like to see the huffman
           encoding for.
   Output: the bit codes for the characters in the
           file and various statistics are sent to
           stdout */
int main(int argc, char *argv[]) {

    /* the head node of the huffman tree that will be returned */
    struct node *n;

    int bitcount, totalchars;

    /* check to make sure they have provided a filename */
    if (argc<2) {
        printf("Proper usage is %s filename.\n",argv[0]);
        exit(0);
    }

    /* create the huffman tree, the root node is returned */
    n = makeHuffmanTree(argv[1]);

    /* n will be NULL if they call this on an empty file */
    if (n!=NULL) {
        printCode(n);
        /* calculate the total number of bits used in the
           compressed version */
        bitcount = bitCount(n);
        /* the total number of characters in the original file */
        totalchars = totalCharCount(n);

        printf("Number of characters = %d.\n",totalchars);
        printf("Average bits per character = %.6f.\n", \
                (double)bitcount/totalchars);
        printf("Number of unique bytes = %d.\n",byteCount(n));

        printf("Compressed file size = %d bits (%d bytes).\n", \
                bitcount,(bitcount+7)/8);
    } else {
        printf("%s is apparently an empty file, no compression necessary.\n", \
                argv[1]);
    }

}





