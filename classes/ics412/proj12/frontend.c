#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "fd.h"

#define CMD_BUF_SIZE 100

/*
 * Converts a c string to upper case.
 *
 * @param *s    string to convert
 *
 * @return    pointer to converted string
 */
static char *strupper(char *s) {
  int i;
  for (i=0; i<strlen(s); i++)
    s[i] = toupper(s[i]);
  return s;
}

int main(int argc, char *argv[]) {
  char *d, *p, cmdbuf[CMD_BUF_SIZE];

  if (argc < 2) {
    fprintf(stderr, "Proper usage is %s disk\n", argv[0]);
    exit(1);
  }

  if (fd_load(argv[1]) < 0) {
    fprintf(stderr, "Unable to open disk %s.\n", argv[1]);
    exit(1);
  }

  printf(">");

  while ((fgets(cmdbuf, CMD_BUF_SIZE, stdin)) != NULL) {

    /* truncate the \n that fgets will put at the end and uppercase */
    cmdbuf[strlen(cmdbuf) - 1] = 0;
    strupper(cmdbuf);

    if (strcmp(cmdbuf,"LS") == 0) {
      if (fd_ls() < 0) {
        printf("An error occurred while displaying the directory.\n");
      }
    } else if (strncmp(cmdbuf, "CD ", strlen("CD ")) == 0) {
      p = cmdbuf + strlen("CD ");
      if (fd_cd(p) < 0) {
        printf("Unable to change to directory.\n");
      }
    } else if (strncmp(cmdbuf, "RM ", strlen("RM ")) == 0) {
      p = cmdbuf + strlen("RM ");
      if (fd_rm(p) < 0) {
        printf("An error occurred while removing %s\n", p);
      }
    } else if (strncmp(cmdbuf, "MKDIR ", strlen("MKDIR ")) == 0) {
      p = cmdbuf + strlen("MKDIR ");
      if (fd_mkdir(p) < 0) {
        printf("An error occurred while creating the directory.\n");
      }
    } else if (strncmp(cmdbuf, "CP ", strlen("CP ")) == 0) {
      p = cmdbuf + strlen("CP ");
      d = strchr(p, ' ');
      if (d) *d = 0;
      if (!d || ++d == 0) {
        printf("Proper usages is:\n"
               "cp source destination\n");
      } else if (fd_cp(p, d) < 0) {
        printf("Unable to copy from %s to %s.\n", p, d);
      }
    } else if (strcmp(cmdbuf, "EXIT") == 0) {
      break;
    } else if (strcmp(cmdbuf, "PWD") == 0) {
      fd_pwd();
    } else { /* HUH ? */
      printf("Unknown command.\n");
    }

    printf(">");

  }

  fd_close();
  return 0;

}
