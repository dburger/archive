#include <stdio.h>
#include <stdlib.h>

/* 
   01/15/01
   detab.c by David J. Burger for ICS 212
   This program will remove tab stops from a file and
   replace them with the appropriate number of spaces.
   This program is called like this:
   detab 7 < infile.txt > outfile.txt
   If the tabwidth is not provided a default of 4 is
   used.
*/

void main(int argc, char *argv[]) {

    int n; /* the tab spacing */
    int i = 0; /* used to track current column position */
    int c,sp;  /* used to read the next character and     
                  calculate number of spaces */

    /* first see if a tab width was passed in from the command line */
    if (argc<2)
        n = 4; /* default value */
    else
        n = atoi(argv[1]); /* value from command line */

    /* this while does all the work on the text */
    while ((c=getchar())!=EOF) {
	if (c=='\t') {
            sp = n -(i % n); /* calculate spaces to next tab stop */
            for (;sp>0;sp--) { /* space to the next tab */
                putchar(' ');
                i++;
            }
	} else if (c=='\n') {
            putchar(c);
            i = 0;
        } else {
            putchar(c);
            i++;
        }
    }

}       






