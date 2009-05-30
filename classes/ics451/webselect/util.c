/*=============================================================================
Assignment: Project 1, Random Web Server/Proxy
Author:     David J. Burger
Language:   ANSI C running on UHUNIX2 (Solaris)
Compile:    by running "make" with included makefile

Class:      ICS 451
Instructor: Edo Biagioni
Due Date:   Sep. 21, 2001
===============================================================================
File:         util.c

Description:  This file contains utility functions that can be helpful in many
              different programs.
              
Functions:    void locase(char *s) - changes all characters is *s to low case

              int filesize(char *name) - returns the size, in bytes, of file
                  *name

              int extMatch(char *filename, char *ext) - returns 1 if *filename
                  has extension *ext and 0 otherwise.  It compares *ext to a
                  lower case version of *filename.    
=============================================================================*/
/* for the file size */
#include <sys/stat.h>

#include "defs.h"

/*=============================================================================
Function locase

Purpose:  This function converts the string pointed at by s into a lower case
          string.
          
Parameters:
    *s (IN/OUT) - the string passed in in s is converted to a lower case string
    
Returns:  s contains a lower case version of the string
=============================================================================*/
void locase(char *s) {
    int i; /* used to iterate through the string */
    for (i=0;i<strlen(s);i++)
        s[i] = tolower(s[i]);
}

/*=============================================================================
Function filesize

Purpose:  This function returns the file size, in bytes, and the file passed in
          in *name.
          
Parameters:
    *name (IN) - the filename to return the size of
    
Returns:  the number of bytes in file *name or -1 if the size cannot be
          determined or the file is not found
=============================================================================*/
int filesize(char *name) {
    struct stat stbuf; /* structure for stat call */
    int ret = stat(name, &stbuf);
    if (ret==-1)
        return -1;
    else
        return stbuf.st_size;
}

/*=============================================================================
Function extMatch

Purpose:  This function determines whether or not the file extension in *ext
          matches the file extension of *filename.  Note that it converts
          *filename to a lower case version before doing the comparison so
          callers of the function should pass in a low case *ext.
          
Parameters:
    *filename (IN) - the filename to determine if *ext is an extension match    
    *ext (IN) - the extension to determine if matches
    
Returns:  1 if *ext is the extension of the lower case version of *filename,
          0 otherwise
=============================================================================*/
int extMatch(char *filename, char *ext) {
    char lobuffer[strlen(filename)+1]; /* used to hold a low case version */
    char *cptr;  /* used to point at the extension part of the string */
    if (strlen(filename)<strlen(ext)) return F;
    /* make the lower case copy */
    strcpy(lobuffer,filename);
    locase(lobuffer);
    cptr = lobuffer;
    /* adjust the cptr to point at the extension area of the string */
    cptr += strlen(lobuffer) - strlen(ext);
    return (strcmp(ext,cptr)==0);
}
