/* scan.c */
/* Finds next syntactical unit and returns its token      */
/* If it is a keyword or identifiier, it goes in termsym. */
/* Note that this continues from line to line to the end  */
/* of the file                                            */
#include "parse.h"
static char line[100];  /* private to this module */
static char *p; /* where we are in line--also private */
int scan()
{
   char *t;
   static char syms[] = "+-*/()={};,";   /* special symbols in order */
   int token, slength;
   if(p==NULL) p = line; /* This will happen on first call to scan  */
   p += strspn(p, " \t\n"); /* skip leading spaces, etc. */
   /* The following will read a line from the file. This will       */
   /* happen the first time scan is called and every time after all */
   /* the tokens in a line have been scanned.                       */
   while(strlen(p)==0) { /* handles multiple blank lines */ 
      printf("\n");  /* output listing  */
      if(fgets(line, 100, fp)==NULL) { /* end of file */
         line[0] = 0;
	  p = line;
         if(test&1) printf("Token = END\n");
         return END;
      }
      p = line+strspn(line, " \t\n"); /* skip leading spaces, etc. */
      printf(";  %s", line);
      if(strlen(p)!=0) printf("\n");
   }
   if(isalpha(*p)) {  /*  ID or keyword  */
      slength = strspn(p,"01234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ"
         "abcdefghijklmnopqrstuvwxyz");
      termsym[0] = 0;
      strncat(termsym, p, slength);
        p += slength;
	  if(strcmp(termsym,"while")==0) token = WHILE;
	    else if(strcmp(termsym,"do")==0) token = DO;
      else token = ID;
   }
   else if(isdigit(*p)) {  /* constant */
        slength = strspn(p, "0123456789");
       termsym[0] = 0;
          strncat(termsym, p, slength);
	     p += slength;
	        token = CONST;
   }
   else {  /* everything else */
       t = strchr(syms, *p); /* works because chars are in order */
      if(t==NULL) token = 0; /* illegal symbol */
        else token = t - syms + 1;
        p++;    
   }
   if(test&1) printf("Token = %d termsym = %s\n", token, termsym);
   return token;
}
