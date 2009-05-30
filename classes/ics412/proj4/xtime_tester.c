#include <stdio.h>
#include <sys/time.h>

#define BUF_LEN 50

/*
 * Main entry point to the program.  Tests and compares
 * my proc file modules xtime values against the values
 * report by gettimeofday.  OF COURSE the module must
 * be inserted:
 *
 * /sbin/insmod my_xtime.o
 *
 * before you run this tester.
 *
 * Running this program will demonstrate that gettimeofday
 * has a much finer clock resolution than the value that
 * is being kept in the xtime kernel variable.  By inspecting
 * the source code it can be seen that the reason for this
 * is that gettimeofday will call the architecture specific
 * do_gettimeofday.  do_gettimeofday finds out how many usecs
 * have transpired since the last timer interrupt (used to
 * update xtime) and makes the appropriate adjustments to the
 * time for microsecond accuracy.  It does this by using the
 * function do_gettimeoffset.  For more information look in
 * .../linux/kernel/time.c and .../arch/i386/kernel/time.c
 */
int main(int argc, char *argv[]) {
  FILE *fp;
  int i, rounds;

  char xtime[BUF_LEN];
  struct timeval gtod;

  if (argc<2) {
    fprintf(stderr,"Proper usage is %s rounds\n",argv[0]);
    exit(1);
  }

  rounds = atoi(argv[1]);

  for (i=0;i<rounds;i++) {
    gettimeofday(&gtod,0);
    if ((fp=fopen("/proc/my_xtime","r"))==NULL) {
      fprintf(stderr,"Error reading proc file.\n");
      exit(1);
    }
    /* should get full xtime each time */
    if (fgets(xtime,BUF_LEN,fp)==NULL) {
      fprintf(stderr,"Error reading proc file.\n");
      exit(1);
    }
    fclose(fp);
    printf("gtod: %d %d  xtime %s\n",
           gtod.tv_sec,
	   gtod.tv_usec,
           xtime);

  }

}
