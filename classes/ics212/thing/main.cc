/* Main program for the Thing class,  */
/* which illustrates constructors and */
/* destructors, allocation and freeing*/
/* storage, and scope of variables.   */

#include "Thing.h"

Thing f(Thing s);

Thing t0("Arthur");
Thing t1 = "Beverly";
static Thing t2("Charles");

void main(void)
{
    printf("***Starting main.\n");
	Thing t3= "Eve";
	static Thing t4("Irene");

	t0.show();
	t2.show();
	t3.show();

	Thing *t5 = new Thing("George");
	Thing *t6 = new Thing("Jane");

	printf("***First Checkpoint.\n");
	Thing t7= t2;
	t2.show();
	t7.show();

	t1.show();
	t5->show();

	t1 = t4;
	t1.show();
	t4.show();

	*t6 = t3;
	t6->show();
	t3.show();

	t3 = "Vivian";
	t3.show();

    printf("***Second Checkpoint.\n");
	t4 = t4;

	Thing *t8 = new Thing(t7);
	t7.show();
	t8->show();

	printf("***Entering f\n");
	t4 = f(t3);
	printf("***Back out of f.\n");
	t3.show();
	t4.show();

	printf("***Entering f again.\n");
	f(t7).show();
	printf("***Back out of f again.\n");

	delete t5;
	delete t6;
	delete t8;
	printf("***Finished.\n");
}

/* This function capitalizes the name  */
/* in the parameter Thing and returns  */
/* the resulting object.               */
Thing f(Thing t)
{   
	printf("***In f.\n");
	Thing s1 = "Tom";
	s1.show();
	static Thing s2 = "Katherine";
	s2.show();
	char *p = t.getName();
	for( ; *p!=0; p++) *p = toupper(*p);
	printf("***Leaving f.\n");
	return t;
}






