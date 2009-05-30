#include <stdio.h>
#include <string.h>

/*
 * node.h by
 * David J. Burger
 * for ICS 212 under the guidance of
 * Dr. Peterson
 *
 * This file contains the declarations for
 * the Node class and functions that operate
 * on a binary search tree.
 */

char *dupstr(char *w);

char *tolower(char *w);

class Node {
    char *word;
    int count;
    Node *left;
    Node *right;
public:
    Node(char *w, int c=1,Node *l=NULL, Node *r=NULL);
    Node *insert(char *w);    
    char *getWord() {return word;};
    void setWord(char *w) {word = dupstr(w);};
    int getCount() {return count;};
    void setCount(int c) {count = c;};
    Node *getLeft() {return left;};
    void setLeft(Node *l) {left = l;};
    Node *getRight() {return right;};
    void setRight(Node *r) {right = r;};
};

void printWordList(Node *r);

int wordCount(Node *r);

int letterCount(Node *r);

int longestLength(Node *r);

void nprint(Node *r, int n);
