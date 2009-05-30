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

struct list *list_init();
void list_insert_front(struct list *l, void *p);
void list_insert_back(struct list *l, void *p);
void *list_remove_front(struct list *l);
void *list_peek_front(struct list *l);
