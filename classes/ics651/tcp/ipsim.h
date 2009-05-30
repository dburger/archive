/* ipsim.h: header file for the IP simulator and TCP test program. */

struct sim_entry {
  int sim_ip;
  int real_ip;
  int real_udp_port;
};

#define MAX_CONNECTIONS	10

/* defined in ip.c */
extern struct sim_entry simulated_hosts [MAX_CONNECTIONS];
extern int valid_entries;

extern int ip_init(int ip_address, int simulator_port);
extern void ip_close ();
extern int ip_send(int IP_address, char * packet, int bytes);
extern int ip_receive(char * packet, int size, int * from, int timeout);

/* defined in tcp.c */
extern int tcp_connect(int local_IP, int IP_address,
                       short local_port, short remote_port);
extern int tcp_listen(int local_IP, short local_port,
                      int * IP_address, int timeout);
extern void tcp_close(int connection, int local_IP);
extern void tcp_init ();
