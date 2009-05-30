#include <stdio.h>
#include <linux/unistd.h>

_syscall1(int,evntopen,int,evnt);
_syscall1(int,evntclose,int,evnt);
_syscall1(int,evntwait,int,evnt);
_syscall1(void,evntsig,int,evnt);

/*
 * NOTE!!! the current code requires NUM_EVNTS==NUM_TASKS because
 * a loop has each created task sleep on a separate event.  If you
 * change here adjust accordingly.
 */
#define NUM_EVNTS 5
#define NUM_TASKS 5

#define VIEW_PAUSE 5

int main(int argc, char *argv[]) {

  int i, res;
  int evnt_id[NUM_EVNTS];
  int pid[NUM_TASKS], mypid;

  printf("Going to create %d events in %d seconds.\n",NUM_EVNTS,VIEW_PAUSE);
  sleep(VIEW_PAUSE);

  for (i=0;i<NUM_EVNTS;i++) {
    if ((evnt_id[i] = evntopen(0)) == -1) {
      fprintf(stderr,"Unable to create a new event.\n");
      exit(1);
    }
    printf("Event with id %d created.\n", evnt_id[i]);
  }

  printf("================================================================\n");
  printf("Going to signal event id %d with no tasks waiting"
         " in %d seconds.\n", evnt_id[0],VIEW_PAUSE);
  sleep(VIEW_PAUSE);

  evntsig(evnt_id[0]);
  printf("Event %d has been signalled.\n",evnt_id[0]);

  printf("================================================================\n");
  printf("Going to create %d child processes in %d seconds.\n",
         NUM_TASKS,VIEW_PAUSE);
  sleep(VIEW_PAUSE);

  for (i=0;i<NUM_TASKS;i++) {
    if ((pid[i]=fork())==0) {
      /* to let the parent create all children before they run code */
      sleep(1);
      mypid = getpid();
      printf("Child %d waiting on event %d.\n",mypid,evnt_id[0]);
      if ((res=evntwait(evnt_id[0]))!=evnt_id[0]) {
        printf("Error %d for child %d waiting on event %d.\n",
               res,mypid,evnt_id[0]);
        exit(1);
      }
      printf("Child %d awake from event %d.\n",mypid,evnt_id[0]);
      /* to make sure all children print wake up messages together */
      sleep(1);
      printf("Child %d waiting on event %d.\n",mypid,evnt_id[i]);
      if ((res=evntwait(evnt_id[i]))!=evnt_id[i]) {
        printf("Error %d for child %d waiting on event %d.\n",
               res,mypid,evnt_id[i]);
        exit(1);
      }
      printf("Child %d awake from event %d.\n",mypid,evnt_id[i]);
      exit(0);
    }
    printf("Child with pid %d created.\n",pid[i]);
  }

  printf("================================================================\n");
  printf("Going to sleep for %d seconds while children wait.\n",VIEW_PAUSE*3);
  sleep(VIEW_PAUSE*3);

  printf("================================================================\n");
  printf("Signaling event %d now!\n",evnt_id[0]);
  evntsig(evnt_id[0]);
  /* to make sure children awake before next print runs */
  sleep(2);

  printf("================================================================\n");
  printf("Going to close all events (with children waiting)"
         " in %d seconds.\n",VIEW_PAUSE);
  sleep(VIEW_PAUSE);

  /* clean up the events */
  for (i=0;i<NUM_EVNTS;i++) {
    printf("Closing event %d.\n",evnt_id[i]);
    if ((res=evntclose(evnt_id[i]))!=evnt_id[i]) {
      printf("Error occurred closing event %d.\n",evnt_id[i]);
    } else {
      printf("Closed event %d.\n",evnt_id[i]);
    }
  }

  /* clean up the children */
  for (i=0;i<NUM_TASKS;i++) {
    waitpid(pid[i],NULL,0);
  }

}
