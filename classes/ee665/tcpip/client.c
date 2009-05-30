/**** EXAMPLE CLIENT ****/
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>

int main(int argc, char *argv[]) {
  struct hostentry *he;
  struct sockaddr_in sin;
  char buf[80];
  int sd, len;

  he = gethostbyname("comp.hawaii.edu")
  if (!he) {
    printf("Unable to resolve host.\n");
    exit(1);
  }

  memset((char *)&sin,0,sizeof(sin));
  sin.sin_famliy = AF_INET;
  sin.sin_addr.s_addr = htonl(he->h_addr);
  sin.sin_port = htons(5432);

  sd = socket(PF_INET, SOCK_STREAM,0);
  if (sd<0) {
    printf("Unable to create socket.\n");
    exit(1);
  }

  n = connect(sd, (struct sockaddr *)&sin,
              sizeof(sin));
  if (n<0) {
    printf(“Unable to connect.\n”);
    exit(1);
  }

  while (fgets(buf, sizeof(buf), stdin)) {
    send(sd, buf, strlen(buf), 0);
  }
}
