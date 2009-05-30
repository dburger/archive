/*
 * IDA* Solution to N x M puzzle problems by:
 *
 * David J. Burger
 *
 * for ICS 461, Artifical Intelligence, Curt Powley
 *
 * To run this program:
 * ./puzzle data -man|-mis
 * where data is a file that contains puzzle problems and the -man|-mis
 * tells the program to use manhattan or misplaced heuristics. The format
 * of the data file should be as follows:

rows cols max_depth
first_cell second_cell ...
first_cell second_cell ...

 * where rows is the number of rows in the puzzle, cols is the number of
 * columns in the puzzle, and max_depth is the maximum depth that the IDA*
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

enum { MANHATTAN, MISPLACED };

/* a Node represents a configuration state in the search tree */
struct Node {
  char via; /* how this state was acheived, R, L, U, D, or X if root */
  int rows;
  int cols;
  int cells; /* to avoid multiplications later */
  int *grid; /* pointer to the puzzle grid, maintained as single dim array */
  int blank_pos;
  int depth;
  int heuristic; /* holds the heuristic value for this node */
};

/* global variable used to count node generations */
int node_gens;

/* the "new" globals, purely for speed up */
int thold;
int new_thold;
struct Node *goal;
int *heuristic;

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
 * Builds a manhattan scoring table for the passed in goal grid. heuristic
 * must have been malloc'ed to the appropriate size.
 *
 * @param *goal  the node to build the heuristic table for
 */
void build_manhattan(struct Node *goal) {
  int i, j, current_row, current_col, target_row, target_col, offset;
  for (i=0; i<goal->cells; i++) {
    target_row = i / goal->cols;
    target_col = i % goal->cols;
    for (j=0 ; j<goal->cells; j++) {
      current_row = j / goal->cols;
      current_col = j % goal->cols;
      offset = abs(target_row - current_row) + abs(target_col - current_col);
      heuristic[goal->grid[i] * goal->cells + j] = !goal->grid[i] ? 0 : offset;
    }
  }
}

/*
 * Builds a misplaced scoring table for the passed in goal grid. heuristic
 * must have been malloc'ed to the appropriate size.
 *
 * @param *goal  the node to build the heuristic table for
 */
void build_misplaced(struct Node *goal) {
  int i, j;
  for (i=0; i<goal->cells; i++) {
    for (j=0 ; j<goal->cells; j++) {
      heuristic[goal->grid[i] * goal->cells + j] =
        !goal->grid[i] ? 0 : (i != j);
    }
  }
}

/*
 * Builds an empty scoring table for the passed in goal grid. heuristic
 * must have been malloc'ed to the appropriate size.
 *
 * @param *goal  the node to build the heuristic table for
 */
void build_none(struct Node *goal) {
  int i;
  for (i=0; i<goal->cells; i++) heuristic[i] = 0;
}

/*
 * Returns the heuristic distance for n
 *
 * @param *n  the node to compute the heuristic distance for
 */
int calc_heuristic(struct Node *n) {
  int row, col, cell;
  int distance = 0;
  for (row=0; row<n->rows; row++) {
    for (col=0; col<n->cols; col++) {
      cell = row * n->cols + col;
      distance += heuristic[n->cells * n->grid[cell] + cell];
    }
  }
  return distance;
}

/*
 * Prints the heuristic distance for each cell.
 * 
 * @param rows        number of rows in the puzzle
 * @param cols        number of columns in the puzzle
 */
void print_heuristic(int rows, int cols) {
  int i, row, col, cells = rows * cols;
  for (i=0; i<cells; i++) {
    printf("%d:\n", i);
    for (row=0; row<rows; row++) {
      for (col=0; col<cols; col++) {
        printf("%02d  ", heuristic[i * cells + cols * row + col]);
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
 * calling this function.  Call with *heuristic == NULL when you only need
 * this routine to undo the changes to the grid, and not to keep the rest
 * of the state in sync.
 *
 * @param *n          node to move the blank left for
 * @param *heuristic  calcuated table of heuristic values
 */
void blank_left(struct Node *n, int *heuristic) {
  int row = blank_row(n);
  int col = blank_col(n);
  int new_blank_pos = row * n->rows + col - 1;
  int temp = n->grid[new_blank_pos];
  /* now move the tile */
  n->grid[new_blank_pos] = 0;
  n->grid[n->blank_pos] = temp;
  /* adjust heuristic, blank_pos, via, not necessary on undo move */
  if (heuristic) {
    n->heuristic += heuristic[n->cells * temp + n->blank_pos] -
      heuristic[n->cells * temp + new_blank_pos];
    n->blank_pos = new_blank_pos;
    n->via = 'L';
  }
}

/*
 * Used to move the blank right for the given Node.  Note that this function
 * does not check if right is a valid move so it should be checked before
 * calling this function.  Call with *heuristic == NULL when you only need
 * this routine to undo the changes to the grid, and not to keep the rest
 * of the state in sync.
 *
 * @param *n  the node to move the blank right for
 * @param *heuristic  calcuated table of heuristic values
 */
void blank_right(struct Node *n, int *heuristic) {
  int row = blank_row(n);
  int col = blank_col(n);
  int new_blank_pos = row * n->rows + col + 1;
  int temp = n->grid[new_blank_pos];
  /* now move the tile */
  n->grid[new_blank_pos] = 0;
  n->grid[n->blank_pos] = temp;
  /* adjust heuristic, blank_pos, via, not necessary on undo move */
  if (heuristic) {
    n->heuristic += heuristic[n->cells * temp + n->blank_pos] -
      heuristic[n->cells * temp + new_blank_pos];
    n->blank_pos = new_blank_pos;
    n->via = 'R';
  }
}

/*
 * Used to move the blank up for the given Node.  Note that this function
 * does not check if up is a valid move so it should be checked before
 * calling this function.  Call with *heuristic == NULL when you only need
 * this routine to undo the changes to the grid, and not to keep the rest
 * of the state in sync.
 *
 * @param *n  the node to move the blank up for
 * @param *heuristic  calcuated table of heuristic values
 */
void blank_up(struct Node *n, int *heuristic) {
  int row = blank_row(n);
  int col = blank_col(n);
  int new_blank_pos = (row - 1) * n->rows + col;
  int temp = n->grid[new_blank_pos];
  /* now move the tile */
  n->grid[new_blank_pos] = 0;
  n->grid[n->blank_pos] = temp;
  /* adjust heuristic, blank_pos, via, not necessary on undo move */
  if (heuristic) {
    n->heuristic += heuristic[n->cells * temp + n->blank_pos] -
      heuristic[n->cells * temp + new_blank_pos];
    n->blank_pos = new_blank_pos;
    n->via = 'U';
  }
}

/*
 * Used to move the blank down for the given Node.  Note that this function
 * does not check if down is a valid move so it should be checked before
 * calling this function.  Call with *heuristic == NULL when you only need
 * this routine to undo the changes to the grid, and not to keep the rest
 * of the state in sync.
 *
 * @param *n  the node to move the blank down for
 * @param *heuristic  calcuated table of heuristic values
 */
void blank_down(struct Node *n, int *heuristic) {
  int row = blank_row(n);
  int col = blank_col(n);
  int new_blank_pos = (row + 1) * n->rows + col;
  int temp = n->grid[new_blank_pos];
  /* now move the tile */
  n->grid[new_blank_pos] = 0;
  n->grid[n->blank_pos] = temp;
  /* adjust heuristic, blank_pos, via, not necessary on undo move */
  if (heuristic) {
    n->heuristic += heuristic[n->cells * temp + n->blank_pos] -
      heuristic[n->cells * temp + new_blank_pos];
    n->blank_pos = new_blank_pos;
    n->via = 'D';
  }
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
  #ifdef SAFE
  if (child == NULL) return NULL;
  #endif

  child->via = parent->via;
  child->rows = parent->rows;
  child->cols = parent->cols;
  child->cells = parent->cells;
  child->grid = parent->grid;
  child->blank_pos = parent->blank_pos;
  child->depth = parent->depth + 1;
  child->heuristic = parent->heuristic;

  node_gens++;
  return child;
}

/*
 * Expands the given node, creating its children and recursing upon them as it
 * goes.
 *
 * @param *n          the node that we are expanding
 * return  1 if the goal the goal is found to be n or one of its descendents,
 *         0 if the goal is not found within max_depth
 */
int expand(struct Node *n) {
  int cost, result;
  struct Node *child;

  /* check to see if the node should be expanded */
  if ((cost = n->depth + n->heuristic) > thold) {
    /* if lowest cost node not expanded, then threshold for next round */
    if (cost < new_thold) new_thold = cost;
    return 0;
  }

  /* solved when heuristic == 0 */
  if (!n->heuristic) {
    printf("%c", inverse_move(n->via));
    return 1;
  }

  /* could have rolled this into a little loop and eliminate repeated code */
  /* but this should be a little faster                                    */

  /* left move */
  if (n->via != 'R' && blank_col(n) > 0) {
    #ifdef SAFE
    if ((child = create_child(n)) == NULL) {
      fprintf(stderr, "Out of memory!\n");
      exit(1);
    }
    #else
    child = create_child(n);
    #endif
    blank_left(child, heuristic);
    result = expand(child);
    blank_right(child, NULL);
    free(child);
    if (result) {
      printf("%c", inverse_move(n->via));
      return 1;
    }
  }

  /* up move */
  if (n->via != 'D' && blank_row(n) > 0) {
    #ifdef SAFE
    if ((child = create_child(n)) == NULL) {
      fprintf(stderr, "Out of memory!\n");
      exit(1);
    }
    #else
    child = create_child(n);
    #endif
    blank_up(child, heuristic);
    result = expand(child);
    blank_down(child, NULL);
    free(child);
    if (result) {
      printf("%c", inverse_move(n->via));
      return 1;
    }
  }

  /* right move */
  if (n->via != 'L' && blank_col(n) < n->cols - 1) {
    #ifdef SAFE
    if ((child = create_child(n)) == NULL) {
      fprintf(stderr, "Out of memory!\n");
      exit(1);
    }
    #else
    child = create_child(n);
    #endif
    blank_right(child, heuristic);
    result = expand(child);
    blank_left(child, NULL);
    free(child);
    if (result) {
      printf("%c", inverse_move(n->via));
      return 1;
    }
  }

  /* down move */
  if (n->via != 'U' && blank_row(n) < n->rows - 1) {
    #ifdef SAFE
    if ((child = create_child(n)) == NULL) {
      fprintf(stderr, "Out of memory!\n");
      exit(1);
    }
    #else
    child = create_child(n);
    #endif
    blank_down(child, heuristic);
    result = expand(child);
    blank_up(child, NULL);
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
  int i;
  int *check = (int *)calloc(n->cells, sizeof(int));
  if (check == NULL) return 0;

  for (i=0; i<n->cells; i++) {
    if (n->grid[i] >= 0 && n->grid[i] < n->cells) check[n->grid[i]] = 1;
  }

  for (i=0; i<n->cells; i++) {
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
  int cell;
  number = inversions = 0;
  for (number=1; number<n->cells; number++) {
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
  start->cells = goal->cells = rows * cols;
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
  int chosen_heuristic, max_depth, solved = 0;
  struct Node *start, *goal;
  FILE *fp;
  struct timeval start_tv, finish_tv;

  /* check for proper command line parameters */
  if (argc != 3) {
    fprintf(stderr, "Proper usage is %s file heuristic\n", argv[0]);
    fprintf(stderr, "where file is the puzzle input file,\n");
    fprintf(stderr, "and heuristic is -man or -mis\n");
    exit(1);
  }

  /* attempt to open the file */
  if ((fp = fopen(argv[1], "r")) == NULL) {
    fprintf(stderr, "Unable to open puzzle input file %s\n", argv[1]);
    exit(1);
  }

  /* now set the proper heuristic */
  if (strcmp(argv[2], "-man") == 0) {
    chosen_heuristic = MANHATTAN;
    printf("Manhattan distance heuristic will be used.\n");
  } else if (strcmp(argv[2], "-mis") == 0) {
    chosen_heuristic = MISPLACED;
    printf("Misplaced tiles heuristic will be used.\n");
  } else {
    chosen_heuristic = MANHATTAN;
    printf("Heuristic parameter %s not recognized,\n" \
           "manhattan distance will be used.\n", argv[2]);
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
      heuristic = (int *)malloc(start->rows * start->cols * start->rows *
                                start->cols * sizeof(int));
      if (heuristic == NULL) {
        fprintf(stderr, "Out of memory!\n");
        exit(1);
      }
      node_gens = 1; /* the start node is the first */
      gettimeofday(&start_tv, NULL); /* including heuristic calculation */

      if (chosen_heuristic == MANHATTAN) {
        build_manhattan(start); /* note backward chaining */
      } else if (chosen_heuristic == MISPLACED) {
        build_misplaced(start); /* note backward chaining */
      } else {
        build_none(start);
      }

      thold = goal->heuristic =  calc_heuristic(goal);
      /* this is the puzzle solution loop, doing a DFS style A* to    */
      /* succesively deeper levels until the problem is solved or the */
      /* max_depth exceeded.  This is known as IDA*, Iterative        */
      /* Deepening A*                                                 */
      while (!solved && thold <= max_depth) {
        new_thold = INT_MAX;
        /* notice the reversed goal and start...backward chaining */
        solved = expand(goal);
        thold = new_thold;
      }
      gettimeofday(&finish_tv, NULL);

      free(heuristic);

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
