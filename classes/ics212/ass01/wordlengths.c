#include <stdio.h>

#define IN 1
#define OUT 0

#define ONE_TO_FIVE 0
#define SIX_TO_TEN 1
#define ELEVEN_TO_FIFTEEN 2
#define SIXTEEN_TO_TWENTY 3
#define OVER_TWENTY 4

main() {

  int c, state, wl, i, j;

  int wordlengths[5];

  for (i=0;i<5;i++)
    wordlengths[i] = 0;

  wl = 0;

  state = OUT;

  while ((c=getchar())!=EOF) {
    if (state==IN) {
      if (c==' ' || c=='\n' || c=='\t') {
        /* add to length table */
        if (wl<=5)
          wordlengths[ONE_TO_FIVE]++;
        else if (wl<=10)
          wordlengths[SIX_TO_TEN]++;
        else if (wl<=15)
          wordlengths[ELEVEN_TO_FIFTEEN]++;
        else if (wl<=20)
          wordlengths[SIXTEEN_TO_TWENTY]++;
        else
          wordlengths[OVER_TWENTY]++;
        state = OUT;
        wl=0;
      } else
        wl++;
    } else {
      if (c!=' ' || c!='\n' || c!='\t') {
        state = IN;
        wl=1;
      }
    }
  }

  printf("==============================\n");
  printf("Word lengths distribution\n");
  printf("==============================\n");
  for (i=0;i<5;i++) {
    for (j=0;j<wordlengths[i];j++)
      printf("*");
    printf("\n");
  }
}
