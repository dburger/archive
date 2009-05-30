
# line 10 "pa7.y"
#include <stdio.h>
#define MAX_EXPR_VARIABLES 10
#define T 1
#define F 0
extern FILE *yyin, *yyout;

/* counter for temporary variables   */
int varCounter = 65;

/* number of vars from expression    */
int numVars = 0;

/* arrays containing variable string */
/* and the temp variable associated  */
/* with the expression variable      */
char *vars[MAX_EXPR_VARIABLES];
int varSymbol[10];

/* prototypes of functions that determine if     */
/*   given string variable has been used before  */
/*   and that add another string variable to     */
/*   the list                                    */
int varExists(char *s);
void addVar(char *v,int t);
char *strdupx(char *s);

/* struct used to keep track of the last primary */
/* along with an enum to identify primary types  */
enum primTypes { wasInt, wasFloat, wasExpr, wasVar };
struct {
  int zero;
  int primType;
} lastPrim, lastFact;


# define CONSTANT 257
# define VARIABLE 258

#ifdef __STDC__
#include <stdlib.h>
#include <string.h>
#else
#include <malloc.h>
#include <memory.h>
#endif

#include <values.h>

#ifdef __cplusplus

#ifndef yyerror
	void yyerror(const char *);
#endif

#ifndef yylex
#ifdef __EXTERN_C__
	extern "C" { int yylex(void); }
#else
	int yylex(void);
#endif
#endif
	int yyparse(void);

#endif
#define yyclearin yychar = -1
#define yyerrok yyerrflag = 0
extern int yychar;
extern int yyerrflag;
#ifndef YYSTYPE
#define YYSTYPE int
#endif
YYSTYPE yylval;
YYSTYPE yyval;
typedef int yytabelem;
#ifndef YYMAXDEPTH
#define YYMAXDEPTH 150
#endif
#if YYMAXDEPTH > 0
int yy_yys[YYMAXDEPTH], *yys = yy_yys;
YYSTYPE yy_yyv[YYMAXDEPTH], *yyv = yy_yyv;
#else	/* user does initial allocation */
int *yys;
YYSTYPE *yyv;
#endif
static int yymaxdepth = YYMAXDEPTH;
# define YYERRCODE 256

# line 202 "pa7.y"


int yyerror(char *s) {
    fprintf(stderr, "%s\n",s);
    return 0;
}


int main(int argc, char *argv[]) {

    if(argc<3) {
        printf("Proper usage is %s expr-file c-file.\n",argv[0]);
        exit(0);
    }

    if ((yyin=fopen(argv[1],"r"))==NULL) {
        printf("Unable to open %s.\n",argv[1]);
        exit(0);
    }

    if ((yyout=fopen(argv[2],"w"))==NULL) {
        printf("Unable to create %s.\n",argv[2]);
        exit(0);
    }
    fprintf(yyout,"#include <stdio.h>\n");
    fprintf(yyout,"#include <math.h>\n");
    fprintf(yyout,"#define MAX_VAR_LENGTH 20\n");
    fprintf(yyout,"float getVar(char *s);\n");
    fprintf(yyout,"int main() {\n");
    yyparse();
    fclose(yyin);
    fclose(yyout);
    return 0;
}

int varExists(char *s) {
  int i;
  for(i=0;i<numVars;i++)
    if (strcmp(s,vars[i])==0)
      return varSymbol[i];
  return 0;
}

void addVar(char *v, int t) {
  vars[numVars] = strdupx(v);
  varSymbol[numVars++] = t;
}

char *strdupx(char *s) {
  return strcpy((char *)malloc(strlen(s)+1),s);
}


















static const yytabelem yyexca[] ={
-1, 1,
	0, -1,
	-2, 0,
	};
# define YYNPROD 17
# define YYLAST 219
static const yytabelem yyact[]={

    10,    19,    20,     7,    14,     8,    17,    18,    27,    15,
    12,    11,    13,    16,     5,     3,     2,     4,     1,     0,
     0,     0,     0,     0,     0,     0,     0,    21,    22,    23,
     0,    26,    24,    25,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,    12,     0,    13,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     6,     9 };
static const yytabelem yypact[]={

   -40,-10000000,     1,   -38,   -24,-10000000,-10000000,  -251,  -256,-10000000,
   -40,-10000000,   -40,   -40,   -40,   -40,   -40,-10000000,-10000000,-10000000,
-10000000,   -33,   -38,   -38,   -24,   -24,-10000000,-10000000 };
static const yytabelem yypgo[]={

     0,    18,    16,    15,    17,    14 };
static const yytabelem yyr1[]={

     0,     1,     2,     2,     2,     3,     3,     3,     4,     4,
     5,     5,     5,     5,     5,     5,     5 };
static const yytabelem yyr2[]={

     0,     5,     2,     7,     7,     2,     7,     7,     3,     7,
     3,     5,     5,     3,     5,     5,     7 };
static const yytabelem yychk[]={

-10000000,    -1,    -2,    -3,    -4,    -5,   257,    43,    45,   258,
    40,    10,    43,    45,    42,    47,    37,   257,   258,   257,
   258,    -2,    -3,    -3,    -4,    -4,    -5,    41 };
static const yytabelem yydef[]={

     0,    -2,     0,     2,     5,     8,    10,     0,     0,    13,
     0,     1,     0,     0,     0,     0,     0,    11,    15,    12,
    14,     0,     3,     4,     6,     7,     9,    16 };
typedef struct
#ifdef __cplusplus
	yytoktype
#endif
{ char *t_name; int t_val; } yytoktype;
#ifndef YYDEBUG
#	define YYDEBUG	0	/* don't allow debugging */
#endif

#if YYDEBUG

yytoktype yytoks[] =
{
	"CONSTANT",	257,
	"VARIABLE",	258,
	"-unknown-",	-1	/* ends search */
};

char * yyreds[] =
{
	"-no such reduction-",
	"fullexpr : expr '\n'",
	"expr : term",
	"expr : expr '+' term",
	"expr : expr '-' term",
	"term : factor",
	"term : term '*' factor",
	"term : term '/' factor",
	"factor : primary",
	"factor : factor '%' primary",
	"primary : CONSTANT",
	"primary : '+' CONSTANT",
	"primary : '-' CONSTANT",
	"primary : VARIABLE",
	"primary : '-' VARIABLE",
	"primary : '+' VARIABLE",
	"primary : '(' expr ')'",
};
#endif /* YYDEBUG */
# line	1 "/usr/ccs/bin/yaccpar"
/*
 * Copyright (c) 1993 by Sun Microsystems, Inc.
 */

#pragma ident	"@(#)yaccpar	6.14	97/01/16 SMI"

/*
** Skeleton parser driver for yacc output
*/

/*
** yacc user known macros and defines
*/
#define YYERROR		goto yyerrlab
#define YYACCEPT	return(0)
#define YYABORT		return(1)
#define YYBACKUP( newtoken, newvalue )\
{\
	if ( yychar >= 0 || ( yyr2[ yytmp ] >> 1 ) != 1 )\
	{\
		yyerror( "syntax error - cannot backup" );\
		goto yyerrlab;\
	}\
	yychar = newtoken;\
	yystate = *yyps;\
	yylval = newvalue;\
	goto yynewstate;\
}
#define YYRECOVERING()	(!!yyerrflag)
#define YYNEW(type)	malloc(sizeof(type) * yynewmax)
#define YYCOPY(to, from, type) \
	(type *) memcpy(to, (char *) from, yymaxdepth * sizeof (type))
#define YYENLARGE( from, type) \
	(type *) realloc((char *) from, yynewmax * sizeof(type))
#ifndef YYDEBUG
#	define YYDEBUG	1	/* make debugging available */
#endif

/*
** user known globals
*/
int yydebug;			/* set to 1 to get debugging */

/*
** driver internal defines
*/
#define YYFLAG		(-10000000)

/*
** global variables used by the parser
*/
YYSTYPE *yypv;			/* top of value stack */
int *yyps;			/* top of state stack */

int yystate;			/* current state */
int yytmp;			/* extra var (lasts between blocks) */

int yynerrs;			/* number of errors */
int yyerrflag;			/* error recovery flag */
int yychar;			/* current input token number */



#ifdef YYNMBCHARS
#define YYLEX()		yycvtok(yylex())
/*
** yycvtok - return a token if i is a wchar_t value that exceeds 255.
**	If i<255, i itself is the token.  If i>255 but the neither 
**	of the 30th or 31st bit is on, i is already a token.
*/
#if defined(__STDC__) || defined(__cplusplus)
int yycvtok(int i)
#else
int yycvtok(i) int i;
#endif
{
	int first = 0;
	int last = YYNMBCHARS - 1;
	int mid;
	wchar_t j;

	if(i&0x60000000){/*Must convert to a token. */
		if( yymbchars[last].character < i ){
			return i;/*Giving up*/
		}
		while ((last>=first)&&(first>=0)) {/*Binary search loop*/
			mid = (first+last)/2;
			j = yymbchars[mid].character;
			if( j==i ){/*Found*/ 
				return yymbchars[mid].tvalue;
			}else if( j<i ){
				first = mid + 1;
			}else{
				last = mid -1;
			}
		}
		/*No entry in the table.*/
		return i;/* Giving up.*/
	}else{/* i is already a token. */
		return i;
	}
}
#else/*!YYNMBCHARS*/
#define YYLEX()		yylex()
#endif/*!YYNMBCHARS*/

/*
** yyparse - return 0 if worked, 1 if syntax error not recovered from
*/
#if defined(__STDC__) || defined(__cplusplus)
int yyparse(void)
#else
int yyparse()
#endif
{
	register YYSTYPE *yypvt = 0;	/* top of value stack for $vars */

#if defined(__cplusplus) || defined(lint)
/*
	hacks to please C++ and lint - goto's inside
	switch should never be executed
*/
	static int __yaccpar_lint_hack__ = 0;
	switch (__yaccpar_lint_hack__)
	{
		case 1: goto yyerrlab;
		case 2: goto yynewstate;
	}
#endif

	/*
	** Initialize externals - yyparse may be called more than once
	*/
	yypv = &yyv[-1];
	yyps = &yys[-1];
	yystate = 0;
	yytmp = 0;
	yynerrs = 0;
	yyerrflag = 0;
	yychar = -1;

#if YYMAXDEPTH <= 0
	if (yymaxdepth <= 0)
	{
		if ((yymaxdepth = YYEXPAND(0)) <= 0)
		{
			yyerror("yacc initialization error");
			YYABORT;
		}
	}
#endif

	{
		register YYSTYPE *yy_pv;	/* top of value stack */
		register int *yy_ps;		/* top of state stack */
		register int yy_state;		/* current state */
		register int  yy_n;		/* internal state number info */
	goto yystack;	/* moved from 6 lines above to here to please C++ */

		/*
		** get globals into registers.
		** branch to here only if YYBACKUP was called.
		*/
	yynewstate:
		yy_pv = yypv;
		yy_ps = yyps;
		yy_state = yystate;
		goto yy_newstate;

		/*
		** get globals into registers.
		** either we just started, or we just finished a reduction
		*/
	yystack:
		yy_pv = yypv;
		yy_ps = yyps;
		yy_state = yystate;

		/*
		** top of for (;;) loop while no reductions done
		*/
	yy_stack:
		/*
		** put a state and value onto the stacks
		*/
#if YYDEBUG
		/*
		** if debugging, look up token value in list of value vs.
		** name pairs.  0 and negative (-1) are special values.
		** Note: linear search is used since time is not a real
		** consideration while debugging.
		*/
		if ( yydebug )
		{
			register int yy_i;

			printf( "State %d, token ", yy_state );
			if ( yychar == 0 )
				printf( "end-of-file\n" );
			else if ( yychar < 0 )
				printf( "-none-\n" );
			else
			{
				for ( yy_i = 0; yytoks[yy_i].t_val >= 0;
					yy_i++ )
				{
					if ( yytoks[yy_i].t_val == yychar )
						break;
				}
				printf( "%s\n", yytoks[yy_i].t_name );
			}
		}
#endif /* YYDEBUG */
		if ( ++yy_ps >= &yys[ yymaxdepth ] )	/* room on stack? */
		{
			/*
			** reallocate and recover.  Note that pointers
			** have to be reset, or bad things will happen
			*/
			int yyps_index = (yy_ps - yys);
			int yypv_index = (yy_pv - yyv);
			int yypvt_index = (yypvt - yyv);
			int yynewmax;
#ifdef YYEXPAND
			yynewmax = YYEXPAND(yymaxdepth);
#else
			yynewmax = 2 * yymaxdepth;	/* double table size */
			if (yymaxdepth == YYMAXDEPTH)	/* first time growth */
			{
				char *newyys = (char *)YYNEW(int);
				char *newyyv = (char *)YYNEW(YYSTYPE);
				if (newyys != 0 && newyyv != 0)
				{
					yys = YYCOPY(newyys, yys, int);
					yyv = YYCOPY(newyyv, yyv, YYSTYPE);
				}
				else
					yynewmax = 0;	/* failed */
			}
			else				/* not first time */
			{
				yys = YYENLARGE(yys, int);
				yyv = YYENLARGE(yyv, YYSTYPE);
				if (yys == 0 || yyv == 0)
					yynewmax = 0;	/* failed */
			}
#endif
			if (yynewmax <= yymaxdepth)	/* tables not expanded */
			{
				yyerror( "yacc stack overflow" );
				YYABORT;
			}
			yymaxdepth = yynewmax;

			yy_ps = yys + yyps_index;
			yy_pv = yyv + yypv_index;
			yypvt = yyv + yypvt_index;
		}
		*yy_ps = yy_state;
		*++yy_pv = yyval;

		/*
		** we have a new state - find out what to do
		*/
	yy_newstate:
		if ( ( yy_n = yypact[ yy_state ] ) <= YYFLAG )
			goto yydefault;		/* simple state */
#if YYDEBUG
		/*
		** if debugging, need to mark whether new token grabbed
		*/
		yytmp = yychar < 0;
#endif
		if ( ( yychar < 0 ) && ( ( yychar = YYLEX() ) < 0 ) )
			yychar = 0;		/* reached EOF */
#if YYDEBUG
		if ( yydebug && yytmp )
		{
			register int yy_i;

			printf( "Received token " );
			if ( yychar == 0 )
				printf( "end-of-file\n" );
			else if ( yychar < 0 )
				printf( "-none-\n" );
			else
			{
				for ( yy_i = 0; yytoks[yy_i].t_val >= 0;
					yy_i++ )
				{
					if ( yytoks[yy_i].t_val == yychar )
						break;
				}
				printf( "%s\n", yytoks[yy_i].t_name );
			}
		}
#endif /* YYDEBUG */
		if ( ( ( yy_n += yychar ) < 0 ) || ( yy_n >= YYLAST ) )
			goto yydefault;
		if ( yychk[ yy_n = yyact[ yy_n ] ] == yychar )	/*valid shift*/
		{
			yychar = -1;
			yyval = yylval;
			yy_state = yy_n;
			if ( yyerrflag > 0 )
				yyerrflag--;
			goto yy_stack;
		}

	yydefault:
		if ( ( yy_n = yydef[ yy_state ] ) == -2 )
		{
#if YYDEBUG
			yytmp = yychar < 0;
#endif
			if ( ( yychar < 0 ) && ( ( yychar = YYLEX() ) < 0 ) )
				yychar = 0;		/* reached EOF */
#if YYDEBUG
			if ( yydebug && yytmp )
			{
				register int yy_i;

				printf( "Received token " );
				if ( yychar == 0 )
					printf( "end-of-file\n" );
				else if ( yychar < 0 )
					printf( "-none-\n" );
				else
				{
					for ( yy_i = 0;
						yytoks[yy_i].t_val >= 0;
						yy_i++ )
					{
						if ( yytoks[yy_i].t_val
							== yychar )
						{
							break;
						}
					}
					printf( "%s\n", yytoks[yy_i].t_name );
				}
			}
#endif /* YYDEBUG */
			/*
			** look through exception table
			*/
			{
				register const int *yyxi = yyexca;

				while ( ( *yyxi != -1 ) ||
					( yyxi[1] != yy_state ) )
				{
					yyxi += 2;
				}
				while ( ( *(yyxi += 2) >= 0 ) &&
					( *yyxi != yychar ) )
					;
				if ( ( yy_n = yyxi[1] ) < 0 )
					YYACCEPT;
			}
		}

		/*
		** check for syntax error
		*/
		if ( yy_n == 0 )	/* have an error */
		{
			/* no worry about speed here! */
			switch ( yyerrflag )
			{
			case 0:		/* new error */
				yyerror( "syntax error" );
				goto skip_init;
			yyerrlab:
				/*
				** get globals into registers.
				** we have a user generated syntax type error
				*/
				yy_pv = yypv;
				yy_ps = yyps;
				yy_state = yystate;
			skip_init:
				yynerrs++;
				/* FALLTHRU */
			case 1:
			case 2:		/* incompletely recovered error */
					/* try again... */
				yyerrflag = 3;
				/*
				** find state where "error" is a legal
				** shift action
				*/
				while ( yy_ps >= yys )
				{
					yy_n = yypact[ *yy_ps ] + YYERRCODE;
					if ( yy_n >= 0 && yy_n < YYLAST &&
						yychk[yyact[yy_n]] == YYERRCODE)					{
						/*
						** simulate shift of "error"
						*/
						yy_state = yyact[ yy_n ];
						goto yy_stack;
					}
					/*
					** current state has no shift on
					** "error", pop stack
					*/
#if YYDEBUG
#	define _POP_ "Error recovery pops state %d, uncovers state %d\n"
					if ( yydebug )
						printf( _POP_, *yy_ps,
							yy_ps[-1] );
#	undef _POP_
#endif
					yy_ps--;
					yy_pv--;
				}
				/*
				** there is no state on stack with "error" as
				** a valid shift.  give up.
				*/
				YYABORT;
			case 3:		/* no shift yet; eat a token */
#if YYDEBUG
				/*
				** if debugging, look up token in list of
				** pairs.  0 and negative shouldn't occur,
				** but since timing doesn't matter when
				** debugging, it doesn't hurt to leave the
				** tests here.
				*/
				if ( yydebug )
				{
					register int yy_i;

					printf( "Error recovery discards " );
					if ( yychar == 0 )
						printf( "token end-of-file\n" );
					else if ( yychar < 0 )
						printf( "token -none-\n" );
					else
					{
						for ( yy_i = 0;
							yytoks[yy_i].t_val >= 0;
							yy_i++ )
						{
							if ( yytoks[yy_i].t_val
								== yychar )
							{
								break;
							}
						}
						printf( "token %s\n",
							yytoks[yy_i].t_name );
					}
				}
#endif /* YYDEBUG */
				if ( yychar == 0 )	/* reached EOF. quit */
					YYABORT;
				yychar = -1;
				goto yy_newstate;
			}
		}/* end if ( yy_n == 0 ) */
		/*
		** reduction by production yy_n
		** put stack tops, etc. so things right after switch
		*/
#if YYDEBUG
		/*
		** if debugging, print the string that is the user's
		** specification of the reduction which is just about
		** to be done.
		*/
		if ( yydebug )
			printf( "Reduce by (%d) \"%s\"\n",
				yy_n, yyreds[ yy_n ] );
#endif
		yytmp = yy_n;			/* value to switch over */
		yypvt = yy_pv;			/* $vars top of value stack */
		/*
		** Look in goto table for next state
		** Sorry about using yy_state here as temporary
		** register variable, but why not, if it works...
		** If yyr2[ yy_n ] doesn't have the low order bit
		** set, then there is no action to be done for
		** this reduction.  So, no saving & unsaving of
		** registers done.  The only difference between the
		** code just after the if and the body of the if is
		** the goto yy_stack in the body.  This way the test
		** can be made before the choice of what to do is needed.
		*/
		{
			/* length of production doubled with extra bit */
			register int yy_len = yyr2[ yy_n ];

			if ( !( yy_len & 01 ) )
			{
				yy_len >>= 1;
				yyval = ( yy_pv -= yy_len )[1];	/* $$ = $1 */
				yy_state = yypgo[ yy_n = yyr1[ yy_n ] ] +
					*( yy_ps -= yy_len ) + 1;
				if ( yy_state >= YYLAST ||
					yychk[ yy_state =
					yyact[ yy_state ] ] != -yy_n )
				{
					yy_state = yyact[ yypgo[ yy_n ] ];
				}
				goto yy_stack;
			}
			yy_len >>= 1;
			yyval = ( yy_pv -= yy_len )[1];	/* $$ = $1 */
			yy_state = yypgo[ yy_n = yyr1[ yy_n ] ] +
				*( yy_ps -= yy_len ) + 1;
			if ( yy_state >= YYLAST ||
				yychk[ yy_state = yyact[ yy_state ] ] != -yy_n )
			{
				yy_state = yyact[ yypgo[ yy_n ] ];
			}
		}
					/* save until reenter driver code */
		yystate = yy_state;
		yyps = yy_ps;
		yypv = yy_pv;
	}
	/*
	** code supplied by user is placed in this switch
	*/
	switch( yytmp )
	{
		
case 1:
# line 52 "pa7.y"
{
              fprintf(yyout,"  printf(\"Result: %%f\\n\", %c);\n"
                      ,varCounter -1);
              fprintf(yyout,"}\n");
              fprintf(yyout,"float getVar(char *varName) {\n");
              fprintf(yyout,"  char s[MAX_VAR_LENGTH];\n");
              fprintf(yyout,"  printf(\"Value for var %%s:  \",varName);\n");
              fprintf(yyout,"  fgets(s,MAX_VAR_LENGTH,stdin);\n");
              fprintf(yyout,"  return atof(s);\n");
              fprintf(yyout,"}\n");
              exit(0);
            } break;
case 3:
# line 67 "pa7.y"
{ 
              fprintf(yyout,"  float %c = %c + %c;\n",varCounter++,yyval
                      ,varCounter-2);
              yyval = varCounter-1;
            } break;
case 4:
# line 73 "pa7.y"
{
              fprintf(yyout,"  float %c = %c - %c;\n",varCounter++,yyval
                      ,varCounter-2);
              yyval = varCounter-1;
            } break;
case 6:
# line 81 "pa7.y"
{
              fprintf(yyout,"  float %c = %c * %c;\n",varCounter++,yyval
                      ,varCounter-2);
              yyval = varCounter-1;
            } break;
case 7:
# line 87 "pa7.y"
{ 
              if (lastFact.zero) {
                yyerror("Division by zero error.\n");
                exit(0);
              }
              fprintf(yyout,"  float %c = %c / %c;\n",varCounter++,yyval
                      ,varCounter-2);
              yyval = varCounter-1;
            } break;
case 8:
# line 98 "pa7.y"
{
              lastFact.zero = lastPrim.zero;
              lastFact.primType = lastPrim.primType;
            } break;
case 9:
# line 103 "pa7.y"
{
              if (lastPrim.primType==wasFloat) {
                yyerror("Illegal float operand in % operation.\n");
                exit(0);
              }
              /* in case the factor or the primary were variables */
              /* or expressions we will cast it for them          */
              fprintf(yyout,"  int %c = (int)%c %% (int)%c;\n",varCounter++,yyval,
                      varCounter-2);
              yyval = varCounter-1;
              lastFact.zero = F;
              lastFact.primType = wasInt;
            } break;
case 10:
# line 118 "pa7.y"
{
              if (strchr((char *)yypvt[-0],'.')==NULL) {
                  fprintf(yyout,"  int %c = %s;\n",varCounter++,yypvt[-0]);
                  lastPrim.primType = wasInt;
              } else {
                  fprintf(yyout,"  float %c = %s;\n",varCounter++,yypvt[-0]);
                  lastPrim.primType = wasFloat;
	      }
              yyval = varCounter-1;
              lastPrim.zero = (atof((char *)yypvt[-0])==0.0);
            } break;
case 11:
# line 130 "pa7.y"
{
              if (strchr((char *)yypvt[-0],'.')==NULL) {
                  fprintf(yyout,"  int %c = %s;\n",varCounter++,yypvt[-0]);
                  lastPrim.primType = wasInt;
	      } else {
                  fprintf(yyout,"  float %c = %s;\n",varCounter++,yypvt[-0]);
                  lastPrim.primType = wasFloat;
	      }
              yyval = varCounter-1;
              lastPrim.zero = (atof((char *)yypvt[-1])==0.0);
            } break;
case 12:
# line 142 "pa7.y"
{
              if (strchr((char *)yypvt[-0],'.')==NULL) {
                  fprintf(yyout,"  int %c = -%s;\n",varCounter++,yypvt[-0]);
                  lastPrim.primType = wasInt;
              } else {
                  fprintf(yyout,"  float %c = %s;\n",varCounter++,yypvt[-0]);
                  lastPrim.primType = wasFloat;
	      }
              yyval = varCounter-1;
              lastPrim.zero = (atof((char *)yypvt[-1])==0.0);
            } break;
case 13:
# line 154 "pa7.y"
{ 
              int varValue;
              if ((varValue=varExists((char *)yypvt[-0]))!=0)
                fprintf(yyout,"  float %c = %c;\n",varCounter++,varValue);
              else {
                addVar((char *)yypvt[-0], varCounter);
                fprintf(yyout,"  float %c = getVar(\"%s\");\n"
                        ,varCounter++,yypvt[-0]);
              }
              yyval = varCounter-1;
              lastPrim.primType = wasVar;
              lastPrim.zero = F;
            } break;
case 14:
# line 168 "pa7.y"
{ 
              int varValue;
              if ((varValue=varExists((char *)yypvt[-0]))!=0)
                fprintf(yyout,"  float %c = -%c;\n",varCounter++,varValue);
              else {
                addVar((char *)yypvt[-0], varCounter);
                fprintf(yyout,"  float %c = getVar(\"%s\");\n"
                        ,varCounter++,yypvt[-0]);
              }
              yyval = varCounter-1;
              lastPrim.primType = wasVar;
              lastPrim.zero = F;
            } break;
case 15:
# line 182 "pa7.y"
{ 
              int varValue;
              if ((varValue=varExists((char *)yypvt[-0]))!=0)
                fprintf(yyout,"  float %c = %c;\n",varCounter++,varValue);
              else {
                addVar((char *)yypvt[-0], varCounter);
                fprintf(yyout,"  float %c = getVar(\"%s\");\n"
                        ,varCounter++,yypvt[-0]);
              }
              yyval = varCounter-1;
              lastPrim.primType = wasVar;
              lastPrim.zero = F;
            } break;
case 16:
# line 196 "pa7.y"
{
              yyval = varCounter-1;
              lastPrim.primType = wasExpr;
              lastPrim.zero = F;
            } break;
# line	531 "/usr/ccs/bin/yaccpar"
	}
	goto yystack;		/* reset registers in driver code */
}

