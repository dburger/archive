#include <stdlib.h>
#include <mpi.h>
#include <math.h>

#include "primes.h"

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
  MPI_Status status;
  int i, j, base_num, chunk[CHUNK_SIZE];
  MPI_Init(&argc, &argv); /* must be called before any MPI functions */

  /* keep doing chunk size jobs until get quit message */
  for (;;) {
    /* send message to indicate a request for work */
    MPI_Send(NULL, 0, MPI_INT, SUPERVISOR_NODE, 0, MPI_COMM_WORLD);
    /* and receive job information */
    MPI_Recv(&base_num, 1, MPI_INT, SUPERVISOR_NODE, MPI_ANY_TAG,
             MPI_COMM_WORLD, &status);
    /* supervisor will send quit indicator when no more work */
    if (status.MPI_TAG == QUIT_TAG) break;
    /* determine which are prime and fill into chunk array */
    for (i=0,j=0 ; i<CHUNK_SIZE; i++) {
      if (is_prime(base_num + i)) chunk[j++] = base_num + i;
    }
    /* zero out remaining slots in chunk array */
    for (;j<CHUNK_SIZE; j++) {
      chunk[j] = 0;
    }
    /* send chunk back to the manager */
    MPI_Send(&chunk, CHUNK_SIZE, MPI_INT, MANAGER_NODE, 0, MPI_COMM_WORLD);
  }

  MPI_Finalize(); /* must be called to clean up */
}
