lzdecomp: main.o lzroutines.o
	gcc -g main.o lzroutines.o -o lzdecomp
main.o: main.c lzroutines.h
	gcc -c -g main.c
lzroutines.o: lzroutines.c
	gcc -c -g lzroutines.c
