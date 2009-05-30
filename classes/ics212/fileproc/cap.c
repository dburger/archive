#include <stdio.h>

/*
   01/15/01
   cap.c by David J. Burger for ICS 212
   This program replaces all lower case letters
   in a text file by upper case letters.
   It is called like this:
   cap < infile.txt > outfile.txt
*/

main() {

  int c;
  
  while((c=getchar())!=EOF) {
    if (c>='a' && c<='z')
      c='A'+c-'a';
    putchar(c);
  }
  
}
