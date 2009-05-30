#include <stdio.h>
#include <string.h>
#include <string>
#include <stream.h>
#include <fstream.h>
#define MAX_MATCH 16

int main(int argc,char *argv[]) {

  if (argc<2) {
    printf("Proper usage is %s filename.\n",argv[0]);
    exit(0);
  }

  char *dictFilename = strdup(argv[1]);

  char *periodPos;
  if ((periodPos=strchr(argv[1],'.'))!=NULL)
    (*periodPos) = '\0';

  strcat(argv[1],".cp");

  char *compFilename = strdup(argv[1]);

  ifstream ifs(dictFilename);
  if (!ifs) {
    printf("Unable to open %s.\n",dictFilename);
    exit(0);
  }

  ofstream ofs(compFilename);
  if (!ofs) {
    printf("Unable to create %s.\n",compFilename);
    exit(0);
  }

  string prevWord = "";
  string currWord = "";
  int matchCount = 0;
  while (!ifs.eof()) {
    getline(ifs,currWord);
    while (matchCount<prevWord.length() &&
           matchCount<currWord.length() &&
           matchCount < MAX_MATCH &&
           prevWord[matchCount]==currWord[matchCount])
      matchCount++;
    prevWord = currWord;
    currWord.replace(0,matchCount,"");
    char c = '0' + matchCount;
    ofs << c << currWord;
    matchCount = 0;
  }

  ifs.close();
  ofs.close();
}





