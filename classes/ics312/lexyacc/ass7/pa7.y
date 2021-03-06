/*
4/29/01
Yacc for the parsing of
arithmetic expressions by
David J. Burger for
ICS 312 under the guidance of
Dr. Sughihara
*/
%{
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


%}
%token CONSTANT VARIABLE

%%

fullexpr:
          expr '\n' 
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
            }

expr:     term
          | expr '+' term
            { 
              fprintf(yyout,"  float %c = %c + %c;\n",varCounter++,$$
                      ,varCounter-2);
              $$ = varCounter-1;
            }
          | expr '-' term
            {
              fprintf(yyout,"  float %c = %c - %c;\n",varCounter++,$$
                      ,varCounter-2);
              $$ = varCounter-1;
            }

term:     factor
          | term '*' factor
            {
              fprintf(yyout,"  float %c = %c * %c;\n",varCounter++,$$
                      ,varCounter-2);
              $$ = varCounter-1;
            }
          | term '/' factor
            { 
              if (lastFact.zero) {
                yyerror("Division by zero error.\n");
                exit(0);
              }
              fprintf(yyout,"  float %c = %c / %c;\n",varCounter++,$$
                      ,varCounter-2);
              $$ = varCounter-1;
            }

factor:   primary
            {
              lastFact.zero = lastPrim.zero;
              lastFact.primType = lastPrim.primType;
            }
          | factor '%' primary
            {
              if (lastPrim.primType==wasFloat) {
                yyerror("Illegal float operand in % operation.\n");
                exit(0);
              }
              /* in case the factor or the primary were variables */
              /* or expressions we will cast it for them          */
              fprintf(yyout,"  int %c = (int)%c %% (int)%c;\n",varCounter++,$$,
                      varCounter-2);
              $$ = varCounter-1;
              lastFact.zero = F;
              lastFact.primType = wasInt;
            }

primary:  CONSTANT
            {
              if (strchr((char *)$1,'.')==NULL) {
                  fprintf(yyout,"  int %c = %s;\n",varCounter++,$1);
                  lastPrim.primType = wasInt;
              } else {
                  fprintf(yyout,"  float %c = %s;\n",varCounter++,$1);
                  lastPrim.primType = wasFloat;
	      }
              $$ = varCounter-1;
              lastPrim.zero = (atof((char *)$1)==0.0);
            }
          | '+' CONSTANT
            {
              if (strchr((char *)$2,'.')==NULL) {
                  fprintf(yyout,"  int %c = %s;\n",varCounter++,$2);
                  lastPrim.primType = wasInt;
	      } else {
                  fprintf(yyout,"  float %c = %s;\n",varCounter++,$2);
                  lastPrim.primType = wasFloat;
	      }
              $$ = varCounter-1;
              lastPrim.zero = (atof((char *)$1)==0.0);
            }
          | '-' CONSTANT
            {
              if (strchr((char *)$2,'.')==NULL) {
                  fprintf(yyout,"  int %c = -%s;\n",varCounter++,$2);
                  lastPrim.primType = wasInt;
              } else {
                  fprintf(yyout,"  float %c = %s;\n",varCounter++,$2);
                  lastPrim.primType = wasFloat;
	      }
              $$ = varCounter-1;
              lastPrim.zero = (atof((char *)$1)==0.0);
            }
          | VARIABLE
            { 
              int varValue;
              if ((varValue=varExists((char *)$1))!=0)
                fprintf(yyout,"  float %c = %c;\n",varCounter++,varValue);
              else {
                addVar((char *)$1, varCounter);
                fprintf(yyout,"  float %c = getVar(\"%s\");\n"
                        ,varCounter++,$1);
              }
              $$ = varCounter-1;
              lastPrim.primType = wasVar;
              lastPrim.zero = F;
            }
          | '-' VARIABLE
            { 
              int varValue;
              if ((varValue=varExists((char *)$2))!=0)
                fprintf(yyout,"  float %c = -%c;\n",varCounter++,varValue);
              else {
                addVar((char *)$2, varCounter);
                fprintf(yyout,"  float %c = getVar(\"%s\");\n"
                        ,varCounter++,$2);
              }
              $$ = varCounter-1;
              lastPrim.primType = wasVar;
              lastPrim.zero = F;
            }
          | '+' VARIABLE
            { 
              int varValue;
              if ((varValue=varExists((char *)$2))!=0)
                fprintf(yyout,"  float %c = %c;\n",varCounter++,varValue);
              else {
                addVar((char *)$2, varCounter);
                fprintf(yyout,"  float %c = getVar(\"%s\");\n"
                        ,varCounter++,$2);
              }
              $$ = varCounter-1;
              lastPrim.primType = wasVar;
              lastPrim.zero = F;
            }
          | '(' expr ')'
            {
              $$ = varCounter-1;
              lastPrim.primType = wasExpr;
              lastPrim.zero = F;
            }

%%

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


















