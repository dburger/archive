#include <stdio.h>
#include <string.h>

#include "treeNode.h"

#define MAX_LINE 100
#define DELIM " ,();{}\t\n\"!=.\\[]"

int main(int argc, char *argv[]) {

  char line[MAX_LINE];
  char *tok;
  FILE *ifp;
  struct treeNode *root = NULL;

  if (argc<2) {
    printf("Proper usage is %s filename.\n",argv[0]);
    exit(0);
  }

  if (!(ifp=fopen(argv[1],"r"))) {
    printf("Unable to open %s.\n",argv[1]);
    exit(0);
  }

  while((fgets(line,MAX_LINE,ifp)))
    for (tok=strtok(line,DELIM);
         tok!=NULL;tok=strtok(NULL,DELIM))
      root = insert(root,tok);

  printTree(root);

  printf("There are %d unique words.\n",countUniqueWords(root));

  printf("There are %d total words.\n",countWords(root));

  printf("The last alpha word was %s.\n",lastAlpha(root));

  printf("The longest word was of length %d.\n",longest(root));

  fclose(ifp);
}
  





