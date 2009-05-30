main: main.o huffman.o fileroutines.o
	gcc -g main.o huffman.o fileroutines.o -o hufftest
main.o: main.c huffman.h
	gcc -c -g main.c
huffman.o: huffman.c huffman.h
	gcc -c -g huffman.c
fileroutines.o: fileroutines.c huffman.h
	gcc -c -g fileroutines.c