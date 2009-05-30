#include <stdio.h>
#include <sys/time.h>
#include <signal.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>

long real_secs=0, virt_secs=0, prof_secs=0;
struct itimerval seed_t, real_t, virt_t, prof_t;

/*
 * Function that will accept SIGALRM in response to ITIMER_REAL
 * every second.
 *
 * @param signo    accepts the signal number causing signal, not used
 */
void real_alarm(int signo) {
  real_secs++;
}

/*
 * Function that will accept SIGVTALRM in response to ITIMER_VIRTUAL
 * every second.
 *
 * @param signo    accepts the signal number causing signal, not used
 */
void virt_alarm(int signo) {
  virt_secs++;
}

/*
 * Function that will accept SIGPROG in response to ITIMER_PROF
 * every second.
 *
 * @param signo    accepts the signal number causing signal, not used
 */
void prof_alarm(int signo) {
  prof_secs++;
}

/*
 * Used to determine the number of usecs that have expired from the
 * tv_sec and tv_usec left in an itimerval.  This is calculated from
 * the assumption that the itimerval was originally set to
 * tv_sec = 1 and tv_usec = 0.  These are count down timers so the
 * elapsed is computed by subtracting from 1000000.
 *
 * @param tv_sec    number of seconds left in timer, 1 or 0
 * @param tv_usec   number of usecs left in the timer
 */
unsigned long elapsed_usecs(unsigned long tv_sec, unsigned long tv_usec) {
  if (tv_sec==1) {
    return 0;
  } else {
    return 1000000 - tv_usec;
  }
}

/*
 * Recursive computation of the fibonacci sequence.
 *
 * @param l    computing the lth fibonacci number
 */
unsigned long fibonacci(unsigned long l) {
  if (l==0) {
    return 0;
  } else if (l==1 || l==2) {
    return 1;
  } else {
    return fibonacci(l-1) + fibonacci(l-2);
  }
}


/*
 * Main entry point of program.  Sets up the timers, the child processes
 * and reports the various times of each.
 *
 * @param argc    number of arguments passed to this program
 * @param *argv[] array of strings passed to this program, used to
 *                retrieve the fibonacci value to compute
 */
int main(int argc, char *argv[]) {
  char *p;
  long val;
  int status;

  if (argc!=2) {
    fprintf(stderr, "Proper usage is %s val\n"
                    "where val is the fibonacci "
                    "value you want to compute.\n",argv[0]);
    exit(1);
  }

  val = strtol(argv[1],&p,0);
  if (errno==ERANGE || p==argv[1]) {
    fprintf(stderr,"Value to compute, %s, is invalid.\n",argv[1]);
    exit(1);
  }

  /* enable the signal handlers */
  if (signal(SIGALRM, real_alarm)==SIG_ERR) {
    fprintf(stderr, "Unable to trap SIGALRM.\n");
    exit(1);
  }

  if (signal(SIGVTALRM, virt_alarm)==SIG_ERR) {
    fprintf(stderr, "Unable to trap SIGVTALRM.\n");
    exit(1);
  }

  if (signal(SIGPROF, prof_alarm)==SIG_ERR) {
    fprintf(stderr, "Unable to trap SIGPROF.\n");
    exit(1);
  }

  /* set up one itimerval to 1 sec, 1 sec. on reset */
  seed_t.it_interval.tv_sec = 1;
  seed_t.it_interval.tv_usec = 0;
  seed_t.it_value.tv_sec = 1;
  seed_t.it_value.tv_usec = 0;

  /* start the timers */
  if (setitimer(ITIMER_REAL,&seed_t,NULL)!=0) {
    fprintf(stderr, "Unable to start real timer.\n");
    exit(1);
  }

  if (setitimer(ITIMER_VIRTUAL,&seed_t,NULL)!=0) {
    fprintf(stderr, "Unable to start virtual timer.\n");
    exit(1);
  }

  if (setitimer(ITIMER_PROF,&seed_t,NULL)!=0) {
    fprintf(stderr, "Unable to start profile timer.\n");
    exit(1);
  }

  /* set up an itimerval to kill the timers */
  seed_t.it_interval.tv_sec = 0;
  seed_t.it_interval.tv_usec = 0;
  seed_t.it_value.tv_sec = 0;
  seed_t.it_value.tv_usec = 0;

  val = fibonacci(val);



  /* and kill the timers */
  if (setitimer(ITIMER_REAL, &seed_t, &real_t)!=0) {
    fprintf(stderr, "Unable to get real time.\n");
    exit(0);
  }

  if (setitimer(ITIMER_VIRTUAL, &seed_t, &virt_t)!=0) {
    fprintf(stderr, "Unable to get virtual time.\n");
    exit(0);
  }

  if (setitimer(ITIMER_PROF, &seed_t, &prof_t)!=0) {
    fprintf(stderr, "Unable to get profile time.\n");
    exit(0);
  }

  printf("ans: %ld, (real) %ld sec, %ld msec\n",
         val, real_secs,
         elapsed_usecs(real_t.it_value.tv_sec,
                       real_t.it_value.tv_usec)/1000);

  printf("ans: %ld, (virt) %ld sec, %ld msec\n",
         val, virt_secs,
         elapsed_usecs(virt_t.it_value.tv_sec,
                       virt_t.it_value.tv_usec)/1000);

  printf("ans: %ld, (prof) %ld sec, %ld msec\n",
         val, prof_secs,
         elapsed_usecs(prof_t.it_value.tv_sec,
                       prof_t.it_value.tv_usec)/1000);
}
