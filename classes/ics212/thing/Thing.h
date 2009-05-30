#include <stdio.h>
#include <string.h>
#include <ctype.h>

/*
  Thing.h by
  David J. Burger
  for ICS212 under the guidance of
  Dr. Peterson.

  This is the header file for the
  Thing object implemented in Thing.cc.
*/

class Thing {
private:
  char *name;
  int serno;
  static int sernoCounter;
public:
  Thing(char *n);
  ~Thing();
  Thing(const Thing &obj);
  Thing operator=(Thing rhs);
  char *getName() { return name; };
  void show() { printf("Show %s (%d)\n",name,serno); };
};
