/*=============================================================================
Assignment:  Implementation of secure hash algorithm (SHA-1).
             
Author:      David J. Burger
Language:    ANSI C running on UHUNIX2 (Solaris)
Compile:     by running "make" with supplied makefile

Execute:     ./shatest filename

Class:       ICS 623
Instructor:  Dr. Peterson
Due Date:    09/17/01
=============================================================================*/
struct hash {
    unsigned long H0;
    unsigned long H1;
    unsigned long H2;
    unsigned long H3;
    unsigned long H4;
    unsigned long sizeHi;
    unsigned long sizeLo;
};

void sha1File(FILE *fp, struct hash *h);
void sha1Mem(char *buff, int len, struct hash *h);
