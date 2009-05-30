#include <stdio.h>

/* huffman.h created for ICS 212 by
   David J. Burger.
   This file contains the structures and declarations
   needed to use the functions in huffman.c */

/* node structure designed for huffman binary tree */
struct node {
    unsigned char byte;
    int count;  /* no. of occurrances of this node */
    int codeword;  /* code word for this node      */
    int codelength;/* length of this code word     */
    struct node *left;
    struct node *right;
};

/* from huffman.c */
struct node *makeHuffmanTree(char *filename);
int byteCount(struct node *head);
void printCode(struct node *n);
int bitCount(struct node *n);
int totalCharCount(struct node *n);

/* from fileroutines.c */
void freqCount(char *filename, int b[], int s[]);




