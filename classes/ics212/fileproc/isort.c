/* An example of sorting a list of strings by  */
/* rearranging the pointers and not moving the */
/* strings themselves.       WP--9/99          */

#include <stdio.h>
#include <string.h>

/* swap the pointers that s and t point to  */
void swap(char **s, char **t)
{
	char* u;
	u = *s;
	*s = *t;
	*t = u;
}

/* Sort the n elements of v[] using an insertion sort */
/* v is assumed to be an array of pointers to strings */
/* This rearranges the pointers in array v.           */
void isort(char **v, int n)
{
	int i, j;

	for(i = 1; i<n; i++) {
		for(j = i; j>0; j--) {
			if(strcmp(v[j],v[j-1])<0) swap(v+j, v+j-1);
		}
	}
}
/* Short main program to test isort()   */
void main()
{
	int i;
    char *a[] = {"oranges", "grapes", "peaches",
		"apples", "pears", "mangos", "lychees"};
	printf("Unsorted:\n");
	for(i = 0; i<7; i++) printf("%s\n",a[i]);
	isort(a, 7);
	printf("\nSorted:\n");
	for(i = 0; i<7; i++) printf("%s\n",a[i]);
}
