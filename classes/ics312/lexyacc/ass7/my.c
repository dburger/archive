#include <stdio.h>
#include <math.h>
#define MAX_VAR_LENGTH 20
int main() {
  int A = getVar("f");
  int B = 8;
  int C = A + B;
  int D = 9;
  int E = 7;
  int F = D * E;
  int G = C + F;
  int H = 4;
  int I = 2;
  int J = H / I;
  int K = G + J;
  int L = 4;
  int M = 7;
  int N = L * M;
  int O = A;
  int P = N * O;
  int Q = K + P;
  printf("Result: %d\n", Q);
}
int getVar(char *varName) {
  char s[MAX_VAR_LENGTH];
  printf("Value for var %s:  ",varName);
  fgets(s,MAX_VAR_LENGTH,stdin);
  return atoi(s);
}




