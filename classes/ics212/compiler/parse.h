/* parse.h */
/* include fole for parser for small subset of C.  */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
/* Tokens */
#define ILLEGAL 0
#define PLUS    1
#define MINUS   2
#define TIMES   3
#define DIVIDE  4
#define LPAREN  5
#define RPAREN  6
#define EQUALS  7
#define LBRACE  8
#define RBRACE  9
#define SEMIC  10
#define COMMA  11
#define WHILE  12
#define DO     13
#define ID     14
#define CONST  15
#define END    16
#define T 1
#define F 0
/* Grammar 
PGM       ::=  STMTLIST  END                     (1)
STMTLIST  ::=  STMT                              (2)
STMTLIST  ::=  STMTLIST  STMT                    (3)
STMT      ::=  EXP  ;                            (4)
STMT      ::=  ID  =  EXP  ;                     (5)
STMT      ::=  {  STMTLIST  }                    (6)
STMT      ::=  WHILE2  STMT                      (7)
STMT      ::=  DOHEAD  STMT  WHILE  (  EXP  ) ;  (8)
WHILE2    ::=  WHILE1  EXP  )                    (9)
WHILE1    ::=  WHILE  (                          (10)
DOHEAD    ::=  DO                                (11)
EXP       ::=  TERM                              (12)
EXP       ::=  EXP  +  TERM                      (13)
EXP       ::=  EXP - TERM                        (14)
TERM      ::=  PRI                               (15)
TERM      ::=  TERM  *  PRI                      (16)
TERM      ::=  TERM  /  PRI                      (17)
PRI       ::=  CONST                             (18)
PRI       ::=  ID                                (19)
PRI       ::=  (  EXP  )                         (20)
PRI       ::=  FUN                               (21)
FNAME     ::=  ID                                (22)
TARGET    ::=  ID                                (23)
FUN       ::=  FNAME  (  PARMLIST  )             (24)
PARMLIST  ::=  EXP                               (25)
PARMLIST  ::=  PARMLIST  ,  EXP                  (26)
*/
/* Input file--open in main, use in scan */
extern FILE *fp;  
/* Terminal symbol, if it is an ID or a CONST */
/* Set in scan(), used by reduce().           */
extern char termsym[20]; 
extern int test;  /* controls debug printing  */
/* If lowest bit of test is 1, do debug print in scan  */
/* if next lowest bit is 1, do debug print in parse    */
/* if third bit is 1, do debug print in reduce         */
int scan();  /* gets successive tokens from input program */
int parse(); /* parse functions */
int stmtlist();
int stmt();
int while2();
int while1();
int dohead();
int exp();
int term();
int pri();
int fun();
int fname();
int target();
int parmlist();
void reduce(int ruleNo); /* Does the semantics */
