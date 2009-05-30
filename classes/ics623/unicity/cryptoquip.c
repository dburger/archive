#include <stdio.h>
#include <ctype.h>

#define BUFF_SIZE 300

int main(int argc, char *argv[]) {

  char c1, c2;
  char buffer[BUFF_SIZE];
  char replace[4];
  int i;

  printf("Enter the cryptoquip string.\n");
  if ((fgets(buffer,BUFF_SIZE,stdin))==NULL) {
    printf("An error occured.\n");
    exit(0);
  }

  for (i=0;i<strlen(buffer);i++)
    buffer[i]=tolower(buffer[i]);

  printf("Enter a substitution:  ");
  while ((fgets(replace,4,stdin))!=NULL) {
    if (strcmp(replace,"q\n")==0) break;
    c1 = replace[0];
    c2 = replace[1];
    for (i=0;i<strlen(buffer);i++)
      if (buffer[i]==c1) buffer[i]=c2;
    printf("\n%s\n",buffer);
    printf("Enter a substitution:  ");
  }

}
