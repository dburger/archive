#include <string.h>
#include "treeNode.h"

struct treeNode *insert(struct treeNode *tn, char *w) {
  int cmp;
  if (tn==NULL)
    tn = createTreeNode(w);
  else if ((cmp=strcmp(w,tn->word))<0)
    tn->left = insert(tn->left,w);
  else if (cmp>0)
    tn->right = insert(tn->right,w);
  else
    tn->count++;

  return tn;

}

struct treeNode *createTreeNode(char *w) {
  struct treeNode *newNode = 
    (struct treeNode *)malloc(sizeof(struct treeNode));
  newNode->word = strdup(w);
  newNode->count = 1;
  newNode->left = NULL;
  newNode->right = NULL;
  return newNode;
}

char *strdupx(char *w) {
  return strcpy((char *)malloc(strlen(w)+1),w);
}

void printTree(struct treeNode *root) {
  if (root!=NULL) {
    printTree(root->left);
    printf("%s\n",root->word);
    printTree(root->right);
  }
}

int countUniqueWords(struct treeNode *root) {
  if (root!=NULL)
    return 1 + countUniqueWords(root->left) + countUniqueWords(root->right);
}

int countWords(struct treeNode *root) {
  if (root!=NULL)
    return root->count + countWords(root->left) + countWords(root->right);
}

char *lastAlpha(struct treeNode *root) {
  char *leftLast;
  char *rightLast;
  char *theLast;
  if (root!=NULL) {
    leftLast = lastAlpha(root->left);
    rightLast = lastAlpha(root->right);
    if (strcmp(leftLast,rightLast)>0)
      theLast = leftLast;
    else
      theLast = rightLast;
    if (strcmp(root->word,theLast)>0)
      theLast = root->word;
    return theLast;
  } else
    return "";
}

int longest (struct treeNode *root) {
  int leftLongest = 0;
  int rightLongest = 0;
  int theLongest = 0;
  if (root!=NULL) {
    leftLongest = longest(root->left);
    rightLongest = longest(root->right);
    if (leftLongest>rightLongest)
      theLongest = leftLongest;
    else
      theLongest = rightLongest;
    if (strlen(root->word)>theLongest)
      theLongest = strlen(root->word);
  }
  return theLongest;
}
