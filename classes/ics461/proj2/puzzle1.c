/*
 * IDA* Solution to N x M puzzle problems by:
 *
 * David J. Burger
 *
 * for ICS 461, Artifical Intelligence, Curt Powley
 *
 * To run this program:
 * ./puzzle data
 * where data is a file that contains puzzle problems.  The format of the
 * data file should be as follows:

rows cols max_depth
first_cell second_cell ...
first_cell second_cell ...

 * where rows is the number of rows in the puzzle, cols is the number of
 * columns in the puzzle, and max_depth is the maximum depth that the DFID
 * should search for a solution.  The data for the start state follows on
 * the next row, in row major order with the start puzzle on the first
 * line and the goal puzzle on the next line.  A sample data set should be
 * included with this file as well as a README file with further
 * information on this program.
 *
 */
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <sys/time.h>

/* a Node represents a configuration state in the search tree */
struct Node {
  char via; /* how this state was acheived, R, L, U, D, or X if root */
  int rows;
  int cols;
  int *grid; /* pointer to the puzzle grid, maintained as single dim array */
  int blank_pos;
  int depth;
};

/* global variableused to count node generations */
int node_gens;

/*
 * Returns the time difference between the start and finish in microseconds.
 *
 * @param *start_tv   the starting timeval
 * @param *finish_tv  the finish timeval
 * return  time difference between start and finish
 */
int time_diff(struct timeval *start_tv, struct timeval *finish_tv) {
  return (finish_tv->tv_sec - start_tv->tv_sec) * 1000000 +
    finish_tv->tv_usec - start_tv->tv_usec;
}

/*
 * Used to print the puzzle grid of a Node.
 *
 * @param *n  the Node to print the grid configuration of
 */
void print_node(struct Node *n) {
  int row, col;
  for (row=0; row<n->rows; row++) {
    for (col=0; col<n->cols; col++) {
      printf("%02d  ", n->grid[n->cols*row + col]);
    }
    printf("\n");
  }
}

/*
 * Builds a manhattan scoring table for the passed in goal grid. manhattan
 * must have been malloc'ed to the appropriate size.
 *
 * @param *goal       the node to build the manhattan table for
 * @param *manhattan  will hold the manhattan distances
 */
void build_manhattan(struct Node *goal, int *manhattan) {
  int i, j, current_row, current_col, target_row, target_col, offset;
  int cells = goal->rows * goal->cols;
  for (i=0; i<cells; i++) {
    target_row = i / goal->cols;
    target_col = i % goal->cols;
    for (j=0 ; j<cells; j++) {
      current_row = j / goal->cols;
      current_col = j % goal->cols;
      offset = abs(target_row - current_row) + abs(target_col - current_col);
      manhattan[goal->grid[i] * cells + j] = !goal->grid[i] ? 0 : offset;
    }
  }
}

/*
 * Returns the manhattan distance for n given the scoring table manhattan.
 *
 * @param *n          the node to compute the manhattan distance for
 * @param *manhattan  table holding the manhattan scores
 */
int manhattan_distance(struct Node *n, int *manhattan) {
  int row, col, cell, cells = n->rows * n->cols;
  int distance = 0;
  for (row=0; row<n->rows; row++) {
    for (col=0; col<n->cols; col++) {
      cell = row * n->cols + col;
      distance += manhattan[cells * n->grid[cell] + cell];
    }
  }
  return distance;
}

/*
 * Prints the manhattan distance for each cell.
 * 
 * @param *manhattan  the computed manhattan distance table
 * @param rows        number of rows in the puzzle
 * @param cols        number of columns in the puzzle
 */
void print_manhattan(int *manhattan, int rows, int cols) {
  int i, row, col, cells = rows * cols;
  for (i=0; i<cells; i++) {
    printf("%d:\n", i);
    for (row=0; row<rows; row++) {
      for (col=0; col<cols; col++) {
        printf("%02d  ", manhattan[i * cells + cols * row + col]);
      }
      printf("\n");
    }
    printf("\n");
  }
}

/*
 * Returns the inverse of a puzzle move.  In this program I have used
 * backward chaining, solving from the goal to the start state, so that the
 * printing of the solution can be done without any auxillary structures,
 * however, this requires that we print the inverse of a move from our
 * backward solution.
 *
 * @param c  the move to return the inverse of
 * return  the inverse of the move
 */
char inverse_move(char c) {
  char inverse = ' ';
  switch(c) {
    case 'L':
      inverse = 'R'; break;
    case 'R':
      inverse = 'L'; break;
    case 'U':
      inverse = 'D'; break;
    case 'D':
      inverse = 'U'; break;
  }
  return inverse;
}

/*
 * Returns the column containing the blank for the given Node.
 *
 * @param *n  the node to determine the blank column for
 * return  the column containing the blank
 */
int blank_col(struct Node *n) {
  return n->blank_pos % n->rows;
}

/*
 * Returns the row containing the blank for the given Node.
 *
 * @param *n  the node to determine the blank row for
 * return  the row containing the blank
 */
int blank_row(struct Node *n) {
  return n->blank_pos / n->rows;
}

/*
 * Used to move the blank left for the given Node.  Note that this function
 * does not check if left is a valid move so it should be checked before
 * calling this function.
 *
 * @param *n  the node to move the blank left for
 */
void blank_left(struct Node *n) {
  int row = blank_row(n);
  int col = blank_col(n);
  int new_blank_pos = row*n->rows + col - 1;
  int temp = n->grid[new_blank_pos];
  n->grid[new_blank_pos] = 0;
  n->grid[n->blank_pos] = temp;
  n->blank_pos = new_blank_pos;
  n->via = 'L';
}

/*
 * Used to move the blank right for the given Node.  Note that this function
 * does not check if right is a valid move so it should be checked before
 * calling this function.
 *
 * @param *n  the node to move the blank right for
 */
void blank_right(struct Node *n) {
  int row = blank_row(n);
  int col = blank_col(n);
  int new_blank_pos = row*n->rows + col + 1;
  int temp = n->grid[new_blank_pos];
  n->grid[new_blank_pos] = 0;
  n->grid[n->blank_pos] = temp;
  n->blank_pos = new_blank_pos;
  n->via = 'R';
}

/*
 * Used to move the blank up for the given Node.  Note that this function
 * does not check if up is a valid move so it should be checked before
 * calling this function.
 *
 * @param *n  the node to move the blank up for
 */
void blank_up(struct Node *n) {
  int row = blank_row(n);
  int col = blank_col(n);
  int new_blank_pos = (row - 1)*n->rows + col;
  int temp = n->grid[new_blank_pos];
  n->grid[new_blank_pos] = 0;
  n->grid[n->blank_pos] = temp;
  n->blank_pos = new_blank_pos;
  n->via = 'U';
}

/*
 * Used to move the blank down for the given Node.  Note that this function
 * does not check if down is a valid move so it should be checked before
 * calling this function.
 *
 * @param *n  the node to move the blank down for
 */
void blank_down(struct Node *n) {
  int row = blank_row(n);
  int col = blank_col(n);
  int new_blank_pos = (row + 1)*n->rows + col;
  int temp = n->grid[new_blank_pos];
  n->grid[new_blank_pos] = 0;
  n->grid[n->blank_pos] = temp;
  n->blank_pos = new_blank_pos;
  n->via = 'D';
}

/*
 * Creates and returns a pointer to a child node of the given parent node.
 * Note that the puzzle grid is shared, and a pointer is set to the parents
 * grid.
 *
 * @param *parent  the parent Node to create a child of
 * return  a pointer to the created child Node
 */
struct Node *create_child(struct Node *parent) {
  struct Node *child = (struct Node *)malloc(sizeof(struct Node));
  if (child == NULL) return NULL;

  child->via = parent->via;
  child->rows = parent->rows;
  child->cols = parent->cols;
  child->grid = parent->grid;
  child->blank_pos = parent->blank_pos;
  child->depth = parent->depth + 1;

  node_gens++;
  return child;
}

/*
 * Determines if the given Node matches the goal state.
 *
 * @param *n     the node to compare to the goal node
 * @param *goal  the goal node for comparison
 * return  1 if matched and puzzle is solved, otherwise 0
 */
int is_solved(struct Node *n, struct Node *goal) {
  return (memcmp(n->grid, goal->grid, n->rows*n->cols*sizeof(int)) == 0);
}

/*
 * Expands the given node, creating its children and recursing upon them as it
 * goes.
 *
 * @param *n          the node that we are expanding
 * @param thold       the threshold for this expansion
 * @param new_thold   threshold for next round will be returned here
 * @param *goal       the goal node we are trying to match
 * @param *manhattan  manhattan distance table
 * return  1 if the goal the goal is found to be n or one of its descendents,
 *         0 if the goal is not found within max_depth
 */
int expand(struct Node *n, int thold, int *new_thold, struct Node *goal,
           int *manhattan) {
  int cost, result;
  struct Node *child;

  if (is_solved(n, goal)) {
    printf("%c", inverse_move(n->via));
    return 1;
  }

  /* check to see if the node should be expanded */
  if ((cost = n->depth + manhattan_distance(n, manhattan)) > thold) {
    /* if lowest cost node not expanded, then threshold for next round */
    if (cost < *new_thold) *new_thold = cost;
    return 0;
  }

  /* could have rolled this into a little loop and eliminate repeated code */
  /* but this should be a little faster                                    */

  /* left move */
  if (n->via != 'R' && blank_col(n) > 0) {
    if ((child = create_child(n)) == NULL) {
      fprintf(stderr, "Out of memory!\n");
      exit(1);
    }
    blank_left(child);
    result = expand(child, thold, new_thold, goal, manhattan);
    blank_right(child);
    free(child);
    if (result) {
      printf("%c", inverse_move(n->via));
      return 1;
    }
  }

  /* up move */
  if (n->via != 'D' && blank_row(n) > 0) {
    if ((child = create_child(n)) == NULL) {
      fprintf(stderr, "Out of memory!\n");
      exit(1);
    }
    blank_up(child);
    result = expand(child, thold, new_thold, goal, manhattan);
    blank_down(child);
    free(child);
    if (result) {
      printf("%c", inverse_move(n->via));
      return 1;
    }
  }

  /* right move */
  if (n->via != 'L' && blank_col(n) < n->cols - 1) {
    if ((child = create_child(n)) == NULL) {
      fprintf(stderr, "Out of memory!\n");
      exit(1);
    }
    blank_right(child);
    result = expand(child, thold, new_thold, goal, manhattan);
    blank_left(child);
    free(child);
    if (result) {
      printf("%c", inverse_move(n->via));
      return 1;
    }
  }

  /* down move */
  if (n->via != 'U' && blank_row(n) < n->rows - 1) {
    if ((child = create_child(n)) == NULL) {
      fprintf(stderr, "Out of memory!\n");
      exit(1);
    }
    blank_down(child);
    result = expand(child, thold, new_thold, goal, manhattan);
    blank_up(child);
    free(child);
    if (result) {
      printf("%c", inverse_move(n->via));
      return 1;
    }
  }

  return 0;

}

/*
 * Checks to see if a given node is a valid puzzle, checking that all the
 * valid numbers for an M x N grid have been used.
 *
 * @param *n  the Node to check if valid
 * return  1 if valid, otherwise 0
 */
int is_valid(struct Node *n) {
  int i, cells = n->rows*n->cols;
  int *check = (int *)calloc(cells, sizeof(int));
  if (check == NULL) return 0;

  for (i=0; i<cells; i++) {
    if (n->grid[i] >= 0 && n->grid[i] < cells) check[n->grid[i]] = 1;
  }

  for (i=0; i<cells; i++) {
    if (!check[i]) {
      free(check);
      return 0;
    }
  }

  free(check);
  return 1;
}

/*
 * Returns the parity for the given node.  Parity is the number of inversions
 * that are found in the Node and can be used to determine which states can
 * be reached from other states...the parity must match, even or odd.  See:
 * The Moment of Proof, Mathematical Epiphanies, Donald C. Benson
 *
 * @param *n  the Node to determine the parity of
 */
int parity(struct Node *n) {
  int row, col, number, inversions;
  int cell, cells = n->rows * n->cols;
  number = inversions = 0;
  for (number=1; number<cells; number++) {
    for (row=0; row<n->rows; row++) {
      if (row % 2 == 0) {
        for (col=0; col<n->cols; col++) {
          cell = row * n->cols + col;
          if (n->grid[cell] == number) {
            row = n->rows;
            break;
          }
          if (n->grid[cell] > number) inversions++;
        }
      } else {
        for (col=n->cols-1; col>=0; col--) {
          cell = row * n->cols + col;
          if (n->grid[cell] == number) {
            row = n->rows;
            break;
          }
          if (n->grid[cell] > number) inversions++;
        }
      }
    }
  }
  return inversions % 2;
}

/*
 * Used to read in puzzle data from file pointer fp.  If successful it will
 * set up the start and goal nodes and return 1.  If an error occurs or the
 * data is incomplete, a 0 is returned.
 * 
 * @param *fp        file pointer to read the data from
 * @param *start     pointer to start node
 * @param *goal      pointer to goal node
 * @param *max_depth  pointer to the maximum depth to search
 * return  1 if successful and the nodes and maximum depth are filled in,
 *         0 if an error occurs
 */
int read_puzzle(FILE *fp, struct Node *start, struct Node *goal,
                int *max_depth) {
  int i, cells, rows, cols;
  /* read in the dimensions and then allocate nodes */
  if (fscanf(fp, "%d %d %d", &rows, &cols, max_depth) < 3) return 0;
  if ((cells = rows*cols) <= 0) return 0;
  /* allocate the grids */
  if ((start->grid = (int *)malloc(cells*sizeof(int))) == NULL) return 0;
  if ((goal->grid = (int *)malloc(cells*sizeof(int))) == NULL) {
    free(start->grid);
    return 0;
  }
  /* set some of the basic parameters */
  start->rows = goal->rows = rows;
  start->cols = goal->cols = cols;
  start->via = goal->via = 'X';

  /* read in the start puzzle */
  for (i=0; i<cells; i++) {
    if (fscanf(fp, "%d", &start->grid[i]) < 1) {
      free(start->grid);
      free(goal->grid);
      return 0;
    }
    if (start->grid[i] == 0) start->blank_pos = i;
  }

  /* read in the goal puzzle */
  for (i=0; i<cells; i++) {
    if (fscanf(fp, "%d", &goal->grid[i]) < 1) {
      free(start->grid);
      free(goal->grid);
      return 0;
    }
    if (goal->grid[i] == 0) goal->blank_pos = i;
  }
  return 1;
}

/*
 * Main entry point of the program.  It opens the input file, running a loop
 * that reads puzzle data and then solves the puzzle.
 */
int main(int argc, char *argv[]) {
  int solved = 0;
  int max_depth, thold, new_thold;
  struct Node *start, *goal;
  int *manhattan;
  FILE *fp;
  struct timeval start_tv, finish_tv;

  /* check for proper command line parameters */
  if (argc < 2) {
    fprintf(stderr, "Proper usage is %s file\n", argv[0]);
    fprintf(stderr, "where file is the puzzle input file\n");
    exit(1);
  }

  /* attempt to open the file */
  if ((fp = fopen(argv[1], "r")) == NULL) {
    fprintf(stderr, "Unable to open puzzle input file %s\n", argv[1]);
    exit(1);
  }

  /* allocate the start node */
  if ((start = (struct Node *)malloc(sizeof(struct Node))) == NULL) {
    fprintf(stderr, "Out of memory!\n");
    exit(1);
  }

  /* allocate the goal node */
  if ((goal = (struct Node *)malloc(sizeof(struct Node))) == NULL) {
    fprintf(stderr, "Out of memory!\n");
    exit(1);
  }

  /* loop while file not exhausted and succesfully reading puzzles */
  while (!feof(fp) && read_puzzle(fp, start, goal, &max_depth)) {

    printf("Start puzzle:\n");
    print_node(start);

    printf("\nGoal puzzle:\n");
    print_node(goal);
    printf("\n");

    /* here the validity and parity matching of the puzzles is checked */
    if (!is_valid(start)) {
      printf("Start puzzle is invalid!\n");
    } else if (!is_valid(goal)) {
      printf("Goal puzzle is invalid!\n");
    } else if (parity(goal) != parity(start)) {
      printf("Puzzle parity does not match, no solution!\n");
    } else {
      manhattan = (int *)malloc(start->rows * start->cols * start->rows *
                                start->cols * sizeof(int));
      if (manhattan == NULL) {
        fprintf(stderr, "Out of memory!\n");
        exit(1);
      }
      node_gens = 1; /* the start node is the first */
      gettimeofday(&start_tv, NULL); /* including manhattan calculation */
      build_manhattan(start, manhattan);
      thold = manhattan_distance(goal, manhattan);
      /* this is the puzzle solution loop, doing a DFS style A* to    */
      /* succesively deeper levels until the problem is solved or the */
      /* max_depth exceeded.  This is known as IDA*, Iterative        */
      /* Deepening A*                                                 */
      while (!solved && thold <= max_depth) {
        new_thold = INT_MAX;
        solved = expand(goal, thold, &new_thold, start, manhattan);
        thold = new_thold;
      }
      gettimeofday(&finish_tv, NULL);

      free(manhattan);

      if (solved) {
        printf("\nProblem solved!\n");
      } else {
        printf("\nProblem not solved within cost %d!\n", max_depth);
      }

      printf("Node generations: %20.6f\n", (double)node_gens);
      printf("Elapsed time:     %20.6f\n",
	     (double)time_diff(&start_tv, &finish_tv) / 1000000);
      printf("Nodes / Second:   %20.6f\n", node_gens /
	     ((double)time_diff(&start_tv, &finish_tv) / 1000000));

    }

    /* reset everything for the next set of puzzles */
    solved = 0;
    free(goal->grid);
    free(start->grid);

    /* and print a separator between each puzzle solution attempt */
    printf("========================================================\n");

  }

}
