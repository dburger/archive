#include <stdio.h>

/*
   01/15/01
   lc.c by David J. Burger for ICS 212
   This program converts all upper case letters
   in a text file to lower case.
   It is called like this:
   lc < infile.txt > outfile.txt
*/

main() {

  int c;
  
  while((c=getchar())!=EOF) {
    if (c>='A' && c<='Z')
      c='a'+c-'A';
    putchar(c);
  }
  
}
