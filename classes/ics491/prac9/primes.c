#include <stdlib.h>
#include <stdio.h>
#include <mpi.h> /* header file for the MPI functions */
#include <math.h> /* for the sqrt() function */

/* super dumb prime checker */
int is_prime(int candidate) {
  int i, max_check = sqrt(candidate);
  if (candidate < 2) return 0;
  for (i=2; i<=max_check; i++) {
    if (candidate % i == 0) return 0;
  }
  return 1;
}

int main(int argc, char *argv[]) {
  int i, leftover, me, max, *primes, range, tasks;
  MPI_Init(&argc, &argv); /* must be called before any MPI functions */
  MPI_Comm_size(MPI_COMM_WORLD, &tasks); /* retrieve number of processors used */
  MPI_Comm_rank(MPI_COMM_WORLD, &me); /* my index in the processors */

  /* make sure they passed in a command line parameter for the range */
  if (argc < 2) {
    if (me == 0) {
      printf("Proper usage is %s n\n"
             "  n - upper range for prime check\n", argv[0]);
    }
    MPI_Finalize(); /* must be called to clean up */
    return 1;
  }

  /* make sure they passed in a value >= 3 */
  if ((max = atoi(argv[1])) < 3) {
    if (me == 0) {
      printf("Please enter a value >= 3\n");
    }
    MPI_Finalize(); /* must be called to clean up */
    return 1;
  }

  /*
   * Calculate the ranges that each process takes care of.
   * The last process only accepts the results from others.
   */
  range = max / (tasks - 1);
  leftover = max % (tasks - 1);

  if (me < tasks - 1) {
    /* worker processes taking care of a slice of the primes */
    int i=0, lo, hi;
    lo = me * range + 1;
    hi = me * range + range;
    /* last worker task gets the leftover */
    if (me == tasks - 2) hi+= leftover;
    /* can't just use range in the calloc because one has leftover */
    primes = (int *)calloc(hi - lo + 1, sizeof(int));
    while (lo + i <= hi) {
      primes[i++] = is_prime(lo + i);
    }
    /* sending the primes buffer to the last task */
    MPI_Send(primes, hi - lo + 1, MPI_INT, tasks - 1, 0, MPI_COMM_WORLD);
    free(primes);
  } else {
    /* tasks - 1 process, collects all the results */
    int i, jobs_complete=0, lo, hi, *temp;
    MPI_Status status;
    /* largest slice is range * leftover */
    temp = (int *)malloc((range + leftover) * sizeof(int));
    primes = (int *)calloc(max + 1, sizeof(int));
    while (jobs_complete < tasks - 1) {
      /* receive into temp from any source */
      MPI_Recv(temp, range + leftover, MPI_INT, MPI_ANY_SOURCE,
               MPI_ANY_TAG, MPI_COMM_WORLD, &status);
      /* the status allows us to determine the source and thus the range */
      lo = status.MPI_SOURCE * range + 1;
      hi = status.MPI_SOURCE * range + range;
      if (status.MPI_SOURCE == tasks - 2) hi += leftover;
      i = 0;
      while (lo <= hi) {
        primes[lo++] = temp[i++];
      }
      jobs_complete++;
    }
    /* print the results */
    for (i=0; i<=max; i++) {
      printf("%d is %d\n", i, primes[i]);
    }
    free(temp);
    free(primes);
  }

  MPI_Finalize(); /* must be called to clean up */
  return 0;
}
