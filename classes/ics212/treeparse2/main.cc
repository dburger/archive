#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include "tree.h"

#define MAX_LINE 1000

/* main.cc by
 * David J. Burger
 * for ICS 212 under the guidance of
 * Dr. Peterson.
 *
 * This file provides the main entry
 * point for the treeParse program.
 * proper usage is:
 * treeParse textFile
 *
 * This program parses the individual
 * words of a text file into a binary
 * search tree and then lists the words
 * in alphabetical order with word
 * frequencies.  Then it uses recursive
 * tree functions to report the:
 *1) total word count
 *2) total letter count
 *3) average letters/word
 */


int main(int argc, char *argv[]) {

    FILE *fp;
    Tree *t;
    char *s;
    char *tok;
    int wc;
    int lc;
    int longest;

    if (argc<2) {
        printf("Proper usage is %s filename.\n",argv[0]);
        exit(0);
    }

    fp = fopen(argv[1],"rb");

    if (fp==NULL) {
        printf("Unable to open %s.\n",argv[1]);
        exit(0);
    }

    t = new Tree();

    while ((fgets(s,MAX_LINE,fp))!=NULL)
        for(tok=strtok(s," ,.:;!?\t\n()");tok!=NULL;
	    tok=strtok(NULL," ,.:;!?\t\n()")) {
	    /* only add if first char is alpha */
	    if isalpha(*tok) {
	        /* all words lower case in tree */
                tolower(tok);
                t->insert(tok);
            }
        }


    t->printWordList();

    /* get the statistics on the text contents */

    wc = t->wordCount();
    lc = t->letterCount();
    longest = t->longestLength();

    /* print out summary statistics */

    printf("wc = %d  lc = %d  lpw = %.4f\n",wc,lc,(double)lc/wc);
    printf("The longest word is %d characters long.\n",longest);
    printf("The following words of that length occur:\n");
    t->nprint(longest);

    fclose(fp);

}
