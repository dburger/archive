/*=============================================================================
Author:     David Burger
Language:   ANSI C running on UHUNIX2 (Solaris)
Edit Date:  Dec. 09, 2001
===============================================================================
File:         list.c
Description:  This file contains functions for working with a doubly linked
              list.
=============================================================================*/

#include <stdlib.h>

#include "list.h"

/*=============================================================================
Function list_init
Purpose:  creates a new list structure and returns a pointer to it

Parameters:  none
Returns:  a pointer to a new list structure
=============================================================================*/
struct list *list_init() {
  struct list *l = (struct list *)malloc(sizeof(struct list));
  l->head = (struct node *)malloc(sizeof(struct node));
  l->tail = (struct node *)malloc(sizeof(struct node));
  l->head->prev = NULL;
  l->head->next = l->tail;
  l->tail->prev = l->head;
  l->tail->next = NULL;
  l->size = 0;
  return l;
}

/*=============================================================================
Function list_insert_front
Purpose:  inserts a node with a pointer to p into the front of the list

Parameters:
     *l (IN) - the list to insert *p into
     *p (in) - a pointer to the data to put in the list
     
Returns:  nothing, a new node structure is created with a pointer to *p and
          is inserted at the front of the list
=============================================================================*/
void list_insert_front(struct list *l, void *p) {
  struct node *n = (struct node *)malloc(sizeof(struct node));
  n->data = p;
  n->next = l->head->next;
  n->prev = l->head;
  l->head->next = n;
  n->next->prev = n;
  l->size++;
}

/*=============================================================================
Function list_insert_back
Purpose:  inserts a node with a pointer to p into the back of the list

Parameters:
     *l (IN) - the list to insert *p into
     *p (in) - a pointer to the data to put in the list

Returns:  nothing, a new node structure is created with a pointer to p and
          is inserted at the back of the list
=============================================================================*/
void list_insert_back(struct list *l, void *p) {
  struct node *n = (struct node *)malloc(sizeof(struct node));
  n->data = p;
  n->prev = l->tail->prev;
  n->next = l->tail;
  l->tail->prev = n;
  n->prev->next = n;
  l->size++;
}

/*=============================================================================
Function list_remove_front
Purpose:  removes the node at the front of the list returning a pointer to the
          data held in that node
          
Parameters:
     *l (IN) - the list to remove the front node of

Returns:  a pointer to the data held in the first node of the list or null if
          the list is empty
=============================================================================*/
void *list_remove_front(struct list *l) {
  struct node *n = l->head->next;
  void *p = n->data;
  if (l->size>0) {
    l->head->next = n->next;
    n->next->prev = l->head;
    free (n);
    l->size--;
    return p;
  }
  return NULL;
}

/*=============================================================================
Function list_peek_front
Purpose:  to get a pointer to the first data item of the list
          
Parameters:
     *l (IN) - the list to return the first data item of

Returns:  a pointer to the data held in the first node of the list or null if
          the list is empty
=============================================================================*/
void *list_peek_front(struct list *l) {
  struct node *n = l->head->next;
  void *p = n->data;
  if (l->size>0)
    return p;
  return NULL;
}
