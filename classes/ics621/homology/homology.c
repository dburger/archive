/*
  Homology Analysis program
  by David J. Burger
  for Dr. Sugihara
  ICS 621, Spring 2002
*/
#include <stdio.h>
#include <stdlib.h>

#define MAX_STRING 2000
#define min(X, Y) ((X) < (Y) ? (X) : (Y))
#define NUM_BASES 4

int bases[] = { 'A', 'C', 'G', 'T' };

/* converts the base c into its index within the cost arrays */
int ndx(int c) {
  int n;
  for (n=0;n<NUM_BASES;n++)
    if (bases[n]==c) return n;
  return -1;  /* no base match */
}

/* retrieves a DNA sequence int buf of at most len-1 characters */
int get_sequence(char *buf, int len) {
  int c, n = 0;
  while (n<(len-1)) {
    if ((c = getchar())=='\n') break;
    if (c=='A' || c=='C' || c=='G' || c=='T') buf[n++] = c;
  }
  buf[n] = 0;
  return n;
}

/* returns the minimum of the triple a, b, c */
double min3(double a, double b, double c) {
  return min(min(a,b),c);
}

/*
  calculates and returns the length of a homology analysis transformation
  using dynamic programming
  
  char *source - the source string
  char *target - the target string
  double insert[] - probabilities for the inserts
  double delete[] - probabilities for the deletes
  double replace[][] - probabilities for the replaces
*/
double length(char *source, char *target, double insert[], double delete[],
	      double replace[][NUM_BASES]) {
  double state[strlen(source)+1][strlen(target)+1];
  int j,k;
  double max_prob = 0;

  /* first we find the greatest probability among all probabilities */
  for (j=0;j<NUM_BASES;j++) {
    if (insert[j]>max_prob) max_prob = insert[j];
    if (delete[j]>max_prob) max_prob = delete[j];
  }

  for (j=0;j<NUM_BASES;j++)
    for (k=0;k<NUM_BASES;k++)
      if (replace[j][k]>max_prob) max_prob = replace[j][k];

  /* now change the values in the arrays to represent respective weights */
  for (j=0;j<NUM_BASES;j++) {
    insert[j]/=max_prob;
    delete[j]/=max_prob;
  }

  for (j=0;j<NUM_BASES;j++)
    for (k=0;k<NUM_BASES;k++)
      replace[j][k]/=max_prob;

  state[0][0] = 0;  /* starting point has length 0 */

  for (j=1;j<strlen(source)+1;j++)  /* left col is all delete */
    state[j][0] = state[j-1][0] + delete[ndx(source[j-1])];

  for (k=1;k<strlen(target)+1;k++)  /* top row is all insert */
    state[0][k] = state[0][k-1] + insert[ndx(target[k-1])];

  for (j=1;j<strlen(source)+1;j++)
    for (k=1;k<strlen(target)+1;k++)
      state[j][k] = min3( 
               state[j-1][k] + delete[ndx(source[j-1])],
               state[j-1][k-1] + replace[ndx(source[j-1])][ndx(target[k-1])],
               state[j][k-1] + insert[ndx(target[k-1])] 
      );

  return state[strlen(source)][strlen(target)];

}

/* retrieves source, target, probs and initiates homology analysis */
int main(int argc, char *argv[]) {

  int j,k;
  char source[MAX_STRING], target[MAX_STRING], input[MAX_STRING];
  double insert[NUM_BASES];
  double delete[NUM_BASES];
  double replace[NUM_BASES][NUM_BASES];

  printf("Enter the source string:");
  get_sequence(source,MAX_STRING);
  printf("The source string is: %s\n",source);

  printf("Enter the target string:");
  get_sequence(target,MAX_STRING);
  printf("The target string is: %s\n\n",target);

  for (j=0;j<NUM_BASES;j++) {
    printf("Enter the cost to insert base %c: ",bases[j]);
    fgets(input,MAX_STRING,stdin);
    insert[j] = atof(input);
  }

  printf("\n");

  for (j=0;j<NUM_BASES;j++) {
    printf("Enter the cost to delete base %c: ",bases[j]);
    fgets(input,MAX_STRING,stdin);
    delete[j] = atof(input);
  }

  printf("\n");

  for (j=0;j<NUM_BASES;j++) {
    for (k=0;k<NUM_BASES;k++) {
      if (j==k)
        replace[j][k] = 0;
      else {
        printf("Enter the cost to replace base %c with base %c: ",bases[j],
               bases[k]);
        fgets(input,MAX_STRING,stdin);
        replace[j][k] = atof(input);
      }
    }
    printf("\n");
  }

  printf("The length is of the transformation is %f\n",
         length(source,target,insert,delete,replace));

}
