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
#include <time.h>

/* a search that goes to depth 500 would probably take several years ??? */
#define MAX_SEARCH_PATH 500

enum { MANHATTAN, MISPLACED };

/* global variables, built for pure speed ... */
char search_path[MAX_SEARCH_PATH]; /* holds moves (LURD) to current_depth */
int *goal_grid;
int *current_grid;
int current_depth;
int current_heuristic;
int current_blank;
int rows;
int cols;
int cells;
int *heuristic_table; /* hold the heuristic calculation table */
int thold;
int new_thold;
int max_depth;
unsigned long node_gens;

/* this variable will be used to avoid some math when checking for down moves */
int last_row;

/*
 * Used to print the puzzle grid of a Node.
 *
 * @param *grid  grid array of puzzle to print
 */
void print_node(int *grid) {
  int row, col;
  for (row=0; row<rows; row++) {
    for (col=0; col<cols; col++) {
      printf("%02d  ", grid[cols * row + col]);
    }
    printf("\n");
  }
}

/*
 * Builds a manhattan scoring table for the passed in goal grid. heuristic
 * must have been malloc'ed to the appropriate size.
 *
 * @param *grid  grid array of puzzle to make heuristic table for
 */
void build_manhattan(int *grid) {
  int i, j, current_row, current_col, target_row, target_col, offset;
  for (i=0; i<cells; i++) {
    target_row = i / cols;
    target_col = i % cols;
    for (j=0 ; j<cells; j++) {
      current_row = j / cols;
      current_col = j % cols;
      offset = abs(target_row - current_row) + abs(target_col - current_col);
      heuristic_table[grid[i] * cells + j] = !grid[i] ? 0 : offset;
    }
  }
}

/*
 * Builds a misplaced scoring table for the passed in goal grid. heuristic
 * must have been malloc'ed to the appropriate size.
 *
 * @param *goal  grid array of puzzle to make heuristic table for
 */
void build_misplaced(int *grid) {
  int i, j;
  for (i=0; i<cells; i++) {
    for (j=0 ; j<cells; j++) {
      heuristic_table[grid[i] * cells + j] = !grid[i] ? 0 : (i != j);
    }
  }
}

/*
 * Returns the heuristic distance for n
 *
 * @param *grid  grid array to calculate heuristic value for
 */
int calc_heuristic(int *grid) {
  int row, col, cell;
  int distance = 0;
  for (row=0; row<rows; row++) {
    for (col=0; col<cols; col++) {
      cell = row * cols + col;
      distance += heuristic_table[cells * grid[cell] + cell];
    }
  }
  return distance;
}

/*
 * Prints the heuristic distance table for each cell
 * 
 */
void print_heuristic_table() {
  int i, row, col;
  for (i=0; i<cells; i++) {
    printf("%d:\n", i);
    for (row=0; row<rows; row++) {
      for (col=0; col<cols; col++) {
        printf("%02d  ", heuristic_table[i * cells + cols * row + col]);
      }
      printf("\n");
    }
    printf("\n");
  }
}

/*
 * Used to move the blank left in the current puzzle.  This function does
 * not check if it is a valid move so that check should be made before
 * calling this function.
 *
 */
void blank_left() {
  int new_blank_pos = current_blank - 1;
  int temp = current_grid[new_blank_pos];
  /* now move the tile */
  current_grid[new_blank_pos] = 0;
  current_grid[current_blank] = temp;
  current_heuristic += heuristic_table[cells * temp + current_blank] -
      heuristic_table[cells * temp + new_blank_pos];
  current_blank = new_blank_pos;
  search_path[current_depth] = 'L';
}

/*
 * Used to move the blank right for the given Node.  Note that this function
 * does not check if right is a valid move so it should be checked before
 * calling this function.
 *
 */
void blank_right() {
  int new_blank_pos = current_blank + 1;
  int temp = current_grid[new_blank_pos];
  /* now move the tile */
  current_grid[new_blank_pos] = 0;
  current_grid[current_blank] = temp;
  current_heuristic += heuristic_table[cells * temp + current_blank] -
      heuristic_table[cells * temp + new_blank_pos];
  current_blank = new_blank_pos;
  search_path[current_depth] = 'R';
}

/*
 * Used to move the blank up for the given Node.  Note that this function
 * does not check if up is a valid move so it should be checked before
 * calling this function.
 *
 */
void blank_up() {
  int new_blank_pos = current_blank - cols;
  int temp = current_grid[new_blank_pos];
  /* now move the tile */
  current_grid[new_blank_pos] = 0;
  current_grid[current_blank] = temp;
  current_heuristic += heuristic_table[cells * temp + current_blank] -
      heuristic_table[cells * temp + new_blank_pos];
  current_blank = new_blank_pos;
  search_path[current_depth] = 'U';
}

/*
 * Used to move the blank down for the given Node.  Note that this function
 * does not check if down is a valid move so it should be checked before
 * calling this function.
 *
 */
void blank_down() {
  int new_blank_pos = current_blank + cols;
  int temp = current_grid[new_blank_pos];
  /* now move the tile */
  current_grid[new_blank_pos] = 0;
  current_grid[current_blank] = temp;
  current_heuristic += heuristic_table[cells * temp + current_blank] -
      heuristic_table[cells * temp + new_blank_pos];
  current_blank = new_blank_pos;
  search_path[current_depth] = 'D';
}

/*
 * Expands the node at the frontier of the search path.
 *
 * return  1 if the goal the goal is found to be n or one of its descendents,
 *         0 if the goal is not found within max_depth
 */
int expand() {
  int cost, result;

  /* check to see if the node should be expanded */
  if ((cost = current_depth + current_heuristic) > thold) {
    /* if lowest cost node not expanded, then threshold for next round */
    if (cost < new_thold) new_thold = cost;
    return 0;
  }

  /* solved when current_heuristic == 0 */
  if (!current_heuristic) return 1;

  /* could have rolled this into a little loop and eliminate repeated code */
  /* but this should be a little faster                                    */

  /* up move */
  if (search_path[current_depth] != 'D' && current_blank >= cols) {
    current_depth++;
    node_gens++;
    blank_up();
    result = expand();
    if (result) return 1;
    blank_down();
    current_depth--;
  }

  /* left move */
  if (search_path[current_depth] != 'R' && current_blank % cols) {
    current_depth++;
    node_gens++;
    blank_left();
    result = expand();
    if (result) return 1;
    blank_right();
    current_depth--;
  }

  /* right move */
  if (search_path[current_depth] != 'L' && (current_blank + 1) % cols) {
    current_depth++;
    node_gens++;
    blank_right();
    result = expand();
    if (result) return 1;
    blank_left();
    current_depth--;
  }

  /* down move */
  if (search_path[current_depth] != 'U' && current_blank < last_row) {
    current_depth++;
    node_gens++;
    blank_down();
    result = expand();
    if (result) return 1;
    blank_up();
    current_depth--;
  }

  return 0;

}

/*
 * Checks to see if a given grid is a valid puzzle, checking that all
 * valid numbers for an M x N grid have been used without repeat.
 *
 * @param *grid  grid array to check if valid
 * return  1 if valid, otherwise 0
 */
  int is_valid(int *grid) {
  int i;
  int *check = (int *)calloc(cells, sizeof(int));
  if (check == NULL) return 0;

  for (i=0; i<cells; i++) {
    if (grid[i] >= 0 && grid[i] < cells) check[grid[i]] = 1;
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
 * Returns the parity for the given grid.  Parity is the number of inversions
 * that are found in the grid and can be used to determine which states can
 * be reached from other states...the parity must match, even or odd.  See:
 * The Moment of Proof, Mathematical Epiphanies, Donald C. Benson
 *
 * @param *grid  grid array to check parity of
 */
  int parity(int *grid) {
  int row, col, number, inversions;
  int cell;
  number = inversions = 0;
  for (number=1; number<cells; number++) {
    for (row=0; row<rows; row++) {
      if (row % 2 == 0) {
        for (col=0; col<cols; col++) {
          cell = row * cols + col;
          if (grid[cell] == number) {
            row = rows;
            break;
          }
          if (grid[cell] > number) inversions++;
        }
      } else {
        for (col=cols-1; col>=0; col--) {
          cell = row * cols + col;
          if (grid[cell] == number) {
            row = rows;
            break;
          }
          if (grid[cell] > number) inversions++;
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
 * return  1 if successful and the nodes and maximum depth are filled in,
 *         0 if an error occurs
 */
int read_puzzle(FILE *fp) {
  int i;
  /* read in the dimensions and then allocate nodes */
  if (fscanf(fp, "%d %d %d", &rows, &cols, &max_depth) < 3) return 0;
  if ((cells = rows*cols) <= 0) return 0;

  /* malloc the grids */
  if ((current_grid = (int *)malloc(cells * sizeof(int))) == NULL) {
    return 0;
  }

  if ((goal_grid = (int *)malloc(cells * sizeof(int))) == NULL) {
    free(current_grid);
    return 0;
  }

  /* read in the start puzzle */
  for (i=0; i<cells; i++) {
    if (fscanf(fp, "%d", &current_grid[i]) < 1) {
      free(current_grid);
      free(goal_grid);
      return 0;
    }
    if (current_grid[i] == 0) current_blank = i;
  }

  /* read in the goal puzzle */
  for (i=0; i<cells; i++) {
    if (fscanf(fp, "%d", &goal_grid[i]) < 1) {
      free(current_grid);
      free(goal_grid);
      return 0;
    }
  }

  search_path[0] = 'X';

  return 1;
}

/*
 * Main entry point of the program.  It opens the input file, running a loop
 * that reads puzzle data and then solves the puzzle.
 */
int main(int argc, char *argv[]) {
  int chosen_heuristic, i, solved = 0;
  FILE *fp;
  clock_t clock_start, clock_finish;
  double elapsed_time;
  unsigned long last_gens;

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

  /* loop while file not exhausted and succesfully reading puzzles */
  while (!feof(fp) && read_puzzle(fp)) {

    printf("Start puzzle:\n");
    print_node(current_grid);

    printf("\nGoal puzzle:\n");
    print_node(goal_grid);
    printf("\n");

    /* here the validity and parity matching of the puzzles is checked */
    if (!is_valid(current_grid)) {
      printf("Start puzzle is invalid!\n");
    } else if (!is_valid(goal_grid)) {
      printf("Goal puzzle is invalid!\n");
    } else if (parity(goal_grid) != parity(current_grid)) {
      printf("Puzzle parity does not match, no solution!\n");
    } else {
      heuristic_table = (int *)malloc(rows * cols * rows * cols * sizeof(int));
      if (heuristic_table == NULL) {
        fprintf(stderr, "Out of memory!\n");
        exit(1);
      }
      clock_start = clock();

      if (chosen_heuristic == MANHATTAN) {
        build_manhattan(goal_grid); /* note backward chaining */
      } else if (chosen_heuristic == MISPLACED) {
        build_misplaced(goal_grid); /* note backward chaining */
      }

      last_gens = 0;
      node_gens = 1; /* the start node is the first */
      current_depth = 0;
      last_row = cells - cols; /* avoid subtraction on checking down moves */
      thold = current_heuristic =  calc_heuristic(current_grid);
      /* this is the puzzle solution loop, doing a DFS style A* to    */
      /* succesively deeper levels until the problem is solved or the */
      /* max_depth exceeded.  This is known as IDA*, Iterative        */
      /* Deepening A*  p                                               */
      while (!solved && thold <= max_depth) {
        new_thold = INT_MAX;
        solved = expand();
        printf("%2d %12d\n", thold, node_gens - last_gens);
        last_gens = node_gens;
        thold = new_thold;
      }
      clock_finish = clock();

      if (solved) {
        for (i=1;i<=current_depth; i++) {
          printf("%c", search_path[i]);
        }
      }

      free(heuristic_table);

      if (solved) {
        printf("\nProblem solved!\n");
      } else {
        printf("\nProblem not solved within cost %d!\n", max_depth);
      }

      printf("Node generations: %20.6f\n", (double)node_gens);
      elapsed_time = (double)(clock_finish - clock_start) / CLOCKS_PER_SEC;
      printf("Elapsed time:     %20.6f\n", elapsed_time);
      printf("Nodes / Second:   %20.6f\n", node_gens / elapsed_time);
    }

    /* reset everything for the next set of puzzles */
    solved = 0;
    free(goal_grid);
    free(current_grid);

    /* and print a separator between each puzzle solution attempt */
    printf("========================================================\n");

  }

}
