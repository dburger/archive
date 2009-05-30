#include <stdio.h>
#include <stdlib.h>

#include "fd.h"

#define BLOCK_SIZE 200

int main(int argc, char *argv[]) {
  char buf[BLOCK_SIZE];
  int fd, fd2, read;

  if (fd_load(argv[1]) < 0) {
    fprintf(stderr, "Unable to open disk %s.\n", argv[1]);
    exit(1);
  }

  if ((fd = fd_fopen("QUIZ.DOC", O_READ)) < 0) {
    printf("Unabled to open the file test.\n");
    exit(1);
  }

  if ((fd2 = fd_fopen("BURGER.DON", O_WRITE)) < 0) {
    printf("Unable to open the file hi.\n");
    exit(1);
  }

  while ((read = fd_fread(fd, buf, BLOCK_SIZE)) > 0) {
    fd_fwrite(fd2, buf, read);
  }

  fd_fclose(fd);
  fd_fclose(fd2);

  fd_close();

  return 0;
}



