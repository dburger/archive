#include <stdio.h>
#include <string.h>

void reverse(char str[], int s, int e) {
  while (s < e) {
    char t = str[s];
    str[s] = str[e];
    str[e] = t;
    s++;
    e--;
  }
}

int main(int argc, char** argv) {
  int len = strlen(argv[1]);
  reverse(argv[1], 0, len - 1);
  int s = 0;
  int e = 0;
  while (s < len) {
    while (argv[1][s] == " ") s++;
    e = s;
    while (argv[1][e] != " ") e++;
    reverse(argv[1], s, e - 1);
    s = e;
  }
  printf("%s\n", argv[1]);
}
