#include <stdio.h>
#include <string.h>
#include "linked.h"

int main(int argc,char *argv[]) {

    struct Node *aNode = initNode("pasta");

}

char *strdupx(char *s) {
    return strcpy((char *)malloc(strlen(s)+1),s);
}
