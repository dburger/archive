#include <stdio.h>
#include <string.h>
#include <string>
#include <iostream.h>
#include <fstream.h>

int main(int argc, char *argv[]) {

  if (argc<3) {
    printf("Proper usage is %s compFile uncompFile.\n",argv[0]);
    exit(0);
  }

  char *compFile = strdup(argv[1]);
  char *dictFile = strdup(argv[2]);

  ifstream ifs(compFile);
  if (!ifs) {
    printf("Unable to open %s.\n",compFile);
    exit(0);
  }

  ofstream ofs(dictFile);
  if (!ofs) {
    printf("Unable to create %s.\n",dictFile);
  }

  string line;
  /* entire file can be read from one line */
  getline(ifs,line);
  ifs.close();

  string prevWord = "";
  while(line.length()>0) {
    int reptLength = line[0] - '0';
    line.replace(0,1,"");
    int tail = line.find_first_of("0123456789");
    string word = prevWord.substr(0,reptLength) + line.substr(0,tail);
    line.replace(0,tail,"");
    ofs << word << endl;
    prevWord = word;
  }
  ofs.close();

}

