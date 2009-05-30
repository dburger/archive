/*
    dictcomp.h by
    David J. Burger
    for ICS 212 under the guidance of
    Dr. Peterson

    This file contains the constants
    used in ditionary compression
    programs comp.cc, decomp.cc,
    display.cc.
*/
/* the maximum length of a match limited by the
   number of characters from 0 to first alpha */
#define MAX_MATCH 16
/* characters in the matching value set */
#define MATCH_CHARS "0123456789:;<=>?@"
/* number of columns and groups for display.cc */
#define NUM_COLS 5
#define NUM_GROUP 10
