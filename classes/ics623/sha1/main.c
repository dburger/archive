/*=============================================================================
Assignment:  Implementation of secure hash algorithm (SHA-1).  This program
             demonstrates my secure hash implementation.  For execution type:
             ./shatest filename
             where filename is the name of the file you wish to determine the
             secure hash value of.  
             
Author:      David J. Burger
Language:    ANSI C running on UHUNIX2 (Solaris)
Compile:     by running "make" with supplied makefile

Execute:     ./shatest

Class:       ICS 623
Instructor:  Dr. Peterson
Due Date:    09/17/01
===============================================================================
File:         main.c

Description:  This file contains the main entry point to the program.
              
Functions:    int main(int argc, char *argv[]) - main entry point to program
                  and computes the SHA-1 value for the value passed in on the
                  command line.
=============================================================================*/
#include <stdio.h>
#include "sha1.h"
/*=============================================================================
Function main

Purpose:  The main entry point of the program.  This function accepts the
          passed in command line filename and computes the SHA-1 value for the
          file.
          
Parameters:
    argc (IN) - number of command line arguments passed to program.
    *argv[] (IN) - array of char *'s to the arguments.    
=============================================================================*/
int main(int argc, char *argv[]) {

  FILE *fp; /* file pointer for opening the file */
  struct hash h; /* structure to hold hash value */

  if (argc<2) {
    printf("Proper usage is %s filename\n",argv[0]);
    exit(0);
  }

  if ((fp=fopen(argv[1],"r"))==NULL) {
    printf("Unable to open %s\n",argv[1]);
    exit(0);
  }

  sha1File(fp, &h);

  printf("File: %s Size = %d bits, or %d bytes\n",argv[1],h.sizeLo,h.sizeLo/8);
  printf("SHA1 HASH: %08x: %08x: %08x: %08x: %08x\n",h.H0,h.H1,h.H2,h.H3,h.H4);

}
