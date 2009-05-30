struct treeNode {
  char *word;
  int count;
  struct treeNode *left;
  struct treeNode *right;
};

struct treeNode *insert(struct treeNode *tn, char *w);

struct treeNode *createTreeNode(char *w);

char *strdupx(char *w);

void printTree(struct treeNode *root);

int countUniqueWords(struct treeNode *root);

int countWords(struct treeNode *root);

char *lastAlpha(struct treeNode *root);

int longest(struct treeNode *root);

