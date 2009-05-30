DEBUGFLAGS=-DDEBUG
router: router.o list.o
	gcc router.o list.o -o router -lsocket -lnsl -lpthread -lrt
router.o: router.c list.h
	gcc router.c -c -DDEBUG
list.o: list.c list.h
	gcc list.c -c
