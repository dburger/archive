#include "huffman.h"

/* huffman.c created for ICS 212 by
   David J. Burger.
   This file contains the functions necessary
   to perform huffman tree computations. */

/* this function encodes a huffman tree by
   adding the proper codeword and codelength.
   Input:  huffman tree rooted at node n
   Ouput:  properly encoded huffman tree */

void makeCode(struct node *n) {                           
    if (n!=NULL && !isLeaf(n)) {                          
        n->left->codelength = n->codelength + 1;          
        n->right->codelength = n->codelength + 1;         
        n->left->codeword = n->codeword;                  
        n->right->codeword = n->codeword;                 
        n->right->codeword |= (0x800000 >> n->codelength);
        makeCode(n->left);                                
        makeCode(n->right);                               
    }                                                     
}                                                         

/* this function creates and returns a node
   for a huffman tree.
   Input:  initialization values for the node
   Output:  huffman node initialized to passed
           in values. */

struct node *nodeInit(unsigned char byte, int count, int codeword, \
                      int codelength, struct node *left, struct node * right) {
    struct node *newNode = (struct node *)malloc(sizeof(struct node));  
    newNode->byte = byte;
    newNode->count = count;
    newNode->codeword = codeword;
    newNode->codelength = codelength;
    newNode->left = left;
    newNode->right = right;
    return newNode;
}

/* this function creates the huffman tree for a
   given file.
   Input:  the filename of the file to create the
           huffman tree for.
   Output: the root node of the huffman tree. */

struct node *makeHuffmanTree(char *filename) {

    /* used for loops */
    int i,j;

    /* the array for the byte count */
    int b[256];

    /* the array to hold the byte value */
    int s[256];

    /* the array to hold the nodes as the
       huffman tree is calculated */
    struct node *n[256];

    /* a working node */
    struct node *tempNode;

    /* compute the freqCount for the file */
    freqCount(filename, b, s);

    i = 0;

    /* fill the array of pointers to node structures
       representing the bytes */
    while(b[i]!=0) {
        n[i] = nodeInit(s[i],b[i],0,0,NULL,NULL);
        i++;
    }

    /* point i back to the second to last valid position */
    i-=2;

    while (i>=0) {
        /* make a temporary node point to the last two nodes
           in the array */
        tempNode = nodeInit(0,n[i]->count + n[i+1]->count,0,0,n[i],n[i+1]);
        /* remove the last two node from the array */
        n[i] = NULL;
        n[i+1] = NULL;
        /* point i back to the last node left in the array */
        i--;
        /* insert the temporary node in sorted  position according
           to count */
        j=i;
        while(j>=0 && (n[j]->count < tempNode->count)) {
            n[j+1] = n[j];
            j--;
        }
        
        /* correct position for the node is j+1 */
        n[j+1] = tempNode;
    }

    makeCode(tempNode);

    return tempNode;

}

/* this function determines whether or
   not a node from a huffman tree is a
   leaf.
   Input:  node n
   Output: true(1) for a leaf, false(0) otherwise */

int isLeaf(struct node *n) {
    if (n->left!=NULL)
        return 0;
    else
        return 1;
}

/* this function returns the number of leaf nodes,
   which is the number of unique bytes, in the
   huffman tree rooted at node n
   Input:  node n the root of the huffman tree
   Output: the number of leaves (unique bytes) in
           the tree */
int byteCount(struct node *n) {
    if (isLeaf(n))
        return 1;
    else
        return byteCount(n->left) + byteCount(n->right);
}

/* this function returns the total number of characters
   in the original file.
   Input:  root node n of the huffman tree
   Output: the total number of characters in the file  */
int totalCharCount(struct node *n) {
    if (isLeaf(n))
        return n->count;
    else
        return totalCharCount(n->left) + totalCharCount(n->right);
}

/* this method prints the individual bits for
   a huffman codeword
   Input:  the node n that you want the bits for
   Output: the bits of the codeword are sent to 
           stdout */
void printBits(struct node *n) {
    int i, bit = 0x800000;
    for (i=0;i < n->codelength;i++,bit=bit>>1) {
        if (n->codeword & bit)
            printf("1");
        else
            printf("0");
    }
}

/* this function prints out the codes for all
   characters encoded by the huffman tree
   Input:  root node n of the huffman tree
   Output: the huffman codes are sent to stdout */
void printCode(struct node *n) {
    if (isLeaf(n)) {
        if ((n->byte>=32) && (n->byte<=126))
            printf("%3x(%c) %10d  ",n->byte,n->byte,n->count);
        else
            printf("%3x( ) %10d  ",n->byte,n->count);
        printBits(n);
        printf("\n");
    } else {
        printCode(n->left);
        printCode(n->right);
    }
}

/* this function returns the number of bits
   necessary to encode the file using the
   huffman encoding
   Input:  root node n of the huffman tree
   Output: the bitcount for the compressed
           file */
int bitCount(struct node *n) {
    if (isLeaf(n))
        return n->codelength * n->count;
    else
        return bitCount(n->left) + bitCount(n->right);
}



