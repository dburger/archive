/*=============================================================================
Assignment:  Modular Arithmetic
             
Author:      David J. Burger
Language:    ANSI C running on UHUNIX2 (Solaris)
Compile:     by running "make" with supplied makefile

Execute:     ./modtest

Class:       ICS 623
Instructor:  Dr. Peterson
Due Date:    10/22/01
===============================================================================
File:         main.c

Description:  
              
Functions:    main - the main entry point to the program.  Puts the modular
              arithmetic functions through several demonstrations.
=============================================================================*/
#include <stdio.h>

#include "modarith.h"
/*=============================================================================
Function main

Purpose:  the main entry point for the program, puts the modular arithmetic
          functions through several tests
          
Parameters:
     int argc (IN) - a count of the number of command line paramters, not used
     char *argv[] (IN) - an array of char *'s to the command line parameters,
                         not used
Returns:  nothing
=============================================================================*/
int main(int argc, char* argv[]) {

  int p = 2147483629;
  int n = 23;
  int t = 1;
  int i;

  unsigned long poly = 0x80000009;
  int b = 0x00001007;  

  printf("First multiplying by 23:\n");
  for (i=1;i<30;i++) {
    t = multm(t,n,p);
    printf("%d^%d = %08x\n",n,i,t);
  }
  printf("=======================\n");

  printf("Now 23^15 * 23^14:\n");
  printf("23^15 * 23^14 = %08x\n",multm(0x3d5a3329,0x18eda92b,p));
  printf("=======================\n");

  printf("Now using fast exponentiation:\n");
  for(i=1;i<30;i++) {
    printf("%d^%d = %08x\n",n,i,expm(n,i,p));
  }
  printf("=======================\n");

  printf("Raising %d^5 to p-1:\n",n);
  printf("(%d^5)^p-1 = %08x\n",n,expm(expm(n,5,p),p-1,p));
  printf("=======================\n");

  printf("Raising %d^5 to p-2 and then multiplying by %d^5:\n",n,n);
  printf("(%d^5)^p-2 * (%d^5) = %08x\n",n,n,multm(expm(expm(n,5,p),p-2,p),expm(n,5,p),p));
  printf("=======================\n");

  printf("Taking x^12 + x^2 + x + 1 to succesive powers by multiplying:\n");
  t = 1;
  for(i=1;i<30;i++) {
    t = multgf(t,b,poly);
    printf("b^%d = %08x\n",i,t);
  }
  printf("=======================\n");

  printf("Now b^15 * b^14:\n");
  printf("b^15 * b^14 = %08x\n",multgf(expgf(b,15,poly),expgf(b,14,poly),poly));
  printf("=======================\n");

  printf("Taking x^12 + x^2 + x + 1 with exponentiation:\n");
  for(i=1;i<30;i++) {
    printf("b^%d = %08x\n",i,expgf(b,i,poly));
  }
  printf("=======================\n");

  printf("Raising b^10 to p-1:\n");
  printf("(b^10)^p-1 = %08x\n",expm(expgf(b,10,poly),p-1,p));
  printf("=======================\n");

  printf("Raising b^10 to p-2 and then multiplying by b^10:\n");
  printf("(b^10)^p-2 * (b^10) = %08x\n",multm(expm(expgf(b,10,poly),p-2,p),expgf(b,10,poly),p));
  printf("=======================\n");

}

