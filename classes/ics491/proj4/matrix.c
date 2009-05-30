/*
 This is an MPI program to multiply matrices.  It is called via:

 poe matrix -procs n input_file

 Where n is the number of processors that should operate on the matrices.

 The input file is in row major order of the format:

 arows acols a11 a12 ... brows bcols b11 b12 ...

 The program works by determining the size of the result matrix, and evenly
 distributing the cells in the result matrix to the number of tasks.  The data
 is read only by process 0, and the data is broadcast to the rest of the
 workers.  The 0 process then gathers the results and prints out the result.

 By:
 David J. Burger
 12/06/2002

 For:
 Dr. Martin
 ICS 491
 */

#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

/*
 macro used by 0 task to tell all the other tasks to shut down
 */
#define BAIL_ALL(s) { \
  printf("%s\n", s); \
  i = 0; \
  MPI_Bcast(&i, 1, MPI_INT, 0, MPI_COMM_WORLD); \
  MPI_Finalize(); \
  exit(0); \
}

/*
 used to determine the range that a particular worker should compute.
 
 @param cells    the number of cells in the corresponding matrix
 @param worker   which worker the range is being calculated for
 @param workers  the number of workers that are working on the cells
 @param *lo      low end of range for worker is returned in this var
 @param *hi      high end of range for worker is returned in this var
 */
void calc_range(int cells, int worker, int workers, int *lo, int *hi) {
  int leftover = cells % workers;
  int range = (cells / workers) + (worker < leftover);
  *lo = worker * range;
  if (worker >= leftover) *lo += leftover;
  *hi = *lo + range - 1;
}

/*
 used to read the dimensions for the next matrix from the file.

 @param *fp    open file pointer for the file
 @param *rows  number of rows is returned in this var
 @param *cols  number of cols is returned in this var

 @return    1 if successful, 0 otherwise
 */
int read_dims(FILE *fp, int *rows, int *cols) {
  return fscanf(fp, "%d %d", rows, cols) == 2;
}

/*
 used to read the matrix cell values from the file

 @param *fp      open file pointer for the file
 @param *matrix  array to be filled in, row major order
 @param size     size of array to be filled in

 @return    number of values read, success is return == size
 */
int read_matrix(FILE *fp, int *matrix, int size) {
  int i;
  for (i=0; i<size; i++)
    if (fscanf(fp, "%d\n", matrix+i) < 1) return i;
  return size;
}

/*
 converts a cell reference to a row major ordered matrix to the
 row corresponding to that cell

 @param cols    number of columns in the matrix
 @param cell    cell to return the row number of

 @return    row number corresponding to cell
 */
int cell2row(int cols, int cell) {
  return cell / cols;
}

/*
 converts a cell reference to a row major ordered matrix to the
 column corresponding to that cell

 @param cols    number of columns in the matrix
 @param cell    cell to return the column number of

 @return    column number corresponding to cell
 */
int cell2col(int cols, int cell) {
  return cell % cols;
}

/*
 converts a row, col reference to a row major order array offset

 @param cols    number of columns in the matrix
 @param row     row to determine row major cell of
 @param col     column to determine row major cell of

 @return    row major order offset of row, col
 */
int rowcol2cell(int cols, int row, int col) {
  return row * cols + col;
}

/*
 fetches the cell at row, col from matrix.

 @param *matrix  array containing the matrix in row major order
 @param cols     number of columns in the matrix
 @param row      row of cell to fetch
 @param col      col of cell to fetch

 @return    value fetched from the matrix at row, col
 */
int fetch_cell(int *matrix, int cols, int row, int col) {
  return matrix[rowcol2cell(cols, row, col)];
}

/*
 calculates the value for the result matrix for cell

 @param *m1    matrix 1 of multiplication
 @param *m2    matrix 2 of multiplication
 @param terms  number of terms in the multiplication
 @param rows   number of rows in the result matrix
 @param cols   number of columns in the result matrix
 @param cell   the cell in the result matrix we are calculating the value of

 @return    the value of cell in the result matrix
 */
int calc_cell(int *m1, int *m2, int terms, int rows, int cols, int cell) {
  int i, sum = 0;
  int row = cell2row(cols, cell);
  int col = cell2col(cols, cell);
  for (i=0; i<terms; i++)
    sum += m1[rowcol2cell(terms, row, i)] * m2[rowcol2cell(cols, i, col)];
  return sum;
}

/*
 prints a matrix

 @param *matrix    matrix to print
 @param rows       number of rows in the matrix
 @param cols       number of columns in the matrix
 */
void print_matrix(int *matrix, int rows, int cols) {
  int i, j;
  for (i=0; i<rows; i++) {
    for (j=0; j<cols; j++)  printf("%03d  ", fetch_cell(matrix, cols, i, j));
    printf("\n");
  }
}

/*
 main entry point to program.  Determines number of tasks, the 0 task becomes
 the head task, reading the data and broadcasting it to all other tasks which
 act as workers.  The 0 task then computes its portion of the result and then
 receives the results from all workers.  The result is then printed.
 */
int main(int argc, char *argv[]) {
  int i, lo, hi, me, tasks;
  int a_rows, a_cols, a_cells, b_rows, b_cols, b_cells;
  int *recv_cnts, *disps;
  int *datapack, *temp;
  FILE *fp;

  MPI_Status status;

  /* init MPI, retrieve number of tasks, retrieve my index in tasks */
  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &tasks);
  MPI_Comm_rank(MPI_COMM_WORLD, &me);

  if (!me) {

    /* check for input file parameter */
    if (argc < 2) BAIL_ALL("Please provide an input parameter");

    /* create arrays for receive counts and displacements for MPI_Gatherv */
    if ((recv_cnts = (int *)malloc(tasks*sizeof(int))) == NULL)
      BAIL_ALL("Unable to allocate receive counts array");
    if ((disps = (int *)malloc(tasks*sizeof(int))) == NULL)
      BAIL_ALL("Unable to allocate displacements arrary");

    /* attempt to open the input file */
    if ((fp = fopen(argv[1], "r")) == NULL)
      BAIL_ALL("Unable to open the input file");

  }


  for (;;) {

    if (!me) {

      if (feof(fp))
        BAIL_ALL("Job complete!");

      /* read the dimensions of matrix A */
      if (!read_dims(fp, &a_rows, &a_cols))
        BAIL_ALL("Unable to read the dimensions of matrix A");

      a_cells = a_rows * a_cols;

      /* allocate the space for the dimensions and matrix A */
      if ((datapack = (int *)malloc((2+a_cells)*sizeof(int))) == NULL)
        BAIL_ALL("Unable to allocate space for matrix A");

      /* put row and column data in the datapack */
      datapack[0] = a_rows;
      datapack[1] = a_cols;

      /* attempt to read in the matrix A values */
      if (read_matrix(fp, datapack+2, a_cells) < a_cells)
        BAIL_ALL("Unable to read the contents of matrix A");

      /* read the dimensions of matrix B */
      if (!read_dims(fp, &b_rows, &b_cols))
        BAIL_ALL("Unable to read the dimensions of matrix B");

      b_cells = b_rows * b_cols;

      /* allocate the extra space for dimensions and matrix B */
      if ((datapack = (int *)realloc(datapack,
                                     (4+a_cells+b_cells)*sizeof(int))) == NULL)
        BAIL_ALL("Unable to allocate space for matrix B");

      /* put row and column data in the datapack */
      datapack[2 + a_cells] = b_rows;
      datapack[3 + a_cells] = b_cols;

      /* attempt to read in the matrix B values */
      if (read_matrix(fp, datapack+4+a_cells, b_cells) < b_cells)
        BAIL_ALL("Unable to read the contents of matrix B");

      /* check for multiplication compatibility */
      if (a_cols != b_rows ||
          a_rows < 1 || a_cols < 1 ||
          b_rows < 1 || b_cols < 1) {
        printf("Matrix A and B are not multiplicative compatible\n");
        free(datapack);
        continue;
      }

      /* calculate the size of the datapack */
      i = 4 + a_cells + b_cells;

    }

    /* broadcast the size of the datapack coming in */
    MPI_Bcast(&i, 1, MPI_INT, 0, MPI_COMM_WORLD);

    /* shutdown message has i == 0 */
    if (!i) {
      MPI_Finalize();
      exit(0);
    }

    /* workers allocate space for the data pack */
    if (me) datapack = (int *)malloc(i*sizeof(int));

    /* broadcast the datapack */
    MPI_Bcast(datapack, i, MPI_INT, 0, MPI_COMM_WORLD);

    /* workers get values from the data pack */
    if (me) {
      a_rows = datapack[0];
      a_cols = datapack[1];
      a_cells = a_rows*a_cols;
      b_rows = datapack[2 + a_cells];
      b_cols = datapack[3 + a_cells];
      b_cells = b_rows*b_cols;
    }

    /* calc the range of cells I am responsible for */
    calc_range(a_rows*b_cols, me, tasks, &lo, &hi);

    /* allocate an array for the portion I will compute */
    temp = (int *)malloc((hi-lo+1)*sizeof(int));

    /* calculate my portion of the results */
    for (i=lo; i<=hi; i++) {
      temp[i-lo] = calc_cell(datapack+2, datapack+4+a_cells, a_cols,
                             a_rows, b_cols, i);
    }

    if (!me) {

      /* calculate the proper displacements and sizes for returned results */
      for (i=0; i<tasks; i++) {
        int worker_hi;
        calc_range(a_rows*b_cols, i, tasks, disps+i, &worker_hi);
        recv_cnts[i] = worker_hi - disps[i] + 1;
      }

      /* print out the matrices */
      printf("MATRIX A\n");
      print_matrix(datapack+2, a_rows, a_cols);
      printf("MATRIX B\n");
      print_matrix(datapack+4+a_cells, b_rows, b_cols);

    }

    /* gatherv the results */
    MPI_Gatherv(temp, hi-lo+1, MPI_INT, datapack, recv_cnts, disps,
                MPI_INT, 0, MPI_COMM_WORLD);

    if (!me) {
      /* print out the result */
      printf("RESULT\n");
      print_matrix(datapack, a_rows, b_cols);
    }

    free(temp);
    free(datapack);
  }

}
atrix(datapack, a_rows, b_cols);
    }

    free(temp);
    free(datapack);
  }

}
