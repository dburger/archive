/*                               -*- Mode: C -*- 
 * nqueens.c -- 
 * Author          : David J. Burger
 * Created On      : Thu Apr 10 12:39:45 2003
 * Last Modified By: David J. Burger
 * Last Modified On: Tue May 13 11:54:23 2003
 * RCS: $Id$
 *
 * Determines solutions to N queens problems. Invoke via:
 *
 * ./nqueens input
 * Where,
 * input - a file that determines the problems to solve
 *
 * input has lines layed out as follows:
 * # extent method
 * Where,
 * # - number of queens
 * extent - if "all" finds all solutions, otherwise finds first
 * method - if "mrv" uses backtracking + mrv, otherwise simple backtracking
 *
 */
#include <stdio.h>
#include <limits.h>

#define PARAM_SIZE 5

/* global variables */
int *vars;
int num_assigned;
int num_values;
int num_vars;
int use_mrv;
int exhaustive;

int num_gens = 0;
int num_solutions = 0;
int num_checks = 0;

/*
 * Prints the current solution.
 */
void print_solution() {
  int i;
  for (i=0; i<num_vars; i++) {
    printf("%d ", vars[i]);
  }
  printf("\n");
}

/*
 * Determines if there is a safe play at position row, col.
 * Note that for backtracking without mrv we could actually write a routine
 * that only checks back "up" the board.  This routines looks in all
 * directions.
 *
 * @param row  row of position to check
 * @param col  col of position to check
 * return 1 if play is safe, 0 otherwise
 */
int safe_play(int var, int val) {
  int back_var, back_val, forward_var, forward_val, i;
  num_checks++;
  /* simple loop that does an offset from the var, val */
  for (i = 1; i < num_vars; i++) {
    /* calculate offsets from var, val */
    back_var = var - i;
    back_val = val - i;
    forward_var = var + i;
    forward_val = val + i;

    /* if none of the var / val values are valid then break */
    if (back_var < 0 && forward_var >= num_vars) break;

    /* check the vertical, don't check horizontal as only one queen per row */
    if (back_var >= 0 && vars[back_var] == val) return 0;
    if (forward_var < num_vars && vars[forward_var] == val) return 0;

    /* check the diagonals */
    if (back_var >= 0 && back_val >=0 && vars[back_var] == back_val) return 0;
    if (back_var >= 0 && forward_val < num_values && vars[back_var] == forward_val) return 0;
    if (forward_var < num_vars && forward_val < num_values && vars[forward_var] == forward_val) return 0;
    if (forward_var < num_vars && back_val >= 0 && vars[forward_var] == back_val) return 0;
  }
  return 1;
}

/*
 * Selects the next variable, or row in this case, that should be assigned.
 * For backtracking it will just be the next unassigned row.  For mrv the row
 * with the fewest plays on it is selected.
 *
 * @return  next variable to assign, or -1 if no variable left to be assigned
 *          contains a consistent assignment
 */
int select_unassigned() {
  if (use_mrv) {
    int best_mrv, curr_mrv, next_var, curr_var, value;
    best_mrv = INT_MAX;
    /* loop to calculate variable with best mrv */
    for (curr_var = 0; curr_var < num_vars; curr_var++) {
      /* only need to check those not assigned */
      if (vars[curr_var] == -1) {
        curr_mrv = 0;
        for (value = 0; value < num_values; value++) {
	  curr_mrv += safe_play(curr_var, value);
        }
	/* have found a better mrv? */
	if (curr_mrv < best_mrv) {
	  best_mrv = curr_mrv;
	  next_var = curr_var;
	  /* no need to check further if found a 0 */
	  if (curr_mrv == 0) break;
	}
      }
    }
    /* if best_mrv == 0, return -1 indicating row with no valid play */
    return best_mrv ? next_var : -1;
  } else {
    return num_assigned;
  }
}

/*
 * Checks if we are at a solution.  If current board is a solution returns 1
 * if looking for one solution, keeps going if exhaustive.  Gets next variable
 * for assignment, checks for valid values and recursively calls itself for
 * valid assignments.
 *
 * return  1 if searching for one solution and a solution is found, 0 if no
 *         solution is found or is called for exhaustive search
 */
int recursive_backtracking() {
  int value, next_var;
  /* is this a solution? */
  if (num_assigned == num_vars) {
    num_solutions++;
    return (!exhaustive);
  }
  /* -1 returned if varialbe w/o valid assignment when using mrv */
  if ((next_var = select_unassigned()) == -1) {
    return 0;
  }
  /* loop through values, checking for consistent assignments and recursing */
  for (value = 0; value < num_values; value++) {
    if (safe_play(next_var, value)) {
      vars[next_var] = value;
      num_assigned++;
      num_gens++;
      //if (recursive_backtracking() && !exhaustive) return 1;
      if (recursive_backtracking()) return 1;
      vars[next_var] = -1;
      num_assigned--;
    }
  }
  return 0;
}

/*
 * Main program entry point.  Reads the input file and solves the indicated
 * N queens problems.
 */
int main(int argc, char *argv[]) {
  int i;
  int last_num_gens = 0;
  int last_num_solutions = 0;
  int last_num_checks = 0;
  char extent[PARAM_SIZE];
  char heuristic[PARAM_SIZE];
  FILE *fp;

  /* check for command line parameter */
  if (argc != 2) {
    printf("Proper usage is %s input\n", argv[0]);
    printf("where input is the input file\n");
    exit(1);
  }

  /* try to open the input file */
  if ((fp = fopen(argv[1], "r")) == NULL) {
    printf("Unable to open input file %s\n", argv[1]);
    exit(1);
  }

  /* main loop */
  while (!feof(fp)) {
    if (fscanf(fp, "%d %s %s", &num_values, extent, heuristic) < 3) break;
    num_vars = num_values;
    exhaustive = !strcmp(extent, "all");
    use_mrv = !strcmp(heuristic, "mrv");

    /* malloc the board here */
    if ((vars = (int *)malloc(num_vars*sizeof(int))) == NULL) {
      printf("Out of memory!\n");
      exit(1);
    }

    /* initialize all variables to unassigned */
    for (i=0; i<num_vars; i++) {
      vars[i] = -1;
    }

    /* solve the specified N queens problem */
    num_assigned = 0;
    printf("%d queens, looking for %s solution(s):\n",
	   num_vars, exhaustive ? "all" : "1");
    recursive_backtracking();
    if (!exhaustive && num_solutions - last_num_solutions > 0)
      print_solution();
    printf("%d solution(s) found with %d node generations and %d checks\n",
	   num_solutions - last_num_solutions, num_gens - last_num_gens,
	   num_checks - last_num_checks);
    printf("==============================================================\n");
    last_num_gens = num_gens;
    last_num_solutions = num_solutions;
    last_num_checks = num_checks;
    free(vars);
  }

  printf("%d total solutions with %d total nodes generated and %d checks\n",
	 num_solutions, num_gens, num_checks);
  fclose(fp);

}
