/*=============================================================================
Assignment: Project 3, mytcp
Author:     David Burger, Warren Lam, Kin Lik Wang
Language:   ANSI C running on UHUNIX2 (Solaris)
Compile:    by running "make" with included makefile
Class:      ICS 451
Instructor: Edo Biagioni
Due Date:   Dec. 09, 2001
===============================================================================
File:         mytcp.c
Description:  This file contains the main entry point to the program.  This
              program sends and receives data by simulating the TCP protocol
              over UPP.  It spawns sender, receiver, and resender threads to
              control the tcp process.
              
Exceution:    mytcp payload lport host rport [error rate]

              payload      - number of bytes to send, if negative this process
                             starts in a wait state
              lport        - the port this process listens on
              host         - the host we will send the data to
              rport        - the port on the remote host to send data to
              [error rate] - optional paramter that sets the percent of dropped
                             or duplicated packets out of 100.  If not supplied
                             0 is used.              
=============================================================================*/

#include <stdio.h>
#include <string.h>
#include <pthread.h>
#include <signal.h>

/* networking includes */
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>

#include "mytcp.h"

/* uncomment to get tcpdump like output */
/* #define VERBOSE */
/* uncomment to include checksum calculations */
/* #define CHECKSUM */

/* program constants */
#define MAX_WINDOW 500
#define MAX_PAYLOAD 0xFFFFFFFF
#define MIN_PORT 1025
#define MAX_PORT 65535
#define MAX_ERR_RATE 100
#define RT_TIMEOUT 2000 /* in milli-seconds */
#define MSS 53
#define MAX_PACKET MSS + sizeof(struct tcp)
#define MAX_BYPASS 50 /* used to control flooding in sender */
#define T 1
#define F 0

#define min(X, Y)  ((X) < (Y) ? (X) : (Y))
#define max(X, Y)  ((X) > (Y) ? (X) : (Y))

/* used to pass the command line paramters to our threads */
struct commandline {
  UL payload_size;
  int lport;
  char *remote_host;
  int rport;
  int err_rate;
};

/* global variables shared among threads */
UL sendnext; /* the next sequence number I am going to send */
UL senduna;  /* the oldest unacknowledged sequence number */
UL sendstop; /* the first sequence number not to send to remote */
US recvwind; /* my window size */
UL recvnext; /* the next sequence number I expect from the remote */

pthread_mutex_t *window_mut; /* a mutex for protecting window information */
pthread_mutex_t *resendlist_mut; /* a mutex for protecting resend list */

struct list *resendlist; /* list to hold packets our waiting for acks */
struct list *inlist; /* list to hold packets received out of order */

char window_buff[MAX_WINDOW]; /* the window buffer */

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
int between(UL a, UL b, UL c) {
  if (b<=c)
    return a>b && a<c;
  else
    return a>b || a<c;
}

/*=============================================================================
Function millidifftime

Purpose:  determines the millisecond time difference between two timeb's
          
Parameters:
    *older (IN) - older timeb
    *newer (IN) - newer timeb
        
Returns:  the millisecond difference between the newer and older timeb's
=============================================================================*/
UL millidifftime(struct timeb *older, struct timeb *newer) {
  return 1000*(newer->time - older->time) + (newer->millitm - older->millitm);
}

/*=============================================================================
Function list_verify_ack

Purpose:  removes the packetentries that are acked
          
Parameters:
    *l (IN) - list that contains the packetentry structures
    ack (IN) - ack # of packet
        
Returns:  nothing, the function iterates through the removing the acked packet
=============================================================================*/
void list_verify_ack(struct list *l, UL ack) {
  struct node *curr;
  struct tcp_packetentry *pe;
  struct tcp_packetentry *tpe = NULL; /* temporary packet entry */
  if (l->size>0) {
    curr = l->head->next;
    while (curr!=l->tail) {
      pe = (struct tcp_packetentry *)curr->data;
      if (pe->ver_ack==ack) {
        /* the packets were inserted in order sent...remove front to current */
        do {
          if (tpe!=NULL) packetentry_free(tpe);
          tpe = list_remove_front(l);
        } while (tpe!=pe);
        packetentry_free(pe);
        return;
      }
      curr = curr->next;
    }
  }
  pthread_mutex_lock(window_mut);
  if (l->size==0)
    senduna = sendnext;
  else {
    pe = (struct tcp_packetentry *)l->head->next;
    senduna = ntohl(pe->tcp_header->seq_num);
  }
  pthread_mutex_unlock(window_mut);
}

/*=============================================================================
Function list_contains_packet
Purpose:  determines whether or not the list contains a packet with the given
          sequence number

Parameters:
     *l (IN)      - list containing packetentry data
     seq_num (IN) - the sequence number we are trying to locate

Returns:  true if packet with given sequence number is found, otherwise false
=============================================================================*/
int list_contains_packet(struct list *l, UL seq_num) {
  struct node *curr;
  struct tcp_packetentry *pe;
  if (l->size>0) {
    curr = l->head->next;
    while (curr!=l->tail) {
      pe = (struct tcp_packetentry *)curr->data;
      if (ntohl(pe->tcp_header->seq_num)==seq_num) return T;
      curr = curr->next;
    }
  }
  return F;
}

/*=============================================================================
Function handlePacket
Purpose:  This function is the workhorse for dealing with incoming packets.
          It handles acking sent packets, getting data from incoming packets
          and placing it in the window_buff, and recylcing packets received
          out of order.  This function is called by the receiver thread.

Parameters:
     *buff (IN) - buffer containing packet data
     size (IN) - size of incoming packet in buff

Returns:  nothing, packet is handled according to its contents
=============================================================================*/
void handlePacket(char *buff, int size) {
  struct tcp *tcp_header = (struct tcp *)buff; /* point at header part */
  char *payload = buff+sizeof(struct tcp); /* point at data part */
  int payload_size = size - sizeof(struct tcp);
  struct node *curr;
  struct node *temp;
  struct tcp_packetentry *pe;
  US chk_sum;
  char *p; /* used to point at window_buff */
  int window_used;
  int window_left;
  int foundone = T;
  #ifdef VERBOSE
    printTCPHeader(T,tcp_header,size-sizeof(struct tcp));
  #endif    
  /* see if this packet will verify some of our sent packets */
  pthread_mutex_lock(window_mut);
  if (between(ntohl(tcp_header->ack_num),senduna,sendnext+1)) { /* unacked range */
    pthread_mutex_unlock(window_mut);
    pthread_mutex_lock(resendlist_mut);
    list_verify_ack(resendlist,ntohl(tcp_header->ack_num));
    pthread_mutex_unlock(resendlist_mut);
  } else {
    pthread_mutex_unlock(window_mut);
  }

  /* now we check to see if the packet is the correct next packet */
  if (ntohl(tcp_header->seq_num)==recvnext && payload_size<=recvwind) {
    p = window_buff + (MAX_WINDOW - recvwind); /* point at insertion point */
    memcpy(p,payload,payload_size); /* copy the new data to the buffer */

    /* adjust the window variables */
    pthread_mutex_lock(window_mut);
    recvwind-=payload_size;
    sendstop = ntohl(tcp_header->ack_num) + ntohs(tcp_header->window);
    recvnext = ntohl(tcp_header->seq_num) + payload_size;
    pthread_mutex_unlock(window_mut);

    /* here we try to use the packets received out of order in inlist */
    while (inlist->size>0 && foundone) {
      foundone = F;
      curr = inlist->head->next;
      while (curr!=inlist->tail) {
        pe = (struct tcp_packetentry *)curr->data;
        payload_size = pe->size - sizeof(struct tcp);
        if (ntohl(pe->tcp_header->seq_num)==recvnext && payload_size<=recvwind) {
          foundone = T; /* it is "next," make it loop again */
          /* point at the insertion point */
          p = window_buff + (MAX_WINDOW - recvwind); /* point at insertion */
          memcpy(p,pe->payload,payload_size); /* copy data to window_buff */
          /* adjust the window variables */
          pthread_mutex_lock(window_mut);
          recvwind-=payload_size;
          sendstop = ntohl(pe->tcp_header->ack_num) + ntohs(pe->tcp_header->window);
          recvnext = ntohl(pe->tcp_header->seq_num) + payload_size;
          pthread_mutex_unlock(window_mut);
          /* remove this packet from the inlist */
          curr->prev->next = curr->next;
          curr->next->prev = curr->prev;
          temp = curr;
          curr = curr->next;
          packetentry_free(pe);
          free(temp);
          inlist->size--;
        } else if (between(ntohl(pe->tcp_header->seq_num),recvnext-1,recvnext+recvwind) &&
             between(ntohl(pe->tcp_header->seq_num)+payload_size-1,recvnext-1,recvnext+recvwind)) {
          curr = curr->next; /* packet is in the current window, keep it */
        } else {
          /* packet is no longer in the current window, remove packet, sending side is flawed */
         #ifdef VERBOSE
            printf("Discarding packet %08x from inlist, no longer in window.\n",ntohl(pe->tcp_header->seq_num));
         #endif
          curr->prev->next = curr->next;
          curr->next->prev = curr->prev;
          temp = curr;
          curr = curr->next;
          packetentry_free(pe);
          free(temp);
          inlist->size--;
        }
      }
    }

    /* in the above we need to boot out packets that are in the inlist but */
    /* no longer in the receive window...this will only happen if the other*/
    /* end has a faulty tcp implementation */

    /* search for the \n in the newly arrived data */
    p = memchr(window_buff,'\n', MAX_WINDOW - recvwind);
    while (p!=NULL) {
      *p = 0; /* replace the \n with a null terminator */
      printf("%s\n",window_buff); /* print out the line */
      window_used = (p - window_buff) + 1; /* + 1 for the /n itself */
      window_left = MAX_WINDOW - recvwind - window_used;
      memmove(window_buff,p+1,window_left); /* adjust the data over */
      /* adjust the window variables */
      pthread_mutex_lock(window_mut);
      recvwind+=window_used;
      pthread_mutex_unlock(window_mut);
      /* search for another \n in the data */
      p = memchr(window_buff,'\n',window_left);
    }
  } else if (between(ntohl(tcp_header->seq_num),recvnext-1,recvnext+recvwind) &&
             between(ntohl(tcp_header->seq_num)+payload_size-1,recvnext-1,recvnext+recvwind)) {
    /* it falls in the current receive window but it is not next */
    if (payload_size>0 && !list_contains_packet(inlist,ntohl(tcp_header->seq_num))) {
      list_insert_back(inlist,packetentry_init(tcp_header,payload,payload_size));
    }
  }
}

/*=============================================================================
Function resender

Purpose:  resends packets from packetentries in the list that have timed out
          
Parameters:
    *p (IN) - void ptr to commandline data containing command line parameters
        
Returns:  nothing, function resends packets that have timed out
=============================================================================*/
void *resender(void *p) {
  struct commandline *params = (struct commandline *)p;

  struct sockaddr_in dad; /* destination sockaddr */
  struct hostent *ptrh;   /* pointer to a host table entry */
  struct protoent *ptrp;  /* pointer to protocol table entry */
  int sd; /* socket descriptor */

  struct node *curr;
  struct tcp_packetentry *pe;

  struct timeb currtb;
  UL currmilli; /* millisecond age of current packet */
  UL oldestmilli; /* millisecond age of oldest packet */

  /* set up the dad structure */
  memset((char *)&dad,0,sizeof(dad)); /* clear the sockaddr structure */
  dad.sin_family = AF_INET;           /* family is internet           */
  dad.sin_port = htons(params->rport);

  ptrh = gethostbyname(params->remote_host);
  if (ptrh==NULL) {
    fprintf(stderr,"Remote host %s is invalid.\n",params->remote_host);
    exit(1);
  }
  memcpy (&dad.sin_addr, ptrh->h_addr, ptrh->h_length);

  /* map the udp transport protocol name to protocol number */
  if (((int)(ptrp = getprotobyname("udp"))) == 0) {
    fprintf(stderr,"Unable to map udp to protocol number.\n");
    exit(1);
  }

  /* attempt to create the socket */
  if ((sd = socket(AF_INET, SOCK_DGRAM, ptrp->p_proto)) < 0) {
    fprintf(stderr,"An error occured creating the socket.\n");
    exit(1);
  }

  while (1) {
    pthread_mutex_lock(resendlist_mut);
    oldestmilli = 0;
    if (resendlist->size>0) {
      ftime(&currtb);
      curr = resendlist->head->next;
      while (curr!=resendlist->tail) {
        pe = (struct tcp_packetentry *)curr->data;
        if ((currmilli=millidifftime(pe->tb,&currtb))>=RT_TIMEOUT) {
          /* random error problems determined here */
          if ((random() % 100) < params->err_rate) {
            #ifdef VERBOSE
              printf("Packet %08x prepared but not resent.\n",ntohl(pe->tcp_header->seq_num));
            #endif
          } else {
            sendto(sd, pe->packet, pe->size, 0,(struct sockaddr *)(&dad), sizeof(dad));
            #ifdef VERBOSE
              printTCPHeader(F,pe->tcp_header,pe->size-sizeof(struct tcp));
            #endif
            if ((random() % 100) < params->err_rate) {
              /* send it twice */
              sendto(sd, pe->packet, pe->size, 0,(struct sockaddr *)(&dad), sizeof(dad));            
              #ifdef VERBOSE
                printTCPHeader(F,pe->tcp_header,pe->size-sizeof(struct tcp));
              #endif
            }
          }
          ftime(pe->tb); /* update the time stamp */          
        } else {
          /* not resent on this iteration, check for age to determine sleep time */
          oldestmilli = max(currmilli,oldestmilli);
        }
        curr = curr->next;
      }
      pthread_mutex_unlock(resendlist_mut);
    } else {
      pthread_mutex_unlock(resendlist_mut);
    }
    usleep(1000*(RT_TIMEOUT-oldestmilli));
  }
}

/*=============================================================================
Function sender

Purpose:  sends the data to the remote host based upon payload left to send
          and the window of the receiver
          
Parameters:
    *p (IN) - void ptr to commandline data containing command line parameters
        
Returns:  nothing, function sends the data to the remote host
=============================================================================*/
void *sender(void *p) {
  struct commandline *params = (struct commandline *)p;

  struct sockaddr_in dad; /* destination sockaddr */
  struct hostent *ptrh;   /* pointer to a host table entry */
  struct protoent *ptrp;  /* pointer to protocol table entry */

  int payload_size; /* size of payload to send */
  int sd; /* socket descriptor */

  struct tcp tcp_header;
  struct tcp_packetentry *pe;

  char payload[MSS]; /* buffer for payload */

  char buff[sizeof(struct tcp)+MSS]; /* buffer for sending */

  UL lastack=0;
  int bypasscnt=MAX_BYPASS;

  memset((char *)&dad,0,sizeof(dad)); /* clear the sockaddr structure */
  dad.sin_family = AF_INET;           /* family is internet           */
  dad.sin_port = htons(params->rport);

  ptrh = gethostbyname(params->remote_host);
  if (ptrh==NULL) {
    fprintf(stderr,"Remote host %s is invalid.\n",params->remote_host);
    exit(1);
  }
  memcpy (&dad.sin_addr, ptrh->h_addr, ptrh->h_length);

  /* map the udp transport protocol name to protocol number */
  if (((int)(ptrp = getprotobyname("udp"))) == 0) {
    fprintf(stderr,"Unable to map udp to protocol number.\n");
    exit(1);
  }

  /* attempt to create the socket */
  if ((sd = socket(AF_INET, SOCK_DGRAM, ptrp->p_proto)) < 0) {
    fprintf(stderr,"An error occured creating the socket.\n");
    exit(1);
  }

  /* set up the tcp header fields that never change */
  tcp_header.srce_port = htons(0); /* params->lport; */
  tcp_header.dest_port = htons(0); /* params->rport; */
  tcp_header.offset = 0x50;
  tcp_header.flags = 0x10; /* ack bit */
  tcp_header.urg_pntr = htons(0);
  while (1) {
    pthread_mutex_lock(window_mut);
    /* set up the tcp header fields for the next packet */
    tcp_header.seq_num = htonl(sendnext);
    tcp_header.ack_num = htonl(recvnext);
    tcp_header.window = htons(recvwind);
    tcp_header.chk_sum = htons(0); /* zero out for checksum computation */

    /* find out how much data to send in the next packet */
    if (sendnext<=sendstop)
      payload_size = min(sendstop - sendnext,MSS);
    else
      payload_size = min(0xffffffff - sendnext + sendstop,MSS);  /* rollover */
    payload_size = min(payload_size,params->payload_size);
    pthread_mutex_unlock(window_mut);

    if (payload_size>0) fillData(payload,payload_size);

    /* set up the packet and a packetentry to wait for the ack */
    pe = packetentry_init(&tcp_header,payload,payload_size);

    #ifdef CHECKSUM
      pe->tcp_header->chk_sum = htons(checksum(pe->packet,pe->size));
    #endif

    if (payload_size==0 && lastack==ntohl(pe->tcp_header->ack_num) && bypasscnt<MAX_BYPASS) {
      /* nothing to send, don't flood the remote with empty acks */
      bypasscnt++; /* keeps track of how many times to bypass via MAX_BYPASS */
      usleep(1); /* to make sure we don't lock out the receiver thread */
    } else {
      /* do our random drop packet test */
      if ((random() % 100) < params->err_rate) {
        #ifdef VERBOSE
          printf("Packet %08x prepared but not sent.\n",ntohl(pe->tcp_header->seq_num));
	      #endif
      } else {
        sendto(sd, pe->packet, pe->size, 0,(struct sockaddr *)(&dad), sizeof(dad));
        #ifdef VERBOSE
          printTCPHeader(F,pe->tcp_header,payload_size);
        #endif
        if ((random() % 100) < params->err_rate) {
          /* send it twice */
          sendto(sd, pe->packet, pe->size, 0,(struct sockaddr *)(&dad), sizeof(dad));
          #ifdef VERBOSE
            printTCPHeader(F,pe->tcp_header,payload_size);
          #endif
        }
      }
      bypasscnt=0;
      lastack=ntohl(pe->tcp_header->ack_num);
    }

    if (payload_size>0) {
      pthread_mutex_lock(resendlist_mut);
      list_insert_back(resendlist, pe);
      pthread_mutex_unlock(resendlist_mut);
      params->payload_size-=payload_size; /* decrement payload left to send */
      pthread_mutex_lock(window_mut);
      sendnext+=payload_size; /* set up the new sequence number */
      pthread_mutex_unlock(window_mut);
    } else {
      /* with no payload we don't need to be acked so we don't add to list */
      packetentry_free(pe);
    }
  }
}

/*=============================================================================
Function receiver

Purpose:  receives data from the remote host
          
Parameters:
    *p (IN) - void ptr to commandline data containing command line parameters
        
Returns:  nothing, valid packets are sent to handlePacket for processing
=============================================================================*/
void *receiver(void *p) {
  struct commandline *params = (struct commandline *)p;

  int addlen; /* length of client address */
  int cnt; /* number of bytes read */
  char buff[MAX_PACKET]; /* buffer for receiving data over tcp */

  struct sockaddr_in sad; /* server sockaddr */
  struct sockaddr_in cad; /* client sockaddr */
  struct protoent *ptrp;  /* pointer to protocol table entry */

  int sd; /* socket descriptor */
  char *data; /* used to point at the data portion of the incoming packet */

  memset((char *)&sad,0,sizeof(sad)); /* clear the sockaddr structure */
  sad.sin_family = AF_INET;           /* family is internet           */
  sad.sin_addr.s_addr = INADDR_ANY;   /* set the local IP address     */

  sad.sin_port = htons((u_short)params->lport); /* the port we listen on */

  /* map the udp transport protocol name to protocol number */
  if (((int)(ptrp = getprotobyname("udp"))) == 0) {
    fprintf(stderr,"Unable to map udp to protocol number.\n");
    exit(1);
  }

  /* attempt to create the socket */
  if ((sd = socket(AF_INET, SOCK_DGRAM, ptrp->p_proto)) < 0) {
    fprintf(stderr,"An error occured creating the socket.\n");
    exit(1);
  }

  /* try to bind to a chosen port */
  if (bind(sd, (struct sockaddr *)&sad, sizeof(sad)) < 0) {
    fprintf(stderr,"An error occured binding to port %d.\n",params->lport);
    close(sd);
    exit(1);
  }

  while (1) {
    addlen = sizeof(cad);
    /* tuck it */
    if ((cnt = recvfrom(sd, buff, MAX_PACKET, 0,(struct sockaddr *) &cad, &addlen))>=sizeof(struct tcp)) {
      handlePacket(buff, cnt);
    } else {
      printf("Invalid packet of size %d received.\n",cnt);
    }
  }

}

int main(int argc, char *argv[]) {
  struct commandline params;
  int initiate; /* keeps track of if we initiate the exhange */
  char *p; /* used in string conversions/manipulations */

  pthread_t sender_pt, receiver_pt, resender_pt;

  /* ignore SIGALRM during usleep */
  signal(SIGALRM, SIG_IGN);

  /* check to see if required command line parameters are in place */
  if (argc<5) {
    fprintf(stderr,"Proper usage is %s payload lport host rport [error rate]\n",argv[0]);
    fprintf(stderr,"payload = packet payload size\n");
    fprintf(stderr,"lport = port to listen on\n");
    fprintf(stderr,"host = host to send packets to\n");
    fprintf(stderr,"rport = port to send to\n");
    fprintf(stderr,"[error rate] - number of packets to drop and duplicate out of 100\n");
    exit(1);
  }

  /* retrieve payload size from command line parameters */
  initiate = (*argv[1]!='-');
  if (!initiate) argv[1]++;

  params.payload_size = strtol(argv[1],&p,0);
  /* should we check payload_size = 0 and initiates...won't work */
  if (p==argv[1] || params.payload_size> MAX_PAYLOAD) {
    fprintf(stderr,"Payload size %s is invalid.\n",argv[1]);
    exit(1);
  }

  /* now the local port from the command line parameters */
  params.lport = strtol(argv[2],&p,0);
  if (p==argv[2] || (params.lport<-1*MAX_PORT || params.lport>MAX_PORT)
      || (params.lport>-1*MIN_PORT && params.lport<MIN_PORT)) {
    fprintf(stderr,"Port %s is invalid.\n",argv[2]);
    exit(1);
  }

  /* set a pointer to the host */
  params.remote_host = argv[3];

  /* now the local port from the command line parameters */
  params.rport = strtol(argv[4],&p,0);
  if (p==argv[4] || (params.lport<-1*MAX_PORT || params.lport>MAX_PORT)
      || (params.lport>-1*MIN_PORT && params.lport<MIN_PORT)) {
    fprintf(stderr,"Port %s is invalid.\n",argv[4]);
    exit(1);
  }

  /* now the optional command line parameter error rate, not present then 0 */
  params.err_rate = 0;
  if (argc>5) {
    params.err_rate = strtol(argv[5],&p,0);
    if (p==argv[5] || params.err_rate<0 || params.err_rate>MAX_ERR_RATE) {
      fprintf(stderr,"Error rate %s is invalid.\n",argv[5]);
      exit(1);
    }
  }

  /* init. packet list structure that keeps track of packs waiting for acks */
  resendlist = list_init();
  /* and list structure that keeps track of packets received out of order */
  inlist = list_init();

  /* set up global variables dealing with windows */
  recvwind = MAX_WINDOW;
  if (initiate) {
    senduna = sendnext = 0xFEDCBA98;
    sendstop = sendnext + MAX_WINDOW; /* start as a sender */
    recvnext = 0x12345678;
  } else {
    senduna = sendnext = 0x12345678;
    sendstop = sendnext; /* closed remote window...waiting for ack */
    recvnext = 0xFEDCBA98;
  }

  window_mut = (pthread_mutex_t *)malloc(sizeof(pthread_mutex_t));
  pthread_mutex_init(window_mut,NULL);

  resendlist_mut = (pthread_mutex_t *)malloc(sizeof(pthread_mutex_t));
  pthread_mutex_init(resendlist_mut,NULL);

  /* create receiver thread */
  if (pthread_create(&receiver_pt,NULL,receiver,&params)!=0) {
    fprintf(stderr,"Unable to create receiver thread.\n");
    exit(1);
  }

  /* create sender thread */
  if (pthread_create(&sender_pt,NULL,sender,&params)!=0) {
    fprintf(stderr,"Unable to create sender thread.\n");
    exit(1);
  }

  /* create the resender thread */
  if (pthread_create(&resender_pt,NULL,resender,&params)!=0) {
    fprintf(stderr,"Unable to create resender thread.\n");
    exit(1);
  }

  pthread_join(receiver_pt,NULL); /* join a thread to keep it running */

}
