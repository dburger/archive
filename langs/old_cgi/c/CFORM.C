#include <stdio.h>
#include <string.h>

main () {

  FILE *fp;
  fp = fopen("formdata.txt", "a");
  fprintf(fp,"\nc");
  printf("Content-type: text/html\n\n");
  printf("<html>");
  printf("<head>");
  printf("<title></title>");
  printf("</head>");
  printf("<body bgcolor='orange'>");
  printf("<h1>C Form</h1>");
  printf("<hr>");
  printf("</body>");
  printf("</html>");
  exit(0);

}




