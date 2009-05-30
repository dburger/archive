/* ip.c: simulated IP. */
/* compile with gcc -c ip.c  */
/* link with ... -lsocket -lnsl */

#include <unistd.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <pthread.h>

#include "ipsim.h"

#define error(s) { perror(s); exit(1); }

struct sim_entry simulated_hosts [MAX_CONNECTIONS];
int valid_entries = 0;

static int sock = -1;
static int simulated_ip_address;

int ip_init(int ip_address, int simulator_port)
{
  struct protoent * protocolentry;
  struct sockaddr_in sin;
  struct sockaddr * sap = (struct sockaddr *) &sin;

  simulated_ip_address = ip_address;
  if ((protocolentry = getprotobyname("udp")) == NULL) {
    error("getprotobyname");
    return -1;			/* not reached */
  }
  if ((sock = socket(AF_INET, SOCK_DGRAM, protocolentry->p_proto)) < 0) {
    error("socket");
    return -1;			/* not reached */
  }
  sin.sin_family = AF_INET;
  sin.sin_addr.s_addr = INADDR_ANY;
  sin.sin_port = htons(simulator_port);
  if (bind(sock, sap, sizeof (sin)) != 0) {
    error ("ip.c: bind failed, port already in use");
    return -1;			/* not reached */
  }
#ifdef DEBUG
  {
    struct in_addr ia;
    ia.s_addr = ip_address;
  /* print information */
    printf ("sim: simulated IP address %s, simulator port %d\n",
	    inet_ntoa (ia), simulator_port);
  }
#endif DEBUG

  return 0;
}

void ip_close ()
{
#ifdef DEBUG
  printf ("closing simulator socket\n");
#endif DEBUG
  if (close (sock) < 0)
    error ("close");
}

#define MAX_USER_PACKET 10000

int ip_send(int IP_address, char * packet, int bytes)
{
  struct sockaddr_in sin;
  struct sockaddr * sap = (struct sockaddr *) &sin;
  int host;
  int simulator_ip_address;
  short simulator_port;
  char buffer [MAX_USER_PACKET + 4];
  int print = ((bytes != 20) || (bytes >= MAX_USER_PACKET));

#ifdef DEBUG
  print = 1;
#endif DEBUG
  sin.sin_family = AF_INET;
  for (host = 0; host < valid_entries; host++) {
    if (IP_address == simulated_hosts [host].sim_ip) {
      sin.sin_addr.s_addr = simulated_hosts [host].real_ip;
      sin.sin_port = htons(simulated_hosts [host].real_udp_port);
      break;
    }
  }
  if (host >= valid_entries) {	/* no match found */
    struct in_addr ia;

    ia.s_addr = IP_address;
    printf ("host %s unreachable\n", inet_ntoa (ia));
    return -1;
  }
  if (print) {
    struct in_addr ia;
    int i;

    ia.s_addr = IP_address;
    /* print information */
    printf ("sim: sending %d-byte packet to %s",
	    bytes, inet_ntoa (ia));
    printf (" (on %s/%d), contents are: ",
	    inet_ntoa (sin.sin_addr), ntohs (sin.sin_port));
    for (i = 0; i < bytes; i++) {
      if (i % 20 == 0) printf ("\n");
      printf ("%02x,", (packet [i]) & 0xff);
    }
    printf ("\n");
  }
  if (bytes >= MAX_USER_PACKET) {
    printf ("packet too large (%d bytes)\n", bytes);
    return -1;
  }
  sin.sin_family = AF_INET;
  /* copy packet to buffer, prepending our simulated IP address */
  memcpy(buffer, &simulated_ip_address, 4);
  memcpy(buffer + 4, packet, bytes);
  if (sendto (sock, buffer, bytes + 4, 0, sap, sizeof(sin)) != bytes + 4) {
    perror ("sendto");
    printf ("arguments are %d, 0x%x, %d, 0x%x, %d\n",
	    sock, packet, bytes, sap, sizeof(sin));
    return -1;
  }
  return 0;
}

int ip_receive(char * packet, int size, int * from, int timeout)
{
  char buffer [MAX_USER_PACKET + 4];
  int count, host, addrlen, opt, optlen = sizeof(opt);
  fd_set fds;
  struct timeval tout;
  struct sockaddr_in sin;
  struct sockaddr * sap = (struct sockaddr *) &sin;

  FD_ZERO(&fds);
  FD_SET(sock, &fds);
  tout.tv_sec = timeout / 1000;
  tout.tv_usec = timeout % 1000;
  /* clear any errors produced by previous sends */
  getsockopt (sock, SOL_SOCKET, SO_ERROR, (char *) &opt, &optlen);
#ifdef DEBUG
  printf ("ip_receive calling select, timeout %d ms\n", timeout);
#endif DEBUG
  if ((count = (select (sock + 1, &fds, NULL, NULL, &tout))) == 0) {
    /* not ready for reading */
#ifdef DEBUG
    printf ("ip_receive timing out after %d milliseconds\n", timeout);
#endif DEBUG
    return -1;
  } else if (count < 0) {
    error ("select");
  } else {
    addrlen = sizeof(sin);
#ifdef DEBUG
    printf ("ip_receive calling recvfrom, addrlen %d\n", addrlen);
#endif DEBUG
    count = recvfrom (sock, buffer, sizeof(buffer), 0, sap, &addrlen);
    if (count <= 0) {
      perror ("ip_receive/recvfrom -- trying again");
      count = recvfrom (sock, buffer, sizeof(buffer), 0, sap, &addrlen);
    }
    if (count <= 0) {
      perror ("ip_receive/recvfrom");
      return -1;
    } else if (count <= 4) {
      printf ("ip_receive got packet with illegal size %d\n", count - 4);
      return -1;
    } else {
#ifdef DEBUG
      int i;
      char * p = (char *) buffer + 4;
      struct in_addr * ia = (struct in_addr *) buffer;

      printf ("ip_receive got %d bytes from IP %s, contents are: ",
	      count - 4, inet_ntoa (*ia));
      for (i = 0; i + 4 < count; i++, p++) {
	if (i % 20 == 0) printf ("\n");
	printf ("%02x,", (*p) & 0xff);
      }
      printf ("\n");
#endif DEBUG
      memcpy(from, buffer, 4);
      memcpy(packet, buffer + 4, count - 4);

      for (host = 0; host < valid_entries; host++) {
	if (*from == simulated_hosts [host].sim_ip) {
	  break;
	}
      }
      if (host >= valid_entries) {	/* no match found */
	simulated_hosts [host].sim_ip = *from;
	simulated_hosts [host].real_ip = sin.sin_addr.s_addr;
	simulated_hosts [host].real_udp_port = ntohs (sin.sin_port);
	valid_entries++;
      }

      return (count - 4);
    }
  }
}
