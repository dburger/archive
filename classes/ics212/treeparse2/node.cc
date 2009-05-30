#include "node.h"

/*
 * node.cc by
 * David J. Burger
 * for ICS 212 under the guidance of
 * Dr. Peterson.
 * This file contains an implementation of
 * a Node class that can be used for a binary
 * search tree storing strings.  It also
 * contains several functions for reporting
 * the contents of the tree:
 *1) the word count
 *2) the letter count
 *3) the word list
 *4) printing words of a specified length
 */

/* 
 * basic constructor, the last three parameters
 * are optional and default to c=1, l=NULL,
 * and r=NULL
 */
Node::Node(char *w, int c, Node *l, Node *r) {
    word = dupstr(w);
    count = c;
    left = l;
    right = r;
}

/*
 * character string duplication function
 */
char *dupstr(char *w) {
    return strcpy(new char[strlen(w)+1],w);
}

/*
 * character string conversion of upper case
 * chars to lower case chars within w
 */
char *tolower(char *w) {
    for (;*w!=0;w++)
        if (*w>='A' && *w<='Z') *w = *w - 'A' + 'a';
    return w;
}


