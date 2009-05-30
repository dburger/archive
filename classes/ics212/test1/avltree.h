struct TreeNode {
    char *word;
    int height;
    struct TreeNode *parent;
    struct TreeNode *left;
    struct TreeNode *right;
};

struct TreeNode *insert(struct TreeNode *r, char *w);

struct TreeNode *initTreeNode(char *w, int h, struct TreeNode *p,
                              struct TreeNode *l,
			      struct TreeNode *r);
char *dupstr(char *s);

void printAVLTree(struct TreeNode *r);
