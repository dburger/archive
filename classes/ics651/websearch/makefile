#LINK =                #Linux
LINK = -lnsl -lsocket  #Solaris
CFLAGS = #-DDEBUG
websearch: websearch.o list.o trie.o
	gcc websearch.o list.o trie.o -o websearch $(LINK)
websearch.o: websearch.c
	gcc websearch.c -c $(CFLAGS)
list.o: list.c
	gcc list.c -c
trie.o: trie.c
	gcc trie.c -c
