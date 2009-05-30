/*

   parse.c modified for ICS 212 by
   David J. Burger.
   This file contains functions that form a
   basic parser and demonstrate how to implement
   a recursive parser.  The basic functionality
   was provided by Dr. Peterson.
   
   Parse rules added by David J. Burger:
       (7)   STMT      ::=  WHILE2  STMT
       (9)   WHILE2    ::=  WHILE1  EXP  )
       (10)  WHILE1    ::=  WHILE  (
       (8)   STMT      ::=  DOHEAD  STMT  WHILE  (  EXP  )  ;
       (11)  DOHEAD    ::=  DO
       (21)  PRI       ::=  FUN
       (22)  FNAME     ::=  ID
       (24)  FUN       ::=  FNAME  (  PARMLIST  )
       (25)  PARMLIST  ::=  EXP              
       (26)  PARMLIST  ::=  PARMLIST  ,  EXP
       
*/


/* This contains all of the parse functions. Each parse */
/* function tries to recognize something--a complete    */
/* program for parse() and otherwise what the name      */
/* implies. It returns T if it succeeds, F if not, and  */
/* when it returns the next two tokens this and next,   */
/* will be the first two after what was recognized.     */

#include "parse.h"
static int this, next;
static void step()
{
    this = next;
    next = scan();
}

/*(1) PGM       ::=  STMTLIST  END        */
int parse()
{
    step(); step(); /* initialize this and next */
    if(test&2) printf("Enter parse--this=%d, next=%d\n", this, next);
    if(!stmtlist()) return F;
    if(this!=END) return F;
    reduce(1);
    if(test&2) printf("Leave parse\n");
    return T;
}

/*  (2) STMTLIST  ::=  STMT               */
/*  (3) STMTLIST  ::=  STMTLIST  STMT     */
int stmtlist()
{
    if(test&2) printf("Enter stmtlist--this=%d  next=%d\n", this, next);
    if(!stmt()) return F;
    reduce(2);
    while(this!=RBRACE && this!=END) {
        if(!stmt()) return F;
        reduce(3);
    }
    if(test&2) printf("Leave stmtlist\n");
    return T;
}

/*  (4) STMT      ::=  EXP  ;                       */
/*  (5) STMT      ::=  ID  =  EXP  ;                */
/*  (6) STMT      ::=  {  STMTLIST  }               */
/*  (7) STMT      ::=  WHILE2 STMT                  */
/*  (8) STMT      ::=  DOHEAD STMT WHILE ( EXP ) ;  */
int stmt()
{
    if(test&2) printf("Enter stmt--this=%d  next=%d\n", this, next);
    if(next==EQUALS) {  /* stmt (5) */
        if(!target()) return F;
	    step();  /* past EQUALS */
        if(!exp()) return F;
	    if(this!=SEMIC) return F;
	    step();  /* past SEMIC */
	    reduce(5);
	    if(test&2) printf("Leave stmt(5)\n");
	    return T;
    }
    else if(this==LBRACE) {  /* stmt (6) */
        step(); /* past LBRACE */
        if(!stmtlist()) return F;
        if(this!=RBRACE) return F;
        step(); /* past RBRACE */
        reduce(6);
        if(test&2) printf("Leave stmt(6)\n");
        return T;
    }
    else if(this==WHILE) {  /* stmt (7) added by D. Burger */
        if (!while2()) return F;
        if (!stmt()) return F;
        reduce(7);
        if (test&2) printf("Leave stmt(7)\n");
        return T;
    }
    else if(this==DO) {     /* stmt (8) added by D. Burger */
        if (!dohead()) return F;
        if (!stmt()) return F;
        if (this!=WHILE) return F;
        step();  /* past WHILE */
        if (this!=LPAREN) return F;
        step();  /* past LPAREN */
        if (!exp()) return F;
        if (this!=RPAREN) return F;
        step();  /* past RPAREN */
        if (this!=SEMIC) return F;
        step();  /* past SEMIC */
        if (test&2) printf("Leave stmt(8)\n");
        reduce(8);
        return T;
    }
    else {  /* stmt (4)  */
        if(!exp()) return F;
	    if(this!=SEMIC) return F;
	    step();  /* past SEMIC */
	    reduce(4);
	    if(test&2) printf("Leave stmt(4)\n");
	    return T;
    }
}

/*         added by D. Burger            */
/* (9) WHILE2       ::=  WHILE1  EXP  )  */
int while2() {
    if(test&2) printf("Enter while2--this=%d  next=%d\n", this, next);
    if (!while1()) return F;
    if (!exp()) return F;
    if (this!=RPAREN) return F;
    step();  /* past RPAREN */
    reduce(9);
    if(test&2) printf("Leave while2\n");
    return T;
}


/*       added by D. Burger       */
/* (10) WHILE1     ::=  WHILE  (  */
int while1() {
    if(test&2) printf("Enter while1--this=%d  next=%d\n", this, next);
    if (this!=WHILE) return F;
    step();  /* past WHILE */
    if (this!=LPAREN) return F;
    step(); /* past LPAREN */
    reduce(10);
    if(test&2) printf("Leave while1\n");
    return T;
}

/*   added by D. Burger   */
/* (11) DOHEAD   ::=  DO  */
int dohead() {
    if(test&2) printf("Enter dohead--this=%d  next=%d\n", this, next);
    if (this!=DO) return F;
    step();  /* past DO */
    reduce(11);
    if(test&2) printf("Leave while1\n");
    return T;
}

/* (12) EXP       ::=  TERM           */
/* (13) EXP       ::=  EXP  +  TERM   */
/* (14) EXP       ::=  EXP  -  TERM   */
int exp()
{
    int w;
    if(test&2) printf("Enter exp--this=%d  next=%d\n", this, next);
    if(!term()) return F;
    reduce(12);
    while((w = this)==PLUS || w==MINUS) {
        step();  /* past PLUS or MINUS */
        if(!term()) return F;
        if(w==PLUS) reduce(13);
        else reduce(14);
    } 
    if(test&2) printf("Leave exp\n");
    return T;
}

/* (15) TERM      ::=  PRI            */
/* (16) TERM      ::=  TERM  *  PRI   */
/* (17) TERM      ::=  TERM  /  PRI   */
int term()
{
    int w;
    if(test&2) printf("Enter term--this=%d  next=%d\n", this, next);
    if(!pri()) return F;
    reduce(15);
    while((w = this)==TIMES || w==DIVIDE) {
        step();  /* past TIMES or DIVIDE */
        if(!pri()) return F;
        if(w==TIMES) reduce(16);
        else reduce(17);
    } 
    if(test&2) printf("Leave term\n");
    return T;
}

/* (18) PRI       ::=  CONST          */
/* (19) PRI       ::=  ID             */
/* (20) PRI       ::=  (  EXP  )      */
/* (21) PRI       ::=  FUN            */
int pri()
{
    if(test&2) printf("Enter pri--this=%d  next=%d\n", this, next);
    if(this==CONST) {
        reduce(18);
        step();  /* past COMST */
        if(test&2) printf("Leave pri(18)\n");
	    return T;
    }
    else if(this==LPAREN) {
        step();  /* past LPAREN */
        if(!exp()) return F;
	    if(this!=RPAREN) return F;
	    step();  /* past RPAREN */
		reduce(20);
        if(test&2) printf("Leave pri(20)\n");
	    return T;
    }
    else if(next==LPAREN) {  /* stmt (21) added by D. Burger */
        if (!fun()) return F;
        reduce(21);
        if(test&2) printf("Leave pri(21)\n");
        return T;
    }
    else {
        if(this!=ID) return F;
        reduce(19);
        step();  /* past ID */
        if(test&2) printf("Leave pri(19)\n");
	    return T;
    }
}

/* (23) TARGET    ::=  ID                    */
int target()
{
    if(test&2) printf("Enter target--this=%d  next=%d\n", this, next);
    if(this!=ID) return F;
    reduce(23);
    step();  /* past ID */
    if(test&2) printf("Leave target\n");
    return T;
}

/*           added by D. Burger           */
/* (24) FUN       ::=  FNAME ( PARMLIST ) */
int fun() {
    if(test&2) printf("Enter fun--this=%d  next=%d\n", this, next);
    if(!fname()) return F;
    if (this!=LPAREN) return F;
    step();  /* past LPAREN */
    if (!parmlist()) return F;
    if (this!=RPAREN) return F;
    step();  /* past RPAREN */
    reduce(24);
    if(test&2) printf("Leave fun\n");
    return T;
}

/*  added by D. Burger   */
/* (22) FNAME     ::= ID */
int fname() {
    if(test&2) printf("Enter fname--this=%d  next=%d\n", this, next);
    if (this!=ID) return F;
    reduce(22);
    step();  /* past ID */
    if(test&2) printf("Leave fname\n");
    return T;
}

/*           added by D. Burger         */
/* (25) PARMLIST  ::=  EXP              */
/* (26) PARMLIST  ::=  PARMLIST  ,  EXP */
int parmlist() {
    if(test&2) printf("Enter parmlist--this=%d  next=%d\n", this, next);
    if (!exp()) return F;
    reduce(25);
    while (this==COMMA) {
        step();   /* past COMMA */
        if (!exp()) return F;
        reduce(26);
    }
    if(test&2) printf("Leave parmlist\n");
    return T;
}