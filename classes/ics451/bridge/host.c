/*=============================================================================
Assignment: Project 2, a Learning Bridge
Author:     David Burger, Bruce Harris, Michael Miranda
Language:   ANSI C running on UHUNIX2 (Solaris)
Compile:    by running "make" with included makefile

Class:      ICS 451
Instructor: Edo Biagioni
Due Date:   Oct. 26, 2001
===============================================================================
File:         host.c

Description:  This file contains functions related to the hostentry structure.
              It contains functions for initializing and freeing the structure
              as well as SPECIALIZED list and hash table functions for lists
              and hash tables that contain ONLY hostentry data.
=============================================================================*/
#include "bridge.h"

/*=============================================================================
Function hostentry_init

Purpose:  creates a new hostentry structure and returns a pointer to it
          
Parameters:
    *add (IN) - address of the hostentry
    *i (IN) - pointer to the interface associated with this host

Returns:  a pointer to a new hostentry structure
=============================================================================*/
struct hostentry *hostentry_init(char *add, struct interface *i) {
    struct hostentry *h = (struct hostentry *)malloc(sizeof(struct hostentry));
    h->add = (char *)malloc(ETH_ADDRESS_LEN);
    memcpy(h->add,add,ETH_ADDRESS_LEN);
    h->iface = i;
    time(&h->t);
    return h;
}

/*=============================================================================
Function hostentry_free

Purpose:  frees a hostentry and the memory associated with a hostentry
          
Parameters:
    *h (IN) - a pointer to the hostentry to free
        
Returns:  nothing, the memory associated is freed
=============================================================================*/
void hostentry_free(struct hostentry *h) {
    if (h->add!=NULL) free(h->add);
    free(h);
}

/*=============================================================================
Function list_expire_he

Purpose:  removes the host entries from a list that have not been updated in
          sec seconds.
          
Parameters:
    *l (IN) - a pointer to the list to check for expired hosts
    sec (IN) - the number of seconds that qualifies as an expired host
        
Returns:  nothing, the function iterates through the list expiring hostentries
=============================================================================*/
void list_expire_he(struct list *l, double sec) {
    int i,j=0;
    time_t t;
    struct node *curr;
    struct node *temp;
    struct hostentry *he;
    if (l->size>0) {
        time(&t);
        curr = l->head->next;
        while (curr!=l->tail) {
            he = (struct hostentry *)curr->data;
            if (difftime(t,he->t)>sec) {
                #ifdef VERBOSE
                printf("bridge port %d expiring host: ",he->iface->lport);
                hexprint(he->add,ETH_ADDRESS_LEN);
                printf("\n");
                #endif
                curr->prev->next = curr->next;
                curr->next->prev = curr->prev;
                temp = curr;
                curr = curr->next;
                hostentry_free(he);
                free(temp);
                l->size--;
            } else
                curr = curr->next;
        }
    }
}

/*=============================================================================
Function list_fetch_he

Purpose:  searches a list for a hostentry with an address matching that in
          buff.  If a match is found a pointer to the associated interface
          is returned, otherwise, a null pointer is returned.
          
Parameters:
    *l (IN) - a pointer to the list to check for a matching address
    *buff (IN) - the address of the host we are searching for
        
Returns:  a pointer to the associated interface for the matching host, or a
          null pointer if the host is not found
=============================================================================*/
struct interface *list_fetch_he(struct list *l, char *buff) {
    struct node *curr;
    struct hostentry *he;
    if (l->size>0) {
        curr = l->head->next;
        while (curr!=l->tail) {
            he = (struct hostentry *)curr->data;
            //check for null data here?
            if (memcmp(buff,he->add,ETH_ADDRESS_LEN)==0)
                return he->iface;
            curr = curr->next;
        }
        return NULL;
    }
}

/*=============================================================================
Function list_update_he

Purpose:  iterates through a list looking for a hostentry with an address
          mathcing srce, if such a hostentry is found it is updated.  If such
          a hostentry is not found, a new hostentry is created and added to
          the front of the list.
          
Parameters:
    *l (IN) - a pointer to the list to update
    *srce (IN) - the address of the host we are updating
    *i (IN) - the interface that received a packet from this host
    
        
Returns:  nothing, the list is updated by updating an existing hostentry or
          adding a new hostentry if a matching host is not found
=============================================================================*/
void list_update_he(struct list *l, char *srce, struct interface *i) {
    int j;
    struct node *curr;
    struct hostentry *he;
    if (l->size>0) {
        curr = l->head->next;
        while (curr!=l->tail) {
            he = (struct hostentry *)curr->data;
            if (memcmp(srce,he->add,ETH_ADDRESS_LEN)==0) {
                #ifdef VERBOSE
                printf("updating time stamp for host entry: ");
                hexprint(srce,ETH_ADDRESS_LEN);
                printf("\n");
                #endif
                /* update the time stamp */
                time(&he->t);
                /* host reconfiguration? */
                he->iface = i;
                return;
            }
            curr = curr->next;
        }
    }
    /* if it got here it didn't find buff in the list, add it */
    #ifdef VERBOSE
    printf("bridge port %d adding host entry: ",i->lport);
    hexprint(srce,ETH_ADDRESS_LEN);
    printf("\n");
    #endif
    he = hostentry_init(srce,i);
    /* use insert_front to take advantage of proximity theory */
    list_insert_front(l,he);
}

/*=============================================================================
Function hash_update_he

Purpose:  to update the hostentry for the host with address add.  The address
          is used to index into the hash table.  If a list is found at that
          address its list_update_he is called.  If a list is not found at that
          address, a list is created for that address and its list_update_he is
          called.
          
Parameters:
    *hashtab[] (IN) - the hash table of lists containing host entries that
                      we are going to update
    size (IN) - the size of the hash table
    *i (IN) - the interface that received a packet from this host
    *add (IN) - the address of the host
    
        
Returns:  nothing, the hash table is updated by updating an existing hostentry
          or adding a new hostentry if a matching host is not found
=============================================================================*/
void hash_update_he(struct list *hashtab[], int size, struct interface *i,
                 char *add) {
    int j;
    unsigned int hashvalue = hash(add,size);
    struct list *l = hashtab[hashvalue];
    if (l==NULL)
        hashtab[hashvalue] = (l = list_init());
    list_update_he(l,add,i);
}

/*=============================================================================
Function hash_expire_he

Purpose:  removes the host entries from a hash table that have not been
          updated in sec seconds.  Most of the work in this function is done
          by the list_expire_he function and the lists held in the hash table.
          
Parameters:
    *hashtab[] (IN) - a pointer to the hash table to check for expired hosts
    sec (IN) - the number of seconds that qualifies as an expired host
        
Returns:  nothing, the function iterates through the hash table, calling
          list_expire on the lists, expiring out of date host entries.
=============================================================================*/
void hash_expire_he(struct list *hashtab[], int size, int sec) {
    int i;
    struct list *l;
    for (i=0;i<size;i++) {
        l = hashtab[i];
        if (l!=NULL) {
            list_expire_he(l,sec);
            if (l->size==0) {
                free (l);
                hashtab[i] = NULL;
            }
        }
    }
}

/*=============================================================================
Function hash_fetch_he

Purpose:  searches a hash table for a hostentry with an address matching that
          in buff.  If a match is found a pointer to the associated interface
          is returned, otherwise, a null pointer is returned.  Most of the
          work is done by the list_fetch_he function called on the lists
          contained in the hash table.
          
Parameters:
    *hashtab (IN) - a pointer to the hash table to check for a matching address
    size (IN) - the size of the hash table
    *add (IN) - the address of the host we are searching for
        
Returns:  a pointer to the associated interface for the matching host, or a
          null pointer if the host is not found
=============================================================================*/
struct interface *hash_fetch_he(struct list *hashtab[], int size, char *add) {
    struct list *l = hashtab[hash(add,size)];
    if (l==NULL)
        return NULL;
    else
        return list_fetch_he(l,add);
}
