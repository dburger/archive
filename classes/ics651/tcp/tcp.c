/* tcp.c: tcp state machine and signaling. */
/* created for ICS 651 by: David J. Burger */
/* interoperates with implementations by:  */
/* Jiey, Wei, Xin, Bin, Yihua              */
/* status:

The program seems to work well as I have had
no problem getting it to work with the
implemenations of other students in the
class.  The program correctly handles both
single connections and multiple connections.

The version I am turning in does not do
simultaneous connect as it doesn't seem
that uhunix is buffering the packets like it
should.  In other words the SYN from the
program that starts first is lost, and
without re-transmission the connection won't
take place.  In our book on pg. 381 the
state diagram shows SYN+ACK being sent from
the SYN_SENT state in response to receiving
a SYN.  This contradicts the state diagram
shown in the RFC.  The book's version of the
state diagram would allow simultaneous
connect to take place in spite of losing the
first packet without retransmission, however,
I have decided to stick with the
interpretation that I got from the RFC, not
the book.  Such a modification could easily
be made if the book ended up being correct.

*/

#include <sys/timeb.h>

#include "ipsim.h"

#define FIN 0x01
#define SYN 0x02
#define RST 0x04
#define ACK 0x10
#define ALL_FLAGS 0x3F /* used to determine set flags in tcp header */

#define CONNECT_TIMEOUT 10000 /* connect timeout without expected packet */
#define TIME_WAIT_SLEEP 2 /* seconds for TIME_WAIT */
#define INFINITY 0x7FFFFFFF /* time out until closed...close to infinity! */

#define PROTOCOL 6 /* TCP */

/* tcp connection states followed by corresponding strings array */
enum states {
  CLOSED, LISTEN, SYN_SENT, SYN_RCVD, ESTAB, FIN_WAIT1, FIN_WAIT2,
  CLOSE_WAIT, CLOSING, LAST_ACK, TIME_WAIT
};

char *tcp_states[] = { "CLOSED", "LISTEN", "SYN_SENT", "SYN_RCVD",
                       "ESTAB", "FIN_WAIT1", "FIN_WAIT2", "CLOSE_WAIT",
                       "CLOSING", "LAST_ACK", "TIME_WAIT" };

/* tcp header structure w/o options */
struct tcp {
  unsigned short srce_port;
  unsigned short dest_port;
  unsigned long seq_num;
  unsigned long ack_num;
  unsigned char offset;
  unsigned char flags;
  unsigned short window;
  unsigned short chk_sum;
  unsigned short urg_pntr;
};

/* transmission control block structure */
struct tcb {
  enum states state;
  enum states prevstate;
  unsigned long rip;
  unsigned short lport;
  unsigned short rport;
  unsigned long senduna;
  unsigned long sendnext;
  unsigned long recvnext;
  unsigned short recvwnd;
};

unsigned long my_ip; /* global local IP address */
struct tcb conns[MAX_CONNECTIONS]; /* global conns table */

/*=============================================================================
Function between

Purpose:  determines if a is between b and c mod 2^32
          
Parameters:
    a (IN) - value to determine if between
    b (IN) - "left" end of range
    c (IN) - "right" end of range
        
Returns:  true if a is between b and c, false otherwise

***NOTE: to do inclusive, add or subtract 1 to the appropriate end value
=============================================================================*/
int between(unsigned long a, unsigned long b, unsigned long c) {
  if (b<=c)
    return a>b && a<c;
  else
    return a>b || a<c;
}

/*=============================================================================
Function cksum

Purpose:  calculates the checksum of buf, assumed to have 16 bit boundary

Parameters:
    *buf (IN) - data to checksum
    count (IN) - the number of words (16 bit) in buf
    src_ip (IN) - source IP for packet
    dst_ip (IN) - destination IP for packet
            
Returns:  the internet checksum of buf
=============================================================================*/
unsigned short cksum(unsigned short *buf, int count, unsigned long src_ip,
                     unsigned long dst_ip) {
  register unsigned long sum = count*2; /* count field before we change it */

  while (count--)
    sum+=*buf++;

  sum+=(0xFFFF & src_ip); /* lower short of source IP */
  sum+=(src_ip>>16);      /* upper short of source IP */

  sum+=(0xFFFF & dst_ip); /* lower short of destination IP */
  sum+=(dst_ip>>16);      /* upper short of destination IP */

  sum+=PROTOCOL; /* protocol */

  while (sum>>16) sum = (sum & 0xFFFF) + (sum >> 16); /* manage carry */

  return ~(sum & 0xFFFF);
}

/*=============================================================================
Function fill_header

Purpose:  fills buf, which must be of length 20 bytes, with the passed in
          header fields
          
Parameters:
    *tcp_header (IN) - the header to fill
    srce_port (IN) - source port to put in header
    dest_port (IN) - destination port to in header
    seq_num (IN) - sequence number to put in header
    ack_num (IN) - acknowledgment number to put in header
    flags (IN) - flags to put in header
    window (IN) - size of window to put in header
    src_ip (IN) - source IP address for packet
    dst_ip (IN) - destination IP address for packet    
            
Returns:  nothing, fills tcp_header with the appropriate header
=============================================================================*/
void fill_header(struct tcp *tcp_header, unsigned short srce_port,
                 unsigned short dest_port, unsigned long seq_num,
                 unsigned long ack_num, unsigned char flags,
                 unsigned short window, unsigned long src_ip,
                 unsigned long dst_ip) {
  tcp_header->srce_port = htons(srce_port);
  tcp_header->dest_port = htons(dest_port);
  tcp_header->seq_num = htonl(seq_num);
  tcp_header->ack_num = htonl(ack_num);
  tcp_header->offset = 0x50;
  tcp_header->flags = flags;
  tcp_header->window = htons(window);
  tcp_header->chk_sum = 0;
  tcp_header->urg_pntr = 0;
  tcp_header->chk_sum = htons(cksum((unsigned short *)tcp_header,10,
                                    src_ip, dst_ip));
}

/*=============================================================================
Function fill_header_conn

Purpose:  fills buf, which must be of length 20 bytes, with the appropriate
          header fields for the given connection and flags
          
Parameters:
    conn (IN) - the connection to make a header for
    *tcp_header (IN) - the header to fill
    flags (IN) - the flags to set in the header
                
Returns:  nothing, fills tcp_header with the appropriate header
=============================================================================*/
void fill_header_conn(int conn, struct tcp *tcp_header, unsigned char flags) {
  fill_header(tcp_header, conns[conn].lport, conns[conn].rport,
              conns[conn].sendnext, conns[conn].recvnext, flags,
              conns[conn].recvwnd, my_ip, conns[conn].rip);
}

/*=============================================================================
Function gen_sequence

Purpose:  generates a sequence number according to rfc, usecs / 4
          
Parameters: - none
            
Returns:  a suitable sequence number equaling current time in usecs / 4
=============================================================================*/
unsigned long gen_sequence() {
  struct timeval now;
  gettimeofday(&now, NULL);
  return now.tv_sec * 250000 + (now.tv_usec >> 2); /* RFC 793 */
}

/*=============================================================================
Function get_free_connection

Purpose:  finds a free connection in the connection table
          
Parameters: - none
            
Returns:  index representing a free connection or -1 if there are none
=============================================================================*/
int get_free_connection() {
  int i;
  for (i=0;i<MAX_CONNECTIONS;i++)
    if (conns[i].state==CLOSED) return i;
  return -1;
}

/*=============================================================================
Function get_connection

Purpose:  finds the connection corresponding to the received header
          
Parameters: - none
            
Returns:  index representing the connection or -1 if it doesn't exist
=============================================================================*/
int get_connection(struct tcp *tcp_header, unsigned long srce_ip) {
  int i;
  for (i=0;i<MAX_CONNECTIONS;i++) {
    /* matches an existing connection or listening port */
    if ((conns[i].state!=CLOSED && conns[i].rip==srce_ip &&
         conns[i].lport==ntohs(tcp_header->dest_port) &&
         conns[i].rport==ntohs(tcp_header->srce_port)) ||
        (conns[i].state==LISTEN &&
         conns[i].lport==ntohs(tcp_header->dest_port)))
      return i;
  }
  return -1;
}

/*=============================================================================
Function millidifftime

Purpose:  determines the millisecond time difference between two timeb's
          
Parameters:
    *older (IN) - older timeb
    *newer (IN) - newer timeb
        
Returns:  the millisecond difference between the newer and older timeb's
=============================================================================*/
int millidifftime(struct timeb *older, struct timeb *newer) {
  return 1000*(newer->time - older->time) + (newer->millitm - older->millitm);
}

/*=============================================================================
Function printTCPHeader

Purpose:  prints out info. from a tcp packet in a tcpdump style
          
Parameters:
    in (IN) - whether this packet we sent out or received in
    *tcp_header (IN) - pointer to tcp header we are printing data for
    size (IN) - the amount of data that came with the header, used for ranges
        
Returns:  nothing, prints out tcpdump style data for the packet
=============================================================================*/
void printTCPHeader(int in, struct tcp *tcp_header, int size) {
  if (in)
    printf("remote.%d > local.%d:",ntohs(tcp_header->srce_port),ntohs(tcp_header->dest_port));
  else
    printf("local.%d > remote.%d:",ntohs(tcp_header->srce_port),ntohs(tcp_header->dest_port));
  if (tcp_header->flags & 0x20) printf(" U");
  if (tcp_header->flags & 0x10) printf(" A");
  if (tcp_header->flags & 0x08) printf(" P");
  if (tcp_header->flags & 0x04) printf(" R");
  if (tcp_header->flags & 0x02) printf(" S");
  if (tcp_header->flags & 0x01) printf(" F");
  printf(" %08x:%08x(%d)",ntohl(tcp_header->seq_num),ntohl(tcp_header->seq_num)+size,size);
  if (tcp_header->flags & 0x10) printf(" ack %08x",ntohl(tcp_header->ack_num));
  printf(" win %d\n",ntohs(tcp_header->window));
}

/*=============================================================================
Function my_ip_receive

Purpose:  calls ip_receive if timeout > 0 otherwise returns code for timeout
          allows us to avoid checking for negative before calling ip_receive
          and also prints the received packet contents
          
Parameters:
    *packet (IN) - buffer to fill in with received data
    size (IN) - size of buffer
    *from (IN) - filled in with the source IP of the received packet
    timeout (IN) - timeout for receive in milliseconds
        
Returns:  fills *packet and returns number of bytes read, or -1 if timed out
=============================================================================*/
int my_ip_receive(char * packet, int size, int * from, int timeout) {
  int i;
  if (timeout>0) {
    i = ip_receive(packet,size,from,timeout);
    if (i!=-1) printTCPHeader(1,(struct tcp *)packet,0);   
    return i;
  } else
    return -1;
}

/*=============================================================================
Function my_ip_send

Purpose:  calls ip_send but also prints the packet contents
          
Parameters:
    IP_address (IN) - IP-address to send to
    *packet (IN) - packet to send
    bytes (IN) - number of bytes in the packet
        
Returns:  0 if the send succeeds, otherwise -1
=============================================================================*/
int my_ip_send(int IP_address, char *packet, int bytes) {
  printTCPHeader(0,(struct tcp *)packet,0);
  return ip_send(IP_address, packet, bytes);
}

/*=============================================================================
Function set_state

Purpose:  sets the state of the passed in connection, keeps track of prevstate
          
Parameters:
    conn (IN) - connection to set state of
    state (IN) - new state for connection
            
Returns:  nothing, but sets the state and correctly sets prevstate
=============================================================================*/
void set_state(int conn, enum states state) {
  conns[conn].prevstate = conns[conn].state;
  conns[conn].state = state;
  printf("connection %d changed to state %s\n\n", conn, tcp_states[state]);
}

/*=============================================================================
Function synchronized

Purpose:  determines if the given state is a synchronized state
          
Parameters:
    state (IN) - state to determine if synchronized
            
Returns:  1 if state is in a synchronized state, otherwsie 0
=============================================================================*/
int synchronized(enum states state) {
  return !(state==CLOSED || state==LISTEN || state==SYN_SENT ||
           state==SYN_RCVD);
}

/*=============================================================================
Function tcp_connect

Purpose:  tries to open a tcp connection
          
Parameters:
    local_IP (IN) - the local IP address for the connection
    IP_address (IN) - IP address to connect to
    local_port (IN) - local port for connection
    remote_port (IN) - remote port for connection
            
Returns:  returns the connection number if successful, otherwise -1
=============================================================================*/
int tcp_connect(int local_IP, int IP_address, short local_port,
                short remote_port) {

  int conn;
  unsigned long seq_num;
  struct tcp tcp_header;

  my_ip = local_IP; /* set the global IP address to our IP */

  /* see if we have a free connection */
  if ((conn = get_free_connection())==-1) {
    printf("tcp_connect: no free connections\n");
    return -1;
  }
  
  seq_num = gen_sequence(); /* generate the ISN */

  /* set up the connection fields */
  conns[conn].lport = local_port;
  conns[conn].rport = remote_port;
  conns[conn].rip = IP_address;
  conns[conn].sendnext = seq_num;
  conns[conn].senduna = seq_num;
  conns[conn].recvnext = 0;

  /* create the initial SYN packet */
  fill_header_conn(conn, &tcp_header, SYN);
  conns[conn].sendnext++; /* SYN counts as a byte */

  /* send the initial SYN */
  if (my_ip_send(conns[conn].rip, (char *)&tcp_header,
                 sizeof(tcp_header))==-1) return -1; /* host unreachable */

  printf("tcp_connect(%d): SYN sent\n",conn);
  /* put it in the proper state */
  set_state(conn, SYN_SENT);

  /* wait for state machine to take to ESTAB */
  if (tcp_receive(conn, CONNECT_TIMEOUT, 1)==0) return -1;

  return conn + 1; /* our array is 0 based, conns 1 based */

}

/*=============================================================================
Function tcp_listen

Purpose:  listens on the given local port, returning the connection number
          
Parameters:
    local_IP (IN) - the local IP address for our listen
    local_port (IN) - port to listen on
    *IP_address (IN) - used to pass the connectors IP address
    timeout (IN) - timeout for listen
            
Returns:  connection number if successful and returns IP address in IP_address,
          otherwise returns -1
=============================================================================*/
int tcp_listen(int local_IP, short local_port, int * IP_address, int timeout) {

  int conn;

  my_ip = local_IP; /* set the global IP address to our IP */

  /* see if we have a free connection */
  if ((conn = get_free_connection())==-1) {
    printf("tcp_listen: no free connections\n");
    return -1;
  }

  /* set up the conns fields */
  conns[conn].lport = local_port;
  set_state(conn, LISTEN);

  /* wait for state machine to take to ESTAB */
  if (tcp_receive(conn, timeout, 0)==0) return -1;

  *IP_address = conns[conn].rip; /* passing back the IP of client */

  return conn + 1; /* our array is 0 based, conns 1 based */

}

/*=============================================================================
Function tcp_close

Purpose:  closes the passed in connection
          
Parameters:
    connection (IN) - connection to close
    local_IP (IN) - our local IP address
            
Returns:  nothing, closes the connection
=============================================================================*/
void tcp_close(int connection, int local_IP) {

  struct tcp tcp_header;

  connection--; /* our array is 0 based, conns 1 based */

  /* make sure this is a valid connection */
  if (conns[connection].state==CLOSED) {
    printf("tcp_close: connection %d already in closed state\n",connection);
    return;
  }

  /* create the FIN packet */
  fill_header_conn(connection, &tcp_header, FIN | ACK);
  conns[connection].sendnext++; /* FIN counts as a byte */

  /* send the FIN packet */
  if (my_ip_send(conns[connection].rip, (char *)&tcp_header, 
                 sizeof(tcp_header))==-1) {
    set_state(connection, CLOSED);
    return; /* apparently host unreachable */
  }

  printf("tcp_close(%d): FIN sent\n",connection);
  /* transition to the proper state */
  if (conns[connection].state == CLOSE_WAIT)
    set_state(connection, LAST_ACK);
  else
    set_state(connection, FIN_WAIT1);

  /* wait for state machine to take to CLOSED */
  tcp_receive(connection, INFINITY, 1);

}

/*=============================================================================
Function tcp_init

Purpose:  initializes the tcp layer, used mainly to set up the conns table
          
Parameters: none    
            
Returns:  nothing, initializes tcp
=============================================================================*/
void tcp_init () {

  int i;
  for (i=0;i<MAX_CONNECTIONS;i++) {
    conns[i].prevstate = CLOSED;
    conns[i].state = CLOSED;
    conns[i].recvwnd = 1; /* largest window necessary in this program */
  }

}

/*=============================================================================
Function tcp_receive

Purpose:  attempts to take connection conn to a fruition state of either
          ESTAB or CLOSED
          
Parameters:
    conn (IN) - connection to take to fruition state
    timeout (IN) - timeout for the fruition state to occur in milliseconds
    reset_clock (IN) - determines whether or not clock resets on each correct
                       next packet in the state machine
                       
Returns:  1 if fruition state is ESTAB, 0 if CLOSED
=============================================================================*/
int tcp_receive(int conn, int timeout, int reset_clock) {
  int count, dest_conn, new_timeout, srce_ip;
  struct timeb start_time, curr_time;
  struct tcp tcp_header;

  ftime(&start_time); /* time stamp for timeouts */

  while (1) {

    /* calculate time left before timeout */
    ftime(&curr_time);
    new_timeout = timeout - millidifftime(&start_time,&curr_time);

    /* receive the next packet */
    count = my_ip_receive((char *)&tcp_header, sizeof(tcp_header),
                          (int *)&srce_ip, new_timeout);

    if (count!=sizeof(tcp_header)) {
      if (count==-1) { /* timed out */
        printf("tcp_receive(%d): connection timed out\n",conn);
        set_state(conn, CLOSED);
        return 0;
      }
      continue; /* bad packet ? */
    }

    /* validate the checksum */
    if (cksum((unsigned short *)&tcp_header, count / 2, my_ip, srce_ip)!=0) {
      printf("tcp_receive(%d): checksum failure\n\n",conn);
      continue;
    }

    /* is this an existing connection ? */
    if ((dest_conn = get_connection(&tcp_header,srce_ip))==-1) {
      printf("tcp_receive(%d): segment target not found, sending RST\n",conn);
      if (tcp_header.flags & ACK)
        fill_header(&tcp_header, 0, ntohs(tcp_header.srce_port),
                    ntohl(tcp_header.ack_num), ntohl(tcp_header.seq_num) + 1,
                    RST | ACK, conns[dest_conn].recvwnd, my_ip,
                    conns[dest_conn].rip);
      else
        fill_header(&tcp_header, 0, ntohs(tcp_header.srce_port), 0,
                    ntohl(tcp_header.seq_num) + sizeof(tcp_header), RST | ACK,
                    conns[dest_conn].recvwnd, my_ip,
                    conns[dest_conn].rip);
      my_ip_send(srce_ip, (char *)&tcp_header, sizeof(tcp_header));
      printf("tcp_receive(%d): RST sent for non-existent connection\n\n",conn);
      continue; /* no connection handled */
    }

    /* check for RST packet */
    if (tcp_header.flags & RST) {
      printf("tcp_receive(%d,%d): RST segment received, RST processing...\n",
             conn,dest_conn);
      if (conns[dest_conn].state==LISTEN) continue; /* ignore */
      /* is the RST valid ? */
      if ((conns[dest_conn].state!=SYN_SENT && between(ntohl(tcp_header.seq_num),
          conns[dest_conn].recvnext-1,
          conns[dest_conn].recvnext + conns[dest_conn].recvwnd) ||
          (conns[dest_conn].state==SYN_SENT &&
          ntohl(tcp_header.ack_num)==conns[dest_conn].sendnext))) {
        if ((conns[dest_conn].state==SYN_RCVD) &&
            (conns[dest_conn].prevstate==LISTEN)) {
          set_state(dest_conn, LISTEN);
        } else {
          set_state(dest_conn, CLOSED); /* otherwise abort connection */
          if (dest_conn==conn) return 0;
        }
      }
      continue; /* reset handled */
    }

    /* check to see if the segment is acceptable for non synchronized state */
    if (!synchronized(conns[dest_conn].state) && (tcp_header.flags & ACK) &&
        tcp_header.ack_num!=htonl(conns[dest_conn].sendnext)) {
      printf("tcp_receive(%d,%d): unacceptable ACK for non-synchronized state\n",
             conn,dest_conn);
      /* send RST and stay in same state */
      fill_header(&tcp_header, conns[dest_conn].lport,
                  conns[dest_conn].rport, ntohl(tcp_header.ack_num),
                  ntohl(tcp_header.seq_num) + sizeof(tcp_header), RST | ACK,
                  conns[dest_conn].recvwnd, my_ip,
                  conns[dest_conn].rip);
      my_ip_send(srce_ip, (char *)&tcp_header, sizeof(tcp_header));
      printf("tcp_received(%d,%d): RST sent for unnacceptable ACK\n\n",conn,dest_conn);
      continue; /* and stay in the same state */
    }

    /* check to see if the segment is acceptable for synchronized state */
    if (synchronized(conns[dest_conn].state) &&
        (!between(ntohl(tcp_header.seq_num), conns[dest_conn].recvnext-1,
                  conns[dest_conn].recvnext + conns[dest_conn].recvwnd)  ||
         !between(ntohl(tcp_header.ack_num), conns[dest_conn].senduna-1,
                  conns[dest_conn].sendnext+1))) {
      printf("tcp_receive(%d,%d): unacceptable segment for synchronized state\n",conn,dest_conn);
      /* send empty ACK */
      fill_header_conn(dest_conn, &tcp_header, ACK);
      my_ip_send(srce_ip, (char *)&tcp_header, sizeof(tcp_header));
      printf("tcp_receive(%d,%d): RST sent for unnacceptable ACK\n\n",conn,dest_conn);
      continue; /* and stay in the same state */
    }

    switch (conns[dest_conn].state) {

      case LISTEN:

        if ((tcp_header.flags & ALL_FLAGS) == SYN) {
          printf("tcp_receive(%d,%d): SYN segment received in LISTEN state\n\n",
                 conn,dest_conn);
          /* fill in conns fields from received packet */
          conns[dest_conn].rip = srce_ip;
          conns[dest_conn].rport = ntohs(tcp_header.srce_port);
          conns[dest_conn].recvnext = ntohl(tcp_header.seq_num) + 1;
          conns[dest_conn].sendnext = gen_sequence();
          conns[dest_conn].senduna = conns[dest_conn].sendnext;

          /* create and send SYN + ACK packet */
          fill_header_conn(dest_conn, &tcp_header, SYN | ACK);
          conns[dest_conn].sendnext++; /* SYN counts as a byte */
          if (my_ip_send(conns[dest_conn].rip, (char *)&tcp_header,
                         sizeof(tcp_header))==-1) {
            set_state(dest_conn, CLOSED);
            if (dest_conn==conn) return 0; /* problem with ip_send */
            break;
          }

          printf("tcp_receive(%d,%d): SYN+ACK sent\n",conn,dest_conn);
          set_state(dest_conn, SYN_RCVD);
          /* reset the clock if we are on a per packet timeout */
          if ((dest_conn==conn) && (reset_clock)) ftime(&start_time);
          break;
        }

        break; /* discard segment */

      case SYN_SENT:

        /* is this a SYN + ACK with proper ACK value ? */
        if ((tcp_header.flags & ALL_FLAGS) == (SYN | ACK) &&
            tcp_header.ack_num == htonl(conns[dest_conn].sendnext)) {
          printf("tcp_receive(%d,%d): SYN+ACK segment received in SYN_SENT state\n\n",
                 conn,dest_conn);
          conns[dest_conn].recvnext = ntohl(tcp_header.seq_num)+1;
          conns[dest_conn].senduna = ntohl(tcp_header.ack_num);
    
          /* send the final ACK */
          fill_header_conn(dest_conn, &tcp_header, ACK);
          if (my_ip_send(conns[dest_conn].rip, (char *)&tcp_header,
                         sizeof(tcp_header))==-1) {
            set_state(dest_conn, CLOSED);
            if (dest_conn==conn) return 0; /* problem with ip_send */
            break;
          }

          printf("tcp_receive(%d,%d): ACK sent\n",conn,dest_conn);
          set_state(dest_conn, ESTAB);
          if (dest_conn==conn) return 1;
          break;
        }

        /* is this SYN ? */
        if ((tcp_header.flags & ALL_FLAGS) == SYN) {
          printf("tcp_receive(%d,%d): SYN segment received in SYN_SENT state\n\n",
                 conn,dest_conn);
          conns[dest_conn].recvnext = ntohl(tcp_header.seq_num)+1;
      
          /* send the ACK */
          fill_header_conn(dest_conn, &tcp_header, ACK);
          if (my_ip_send(conns[dest_conn].rip, (char *)&tcp_header,
                         sizeof(tcp_header))==-1) {
            set_state(dest_conn, CLOSED);
            if (dest_conn==conn) return 0; /* problem with ip_send */
            break;
          }

          printf("tcp_receive(%d,%d): ACK sent\n",conn,dest_conn);
          set_state(dest_conn, SYN_RCVD);
          if ((dest_conn==conn) && (reset_clock)) ftime(&start_time);
          break;
        }

        break; /* discard segment */

      case SYN_RCVD:

        /* is this the ACK with proper ACK value ? */
        if ((tcp_header.flags & ALL_FLAGS) == ACK &&
            tcp_header.ack_num == htonl(conns[dest_conn].sendnext)) {
          printf("tcp_receive(%d,%d): ACK segment received in SYN_RCVD state\n",
                 conn,dest_conn);
          conns[dest_conn].senduna = ntohl(tcp_header.ack_num);
          set_state(dest_conn, ESTAB);
          if (dest_conn==conn) return 1;
          break;
        }

        break; /* discard segment */

      case ESTAB:

        /* is this FIN ? */
        if ((tcp_header.flags & ALL_FLAGS) == (FIN | ACK) &&
            tcp_header.ack_num == htonl(conns[dest_conn].senduna)) {
          printf("tcp_receive(%d,%d): FIN segment received in ESTAB state\n\n",
                 conn,dest_conn);
          conns[dest_conn].recvnext++;

          /* send the ACK */
          fill_header_conn(dest_conn, &tcp_header, ACK);
          if (my_ip_send(conns[dest_conn].rip, (char *)&tcp_header,
                         sizeof(tcp_header))==-1) {
            set_state(dest_conn, CLOSED);
            if (dest_conn==conn) return 0; /* problem with ip_send */
            break;
          }

          printf("tcp_receive(%d,%d): ACK sent\n",conn,dest_conn);
          set_state(dest_conn, CLOSE_WAIT);
          /* reset the clock if we are on a per packet timeout */
          if ((dest_conn==conn) && (reset_clock)) ftime(&start_time);
          break;
        }

        break; /* discard segment */

      case FIN_WAIT1:

        /* is this FIN + ACK with proper ACK value ? */
        if ((tcp_header.flags & ALL_FLAGS) == (FIN | ACK) &&
            tcp_header.ack_num == htonl(conns[dest_conn].sendnext)) {
          printf("tcp_receive(%d,%d): FIN+ACK segment received in FIN_WAIT1 state\n\n",
                 conn,dest_conn);
          conns[dest_conn].recvnext++;
          conns[dest_conn].senduna = ntohl(tcp_header.ack_num);
    
          /* send the final ACK */
          fill_header_conn(dest_conn, &tcp_header, ACK);
          if (my_ip_send(conns[dest_conn].rip, (char *)&tcp_header,
                         sizeof(tcp_header))==-1) {
            set_state(dest_conn, CLOSED);
            if (dest_conn==conn) return 0; /* problem with ip_send */
            break;
          }

          printf("tcp_receive(%d,%d): ACK sent\n",conn,dest_conn);
          set_state(dest_conn, TIME_WAIT);
          sleep(TIME_WAIT_SLEEP);
          set_state(dest_conn, CLOSED);
          if (dest_conn==conn) return 0;
          break;
        }

        /* is this FIN ? */
        if ((tcp_header.flags & ALL_FLAGS) == (FIN | ACK) &&
            tcp_header.ack_num == htonl(conns[dest_conn].senduna)) {
          printf("tcp_receive(%d,%d): FIN segment received in FIN_WAIT1 state\n\n",
                 conn,dest_conn);
          conns[dest_conn].recvnext++;

          /* send the ACK */
          fill_header_conn(dest_conn, &tcp_header, ACK);
          if (my_ip_send(conns[dest_conn].rip, (char *)&tcp_header,
                         sizeof(tcp_header))==-1) {
            set_state(dest_conn, CLOSED);
            if (dest_conn==conn) return 0; /* problem with ip_send */
            break;
          }

          printf("tcp_receive(%d,%d): ACK sent\n",conn,dest_conn);
          set_state(dest_conn, CLOSING);
          /* reset the clock if we are on a per packet timeout */
          if ((dest_conn==conn) && (reset_clock)) ftime(&start_time);
          break;
        }

        /* is this ACK with proper ACK value ? */
        if ((tcp_header.flags & ALL_FLAGS) == ACK &&
            tcp_header.ack_num == htonl(conns[dest_conn].sendnext)) {
          printf("tcp_receive(%d,%d): ACK segment received in FIN_WAIT1 state\n",
                 conn,dest_conn);
          conns[dest_conn].senduna = ntohl(tcp_header.ack_num);
          set_state(dest_conn, FIN_WAIT2);
          if ((dest_conn==conn) && (reset_clock)) ftime(&start_time);
          break;
        }

        break; /* discard segment */

      case FIN_WAIT2:

        /* is this FIN ? */
        if ((tcp_header.flags & ALL_FLAGS) == (FIN | ACK) &&
            tcp_header.ack_num == htonl(conns[dest_conn].sendnext)) {
          printf("tcp_receive(%d,%d): FIN segment received in FIN_WAIT2 state\n\n",
                 conn,dest_conn);
          conns[dest_conn].recvnext++;

          /* send the ACK */
          fill_header_conn(dest_conn, &tcp_header, ACK);
          if (my_ip_send(conns[dest_conn].rip, (char *)&tcp_header,
                         sizeof(tcp_header))==-1) {
            set_state(dest_conn, CLOSED);
            if (dest_conn==conn) return 0; /* problem with ip_send */
            break;
          }

          printf("tcp_receive(%d,%d): ACK sent\n",conn,dest_conn);
          set_state(dest_conn, TIME_WAIT);
          sleep(TIME_WAIT_SLEEP);
          set_state(dest_conn, CLOSED);
          if (dest_conn==conn) return 0;

          break;

        }

        break; /* discard segment */

      case CLOSING:

        /* is this ACK with proper ACK value ? */
        if ((tcp_header.flags & ALL_FLAGS) == ACK &&
            tcp_header.ack_num == htonl(conns[dest_conn].sendnext)) {
          printf("tcp_receive(%d,%d): ACK segment received in CLOSING state\n\n",
                 conn,dest_conn);
          conns[dest_conn].senduna = ntohl(tcp_header.ack_num);
          set_state(dest_conn, TIME_WAIT);
          sleep(TIME_WAIT_SLEEP);
          set_state(dest_conn, CLOSED);
          if (dest_conn==conn) return 0;
          break;
        }

        break; /* discard segment */

      case LAST_ACK:

        /* is this ACK with proper ACK value ? */
        if ((tcp_header.flags & ALL_FLAGS) == ACK &&
            tcp_header.ack_num == htonl(conns[dest_conn].sendnext)) {
          printf("tcp_receive(%d,%d): ACK segment received in LAST_ACK state\n\n",
                 conn,dest_conn);
          conns[dest_conn].senduna = ntohl(tcp_header.ack_num);
          set_state(dest_conn, CLOSED);
          if (dest_conn==conn) return 0;
          break;
        }

        break; /* discard segment */

      default:

        printf("tcp_receive(%d,%d): problem, unrecognized state\n\n",conn,dest_conn);

    }

  }

}
