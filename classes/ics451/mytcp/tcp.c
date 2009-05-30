/*=============================================================================
Assignment: Project 3, mytcp
Author:     David Burger, Warren Lam, Kin Lik Wang
Language:   ANSI C running on UHUNIX2 (Solaris)
Compile:    by running "make" with included makefile
Class:      ICS 451
Instructor: Edo Biagioni
Due Date:   Dec. 09, 2001
===============================================================================
File:         tcp.c
Description:  This file contains functions for working with a tcp headers and
              packetentries.
=============================================================================*/

#include <stdio.h>
#include "mytcp.h"

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
  if (in) {
    printf("remote.%d > local.%d:",ntohs(tcp_header->srce_port),ntohs(tcp_header->dest_port));
  } else {
    printf("local.%d > remote.%d:",ntohs(tcp_header->srce_port),ntohs(tcp_header->dest_port));
  }
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
Function packetentry_init
Purpose:  creates a new tcp_packetentry structure and returns a pointer to it

Parameters:
     *tcp_header (IN) - the header to stick in the packet
     *payload (IN) - the payload to stick in the packet
     payload_size (IN) - the size of the payload

Returns:  a pointer to a new tcp_packetentry structure
=============================================================================*/
struct tcp_packetentry *packetentry_init(struct tcp *tcp_header, char *payload,
                                         int payload_size) {
  int header_size = sizeof(struct tcp);
  struct tcp_packetentry *pe =
  (struct tcp_packetentry *)malloc(sizeof(struct tcp_packetentry));
  pe->packet = (char *)malloc(header_size+payload_size);
  memcpy(pe->packet,tcp_header,sizeof(struct tcp));
  memcpy(pe->packet+sizeof(struct tcp),payload,payload_size);
  pe->tcp_header = (struct tcp *)pe->packet;
  pe->payload = pe->packet + header_size;
  pe->size = header_size+payload_size;
  pe->tb = (struct timeb *)malloc(sizeof(struct timeb));
  ftime(pe->tb);
  pe->ver_ack = ntohl(tcp_header->seq_num) + payload_size;
  return pe;
}

/*=============================================================================
Function packetentry_free

Purpose:  frees a packetentry and the memory associated with a packetentry
          
Parameters:
    *p (IN) - a pointer to the packetentry to free
        
Returns:  nothing, the memory associated is freed
=============================================================================*/
void packetentry_free(struct tcp_packetentry *p) {
  if (p->packet!=NULL) free(p->packet);
  if (p->tb!=NULL) free(p->tb);
  free(p);
}

/*=============================================================================
Function checksum16

Purpose:  creates 16 bit checksums
          
Parameters:
    *data  (IN) - a pointer to the data in a char buffer
    length (IN) - length of the data passed in
    chk (IN)    - a "carry" check sum
        
Returns:  the 16 bit checksum for the data and the carry

NOTE:
US chk can be used to chain these together to get checksums of data that
aren't contiguous...ie psuedo headers.  Be careful when chaining because
only one of your segments should be odd, and that should be the inner-
most call of the chain....call like this:

US chk = checksum16(psuedoheader,psuedoheader lenght,checksum16(packet,packet length, 0);
=============================================================================*/
US checksum16(char *data, int length, US chk) {
  UL sum = 0; /* to hold the checksum */
  US *high = (US *)&sum; /* points at the high word to add back in for carries */
  US *p = (US *)data; /* points at the next word */
  char *b; /* used to point at the final byte if one is left over */
  US last; /* used to manipulate the final byte if one is left over */
  while (length>1) {
    sum+=*p++; /* add the next word */
    sum+=*high; /* add in a possible carry */
    *high = 0; /* blank out the carry */
    length -= 2;
  }
  if (length==1) {
    b = (char *)p; /* point at the final byte */
    last = *b<<8; /* pad on the right with zeros */
    sum+=last; /* add it in */
    sum+=*high; /* add in possible carry */
  }
  sum+=chk;
  sum+=*high;
  *high = 0xffff;
  return ~sum;
}
