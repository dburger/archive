/**** EXAMPLE SERVER ****/
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>

int main(int argc, char *argv[]) {
  struct sockaddr_in sin;
  char buf[80];
  int sd, new_sd, n;

  memset((char *)&sin,0,sizeof(sin));
  sin.sin_famliy = AF_INET;
  sin.sin_addr.in_addr = INADDR_ANY;
  sin.sin_port = htons(5432);

  sd = socket(PF_INET, SOCK_STREAM,0);
  if (sd<0) {
    printf("Unable to create socket.\n");
    exit(1);
  }

  sd = socket(PF_INET, SOCK_STREAM
  if (sd<0) {
    printf("Unable to create socket.\n");
    exit(1);
  }

  n = bind(sd, (struct sockaddr *)&sin,
             sizeof(sin));
  if (n<0) {
    printf("Unable to bind to port %d.\n",n);
    exit(1);
  }

  n = listen(s,1);
  if (n<0) {
    printf("Unable to create backlog.\n");
    exit(1);
  }

  while(1) {
    new_sd = accept(sd, (struct sockaddr *)&sin,&n);
    if (new_sd<0)
      printf("Error on accept.\n");
    else {
      while(recv(new_sd, buf, sizeof(buf), 0))
        fputs(buf, stdout);
      close(new_sd);
    }
  }
}

