parse: main.o parse.o scan.o reduce.o
	gcc -g main.o parse.o scan.o reduce.o -o parse
main.o: main.c parse.h
	gcc -c -g main.c
parse.o: parse.c parse.h
	gcc -c -g parse.c
scan.o: scan.c parse.h
	gcc -c -g scan.c
reduce.o: reduce.c parse.h
	gcc -c -g reduce.c