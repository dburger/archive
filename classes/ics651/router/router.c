/*=============================================================================
Assignment: Project 1, router
Author:     David J. Burger
Language:   ANSI C running on UHUNIX2 (Solaris)
Compile:    by running "make" with included makefile
Class:      ICS 651
Instructor: Edo Biagioni
Due Date:   Feb. 12, 2002
===============================================================================
File:         router.c
Description:  this program simulates a router using slip for communication
              
Exceution:    router lport/sim_ip/rport ip@lport

              lport  - local port for simulated interface
              sim_ip - destination address for packets through this iface
              rport  - destination port for packets through this iface

              ip     - simulated destination ip
              lport  - local port/iface to handle this ip
=============================================================================*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>

#include <pthread.h>
#include <time.h>

#include "list.h" /* linked list functions */

typedef unsigned long UL;
typedef unsigned short US;
typedef unsigned char UC;

#define END 0xC0
#define ESC 0xDB
#define ESC_END 0xDC
#define ESC_ESC 0xDD

#define MAX_PACKET 1006
#define MIN_PORT 1025
#define MAX_PORT 65535

#define MAX_IFACES 100
#define MAX_ROUTES 100
#define MAX_QUEUE 3

#define SLEEP 800000

#define error(s) { perror(s); exit(1); }

struct ip_hdr {
  UC verlen; /* version and header length in octets */
  UC tos; /* type of service */
  US length; /* total length of packet in bytes */
  US id; /* identification used in fragmentation */
  US fragoffset; /* flags in upper 3 bits and fragment offset */
  UC ttl; /* time to live */
  UC protocol; /* protocol of payload */
  US checksum; /* yes, the checksum */
  UL srceadd; /* source IP address */
  UL destadd; /* destination IP address */
};

struct interface { 
  int lport; /* local port number */
  UL rip; /* remote ip address */
  int rport; /* remote port number */
  pthread_t *listen; /* listen thread for interface */
  pthread_mutex_t *qmut; /* the mutex for the packet queue on this iface */
  struct list *sendq; /* the sending queue */
};

struct route {
  UL ip; /* destination for this route */
  int lport; /* the local port of the route, matches an interface port */
  int iface_idx; /* index of iface that services this route or -1 if none */
};

struct packet_entry {
  char *packet; /* the actual packet data */
  struct ip_hdr *ip; /* pointer used to point at packet to get at ip fields */
  int len; /* total size of the packet */
};

struct interface ifaces[MAX_IFACES]; /* array of interfaces */
int ifacecnt = 0;

struct route route_tab[MAX_ROUTES]; /* routing table */
int routecnt = 0;

/*=============================================================================
Function print_packet
Purpose:  to print out the contents of a packet in hex

Parameters:
     buf (IN) - buffer containing packet data
     len (IN) - length of buffer data

Returns:  nothing, prints out the packet contents in hex
=============================================================================*/
void print_packet(char *buf, int len) {
  int n;
  for (n=0;n<len;n++)
    printf("%02x.",0xff & buf[n]);
  printf("\n");
}

/*=============================================================================
Function mysleep
Purpose:  a friendly interface to the nanosleep function

Parameters:
     secs (IN) - time to sleep

Returns:  0 if sleeps successfully, otherwise returns -1 and sets errno()
=============================================================================*/
int mysleep(int secs, long nanosecs) {
  struct timespec tm;
  tm.tv_sec = 0;//secs;
  tm.tv_nsec = nanosecs;
  return nanosleep(&tm,NULL);
}

/*=============================================================================
Function packetentry_init
Purpose:  creates a new packetentry structure and returns a pointer to it

Parameters:
     *buf (IN) - the buffer containing the packet
     *len (IN) - the size of the packet

Returns:  a pointer to a new packet_entry structure
=============================================================================*/
struct packet_entry *packet_entry_init(char *buf, int len) {
  struct packet_entry *pe =
    (struct packet_entry *)malloc(sizeof(struct packet_entry));
  pe->packet = (char *)malloc(len);
  memcpy(pe->packet,buf,len);
  pe->ip = (struct ip_hdr *)pe->packet; /* pointer used to access ip fields */
  pe->len = len;
  return pe;
}

/*=============================================================================
Function packetentry_free

Purpose:  frees a packetentry and the memory associated with a packetentry
          
Parameters:
    *p (IN) - a pointer to the packetentry to free
        
Returns:  nothing, the memory associated is freed
=============================================================================*/
void packet_entry_free(struct packet_entry *pe) {
  if (pe->packet!=NULL) free(pe->packet);
  free(pe);
}

/*=============================================================================
Function parse_route

Purpose:  parses route information from a command line route parameter
          
Parameters:
    *s (IN) - a pointer to the command line paramter
    *r (IN) - a pointer to a route within the route table
        
Returns:  if a route was succesfully parsed, 1 is returned and *r is populated,
          otherwise, 0 is returned
=============================================================================*/
int parse_route(char *s, struct route *r) {
  int lport,b0,b1,b2,b3;
  char ip[30]; /* 29 characters should be enough for all valid strings */
  char *p = strchr(s,'@');
  if (p!=NULL) *p = ' ';
  if (strlen(s)>sizeof(ip)-1) return 0;
  if (sscanf(s,"%s %d",ip,&lport)<2) return 0;
  if (lport<MIN_PORT || lport>MAX_PORT) return 0;
  if (sscanf(ip,"%d.%d.%d.%d",&b3,&b2,&b1,&b0)<4) return 0;
  if (b0<0 || b0>255 || b1<0 || b1>255 || b2<0 || b2>255 || b3<0 || b3>255)
    return 0;
  r->ip = (b3<<24) | (b2<<16) | (b1<<8) | b0;
  r->lport = lport;
  return 1;
}

/*=============================================================================
Function parse_iface

Purpose:  parses interface information from a command line interface parameter
          
Parameters:
    *s (IN) - a pointer to the command line paramter
    *i (IN) - a pointer to an interfaces within the ifaces table
        
Returns:  if an interface was succesfully parsed, 1 is returned and *i is
          populated, otherwise, 0 is returned
=============================================================================*/
int parse_iface(char *s, struct interface *i) {
  char *p;
  int lport,rport;
  char host[30]; /* 29 characters should be enough for all valid strings */
  struct hostent *he;
  if (strlen(s)>sizeof(host)-1) return 0; /* prevent buff overflow in sscanf */
  while((p=strchr(s,'/'))!=NULL) *p=' '; /* replace all / with space */
  if (sscanf(s,"%d %s %d",&lport,host,&rport)<3) return 0;
  if (lport<MIN_PORT || lport>MAX_PORT || rport<MIN_PORT || rport>MAX_PORT)
    return 0;
  if ((he=gethostbyname(host))==NULL) return 0;
  i->lport = lport;
  i->rport = rport;
  i->rip = *(UL *)(he->h_addr);
  return 1;
}

/*=============================================================================
Function config_routes

Purpose:  to match routes with interfaces
          
Parameters:  none
        
Returns:  nothing, but places the index of the corresponding interface for
          the route in the route_tab or -1 if no route exists
=============================================================================*/
void config_routes() {
  int i, j;
  for (i=0;i<routecnt;i++) {
    route_tab[i].iface_idx = -1; /* -1 indicates no route */
    for (j=0;j<ifacecnt;j++)
      if (route_tab[i].lport == ifaces[j].lport) {
        route_tab[i].iface_idx = j;
        break;
      }
  }
}

/*=============================================================================
Function print_ifaces

Purpose:  to print out the interfaces for the simulation
          
Parameters:  none
        
Returns:  nothing, but prints a formatted output of the interfaces for simul.
=============================================================================*/
void print_ifaces() {
  int n;
  printf("Interfaces for simulation(%d):\n",ifacecnt);
  printf("lport   rip        rport\n");
  for (n=0;n<ifacecnt;n++)
    printf("%d    %08x   %d\n",
           ifaces[n].lport,ifaces[n].rip,ifaces[n].rport);
  printf("\n");
}

/*=============================================================================
Function print_routes

Purpose:  to print out the routes for the simulation
          
Parameters:  none
        
Returns:  nothing, but prints a formatted output of the routes for simul.
=============================================================================*/
void print_routes() {
  int n;
  printf("Routes for simulation(%d):\n",routecnt);
  printf("port    ip         iface\n");
  for (n=0;n<routecnt;n++)
    printf("%d    %08x   %d\n",
           route_tab[n].lport,route_tab[n].ip,route_tab[n].iface_idx);
  printf("\n");
}

/*=============================================================================
Function get_class_mask

Purpose:  determines the mask that should be used with IP address comparisons
          based on class based addressing
          
Parameters:
    addr (IN) - the address to determine the class mask of
        
Returns:  the mask that should be used in route comparisons for the given addr
          based on class based addressing
=============================================================================*/
UL get_class_mask(UL addr) {
  if ((addr & 0xE0000000) == 0xC0000000)
    return 0xFFFFFF00; /* CLASS C MASK */
  else if ((addr & 0xC0000000) == 0x80000000)
    return 0xFFFF0000; /* CLASS B MASK */
  else
    return 0xFF000000; /* CLASS A MASK */
}

/*=============================================================================
Function iface_match

Purpose:  determines the interface that should handle destadd by going through
          route_tab to find a match
          
Parameters:
    destadd (IN) - the destination address
        
Returns:  the index of the interface that should handle packets with address
          destadd, or -1 if no such route exists
=============================================================================*/
int iface_match(UL destadd) {
  int i;
  UL mask = get_class_mask(destadd);
  for (i=0;i<routecnt;i++)
    if ((destadd & mask) == (route_tab[i].ip & mask))
      return route_tab[i].iface_idx;
  return -1;
}

/*=============================================================================
Function send_packet

Purpose:  sends the packets in the queue for the passed in interface
          adding slip encoding as it sends
          
Parameters:
    *i (IN) - a pointer to the interface to send a packet for
        
Returns:  nothing, the packets for interface *i are sent and then removed
=============================================================================*/
void *send_packet(void *i) {
  struct interface *iface = (struct interface *)i;

  int sd, addlen, qsize = 1; /* always at least 1 packet to send */
  struct sockaddr_in sin;
  struct protoent *ptrp;

  struct packet_entry *pe;
  char *p;
  int temp;
  memset((char *)&sin,0,sizeof(sin));
  sin.sin_family = AF_INET;
  sin.sin_port = htons(iface->rport);
  sin.sin_addr.s_addr = htonl(iface->rip);

  if (((int)(ptrp = getprotobyname("udp"))) == 0)
    error("getprotobyname");

  if ((sd = socket(AF_INET, SOCK_DGRAM,ptrp->p_proto)) < 0)
    error("socket");

  while(qsize) {

    pe = list_peek_front(iface->sendq); /* leave on queue */
    p = pe->packet;
    #ifdef DEBUG
      printf("sending  (%d): ",pe->len);
      print_packet(p,pe->len);
    #endif
    /* sending an END at the start will flush any residual packet */
    temp = *p;
    *p = END;
    sendto(sd,p,1,0,(struct sockaddr *)(&sin),sizeof(sin));    
    *p = temp;
    while (pe->len--) {
      switch (*p) {
        case (char)END:
          *p = ESC;
          sendto(sd,p,1,0,(struct sockaddr *)(&sin),sizeof(sin));
          mysleep(0,SLEEP);
          *p = ESC_END;
          break;
        case (char)ESC:
          *p = ESC;
          sendto(sd,p,1,0,(struct sockaddr *)(&sin),sizeof(sin));
          mysleep(0,SLEEP);
          *p = ESC_ESC;
          break;
      }
      sendto(sd,p++,1,0,(struct sockaddr *)(&sin),sizeof(sin));
      mysleep(0,SLEEP);
    }
    *--p = END; /* END placed at end of packet and then sent */
    sendto(sd,p,1,0,(struct sockaddr *)(&sin),sizeof(sin));
    pthread_mutex_lock(iface->qmut);
    pe = list_remove_front(iface->sendq); /* now remove from queue */
    packet_entry_free(pe);
    qsize = iface->sendq->size; /* this will determine if thread continues */
    pthread_mutex_unlock(iface->qmut);
  }
}

/*=============================================================================
Function route_packet

Purpose:  routes a packet...that is it decrements the ttl and places it on the
          appropriate outgoing queue if packet is valid, a route is found,
          the queue has room, and the packet has not timed out
          
Parameters:
    *buf (IN) - the buffer containing the packet to route
    len  (IN) - the length of the buffer
        
Returns:  nothing
=============================================================================*/
void route_packet(char *buf, int len) {
  struct packet_entry *pe;
  pthread_t *new_st; /* new send thread */
  struct ip_hdr *ip = (struct ip_hdr *)buf;
  int idx, qsize;
  printf("Routing received packet:\n");
  #ifdef DEBUG
    printf("recv'ed  (%d): ",len);
    print_packet(buf,len);  
  #endif
  if (len<sizeof(struct ip_hdr)) {
    printf("Invalid packet, packet discarded.\n"); 
    return;
  }
  if (ip->ttl<=1) {
    printf("Discarding timed out packet.\n");
    return;
  }
  ip->ttl-=1;
  printf("ttl decremented to %d decimal, 0x%02x hex.\n",ip->ttl,ip->ttl);
  if ((idx = iface_match(ip->destadd))==-1)
    printf("No matching route found, packet discarded.\n");
  else {
    pthread_mutex_lock(ifaces[idx].qmut);
    qsize = ifaces[idx].sendq->size;
    if (qsize<MAX_QUEUE) {
      printf("Sending packet on iface with port %d.\n",ifaces[idx].lport);
      pe = packet_entry_init(buf,len);
      list_insert_back(ifaces[idx].sendq,pe);
    } else {
      printf("Send queue full for iface with port %d, packet discarded.\n",
             ifaces[idx].lport);
    }
    pthread_mutex_unlock(ifaces[idx].qmut);
    if (!qsize) {            /* queue was empty, thread must be started */
      new_st = (pthread_t *)malloc(sizeof(pthread_t));
      if (pthread_create(new_st,NULL,send_packet,&ifaces[idx])!=0)
        error("pthread_create");
    }
  }
}

/*=============================================================================
Function listen_iface

Purpose:  used as a listening thread for an interface.  When a packet is
          received slip decoding is performed as it is paced in the buffer, the
          packet is then passed to the route_packet routine
          
Parameters:
    *i (IN) - a pointer to the interface to listen on
        
Returns:  nothing
=============================================================================*/
void *listen_iface(void *i) {
  struct interface *iface = (struct interface *)i;

  int sd, addlen, c, totbytes = 0;
  char buf[1];
  char slipBuf[MAX_PACKET];
  struct sockaddr_in sin;
  struct protoent *ptrp;
  /* set up the sockaddr */
  memset((char *)&sin,0,sizeof(sin));
  sin.sin_family = AF_INET;
  sin.sin_addr.s_addr = INADDR_ANY;
  sin.sin_port = htons(iface->lport);

  if (((int)(ptrp = getprotobyname("udp"))) == 0)
    error("getprotobyname");

  if ((sd = socket(AF_INET, SOCK_DGRAM,ptrp->p_proto)) < 0)
    error("socket");

  if (bind(sd,(struct sockaddr *)&sin,sizeof(sin)) < 0)
    error("bind");
  
  while(1) {
    recvfrom(sd,buf,1,0,(struct sockaddr *)&sin,&addlen);
    c = 0xff & buf[0];
    switch (c) {
      case END:
        if (totbytes) {
          route_packet(slipBuf,totbytes); /* handle the packet */
          totbytes = 0; /* reset for next packet */
        }
        break;
      case ESC:
        recvfrom(sd,buf,1,0,(struct sockaddr *)&sin,&addlen);
        c = 0xff & buf[0];
        switch (c) {
          case ESC_END:
            c = END;
            break;
          case ESC_ESC:
            c = ESC;
            break;
        }
        /* falling through here */
      default:
        if (totbytes<MAX_PACKET)
          slipBuf[totbytes++] = c;
    }
  }

}

/*=============================================================================
Function main

Purpose:  this is the main entry point to program.  Command line paramters are
          parsed to establish interfaces and routes and then a listening thread
          is started for each interface.
          
Parameters:
    argc (IN) - count of command line paramters
    *arvg[] (IN) - array of char *'s to command line paramters
        
Returns:  nothing
=============================================================================*/
int main(int argc, char *argv[]) {

  int i;

  /* parse command line parameters into routes and interfaces */
  for (i=1;i<argc;i++)
    if (strchr(argv[i],'@')==NULL) {
      if (ifacecnt<MAX_IFACES && parse_iface(argv[i],&ifaces[ifacecnt]))
        ifacecnt++;
    } else {
      if (routecnt<MAX_ROUTES && parse_route(argv[i],&route_tab[routecnt]))
        routecnt++;
    }

  if (ifacecnt==0) {
    printf("Proper usage is %s localport/ip/remoteport ...\n",argv[0]);
    exit(1);
  }

  printf("Parsed %d interfaces with %d routes.\n",ifacecnt,routecnt);

  config_routes(); /* matches routes to interfaces in the route_tab */

  print_ifaces();
  print_routes();

  /* now start a listen thread for each interface */
  for (i=0;i<ifacecnt;i++) {
    ifaces[i].listen = (pthread_t *)malloc(sizeof(pthread_t));
    if (pthread_create(ifaces[i].listen,NULL,listen_iface,&ifaces[i])!=0)
      error("pthread_create");
    ifaces[i].qmut = (pthread_mutex_t *)malloc(sizeof(pthread_mutex_t));
    pthread_mutex_init(ifaces[i].qmut,NULL);
    ifaces[i].sendq = list_init();
  }

  pthread_join(*ifaces[0].listen,NULL);   /* keep running by joining iface 0 */

}
