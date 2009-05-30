#include "tree.h"

Tree::Tree() {
    root=NULL;
    count=0;
}

void Tree::insert(char *w) {
    int cmp;
    int inserted = 0;
    Node *np = root;
    while(!inserted) {
        if (np==NULL) {
            np = new Node(w);
            root = np;
            count++;
            inserted = 1;
        } else if ((cmp=strcmp(w,np->getWord()))==0) {
                np->setCount(np->getCount()+1);
                inserted=1;
	} else if(cmp<0) {
            if (np->getLeft()==NULL) {
                np->setLeft(new Node(w));
                count++;
                inserted=1;
            } else
                np = np->getLeft();
	} else {
	    if (np->getRight()==NULL) {
                np->setRight(new Node(w));
                count++;
                inserted=1;
            } else
                np = np->getRight();
	}
    }
}

void Tree::printWordList() {
    printWordList(root);
}

void Tree::printWordList(Node *r) {
    if (r!=NULL) {
        printWordList(r->getLeft());
        printf("%5d:  %s\n",r->getCount(),r->getWord());
        printWordList(r->getRight());
    }
}

int Tree::wordCount() {
    return wordCount(root);
}

int Tree::wordCount(Node *r) {
    if (r==NULL)
        return 0;
    else
        return wordCount(r->getLeft()) + r->getCount()
                                       + wordCount(r->getRight());
}

int Tree::letterCount() {
    return letterCount(root);
}

int Tree::letterCount(Node *r) {
    if (r==NULL)
        return 0;
    else
        return letterCount(r->getLeft())
               + strlen(r->getWord()) * r->getCount()
               + letterCount(r->getRight());
}
    

int Tree::longestLength() {
    return longestLength(root);
}

int Tree::longestLength(Node *r) {
    int longestLeft;
    int longestRight;
    int len;
    if (r==NULL)
        return 0;
    else {
        longestLeft = longestLength(r->getLeft());
        longestRight = longestLength(r->getRight());
        longestLeft = longestLeft > longestRight ? longestLeft : longestRight;
        len = strlen(r->getWord());
        return len > longestLeft ? len : longestLeft;
    }
}
 
void Tree::nprint(int n) {
    nprint(root,n);
}

void Tree::nprint(Node *r,int n) {
    if (r!=NULL) {
        nprint(r->getLeft(),n);
        if (strlen(r->getWord())==n)
            printf("%s\n",r->getWord());
        nprint(r->getRight(),n);
    }
}
