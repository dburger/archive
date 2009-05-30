/*=============================================================================
Assignment: Project 2, a Learning Bridge
Author:     David Burger, Bruce Harris, Michael Miranda
Language:   ANSI C running on UHUNIX2 (Solaris)
Compile:    by running "make" with included makefile

Class:      ICS 451
Instructor: Edo Biagioni
Due Date:   Oct. 26, 2001
===============================================================================
File:         bridge.c

Description:  This program functions as a virtual learning bridge.  It is
              invoked by passing it parameters in the form of:
              
              localport:remoteip:remoteport
              
              It can accept up to 20 of these paramters to simulate listening
              on 20 interfaces.  localport is the local port number a particular
              interface will listen on.  remoteip is the IP address of the
              system connected to this interface and remoteport is the port
              that the connected system is listening on.
              
              After the program is invoked it will function as a learning
              bridge, waiting for incoming packets and handling them
              appropriately.  Packets for unknown hosts and broadcast packets
              will be sent out on all but the incoming interface.  A host table
              is kept in the form of a hash table with chaining in the form of
              a doubly linked list.  Known hosts will be identified in this
              table so that packets bound for that host can be sent only on
              that interface.  Host entries in the host table will be removed
              after 60 seconds with no further packets from the host.
=============================================================================*/
#include <stdio.h>
#include <string.h>

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>

#include <errno.h>
#include <pthread.h>

#include "bridge.h"

#define ETHSIZE 1514       /* maximum size ethernet */
#define MIN_PORT 1025
#define MAX_PORT 0xffff
#define MAX_QUEUE_SIZE 10  /* outgoing queue for interface */
#define EXPIRE_TIME 60     /* expiration for host entry */
#define MAX_IFACE 20       /* maximum # interfaces for this bridge */
#define HOST_TAB_SIZE 101  /* num entries in host hash table */

/* global data about interfaces on this bridge */
struct interface iface[MAX_IFACE]; /* interfaces */
int ifacecnt = 0; /* number of interfaces */
pthread_mutex_t *hostmut; /* a mutex for protecting the host table */
struct list *hosttab[HOST_TAB_SIZE]; /* the host table */

unsigned char BCAST[] = {0xff,0xff,0xff,0xff,0xff,0xff}; /* broadcast add */

/*=============================================================================
Function packet_init

Purpose:  creates a new packet structure and returns a pointer to it
          
Parameters:
    *buff (IN) - data to put in the packet structure
    len (IN) - length of data in buff
    refcount (IN) - number of queues that reference this packet
    
Returns:  a pointer to a new packet structure
=============================================================================*/
struct packet *packet_init(char *buff, int len, int refcount) {
    struct packet *p = (struct packet *)malloc(sizeof(struct packet));
    p->data = (char *)malloc(len);
    memcpy(p->data,buff,len);
    p->len = len;
    p->refcount = refcount;
    p->mut = (pthread_mutex_t *)malloc(sizeof(pthread_mutex_t));
    pthread_mutex_init(p->mut,NULL);
    return p;
}

/*=============================================================================
Function packet_free

Purpose:  frees a packet and the memory associated with a packet
          
Parameters:
    *p (IN) - a pointer to the packet to free
        
Returns:  nothing, the memory associated is freed
=============================================================================*/
void packet_free(struct packet *p) {
    if (p->data!=NULL) free(p->data);
    if (p->mut!=NULL) free(p->mut);
    free(p);
}

/*=============================================================================
Function hash

Purpose:  the function we are using to index into our hash table from an
          ethernet address
          
Parameters:
    *s (IN) - a pointer to a address string to create the hash from
    size (IN) - the size of the hash table
        
Returns:  an integer that is the hash value for ethernet address s
=============================================================================*/
unsigned int hash(char *s, int size) {
    int i;
    unsigned int hashvalue = 0;
    for (i=0;i<ETH_ADDRESS_LEN;i++)
        hashvalue = s[i] + 31 * hashvalue;
    return hashvalue % size;
}

/*=============================================================================
Function makeulong

Purpose:  makes an unsigned long from the four passed in bytes
          
Parameters:
    b3 - b0 (IN) - the bytes used to create the unsigned long
    
Returns:  an unsigned long with b3 at the high ... b0 at the low byte
=============================================================================*/
unsigned long makeulong(int b3, int b2, int b1, int b0) {
    return b3<<24 | b2<<16 | b1<<8 | b0;
}

/*=============================================================================
Function hexprint

Purpose:  prints the hex values of a binary string to stdout
          
Parameters:
    *buff (IN) - the binary string to print
    n (IN) - the size/number of bytes to print from buff
    
Returns:  nothing, the hex values are sent to stdout
=============================================================================*/
void hexprint(char *buff, int n) {
    int i;
    for (i=0;i<n;i++) {
        if (i>0 && i<n) printf(":");
        printf("%02x",(unsigned char)buff[i]);
    }
}

/*=============================================================================
Function isBroadcast

Purpose:  determines whether or not the passed in address is broadcast
          
Parameters:
    *add (IN) - the address to check
    
Returns:  1 if broadcast, 0 otherwise
=============================================================================*/
int isBroadcast(unsigned char *add) {
    return (memcmp(BCAST,add,ETH_ADDRESS_LEN)==0);
}

/*=============================================================================
Function parsecl

Purpose:  parses a command line string for the:

          localport:remoteip:remoteport
          
          that this program expects.
          
Parameters:
    *s (IN) - a command line string from *argv[]
    *i (OUT) - a pointer to an interface structure
    
Returns:  1 if command line information was successfully parsed and the
          struct interface *i is filled in, otherwise, a 0 is returned
=============================================================================*/
int parsecl(char *s, struct interface *i) {
    char *p;
    int lport,rport,b0,b1,b2,b3;
    unsigned long temp;
    char ip[30]; /* 29 characters should be enough for all valid strings */
    if (strlen(s)>sizeof(ip)-1) return 0; /* prevent buff overflow in sscanf */
    while ((p=strchr(s,':'))!=NULL) *p=' ';
    sscanf(s,"%d %s %d",&lport,ip,&rport);
    if (sscanf(s,"%d %s %d",&lport,ip,&rport)<3) return 0;
    if (lport<MIN_PORT || lport>MAX_PORT || rport<MIN_PORT || rport>MAX_PORT)
        return 0;
    if (sscanf(ip,"%d.%d.%d.%d",&b3,&b2,&b1,&b0)<4) return 0;
    if (b0<0 || b0>255 || b1<0 || b1>255 || b2<0 || b2>255 || b3<0 || b3>255)
        return 0;
    i->lport = lport;
    i->rport = rport;
    i->rip = makeulong(b3,b2,b1,b0);
    return 1;
}

/*=============================================================================
Function bouncer

Purpose:  to time out host entries that haven't sent packets in EXPIRE_TIME sec

Returns:  nothing, but times out expired host entries
=============================================================================*/
void *bouncer() {
    int i;
    while(1) {
        #ifdef VERBOSE
        printf("bouncing\n");
        #endif
        pthread_mutex_lock(hostmut);
        hash_expire_he(hosttab,HOST_TAB_SIZE,EXPIRE_TIME);
        pthread_mutex_unlock(hostmut);
        sleep(5);
    }
}

/*=============================================================================
Function handlePacket

Purpose:  handles a packet...puts it on all other interface queues if the
          destination is unknown or is a broadcast packet.  If the destination
          is found in the host table then the packet is placed only on the
          appropriate queue.
          
Parameters:
    *buffer (IN) - a pointer to a valid packet
    *len (IN) - the length of the packet
    *recvface (IN) - a pointer to the interface the packet was received upon
    
Returns:  nothing, but handles the packet as described above
=============================================================================*/
void handlePacket(char *buffer, int len, struct interface *recvface) {
    int i;
    char dest[ETH_ADDRESS_LEN];
    char srce[ETH_ADDRESS_LEN];
    struct packet *pack;
    struct interface *sendface;
    memcpy(dest,buffer,ETH_ADDRESS_LEN);
    memcpy(srce,buffer+ETH_ADDRESS_LEN,ETH_ADDRESS_LEN);

    /* update the host table for recvface */
    pthread_mutex_lock(hostmut);
    hash_update_he(hosttab,HOST_TAB_SIZE,recvface,srce);
    pthread_mutex_unlock(hostmut);

    if (!isBroadcast(dest)) {
        pthread_mutex_lock(hostmut);
        sendface = hash_fetch_he(hosttab,HOST_TAB_SIZE,dest);
        pthread_mutex_unlock(hostmut);
        if (sendface!=NULL) {
            /* don't insert on port that was received upon */
            if (sendface==recvface) return;
            pthread_mutex_lock(sendface->qmut);
            if (sendface->outq->size<MAX_QUEUE_SIZE) {
                pack = packet_init(buffer,len,1);
                list_insert_back(sendface->outq,pack);
            } else {
                #ifdef VERBOSE
                printf("packet overflow for bridge port %d\n",sendface->lport);
                #endif
            }
            pthread_mutex_unlock(sendface->qmut);            
            return;
        }
    }

    /* if the proper host was found, this function returned, everything else */
    /* will be treated like broadcast */
    if (ifacecnt>1)
        pack = packet_init(buffer,len,ifacecnt-1);

    for (i=0;i<ifacecnt;i++) {
        /* don't insert on port that was received upon */
        if (&iface[i]!=recvface) {
            pthread_mutex_lock(iface[i].qmut);
            if (iface[i].outq->size<MAX_QUEUE_SIZE) {
                list_insert_back(iface[i].outq,pack);
            } else {
                #ifdef VERBOSE
                printf("packet overflow for bridge port %d\n",iface[i].lport);
                #endif
            }
            pthread_mutex_unlock(iface[i].qmut);
        }
    }
}

/*=============================================================================
Function send_iface

Purpose:  To send the packets for a single interface.  The thread wakes up
          every second and sends the first packet on the queue if there is one.
          The refcount for the packet is decremented and if it equals one the
          packet is freed.
          
Parameters:
    *p (IN) - a pointer to the struct interface that this thread of send_iface
              will be sending for.  Passed as a void * to work as a pthread.
              
Returns:  nothing, but handles the packet queue for the interface as described
          above
=============================================================================*/
void *send_iface(void *p) {
    struct interface *i = (struct interface *)p;
    struct packet *pack;
    struct sockaddr_in cad; /* client sockaddr */

    int cnt;

    /* set up the cad structure */
    memset((char *)&cad,0,sizeof(cad)); /* clear the sockaddr structure */
    cad.sin_family = AF_INET;           /* family is internet           */
    cad.sin_port = htons(i->rport);
    //differ?
    memcpy (&cad.sin_addr, &i->rip, sizeof (i->rip));

    while(1) {
        pthread_mutex_lock(i->qmut);
        if (i->outq->size>0) {
            pack = (struct packet *)list_remove_front(i->outq);
            pthread_mutex_lock(pack->mut);
            #ifdef VERBOSE
            printf("bridge port %d sending to: %08x:%d\n",i->lport,i->rip,i->rport);
            #endif
            cnt = sendto (i->sd, pack->data, pack->len, 0,
                          (struct sockaddr *) (&cad), sizeof (cad));
            pack->refcount--;
            if (pack->refcount==0) {
                pthread_mutex_unlock(pack->mut);
                packet_free(pack);
            } else {
                pthread_mutex_unlock(pack->mut);
            }
        }
        pthread_mutex_unlock(i->qmut);
        sleep(1);
    }
}

/*=============================================================================
Function listen_iface

Purpose:  To receive packets for a single interface.  Any received packets of
          length greater than 60, apparently valid, are passed to the
          handlePacket function.
          
Parameters:
    *p (IN) - a pointer to the struct interface that this thread of
              listen_iface listens for.  Passed as a void * to work as a
              pthread.
              
Returns:  nothing, but listens for packets for the passed in interface.
=============================================================================*/
void *listen_iface(void *p) {

    struct interface *i = (struct interface *)p;
    
    int addlen, clilen, cnt, j;
    char buff[ETHSIZE];

    struct sockaddr_in sad; /* server sockaddr */
    struct sockaddr_in cad; /* client sockaddr */
    struct protoent *ptrp;  /* pointer to protocol table entry */

    /* set up the sad structure */
    memset((char *)&sad,0,sizeof(sad)); /* clear the sockaddr structure */
    sad.sin_family = AF_INET;           /* family is internet           */
    sad.sin_addr.s_addr = INADDR_ANY;   /* set the local IP address     */

    sad.sin_port = htons((u_short)i->lport);

    /* map the udp transport protocol name to protocol number */
    if (((int)(ptrp = getprotobyname("udp"))) == 0) {
        /* unable to map udp to protocol number report Internal server error */
        fprintf(stderr,"Unable to map udp to protocol number.\n");
        exit(1);
    }

    /* attempt to create the socket */
    if ((i->sd = socket(AF_INET, SOCK_DGRAM, ptrp->p_proto)) < 0) {
        fprintf(stderr,"An error occured creating the socket.\n");
        exit(1);
    }  
        
    /* try to bind to a chosen port */
    if (bind(i->sd, (struct sockaddr *)&sad, sizeof(sad)) < 0) {
        fprintf(stderr,"An error occured binding to port %d.\n",i->lport);
        close(i->sd);
        exit(1);
    }

    /* udp does not need to call listen or accept */

    clilen = sizeof(cad);
    while (1) {
        addlen = clilen;
        cnt = recvfrom (i->sd, buff, ETHSIZE, 0,
                        (struct sockaddr *) &cad, &addlen);
        if (cnt>=60) {
            #ifdef VERBOSE
            printf("bridge port %d has received %d bytes data starting with: \n",i->lport,cnt);
            hexprint(buff,12);
            printf("\n");
            #endif
            handlePacket(buff,cnt,i);
        } else {
            #ifdef VERBOSE
            printf("bridge port %d has received a corrupted packet of size %d\n",i->lport,cnt);
            #endif
        }
    }

}

/*=============================================================================
Function main

Purpose:  initializes interfaces, listeners for interfaces, senders for
          interface queues, and the host hash table.
          
Parameters:
    argc (IN) - count of the number of command line arguments

    *argv[] (IN) - array of pointers to command line argument strings
              
Returns:  nothing, but gets everything started!
=============================================================================*/
int main(int argc, char *argv[]) {

    int i, ret;
    pthread_t bnc;  /* pthread for bouncer thread */

    /* parse the command line strings for interfaces */
    for (i=1;i<argc;i++)
        if (parsecl(argv[i],&iface[ifacecnt])) ifacecnt++;

    if (ifacecnt==0) {
        printf("Proper usage is %s localport:ip:remoteport ...\n",argv[0]);
        exit(1);
    }

    printf("\nlistening on %d interfaces\n",ifacecnt);

    hostmut = (pthread_mutex_t *)malloc(sizeof(pthread_mutex_t));
    pthread_mutex_init(hostmut,NULL);

    /* make sure the host table hash table is all null */
    for (i=0;i<HOST_TAB_SIZE;i++)
        hosttab[i] = NULL;

    for (i=0;i<ifacecnt;i++) {
        /* mutex used on the outgoing queue for an interface */
        iface[i].qmut = (pthread_mutex_t *)malloc(sizeof(pthread_mutex_t));
        /* pthreads for listening and sending on the interface */
        iface[i].listen = (pthread_t *)malloc(sizeof(pthread_t));
        iface[i].send = (pthread_t *)malloc(sizeof(pthread_t));
        /* initialize the outgoing packet queue for the interface */
        iface[i].outq = list_init();
        /* initialize the mutex for the outqoing packet queue */
        pthread_mutex_init(iface[i].qmut,NULL);
        /* start the listening and sending threads for this interface */
        if (pthread_create(iface[i].listen,NULL,listen_iface,&iface[i])!=0) {
            printf("Unable to start listen thread for interface %d.\n",i);
            printf("The bridge will shut down.\n");
            exit(0);
        }
        if (pthread_create(iface[i].send,NULL,send_iface,&iface[i])!=0) {
            printf("Unable to start send thread for interface %d.\n",i);
            printf("The bridge will shut down.\n");
            exit(0);
        }
    }

    /* start the bouncer thread */
    if (pthread_create(&bnc,NULL,bouncer,(void *)NULL)!=0) {
        printf("Unable to start the bouncer thread.\n");
        printf("The bridge will shut down.\n");
        exit(0);
    }

    /* keep this thread running indefintely, all threads keep running so we */
    /* only need to join 0 */
    if (ifacecnt>0) pthread_join(*iface[0].listen,NULL);

    /* shouldn't get here, the bridge runs indefinitely */
    printf("bridge going down\n");

}
