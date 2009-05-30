modtest: main.o modarith.o modarith.h
	gcc main.o modarith.o -o modtest
main.o: main.c modarith.h
	gcc main.c -c
modarith.o: modarith.c
	gcc modarith.c -c
