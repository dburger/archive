parse: main.o parse.o scan.o treduce.o
	gcc -g main.o parse.o scan.o treduce.o -o parse
main.o: main.c parse.h
	gcc -c -g main.c
parse.o: parse.c parse.h
	gcc -c -g parse.c
scan.o: scan.c parse.h
	gcc -c -g scan.c
treduce.o: treduce.c parse.h
	gcc -c -g treduce.c