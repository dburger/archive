#include <fstream.h>
#include <iostream.h>
#include <stdio.h>
#include <string>
#include "dictcomp.h"

/*
   comp.cc by
   David J. Burger
   for ICS 212 under the guidance of
   Dr. Peterson

   This program compresses a dictionary
   file that has words in alphabetical
   order on consecutive lines of a text
   file by replacing the repeat prefix
   of a string by a character representing
   the length of repeat from the previous
   word.

   This program also demonstrates the
   usage of the string class in C++.
*/

int main(int argc, char *argv[]) {

    /* usage needs dictionary filename */
    if (argc<2) {
        printf("Proper usage is %s filename\n",argv[0]);
        return 1;
    }

    /* store the dictionary filename in dictFilename */
    char *dictFilename = strdup(argv[1]);

    /* now determine the compressed filename */
    char *periodPos;
    /* look for the period, if found truncate there */
    if ((periodPos=strrchr(argv[1],'.'))!=NULL)
        *periodPos = '\0';

    /* concatenate the new file extension */
    strcat(argv[1],".cp");

    /* store the compressed filename in compFilename */
    char *compFilename = strdup(argv[1]);

    /* open the dictionary file */
    ifstream fin(dictFilename);
    if (!fin) {
        printf("Unable to open %s.\n",dictFilename);
        return 1;
    }

    /* create the compressed file */
    ofstream fout(compFilename);
    if (!fout) {
        printf("Unable to create %s.\n",compFilename);
        return 1;
    }

    /* variables to store the number of matching characters */
    /* the previous word, and the current word respectively */
    /* along with variables to keep track of file statistics*/
    int matchCount = 0;
    int numWords = 0;
    int sizeBefore = 0;
    int sizeAfter = 0;
    string previous = "";
    string current;
    /* read the dictionary file, one line at a time */
    /* each line is a different word in the dict.   */
    while (!fin.eof()) {
        getline(fin,current);
        /* we don't want to process that last empty line */
        if (current.length()==0) continue;
        numWords++;
        /* +1 for the newline character */
        sizeBefore+=current.length() + 1;
        /* determine the number of matching characters to previous word */
        while (matchCount<previous.length() &&
               matchCount<current.length() && matchCount<MAX_MATCH) {
            if (previous[matchCount]==current[matchCount])
                matchCount++;
            else
                break;
        }
        /* set up previous for next iteration */
        previous = current;
        /* erase the repeated part      */
        /* current.erase(0,matchCount); */
        current.replace(0,matchCount,"");
        /* character which represents number matching */
        char c = '0'+matchCount;
        sizeAfter+=current.length() + 1;
        /* write to the compressed file */
        fout << c << current;

        /* matchCount back to 0 for next iteration */
        matchCount = 0;
    }

    /* close the input and output files */
    fin.close();
    fout.close();

    /* output the compression statistics */
    printf("Input file: %s, Output file: %s.\n",dictFilename,compFilename);
    printf("Size before: %d, after %d.  No. of words: %d.\n",
           sizeBefore,sizeAfter,numWords);

}




