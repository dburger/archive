#include <iostream.h>
#include <fstream.h>
#include <stdio.h>
#include <string>
#include <list>

#include "Item.cc"

#define TAIL_SENTINEL "zzzzzzz"
#define CNT_CUTOFF 5
#define WORD_WIDTH 20
#define CNT_WIDTH 15

int main(int argc, char *argv[]) {
  /* check for proper command line parameters */
  if (argc<3) {
    printf("Proper usage is %s file1 file2.\n",argv[0]);
    return 1;
  }

  /* attempt to open the first input file */
  ifstream infile1(argv[1]);
  if (!infile1) {
    printf("Unable to open %s.\n",argv[1]);
    return 1;
  }

  /* attempt to open the second input file */
  ifstream infile2(argv[2]);
  if (!infile2) {
    printf("Unable to open %s.\n",argv[2]);
    return 1;
  }

  string inputLine;
  char *c_inputLine;
  char *wordTok;
  char *countTok;

  /* lists for first and second file data */
  list<Item> list1;
  list<Item> list2;

  Item *tmpItem;

  /* process the first file */
  while(!infile1.eof()) {
    getline(infile1,inputLine);
    /* get a char * version of the input */
    c_inputLine = strdup(inputLine.c_str());
    /* process the tokens */
    wordTok=strtok(c_inputLine," ");
    while (wordTok!=NULL) {
      countTok=strtok(NULL," ");
      tmpItem = new Item(wordTok,atoi(countTok));
      /* add the new item at the back of the list */
      list1.push_back(*tmpItem);
      wordTok=strtok(NULL," ");
    }
  }

  infile1.close();

  /* process the second file */
  while(!infile2.eof()) {
    getline(infile2,inputLine);
    /* get a char * version of the input */
    c_inputLine = strdup(inputLine.c_str());
    /* process the tokens */
    wordTok=strtok(c_inputLine," ");
    while (wordTok!=NULL) {
      countTok=strtok(NULL," ");
      tmpItem = new Item(wordTok,atoi(countTok));
      /* add the new item to the back of the list */
      list2.push_back(*tmpItem);
      wordTok=strtok(NULL," ");
    }
  }

  infile2.close();

  /* iterators to be used to move through the lists */
  list<Item>::iterator it1, it2;

  it1 = list1.begin();
  it2 = list2.begin();

  int wordCount = 0;
  int distinctWords = 0;

  /* process word count data for file1 */
  while(it1!=list1.end()) {
    wordCount+=(*it1).getCount();
    distinctWords++;
    it1++;
  }

  printf("File %s: %d distinct words and %d total words.\n",argv[1]
                                                           ,distinctWords
                                                           ,wordCount);
  wordCount = 0;
  distinctWords = 0;

  /* process word count data for file2 */
  while(it2!=list2.end()) {
    wordCount+=(*it2).getCount();
    distinctWords++;
    it2++;
  }

  printf("File %s: %d distinct words and %d total words.\n",argv[2]
                                                           ,distinctWords
                                                           ,wordCount);

  printf("Words that appear %d or more times:\n",CNT_CUTOFF);
  /* header line for data in output */
  cout.setf(ios::left);
  cout.width(WORD_WIDTH);
  cout << "Word";
  cout.width(CNT_WIDTH);
  cout << argv[1];
  cout.width(CNT_WIDTH);
  cout << argv[2] << endl;
  tmpItem = new Item(TAIL_SENTINEL,0);
  /* 
     the tail sentinel will be larger than anything
     else that can be added to the list, this prevents
     the need for special cases in processing the lists
  */
  list1.push_back(*tmpItem);
  list2.push_back(*tmpItem);

  it1 = list1.begin();
  it2 = list2.begin();

  int onlyFile1 = 0;
  int onlyFile2 = 0;
  int onlyTotalFile1 = 0;
  int onlyTotalFile2 = 0;
  int both = 0;
  int bothFile1 = 0;
  int bothFile2 = 0;

  /* process the lists */
  while ((*it1).getWord()<TAIL_SENTINEL || (*it2).getWord()<TAIL_SENTINEL) {
    if ((*it1).getWord()<(*it2).getWord()) {
      /* word in first list not in second */
      if ((*it1).getCount()>=CNT_CUTOFF) {
        cout << (*it1).getWord().c_str();
        cout.width(WORD_WIDTH-(*it1).getWord().length());
        cout << "";
        cout.width(CNT_WIDTH);
        cout << (*it1).getCount() << endl;
      }
      onlyFile1++;
      onlyTotalFile1+=(*it1).getCount();
      it1++;
    } else if ((*it2).getWord()<(*it1).getWord()) {
      /* word in second list not in first */
      if ((*it2).getCount()>=CNT_CUTOFF) {
	cout << (*it2).getWord();
        cout.width(WORD_WIDTH-(*it2).getWord().length()+CNT_WIDTH);
        cout << "";
        cout.width(CNT_WIDTH);
        cout << (*it2).getCount() << endl;
      }
      onlyFile2++;
      onlyTotalFile2+=(*it2).getCount();
      it2++;
    } else {
      /* word in both lists               */
      if ((*it1).getCount()+(*it2).getCount()>=CNT_CUTOFF) {
        cout << (*it1).getWord();
        cout.width(WORD_WIDTH-(*it1).getWord().length());
        cout << "";
        cout.width(CNT_WIDTH);
        cout << (*it1).getCount();
        cout.width(CNT_WIDTH);
        cout << (*it2).getCount() << endl;
      }
      both++;
      bothFile1+=(*it1).getCount();
      bothFile2+=(*it2).getCount();
      it1++;
      it2++;
    }
  }

  /* summary stats for both files */
  printf("%d distinct words and %d total words appear only in file %s.\n",
         onlyFile1,onlyTotalFile1,argv[1]);
  printf("%d distinct words and %d total words appear only in file %s.\n",
         onlyFile2,onlyTotalFile2,argv[2]);
  printf("There are %d distinct words that appear in both files.\n",both);
  printf("They appear %d times in file %s.\n",bothFile1,argv[1]);
  printf("They appear %d times in file %s.\n",bothFile2,argv[2]);
}

/* char * duplicator function */
char *strdup(char *s) {
  return strcpy(new char[strlen(s)+1],s);
}










