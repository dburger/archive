#include <stdlib.h>
#include <stdio.h>
#include <mpi.h>
#include <math.h>

#include "primes.h"

int main(int argc, char *argv[]) {
  MPI_Status status;
  int i, j;
  int results[CHUNK_SIZE];
  int max = atoi(argv[1]); /* retrieve the range we need to cover */
  int sqrt_limit = sqrt(max); /* the limit we need determined to */
  /* allocate prime array, assume all prime except for 0, 1, 2 */
  int *primes = (int *)malloc((max + 1)*sizeof(int));
  primes[0] = primes[1] = primes[2] = 0;
  for (i=3; i<max+1; i++) primes[i] = 1;

  MPI_Init(&argc, &argv); /* must be called before any MPI functions */

  /* send the range to the supervisor */
  MPI_Send(&sqrt_limit, 1, MPI_INT, SUPERVISOR_NODE, 0, MPI_COMM_WORLD);

  /* accept results from workers until the supervisor indicates done */
  for (;;) {
    MPI_Recv(results, CHUNK_SIZE, MPI_INT, MPI_ANY_SOURCE, MPI_ANY_TAG,
             MPI_COMM_WORLD, &status);
    /* only time supervisor will respond again is when workers done */
    if (status.MPI_SOURCE == SUPERVISOR_NODE) break;
    /* mark all the multiples of the primes as not prime */
    i = 0;
    while (i < CHUNK_SIZE && results[i]) {
      for (j=2; results[i]*j<max+1; j++) primes[results[i]*j] = 0;
      i++;
    }
  }

  /* print the results */
  for (i=0; i<max+1; i++) {
    if (primes[i]) printf("%d is prime.\n", i);
  }

  MPI_Finalize(); /* must be called to clean up */
}
