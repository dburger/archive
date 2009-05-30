#include <stdio.h>
#include <linux/unistd.h> /* necessary to create stub using _syscall# */
#include <sys/time.h>

/* this macro from unistd.h allows us to create the stub function */
_syscall2(int,pedagogictime,int,flag,struct timeval *,tv);

/*
 * This is the main entry point to the program that test our custom
 * system call pedagogictime.
 */
int main(int argc, char *argv[]) {
  struct timeval tv;
  /*
   * 1 means we would like the time printed as well, it will be sent to
   * /var/log/messages
   */
  if (pedagogictime(1,&tv)) {
    printf("pedagogic time %d %d\n",tv.tv_sec, tv.tv_usec);
  } else {
    printf("pedagogic time encountered an error\n");
  }
}
