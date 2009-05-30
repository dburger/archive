#include "node.h"

/*
 * node.cc by
 * David J. Burger
 * for ICS 212 under the guidance of
 * Dr. Peterson.
 * This file contains an implementation of
 * a Node class that can be used for a binary
 * search tree storing strings.  It also
 * contains several functions for reporting
 * the contents of the tree:
 *1) the word count
 *2) the letter count
 *3) the word list
 *4) printing words of a specified length
 */

/* 
 * basic constructor, the last three parameters
 * are optional and default to c=1, l=NULL,
 * and r=NULL
 */
Node::Node(char *w, int c, Node *l, Node *r) {
    word = dupstr(w);
    count = c;
    left = l;
    right = r;
}

/*
 * insert method for inserting a new word into the
 * binary search tree.
 */
Node *Node::insert(char *w) {
    int cmp;
    if (this==NULL) {
        return new Node(w);
    } else if((cmp=strcmp(w,getWord()))==0) {
        setCount(getCount()+1);
        return this;
    } else if(cmp<0) {
        setLeft(getLeft()->insert(w));
        return this;
    } else {
        setRight(getRight()->insert(w));
        return this;
    }
}

/*
 * character string duplication function
 */
char *dupstr(char *w) {
    return strcpy(new char[strlen(w)+1],w);
}

/*
 * character string conversion of upper case
 * chars to lower case chars within w
 */
char *tolower(char *w) {
    for (;*w!=0;w++)
        if (*w>='A' && *w<='Z') *w = *w - 'A' + 'a';
    return w;
}

/*
 * recursive printWordList function that does an
 * in-order traversal to print the words contained
 * in the binary search tree rooted at r in
 * alpha-order.
 */
void printWordList(Node *r) {
    if (r!=NULL) {
        printWordList(r->getLeft());
        printf("%5d:  %s\n", r->getCount(), r->getWord());
        printWordList(r->getRight());
    }
}

/*
 * recursive wordCount function that returns the count
 * of words in the tree rooted at r.
 */
int wordCount(Node *r) {
    if (r==NULL)
        return 0;
    else
        return r->getCount() + wordCount(r->getLeft()) + 
                               wordCount(r->getRight());
}

/*
 * recursive letterCount function that returns the count
 * of letters in the tree rooted at r.
 */
int letterCount(Node *r) {
    if (r==NULL)
        return 0;
    else return r->getCount()*strlen(r->getWord()) +
                letterCount(r->getLeft()) +
                letterCount(r->getRight());
}

/*
 * recursive longestLength function that returns the
 * length of the longest string in the tree rooted at
 * r.
 */
int longestLength(Node *r) {
    int longestLeft = 0;
    int longestRight = 0;
    int longerChild = 0;
    int thisLength = 0;
    if (r==NULL)
        return 0;
    else {
        longestLeft = longestLength(r->getLeft());
        longestRight = longestLength(r->getRight());
        thisLength = strlen(r->getWord());
        longerChild =(longestLeft > longestRight) ? longestLeft : longestRight;
        return (thisLength > longerChild) ? thisLength : longerChild;
    }
}

/*
 * recursive nprint function that prints all words of
 * length n in the tree rooted at r.
 */
void nprint(Node *r, int n) {
    if (r!=NULL) {
        nprint(r->getLeft(),n);
        if (strlen(r->getWord())==n)
            printf("%s\n",r->getWord());
        nprint(r->getRight(),n);
    }
}

/* this block contains a set of
   more advanced recursive functions
   I wrote while studying for the
   final

void printTree(TreeNode *root) {
  if (root!=NULL) {
    printTree(root->getLeft());
    printf("%s\n",root->getWord());
    printTree(root->getRight());
  }
}

int wordCount(TreeNode *root) {
  if (root==0)
    return 0;
  else
    return root->getCount() + wordCount(root->getLeft())
                            + wordCount(root->getRight());
}

int letterCount(TreeNode *root) {
  if (root==NULL)
    return 0;
  else
    return strlen(root->getWord())*root->getCount()
           + letterCount(root->getLeft())
           + letterCount(root->getRight());
}

int longestWordLen(TreeNode *root) {
  if (root==NULL)
    return 0;
  else {
    int longestLeft = longestWordLen(root->getLeft());
    int longestRight = longestWordLen(root->getRight());
    int theLongest = (longestLeft>longestRight) ? longestLeft : longestRight;
    if (strlen(root->getWord())>theLongest)
      theLongest = strlen(root->getWord());
    return theLongest;
  }
}

void nprint(TreeNode *root,int n) {
  if (root!=NULL) {
    nprint(root->getLeft(),n);
    if (strlen(root->getWord())==n)
      printf("%s\n",root->getWord());
    nprint(root->getRight(),n);
  }
}

int highestFrequency(TreeNode *root) {
  if (root==NULL)
    return 0;
  else {
    int freqLeft = highestFrequency(root->getLeft());
    int freqRight = highestFrequency(root->getRight());
    int theMost = (freqLeft>freqRight) ? freqLeft : freqRight;
    if (root->getCount()>theMost)
      theMost = root->getCount();
    return theMost;
  }
}

TreeNode *highFreqNode(TreeNode *root) {
  if (root==NULL)
    return NULL;
  else {
    TreeNode *highLeft = highFreqNode(root->getLeft());
    TreeNode *highRight = highFreqNode(root->getRight());
    TreeNode *theHighest = NULL;
    if (highLeft!=NULL && highRight!=NULL)
      if (highLeft->getCount()>highRight->getCount())
        theHighest = highLeft;
      else
        theHighest = highRight;
    else if (highRight==NULL)
      theHighest = highLeft;
    else if (highLeft==NULL)
      theHighest = highRight;

    if (theHighest==NULL || root->getCount()>theHighest->getCount())
      theHighest = root;

    return theHighest;

  }
}


char *longestWord(TreeNode *root) {
  if (root==NULL)
    return NULL;
  else {
    char *leftLongest = longestWord(root->getLeft());
    char *rightLongest = longestWord(root->getRight());
    char *theLongest = NULL;
    if (leftLongest!=NULL && rightLongest!=NULL)
      if (strlen(leftLongest)>strlen(rightLongest))
        theLongest = leftLongest;
      else
        theLongest = rightLongest;
    else if (rightLongest==NULL)
      theLongest = leftLongest;
    else if (leftLongest==NULL)
      theLongest = rightLongest;

    if (theLongest==NULL || strlen(root->getWord())>strlen(theLongest))
      theLongest = root->getWord();

    return theLongest;

  }

}

char *lastAlpha(TreeNode *root) {
  if (root==NULL)
    return NULL;
  else
    if (root->getRight()==NULL)
      return root->getWord();
    else
      return lastAlpha(root->getRight());
}


*/








