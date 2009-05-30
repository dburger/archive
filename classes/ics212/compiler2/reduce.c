/*
    reduce.c modified by
    David J. Burger.
    This file contains the reduce function that converts
    code into assembler.  The basic functionality of this
    code was provided by Dr. Peterson.

    Reduce grammars added by David J. Burger:

 (7) STMT       ::=  WHILE2  STMT
 (8) STMT       ::=  DOHEAD  STMT  WHILE  (  EXP  )
 (9) WHILE2     ::=  WHILE1  EXP
 (10) WHILE1    ::=  WHILE  (
 (11) DOHEAD    ::=  DO
 (22) FNAME     ::=  ID
 (24) FUN       ::=  FNAME  (  PARMLIST  )
 (25) PARMLIST  ::=  EXP
 (26) PARMLIST  ::=  PARMLIST  ,  EXP

*/

/*  reduce.c  */
/*  This program actually writes the assembler  */
/*  language statements.                        */
#include "parse.h"

static char stack[25][20];
static int sp = -1;
static int symno;
char sym[5];

static void newsym()
{
    sprintf(sym, "#%d", symno++);
}

static void push(char *s)
{
	if(sp>0 && strcmp(stack[sp-1],"AX")==0) {
		newsym();
		printf("      mov   %s,AX\n", sym);
		strcpy(stack[sp-1], sym);
	}
    strcpy(stack[++sp], s);
}

static char *pop()
{
    return stack[sp--];
}

void reduce(int pn)
{
    int i;
	char *s, *t;

    if(test&4) {
        printf("Reduction number %d  sp=%d\n", pn ,sp);
        for(i = 0; i<=sp; i++) printf("<%s> ", stack[i]);
        printf("\n");
    }

    switch(pn) {

/* (18) PRI       ::=  CONST   */
/* (19) PRI       ::=  ID      */
/* (23) TARGET    ::=  ID      */

	        case 18:
                case 19:
		case 23:
			push(termsym);
            break;

/*  (4) STMT      ::=  EXP  ;                   */        

		case 4:
            pop();  /* Throw away result--not used  */
			break;

/*  (5) STMT      ::=  TARGET  =  EXP  ;   */

        case 5:
            s = pop();
			if(strcmp(s,"AX")!=0) 
				printf("      mov   AX,%s\n",s);
			printf("      mov   %s,AX\n", pop());
			break;

/* (7) STMT       ::=  WHILE2  STMT     */
/*           added by dburger           */

                case(7):
		        /*  get the labels off the stack */
                        s = pop();
                        t = pop();
                        /*  put in the jmp back to the top */
                        printf("      jmp %s\n",t);
                        /*  the label for while loop termination */
                        printf("%s:\n",s);
                        break;

/* (8) STMT    ::=  DOHEAD  STMT  WHILE  (  EXP  )*/
/*           added by dburger                     */

                case(8):
		        /*  get the test value off the stack */
                        s = pop();
                        printf("      test %s\n",s);
                        /*  get the label off the stack */
                        s = pop();
                        printf("      jnz %s\n",s);
                        break;

/* (9) WHILE2    ::=  WHILE1  EXP       */
/*           added by dburger           */

                case(9):
		        /*  get the test value off the stack */
                        s = pop();
                        printf("      test %s\n",s);
                        /*  create a new label and push on stack */
                        newsym();
                        push(sym);
                        printf("      jz %s\n",sym);
                        break;


/* (10) WHILE1    ::=  WHILE  (         */
/*           added by dburger           */

                case(10):
		        /*  create, push, and write out label for */
		        /*  top of while loop                     */
                        newsym();
                        push(sym);
                        printf("%s:\n",sym);
                        break;

/* (11) DOHEAD    ::=  DO               */
/*           added by dburger           */

                case(11):
		        /*  create, push, and write out label for */
		        /*  top of do loop                        */
                        newsym();
                        push(sym);
                        printf("%s:\n",sym);
                        break;

/* (13) EXP       ::=  EXP  +  TERM     */

		case 13:
			s = pop();
			t = pop();
			if(strcmp(s,"AX")==0) 
				printf("      add   AX,%s\n", t);
			else {
				if(strcmp(t,"AX")!=0)
					printf("      mov   AX,%s\n", t);
				printf("      add   AX,%s\n", s);
			}
			push("AX");
			break;

/* (14) EXP       ::=  EXP - TERM       */

		case 14:
			s = pop();
			t = pop();
            if(strcmp(t,"AX")!=0)
        		printf("      mov   AX,%s\n", t);
			printf("      sub   AX,%s\n", s);
			push("AX");
			break;

/* (16) TERM      ::=  TERM  *  PRI     */

		case 16:
			s = pop();
			t = pop();
			if(strcmp(s,"AX")==0) 
				printf("      mult  AX,%s\n", t);
			else {
				if(strcmp(t,"AX")!=0)
					printf("      mov   AX,%s\n", t);
				printf("      mult  AX,%s\n", s);
			}
			push("AX");
			break;

/* (17) TERM      ::=  TERM  /  PRI     */                

		case 17:
			s = pop();
			t = pop();
            if(strcmp(t,"AX")!=0)
        		printf("      mov   AX,%s\n", t);
			printf("      div   AX,%s\n", s);
			push("AX");
			break;

/* (22) FNAME     ::=  ID               */
/*           added by dburger           */

                case(22):
		        /*  push the symbol on the stack */
                        push(termsym);
                        break;

/* (24) FUN       ::=  FNAME  (  PARMLIST  )*/
/*           added by dburger               */

                case(24):
		        /*  pull the symbol off the stack and call it */
                        s = pop();
                        printf("      call %s\n",s);
                        /*  result is returned in AX */
                        push("AX");
                        break;

/* (25) PARMLIST  ::=  EXP              */
/*           added by dburger           */

                case(25):
		        /*  putting exp onto execution stack */
                        s = pop();
                        printf("      push %s\n",s);
                        break;

/* (26) PARMLIST  ::=  PARMLIST  ,  EXP */
/*           added by dburger           */

                case(26):
		        /*  putting exp onto execution stack */
                        s = pop();
                        printf("      push %s\n",s);
                        break;

/*  The following don't need any instructions to be generated.  */
/*  (1) PGM       ::=  STMTLIST  END            */        
/*  (2) STMTLIST  ::=  STMT                     */        
/*  (3) STMTLIST  ::=  STMTLIST  STMT           */         
/*  (6) STMT      ::=  {  STMTLIST  }           */        
/* (12) EXP       ::=  TERM                     */         
/* (15) TERM      ::=  PRI                      */         
/* (20) PRI       ::=  (  EXP  )                */         
/* (21) PRI       ::=  FUN                      */
	}
    return;
}


