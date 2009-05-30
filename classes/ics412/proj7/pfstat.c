#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <linux/unistd.h>

_syscall1(void, init_pfmeter, int, pid);
_syscall1(int, check_pfmeter, int, span);

#define FULL_PERCENT 50 /* the number of asterisks representing 100% */

int main(int argc, char *argv[]) {

  char *p;
  double max_rate = 0;
  int i=0, percent, pid, span, num, *rate;

  if (argc<4) {
    fprintf(stderr,"Proper usage is %s pid span num\n"
            "Where pid is the process to watch, 0 for all,\n"
            "span is the reference frame for page faults in seconds,\n"
	    "and num is the number of samples of span length to take.\n",
            argv[0]);
    exit(1);
  }

  /* strtol allows us to catch conversion errors */
  pid = strtol(argv[1],&p,0);
  if (errno==ERANGE || p==argv[1]) {
    fprintf(stderr,"Value for pid, %s, is invalid.\n",argv[1]);
    exit(1);
  }

  span = strtol(argv[2],&p,0);
  if (errno==ERANGE || p==argv[2]) {
    fprintf(stderr,"Value for span, %s, is invalid.\n",argv[2]);
    exit(1);
  }

  if (span < 1) {
    fprintf(stderr,"The span must be a whole number greater than 0.\n");
    exit(1);
  }

  num = strtol(argv[3],&p,0);
  if (errno==ERANGE || p==argv[3]) {
    fprintf(stderr,"Value for num, %s, is invalid.\n",argv[3]);
    exit(1);
  }

  if (num < 1) {
    fprintf(stderr,"The num must be a whole number greater than 0.\n");
    exit(1);
  }

  rate = (int *)malloc(sizeof(int)*num);

  init_pfmeter(pid);

  while (i<num) {
    printf("Sleeping for %d seconds...\n", span);
    sleep(span);
    printf("Taking page fault sample...");
    rate[i] = check_pfmeter(span);
    if (rate[i] > max_rate) max_rate = rate[i];
    printf("%02d\n",rate[i++]);
  }

  printf("Turning off page fault meter.\n");
  init_pfmeter(-1);

  for (i=0;i<num;i++) {
    percent = FULL_PERCENT * (rate[i] / max_rate);
    printf("%02d: ",i);
    while (percent-->0) printf("*");
    printf("\n");
  }

}
