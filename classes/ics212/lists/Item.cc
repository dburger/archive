#include <string>

class Item {
  string word;
  int count;
public:
  Item(char *w) {word=w;count=1;};
  Item() {word=NULL;count=0;};
  Item(char *w, int c) {word=w;count=c;};
  string getWord() {return word;};
  int getCount() {return count;};
};
