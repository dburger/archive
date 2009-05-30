/*=============================================================================
Assignment: Project 3, mytcp
Author:     David Burger, Warren Lam, Kin Lik Wang
Language:   ANSI C running on UHUNIX2 (Solaris)
Compile:    by running "make" with included makefile
Class:      ICS 451
Instructor: Edo Biagioni
Due Date:   Dec. 09, 2001
===============================================================================
File:         data.c
Description:  This file contains the functions that generate sentence data for
              the mytcp program.  "Random" sentences are generated using the
              data from the arrays.
=============================================================================*/

#include <string.h>

/* NOTE!! make sure that the sum of the longest of each part < MAX_SENTENCE */
#define MAX_SENTENCE 79

/* NOTE!! make sure that each array has MAX_PARTS elements */
#define MAX_PARTS 7


/* the array data for forming sentences */
char *subject[] = {
  "Warren", 
  "David",
  "Kin Wang",
  "The cat",
  "The dog",
  "The programmer",
  "Pres. George W. Bush"

};

char *adverb[] = {
  "quickly",
  "silently",
  "doggedly",
  "hurriedly",
  "madly",
  "furiously",
  "passionately"

};

char *verb[] = {
  "ate",
  "drank",
  "drove",
  "chased",
  "smelled",
  "kicked",
  "incinerated"

};


char *adjective[] = {
  "delicious",
  "stale",
  "aero-dynamic",
  "sweaty",
  "fragrant",
  "stupid",
  "outrageous"

};


char *object[] = {
  "pizza",
  "beer",
  "car",
  "mail man",
  "flower",
  "computer",
  "party pooper"
};

/*=============================================================================
Function getSentence
Purpose:  creates a "random" sentence and places it in the buffer sentence[],
          sentence[] should be MAX_SENTENCE size

Parameters:
     sentence[] (IN) - buffer to place the sentence in

Returns:  the length of the random sentence placed in sentence[]
=============================================================================*/
int getSentence (char sentence[]) {
  sprintf (  
    sentence, "%s %s %s the %s %s.\n", 
    subject  [rand () % MAX_PARTS],
    adverb   [rand () % MAX_PARTS],
    verb     [rand () % MAX_PARTS], 
    adjective[rand () % MAX_PARTS], 
    object   [rand () % MAX_PARTS]
  );
  return strlen(sentence);
}

/*=============================================================================
Function fillData
Purpose:  fills the buffer buff of size size with random sentence data, the
          key feature is that it remembers its location in a sentence between
          calls and fills it from where it left off.

Parameters:
     buff (IN) - the buffer to fill with random sentence data
     size (IN) - the size of buff

Returns:  nothing, but buff is filled with random sentence data
=============================================================================*/
void fillData(char *buff, int size) {
  
  static char sentence[MAX_SENTENCE];
  static char *p = NULL; /* when it is null there is no leftover */
  static int len;

  if (p==NULL) { /* get a new sentence */
    len = getSentence(sentence);
    p = sentence;
  }

  while (size>0) {
    if (size>=len) {
      memcpy(buff,p,len);
      buff+=len; /* point at new insertion point */
      size-=len; /* adjust size left to copy */
      len = getSentence(sentence);
      p = sentence;
    } else {
      memcpy(buff,p,size);
      p+=size;
      len-=size;
      size=0;
    }
  }

}
