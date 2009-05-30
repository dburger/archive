/*=============================================================================
Author:     David Burger
Language:   ANSI C running on UHUNIX2 (Solaris)
Edit Date:  Apr. 10, 2002
===============================================================================
File:         trie.c
Description:  This file contains functions for working with a very basic trie
=============================================================================*/

#include <stdlib.h>

#include "trie.h"
#include "list.h"

struct trie_item {
  char c; /* character at position in trie */
  int terminal; /* != 0 means terminal, allowing dups also indicates count */
  struct list *sub_trie; /* link to next character trie */
};

/*=============================================================================
Function trie_init
Purpose:  creates a new trie structure and returns a pointer to it

Parameters:  none
Returns:  a pointer to a new trie structure
=============================================================================*/
struct trie *trie_init() {
  struct trie *t = (struct trie *)malloc(sizeof(struct trie));
  t->root_list = list_init();
  t->size = 0;
  return t;
}

/*=============================================================================
Function trie_list_locate

Purpose: determines if the given character is in the given trie list, returning
         a reference to it if it is
          
Parameters:
    *trie_list (IN) - list that we are checking for char c
    c (IN) - character we are looking for
        
Returns: the trie_item if found, otherwise returns NULL
=============================================================================*/
struct trie_item *trie_list_locate(struct list *trie_list, char c) {
  struct trie_item *ti;
  struct node *curr;
  for (curr=trie_list->head->next;curr!=trie_list->tail;curr=curr->next) {
    ti = (struct trie_item *)curr->data;
    if (ti->c==c) {
      /* heuristic that will move accessed items one closer to the front */
      if (curr->prev!=trie_list->head) {
        curr->data = curr->prev->data;
        curr->prev->data = ti;
      }
      return ti;
    }
  }
  return NULL;
}

/*=============================================================================
Function trie_insert

Purpose: inserts string into the trie
          
Parameters:
    *trie (IN) - trie we are inserting into
    *string (IN) - string we are attempting to insert
    allow_dups (IN) - whether or not to allow duplicates
        
Returns: the count of string in the trie, or 0 if the string is already in the
         trie and not allowing duplicates
=============================================================================*/
int trie_insert(struct trie *trie, char *string, int allow_dups) {
  int i;
  struct trie_item *ti;
  struct list *trie_list = trie->root_list;
  int len = strlen(string) - 1; /* -1 because last character is special case */
  for (i=0;i<len;i++) {
    ti = trie_list_locate(trie_list,string[i]);
    if (ti==NULL) {
      ti = (struct trie_item *)malloc(sizeof(struct trie_item));
      ti->c = string[i];
      ti->terminal = 0;
      ti->sub_trie = list_init();
      list_insert_back(trie_list, ti);
    }
    trie_list = ti->sub_trie;
  }
  ti = trie_list_locate(trie_list,string[i]);
  if (ti==NULL) { /* last character not found */
    ti = (struct trie_item *)malloc(sizeof(struct trie_item));
    ti->c = string[i];
    ti->terminal = 1;
    ti->sub_trie = list_init();
    list_insert_back(trie_list, ti);
    trie->size++;
    return 1;      
  } else { /* last character found */
    if (ti->terminal && !allow_dups)
      return 0;
    else {
      trie->size++;
      return ++ti->terminal;
    }

  }
}
