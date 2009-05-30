/* main.c */
/* Main program for compiler for subset of C. WP--2/01 */
/* Open file and call parse(). Note that the file      */
/* pointer is an external variable. The file reading   */
/* is done in scan().                                  */
#include "parse.h"
FILE *fp;
char termsym[20];
int test = 4;  /* do all debug printing */
void main(int argc, char *argv[])
{
   char filename[25];
   if(argc==2) strcpy(filename, argv[1]);
   else {
      printf("Enter file name: ");
      scanf("%s", filename);
   }
   fp = fopen(filename, "r");
   if(fp==NULL) {
      printf("Could not open file %s.\n", filename);
      exit(0);
   }
   if(parse()) printf("Finished OK\n"); 
   else printf("Syntax error\n");  
}
