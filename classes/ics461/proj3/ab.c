/*                               -*- Mode: C -*- 
 * ab.c -- 
 * Author          : David J. Burger
 * Created On      : Thu Mar 20 10:39:03 2003
 * Last Modified By: David J. Burger
 * Last Modified On: Thu Mar 20 10:53:16 2003
 * RCS: $Id$
 * For:            : ICS 461, Curt Powley
 *
 * This program computes the alpha beta minimax value for given
 * input trees.  The program is executed via:
 *
 * ./ab input
 *
 * Where input is an input file of tree data.  The data is of the
 * format:
 *
 * depth
 * leaves at depth separated by spaces
 *
 * See the accompanying input file for more details.
 * The program works by doing a depth first search down to the
 * depth of the tree and then using these values in an alpha beta
 * minimax traversal, pruning as it goes.
 *
 */
#include <stdio.h>
#include <limits.h>
#include <math.h>

/* forward declares */
int minimax(int node_index, int node_depth, int alpha, int beta);
int maximin(int node_index, int node_depth, int alpha, int beta);

/* globals */
int leaves_examined, max_depth, *tree;

/*
 * Reads tree data from file pointer fp, returning 1 if successful.
 *
 * @param fp  open file pointer for input data file
 * @return  1 if successful, otherwise 0
 */
int read_tree(FILE *fp) {
  int last_row_size, tree_size;
  if (fscanf(fp, "%d", &max_depth) < 1) return 0;
  if (max_depth < 0) return 0;
  last_row_size = pow(2, max_depth);
  tree_size = 2 * last_row_size - 1;
  if ((tree = (int *)malloc(sizeof(int) * tree_size)) == NULL) return 0;
  while (last_row_size) {
    if (fscanf(fp, "%d", &tree[tree_size - last_row_size--]) < 1) {
      free(tree);
      return 0;
    }
  }
  return 1;
}

/*
 * Prints the leaves of the currently loaded tree.
 */
void print_leaves() {
  int last_row_size = pow(2, max_depth);
  int tree_size = 2 * last_row_size - 1;
  printf("leaves:\n");
  while (last_row_size)
    printf("%02d ", tree[tree_size - last_row_size--]);
  printf("\n");
}

/*
 * Prints the bound for leaf examinatino of the currently loaded tree.
 */
void print_leaf_bounds() {
  /* only binary trees for this program */
  int last_row_size = pow(2, max_depth);
  int min_leaves = pow(2, max_depth / 2) + 
                   pow(2, max_depth / 2 + max_depth % 2) - 1;
  printf("examination bounds [%d, %d]\n", min_leaves, last_row_size);
}

/*
 * Computes maximin value for given node.  This function is called on
 * max nodes.  It will adjust the alpha bound up and then return the
 * alpha bound.
 *
 * @param node_index  array index of given node
 * @param alpha       alpha bound value for all ancestors
 * @param beta        beta bound value for all ancestors
 */
int maximin(int node_index, int node_depth, int alpha, int beta) {
  int i, value;
  if (node_depth == max_depth) {
    leaves_examined++;
    printf("%02d ", tree[node_index]);
    return tree[node_index];
  }
  for (i=0; i<2; i++) {
    value = minimax(2 * node_index + i + 1, node_depth + 1, alpha, beta);
    if (value > alpha) alpha = value;
    if (alpha >= beta) return alpha;
  }
  return alpha;
}

/*
 * Computes minimax value for given node.  This function is called on
 * min nodes.  It will adjust the beta bound down and then return the
 * beta bound.
 *
 * @param node_index  array index of given node
 * @param alpha       alpha bound value for all ancestors
 * @param beta        beta bound value for all ancestors
 */
int minimax(int node_index, int node_depth, int alpha, int beta) {
  int i, value;
  if (node_depth == max_depth) {
    leaves_examined++;
    printf("%02d ", tree[node_index]);
    return tree[node_index];
  }
  for (i=0; i<2; i++) {
    value = maximin(2 * node_index + i + 1, node_depth + 1, alpha, beta);
    if (value < beta) beta = value;
    if (beta <= alpha) return beta;
  }
  return beta;
}

/*
 * Main entry point of program.  Executes a loop that loads tree data and
 * then performs alpha beta minimax on the tree.
 */
int main(int argc, char *argv[]) {

  FILE *fp;
  int problem = 1, minimax;

  /* check for proper command line parameters */
  if (argc != 2) {
    printf("Proper usage is %s file\n", argv[0]);
    exit(1);
  }

  /* now attempt to open the input file */
  if ((fp = fopen(argv[1], "r")) == NULL) {
    printf("Unable to open input file %s\n", argv[1]);
    exit(1);
  }

  /* main loop, read tree data, execute alpha beta minimax */
  while (read_tree(fp)) {
    print_leaves();
    print_leaf_bounds();
    printf("leaves examined:\n");
    leaves_examined = 0;
    minimax = maximin(0, 0, INT_MIN, INT_MAX);
    printf("\n%d leaves examined\n", leaves_examined);
    printf("minimax value of problem %d is %d\n",
           problem++, minimax);
    printf("============================================================\n");
    free(tree);
  }

}