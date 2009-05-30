/* treduce.c */
/* This is a temporary reduce function for the purpose of   */
/* debugging the parser only.                               */
#include "parse.h"
void reduce(int ruleno)
{
  if(test&4) 
    printf("Reduce: Rule No. %d Termsym = %s\n", ruleno, termsym);
}
