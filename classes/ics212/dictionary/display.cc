#include <fstream.h>
#include <iostream.h>
#include <stdio.h>
#include <string>
#include "dictcomp.h"

/*
   display.cc by
   David J. Burger
   for ICS 212 under the guidance of
   Dr. Peterson

   This program displays a compressed
   dictionary files characters
   in groups and columns as defined by the
   constants in dictcomp.h.  This program
   was made for easier viewing of a compressed
   dictionary file.

   This program also demonstrates the
   usage of the string class in C++.
*/

int main(int argc, char *argv[]) {

    /* check for the passed in source file for display */
    if (argc<2) {
        printf("Proper usage is %s filename.\n",argv[0]);
        return 1;
    }

    /* open the source file */
    ifstream fin(argv[1]);
    if (!fin) {
        printf("Unable to open %s.\n",argv[1]);
        return 1;
    }    

    /* standard compressed format is one long line */    
    string line;
    getline(fin,line);
    fin.close();

    /* used to keep track of when to wrap */
    int col = 0;
    while (line.length()>0) {
        /* output NUM_GROUP characters */
        cout << line.substr(0,NUM_GROUP);
        col++;
        /* if NUM_COLS then wrap */
        if (col%NUM_COLS!=0)
	    cout << "  ";
        else
	    cout << "\n";
        /* remove the already printed characters */
        /* line.erase(0,NUM_GROUP); */
        line.replace(0,NUM_GROUP,"");
    }

    cout << "\n";

}








