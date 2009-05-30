keyexchange: main.o long.o
	gcc main.o long.o -o keyexchange
main.o: main.c long.h
	gcc main.c -c
long.o: long.c long.h
	gcc long.c -c
