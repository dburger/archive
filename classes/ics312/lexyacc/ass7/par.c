#include <stdio.h>
#include <math.h>
#define MAX_VAR_LENGTH 20
int main() {
  int A = getVar("d");
  int B = getVar("c");
  int C = 3;
  int D = pow(B,C);
  int E = 3;
  int F = D % E;
  int G = A - F;
  int H = 5;
  int I = G + H;
  int J = A;
  int K = B;
  int L = J + K;
  int M = 2;
  int N = L - M;
  int O = I / N;
  printf("Result: %d\n", O);
}
int getVar(char *varName) {
  char s[MAX_VAR_LENGTH];
  printf("Value for var %s:  ",varName);
  fgets(s,MAX_VAR_LENGTH,stdin);
  return atoi(s);
}
