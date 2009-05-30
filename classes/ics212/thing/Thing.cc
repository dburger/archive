#include "Thing.h"

/*
  Thing.cc by
  David J. Burger
  for ICS212 under the direction of
  Dr. Peterson

  This file implements the Thing object.
  It has a basic constructor and destructor
  along with a copy constructor and the
  overloading of the assignment statement
  to properly deal with and demonstrate 
  dynamic memory issues and objects.
*/

/* each new thing object gets a new serno
   incremented from 0 from this static int */
int Thing::sernoCounter;

/* basic constructor */
Thing::Thing(char *n) {
  name = strcpy(new char[strlen(n)+1],n);
  serno = sernoCounter++;
  printf("Construct %s (%d)\n",name,serno);
}

/* destructor frees the char array */
Thing::~Thing() {
  printf("Destruct %s (%d)\n",name,serno);
  delete [] name;
}

/* copy constructor, makes sure that new object
   gets its own copy of the string data */
Thing::Thing(const Thing &obj) {
  if (this==&obj) return;
  name = strcpy(new char[strlen(obj.name)+1],obj.name);
  serno = sernoCounter++;
  printf("Construct copy %s (%d)\n",name,serno);
}

/* assignment operator, makes sure that assigned to
   object gets its own copy of the string */
Thing Thing::operator=(Thing t) {
  delete [] name;
  name = strcpy(new char[strlen(t.name)+1],t.name);
  printf("Assign copy (%d) %s to (%d)\n",t.serno,t.name,serno);
  return *this;
}







