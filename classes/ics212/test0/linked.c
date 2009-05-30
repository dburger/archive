#include "linked.h"
#include <string.h>

struct Node *initNode(char *s) {
    struct Node *aNode = (struct Node *)malloc(sizeof(struct Node));
    aNode->word = strdupx(s);
    aNode->prev = NULL;
    aNode->next = NULL;
}
