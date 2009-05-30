
struct Node {
    char *word;
    struct Node *prev;
    struct Node *next;
};

struct Node *initNode(char *s);

char *strdupx(char *s);
