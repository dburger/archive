/* testtcp.c: run the TCP connection setup and teardown */

#include <unistd.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <pthread.h>

#include "ipsim.h"

#define error(s) { perror(s); exit(1); }

static void test_listen (char ** argv);
static void test_connect (int argc, char ** argv);

/* argc is 1 (for command name) plus the number of arguments */
main (int argc, char ** argv)
{
  printf ("argc = %d\n", argc);
  if (argc == 6) {
#ifdef DEBUG
    printf ("testtcp.c: listening\n");
#endif DEBUG
    test_listen (argv + 1);
  } else if (argc % 6 == 3) {
#ifdef DEBUG
    printf ("testtcp.c: connecting\n");
#endif DEBUG
    test_connect (argc - 1, argv + 1);
  } else {
    printf ("usage: testtcp sim_IP UDP_port timeout tcp_port delay\n");
    printf ("       sim_IP has the form 1.2.3.4\n");
    printf ("       UDP_port is the port on which to run the simulator\n");
    printf ("       timeout and tcp_port are passed to tcp_listen\n");
    printf ("       delay is the delay in seconds before closing\n");
    printf ("usage: testtcp sim_IP UDP_port [real_ip UDP_port sim_IP\n");
    printf ("       local port remote port delay]*\n");
    return -1;
  }
}

static void test_listen (char ** argv)
{
  int local_ip, udp_port, timeout, tcp_port, delay;
  int remote_ip, listen_result;

  local_ip = inet_addr(argv [0]);
  udp_port = atoi(argv [1]);
  timeout = atoi(argv [2]);
  tcp_port = atoi(argv [3]);
  delay = atoi(argv [4]);

  if (ip_init(local_ip, udp_port) < 0) {
    error ("testtcp/ip_init");
    return;
  }
#ifdef DEBUG
  printf ("testtcp.c: calling tcp_init()\n");
#endif DEBUG
  tcp_init ();
#ifdef DEBUG
  {
    struct in_addr ia;
    ia.s_addr = local_ip;
    printf ("testtcp.c: calling tcp_listen(%s, %d, 0x%x, %d)\n",
	    inet_ntoa (ia), tcp_port, &remote_ip, timeout);
  }
#endif DEBUG
  listen_result = tcp_listen (local_ip, tcp_port, &remote_ip, timeout);
#ifdef DEBUG
  {
    struct in_addr ia;
    ia.s_addr = remote_ip;
    printf ("testtcp.c: tcp_listen returned %d, IP address %s\n",
	    listen_result, inet_ntoa (ia));
  }
#endif DEBUG
  if (listen_result >= 0) {
#ifdef DEBUG
    printf ("testtcp.c: sleeping %d seconds\n", delay);
#endif DEBUG
    sleep (delay);
#ifdef DEBUG
    printf ("testtcp.c: closing connection %d\n", listen_result);
#endif DEBUG
    tcp_close (listen_result, local_ip);
  }
}

static void test_connect (int argc, char ** argv)
{
  int local_ip, udp_port, i;
  int local_ports [MAX_CONNECTIONS];
  int remote_ports [MAX_CONNECTIONS];
  struct {int local_port; int remote_port; int duration;}
         arguments [MAX_CONNECTIONS];
  int connections [MAX_CONNECTIONS];
  struct {int sleep; int connection;} sleeps [MAX_CONNECTIONS];
  int duration_used [MAX_CONNECTIONS];
  int sleep_so_far;

  local_ip = inet_addr(argv [0]);
  udp_port = atoi(argv [1]);
  if (ip_init(local_ip, udp_port) < 0) {
    error ("testtcp/ip_init");
    return;
  }
#ifdef DEBUG
  printf ("testtcp.c: calling tcp_init()\n");
#endif DEBUG
  tcp_init ();

  for (i = 0, argc -= 2, argv += 2; (argc >= 6) && (i < MAX_CONNECTIONS);
       i++, argc -= 6, argv += 6) {
    simulated_hosts [i].real_ip = inet_addr(argv [0]);
    simulated_hosts [i].real_udp_port = atoi(argv [1]);
    simulated_hosts [i].sim_ip = inet_addr(argv [2]);
    arguments [i].local_port = atoi(argv [3]);
    arguments [i].remote_port = atoi(argv [4]);
    arguments [i].duration = atoi(argv [5]);
  }
  valid_entries = i;
  for (i = 0; i < valid_entries; i++) {
    if (arguments [i].duration < 0) {
      printf ("setting negative duration %d to zero\n",
	      arguments [i].duration);
      arguments [i].duration = 0;
    }
    if (arguments [i].duration > 200) { /* arbitrary max */
      printf ("setting duration over 200 to 200\n");
      arguments [i].duration = 200;
    }
  }
  /* n^2 sorting of durations to compute sleep intervals. */
  sleep_so_far = 0;
  for (i = 0; i < MAX_CONNECTIONS; i++) {
    duration_used [i] = 0;
  }

  /* open the connections */
  for (i = 0; i < valid_entries; i++) {
#ifdef DEBUG
    {
      struct in_addr ia;
      ia.s_addr = local_ip;
      printf ("calling tcp_connect(%s, ", inet_ntoa (ia));
      ia.s_addr = simulated_hosts [i].sim_ip;
      printf ("%s, %d, %d)\n", inet_ntoa (ia), arguments [i].local_port,
	      arguments [i].remote_port);
    }
#endif DEBUG
    connections [i] = tcp_connect (local_ip, simulated_hosts [i].sim_ip, 
				   arguments [i].local_port,
				   arguments [i].remote_port);
    if (connections [i] < 0) {
      printf ("result %d opening connection %d\n", connections [i], i);
      return;
    }
#ifdef DEBUG
    else {
      printf ("result %d opening connection %d\n", connections [i], i);
    }
#endif DEBUG

  }

  for (i = 0; i < valid_entries; i++) {
    int j, smallest = 201, search_index = MAX_CONNECTIONS;

    for (j = 0; j < valid_entries; j++) {
      if ((arguments [j].duration < smallest) &&
	  (duration_used [j] == 0)) {
	search_index = j;
	smallest = arguments [j].duration;
      }
    }
    duration_used [search_index] = 1;
    sleeps [i].sleep = smallest - sleep_so_far;
    sleep_so_far = smallest;
    sleeps [i].connection = connections [search_index];
  }

  /* sleep as appropriate */
  for (i = 0; i < valid_entries; i++) {
#ifdef DEBUG
    printf ("calling sleep(%d)\n", sleeps [i].sleep);
#endif DEBUG
    sleep (sleeps[i].sleep);
#ifdef DEBUG
    printf ("calling tcp_close(%d)\n", sleeps [i].connection);
#endif DEBUG
    tcp_close (sleeps [i].connection, local_ip);
  }
}

