shatest: main.o sha1.o
	gcc main.o sha1.o -o shatest
main.o: sha1.h main.c
	gcc main.c -c
sha1.o: sha1.h sha1.c
	gcc sha1.c -c
