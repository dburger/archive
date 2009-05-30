#include <time.h>
#include <sys/timeb.h>

typedef unsigned long UL;
typedef unsigned short US;
typedef unsigned char UC;

/* doubly linked list structure */
struct list {
  struct node *head;
  struct node *tail;
  int size;
};

/* doubly linked list node structure */
struct node {
  void *data;
  struct node *next;
  struct node *prev;
};

/* tcp header structure w/o options */
struct tcp {
  US srce_port;
  US dest_port;
  UL seq_num;
  UL ack_num;
  UC offset;
  UC flags;
  US window;
  US chk_sum;
  US urg_pntr;
};

/* used to hold a packet in a packet list */
struct tcp_packetentry {
  char *packet; /* the actual packet data */
  char *payload; /* the payload portion of the data */
  struct tcp *tcp_header; /* a pointer to the header of the packet */
  int size; /* total size of the packet */
  struct timeb *tb; /* time stamp of packet */
  UL ver_ack; /* the ack that verifies this packet */
};

/* from list.c */
struct list *list_init();
void list_insert_front(struct list *l, void *p);
void list_insert_back(struct list *l, void *p);
void *list_remove_front(struct list *l);

/* from tcp.c */
void printTCPHeader(int in, struct tcp *tcp_header, int size);
struct tcp_packetentry *packetentry_init(struct tcp *tcp_header, char *payload,
                                         int payload_size);
void packetentry_free(struct tcp_packetentry *p);
US checksum16(char *data, int length, US chk);

/* from data.c */
void fillData(char *buff, int size);
