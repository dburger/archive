#include <stdio.h>

#define MAXLINE 1000

void reverse(char orig[], char reversed[]);
int getline(char s[], int lim);

main() {

    int len;
    char line[MAXLINE];
    char revline[MAXLINE];

    while ((len = getline(line, MAXLINE)) > 0) {
        if (len>1) {
            reverse(line,revline);
            printf("%s", revline);
        } else {
            printf("\n");
        }
    }
}

int getline(char s[], int lim) {
    int c, i;

    for (i=0;i<lim-1 && (c=getchar())!=EOF && c!='\n'; ++i)
        s[i] = c;
    if (c == '\n') {
        s[i] = c;
        i++;
    }
    s[i] = '\0';
    return i;
}

void reverse(char orig[], char reversed[]) {
    int i, len;
    for (i=0;i<MAXLINE && orig[i]!='\n';i++)
        ;
    len = i;
    for (i=0;i<=len;i++)
        reversed[i] = orig[len-i];
    reversed[i] = '\0';
}




