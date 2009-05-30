#include <stdio.h>
#include <sys/shm.h> /* for shared memory */
#include <sys/sem.h> /* for semaphores */
#include <sys/stat.h> /* for permission constants */
#include <unistd.h> /* getpagesize */

#define ROUNDS 100

/* union necessary to work with semaphores */
union semun {
  int val;
  struct semid_ds *buf;
  unsigned short int *array;
  struct seminfo *__buf;
};

int main(int argc, char *argv[]) {
  int sem_id;
  int shm_id;
  char *shmbuf;
  pid_t pid;
  struct sembuf semops[1];
  struct shmid_ds shminfo;
  union semun semun_arg;
  unsigned short values[1];
  int page_size = getpagesize();

  printf("Building shared memory of size %d bytes...\n",page_size);

  /* create the shared memory segment with everyone having rw access */
  shm_id = shmget(IPC_PRIVATE, page_size,
             IPC_CREAT | IPC_EXCL | S_IRUSR | S_IWUSR | S_IROTH | S_IWOTH);

  if (shm_id==-1) {
    fprintf(stderr,"Unable to create the shared memory segment.\n");
    exit(1);
  }

  printf("Shared memory with id %08x created.\n", shm_id);

  /* create 1 semaphore (0th) to control access to the shared memory */
  sem_id = semget(IPC_PRIVATE, 1,
             IPC_CREAT | IPC_EXCL | S_IRUSR | S_IWUSR | S_IROTH | S_IWOTH);

  if (sem_id==-1) {
    fprintf(stderr,"Unable to create the semaphore.\n");
    /* must deallocate the shared memory segment */
    shmctl(shm_id, IPC_RMID, 0);    
    exit(1);
  }

  printf("Semaphore with id %08x created.\n",sem_id);

  /* initialize the semaphore to 1 */
  values[0] = 1;
  semun_arg.array = values;
  if (semctl(sem_id, 0, SETALL, semun_arg)==-1) {
    fprintf(stderr,"A problem occurred initializing the semaphore.\n");
    /* must deallocate the shared memory segment and the semaphore */
    shmctl(shm_id, IPC_RMID, 0);
    semctl(sem_id, 0, IPC_RMID, semun_arg);
    exit(1);
  }

  /* set up semops for later use */
  semops[0].sem_num = 0; /* first and only */
  semops[0].sem_flg = SEM_UNDO; /* permit undoing on unexpected exit */

  if ((pid=fork())==0) {
    /* child, attach to the shared memory segment */
    shmbuf = (char *)shmat(shm_id, 0, 0);
    printf("Child attached to %08x at %p.\n", shm_id, shmbuf);

    /* wait on the semaphore */
    semops[0].sem_op = -1; /* decrement 1 */
    if (semop(sem_id,semops,1)==-1) {
      fprintf(stderr,"Child had problem waiting for semaphore.\n");
      exit(1);
    }

    /* we have the lock so write to the shared memory */
    sprintf(shmbuf,"Hi parent, from your child!\0");

    /* force the parent to wait on the semaphore */
    printf("Child forcing the parent to wait for 5 seconds.\n");
    sleep(5);

    /* release the semaphore */
    semops[0].sem_op = 1; /* increment 1 */
    if (semop(sem_id,semops,1)==-1) {
      fprintf(stderr,"Child had problems releasing semaphore.\n");
      exit(1);
    }

    /* detach from the shared memory */
    shmdt(shmbuf);

    printf("Child exiting.\n");
  } else {
    /* parent, attach to he shared memory segment */
    shmbuf = (char *)shmat(shm_id, 0, 0);
    printf("Parent attached to %08x at %p.\n", shm_id, shmbuf);

    /* sleep so the child gets the lock first */
    sleep(5);

    /* wait on the semaphore */
    semops[0].sem_op = -1; /* decrement 1 */
    if (semop(sem_id,semops,1)==-1) {
      fprintf(stderr,"Parent had problem waiting for semaphore.\n");
      /* wait for the child to close */
      waitpid(pid,NULL,0);
      /* deallocate the shared memory segment and the semaphore */
      shmctl(shm_id, IPC_RMID, 0);
      semctl(sem_id, 0, IPC_RMID, semun_arg);
      exit(1);
    }

    /* we have the lock so read the shared memory */
    printf("Parent reading from the shared memory:\n");
    printf("%s\n",shmbuf);

    /* release the semaphore */
    semops[0].sem_op = 1; /* increment 1 */
    if (semop(sem_id,semops,1)==-1) {
      fprintf(stderr,"Parent had problems releasing semaphore.\n");
      /* wait for the child to close */
      waitpid(pid,NULL,0);
      /* deallocate the shared memory segment and the semaphore */
      shmctl(shm_id, IPC_RMID, 0);
      semctl(sem_id, 0, IPC_RMID, semun_arg);
      exit(1);
    }

    /* wait for the child to close */
    waitpid(pid,NULL,0);
    /* detach from the shared memory segment */
    shmdt(shmbuf);
    /* deallocate the shared memory segment */
    shmctl(shm_id, IPC_RMID, 0);
    /* deallocate the 0th and only semaphore */
    semctl(sem_id, 0, IPC_RMID, semun_arg);

    printf("Parent exiting.\n");
  }

}
