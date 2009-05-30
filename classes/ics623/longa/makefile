longtest: long.o main.o
	gcc long.o main.o -o longtest
main.o: main.c long.h
	gcc main.c -c
long.o: long.c
	gcc long.c -c
