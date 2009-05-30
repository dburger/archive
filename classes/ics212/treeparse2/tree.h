#include <string.h>
#include "node.h"

class Tree {
    Node *root;
    int count;
    void printWordList(Node *r);
    int wordCount(Node *r);
    int letterCount(Node *r);
    int longestLength(Node *r);
    void nprint(Node *r, int n);
public:
    Tree();
    void insert(char *w);
    void printWordList();
    int wordCount();
    int letterCount();
    int longestLength();
    void nprint(int n);
};
