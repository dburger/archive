#include <stdio.h>
#include <linux/unistd.h>

_syscall3(void, schedictl, int, enable, int, dump, int, init);

int main(int argc, char *argv[]) {

  int c;

  /* defaults for the call */
  int start = 1;
  int init = 0;
  int dump = 0;

  while ((c = getopt(argc, argv, "kid"))!=-1) {
    switch (c) {
      case 'k':
        start = 0;
        break;
      case 'i':
        init = 1;
        break;
      case 'd':
        dump = 1;
        break;
    }
  }

  schedictl(start,dump,init);

}
