/*
demonstrates simple usage of regular expressions in C
Copyright (C) 2003  David J. Burger, dburger@hawaii.edu

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
*/

/*
  aeiou, yes yes   a e i o u !!! uh huh, aeiou 
  Demonstration of regular expression usage in C.
*/
#include <stdio.h>
#include <regex.h>
#include <sys/types.h>

#define BUF_SIZE 1024

int main(int argc, char *argv[]) {

  FILE *fp;
  char buf[BUF_SIZE], *cp;
  int error, offset;

  regex_t regex;
  regmatch_t regmatch;

  /* check for command line argument */
  if (argc < 3) {
    fprintf(stderr, "Proper usages is %s filename pattern\n", argv[0]);
    return 1;
  }

  /* attempt to open argv[1] */
  if ((fp = fopen(argv[1], "r")) == NULL) {
    fprintf(stderr, "Unable to open %s\n", argv[1]);
    return 1;
  }

  /* attempt to compile the regex */
  if ((error = regcomp(&regex, argv[2], 0)) != 0) {
    regerror(error, &regex, buf, BUF_SIZE);
    fprintf(stderr, "Unable to compile the regex:\n");
    fprintf(stderr, "$s\n", buf);
    return 1;
  }

  while ((cp = fgets(buf, BUF_SIZE, fp)) != NULL) {
    offset = 0;
    /* only using 1 for regmatch, so the longest match comes first, and
     * overlapped matches will be skipped over.
     */
    while (regexec(&regex, buf+offset, 1, &regmatch, 0) == 0) {
      printf("Match found from %d to %d:\n", regmatch.rm_so, regmatch.rm_eo);
      printf("%s", buf+offset);
      offset += regmatch.rm_eo;
    }
  }

  regfree(&regex);
  fclose(fp);

}
