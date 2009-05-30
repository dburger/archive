#include <fstream.h>
#include <iostream.h>
#include <stdio.h>
#include <string>
#include "dictcomp.h"

/*
   decomp.cc by
   David J. Burger
   for ICS 212 under the guidance of
   Dr. Peterson

   This program decompresses a compressed
   dictionary file that has words in alphabetical
   order in a format where the prefix matching
   the previous word has been replaced by a
   character representing the length of the
   matching prefix.  For example, a dictionary
   with a file:

bob
bobby

   Would be encoded as:

0bob3by

   This program also demonstrates the
   usage of the string class in C++.
*/

int main(int argc, char *argv[]) {

    /* usage needs dictionary filename */
    if (argc<3) {
        printf("Proper usage is %s source dest\n",argv[0]);
        printf("Where source is the compressed file,\n");
        printf("and dest is the decompressed result.\n");
        return 1;
    }

    /* open the compressed dictionary file */
    ifstream fin(argv[1]);
    if (!fin) {
        printf("Unable to open %s.",argv[1]);
        return 1;
    }

    /* create the output file              */
    ofstream fout(argv[2]);
    if (!fout) {
        printf("Unable to create %s.",argv[2]);
        return 1;
    }

    /* the dictionary format is one long line */
    string line;
    getline(fin,line);
    fin.close();
    /* variables for file statistics */
    int sizeBefore = line.length();
    int sizeAfter = 0;
    int numWords = 0;
    string previous = "";
    while (line.length()>0) {
        numWords++;
        /* retrieve the character that represents # of repeats */
        char reptChar = line[0];
        /* erase it */
        /* line.erase(0,1); */
        line.replace(0,1,"");
        /* determine where the word ends */
        int tail = line.find_first_of(MATCH_CHARS);
        /* extract the individual word */
        string word = line.substr(0,tail);
        /* add on the prefix match from previous word */
        word = previous.substr(0,reptChar-'0') + word;
        /* set up previous for next iteration */
        previous = word;
        /* to get an exact pre/post compression match, make */
        /* sure that we don't output a line for the last    */
        /* empty line of the pre compressed file            */
        if (word.length()>0)
	  fout << word << '\n';
        /* +1 for newline character */
        sizeAfter += word.length() + 1;
        /* line.erase(0,tail); */
        line.replace(0,tail,"");        
    }

    /* close the output file */
    fout.close();

    /* display file statistics */
    printf("Input file: %s, Output file: %s.\n",argv[1],argv[2]);
    printf("Size before: %d, after %d.  No. of words: %d.\n",
           sizeBefore,sizeAfter,numWords);

}



