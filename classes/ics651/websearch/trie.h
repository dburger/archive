/* the trie is basically composed of a tree of linked lists */
struct trie {
  struct list *root_list;
  int size;
};

struct trie *trie_init();
int trie_insert(struct trie *trie, char *string, int allow_dups);
