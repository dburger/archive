#include <time.h>

/* used to turn on and off verbose output */
#define VERBOSE

#define ETH_ADDRESS_LEN 6

/* structure for holding a packet and its associated reference count */
struct packet {
    char *data;
    int len;
    int refcount;
    pthread_mutex_t *mut;
};

/* structure for holding all information about an interface */
struct interface {
    int sd; /* socket descriptor */
    int lport; /* local port */
    unsigned long rip; /* remote ip */
    int rport; /* remote port */
    pthread_t *listen; /* for the listen for this interface */
    pthread_t *send; /* for the send for this interface */
    pthread_mutex_t *qmut; /* the mutex for the packet queue on this iface */
    struct list *outq;
};

/* structure for holding a host entry in the host table */
struct hostentry {
    char *add;
    struct interface *iface; /* associated interface */
    time_t t; /* time stamp on last reception from address */
};

/* doubly linked list node structure */
struct node {
    void *data;
    struct node *next;
    struct node *prev;
};

/* doubly linked list structure */
struct list {
    struct node *head;
    struct node *tail;
    int size;
};

/* used to print the hex values of a binary string of length n */
void hexprint(char *buff, int n);

/* functions for working with the doubly linked list */
struct list *list_init();
void *list_remove_front(struct list *l);
void list_insert_back(struct list *l, void *p);
void list_insert_front(struct list *l, void *p);

/* functions for creating and freeing host entry structures */
struct hostentry *hostentry_init(char *add, struct interface *i);
void hostentry_free(struct hostentry *h);

/* special functions used on hash tables containing host entry data */
/* update, expire, and fetch */
void hash_update_he(struct list *hashtab[], int size, struct interface *i,
                    char *add);
void hash_expire_he(struct list *hashtab[], int size, int sec);
struct interface *hash_fetch_he(struct list *hashtab[], int size, char *add);

/* special functions used on linked lists containing host entry data */
/* update, expire, and fetch*/
void list_update_he(struct list *l, char *buff, struct interface *i);
void list_expire_he(struct list *l, double sec);
struct interface *list_fetch_he(struct list *l, char *buff);
