#include <string.h>
#include "avltree.h"

struct TreeNode *insert(struct TreeNode *r, char *w) {
  if (r==NULL) {
    r = initTreeNode(w,0,NULL,NULL,NULL);
  } else if (strcmp(w,r->word)<0) {
    r->left = insert(r->left,w);
  } else {
    r->right = insert(r->right,w);
  }
  return r;
}

struct TreeNode *initTreeNode(char *w, int h, struct TreeNode *p,
                              struct TreeNode *l,
			      struct TreeNode *r) {
  struct TreeNode *tn = (struct TreeNode *)malloc(sizeof(struct TreeNode));
  tn->word = dupstr(w);
  tn->height = h;
  tn->parent = p;
  tn->left = l;
  tn->right = r;
  return tn;
}

char *dupstr(char *s) {
  return strcpy((char *)malloc(strlen(s)+1),s);
}

void printAVLTree(struct TreeNode *r) {
  if (r!=NULL) {
    printAVLTree(r->left);
    printf("%s\n",r->word);
    printAVLTree(r->right);
  }
}





