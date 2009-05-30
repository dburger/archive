#include <stdio.h>
#include <string.h>
#include "avltree.h"

#define MAXLINE 1000

int main(int argc, char *argv[]) {

  FILE *fp;
  char s[MAXLINE];
  char *tok;

  struct TreeNode *r = NULL;

  if (argc<2) {
    printf("Proper usage is %s filename.\n",argv[0]);
    exit(0);
  }

  if ((fp=fopen(argv[1],"r"))==NULL) {
    printf("Unable to open %s.\n",argv[1]);
    exit(0);
  }


  while ((fgets(s,MAXLINE,fp))!=NULL)
    for (tok=strtok(s," ,.:;!?\t\n()");tok!=NULL;
         tok=strtok(NULL," ,.:;!?\t\n()")) {
        printf("inserting %s\n",tok);
        r = insert(r, tok);
    }

  fclose(fp);

  printAVLTree(r);

}


