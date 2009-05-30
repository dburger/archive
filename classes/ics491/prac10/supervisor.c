#include <stdlib.h>
#include <mpi.h>

#include "primes.h"

int main(int argc, char *argv[]) {
  MPI_Status status;
  int i, max_check, tasks;
  MPI_Init(&argc, &argv); /* must be called before any MPI functions */
  MPI_Comm_size(MPI_COMM_WORLD, &tasks); /* get process count */

  /* receive the upper limit to check from the manager */
  MPI_Recv(&max_check, 1, MPI_INT, MANAGER_NODE, MPI_ANY_TAG, MPI_COMM_WORLD,
           &status);

  /* keep looping until all the work has been delegated in CHUNK_SIZE chunks */
  for (i=0; i<max_check; i+=CHUNK_SIZE) {
    /* accept requests for work from workers */
    MPI_Recv(NULL, 0, MPI_INT, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD,
             &status);
    /* send a job to the requesting worker */
    MPI_Send(&i, 1, MPI_INT, status.MPI_SOURCE, 0, MPI_COMM_WORLD);
  }

  /*
   * Count the unrequited requests until all the workers are accounted for,
   * this will ensure they have sent their data to the manager
   */
  for (i=0; i<tasks-2; i++) {
    MPI_Recv(NULL, 0, MPI_INT, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD,
             &status);
    /* tell the worker they can shut down, no more work */
    MPI_Send(NULL, 0, MPI_INT, status.MPI_SOURCE, QUIT_TAG, MPI_COMM_WORLD);
  }

  /* and now tell the manager that everyone is done */
  MPI_Send(NULL, 0, MPI_INT, MANAGER_NODE, QUIT_TAG, MPI_COMM_WORLD);

  MPI_Finalize(); /* must be called to clean up */
}
