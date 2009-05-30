bridge: bridge.o list.o host.o
	gcc bridge.o list.o host.o -o bridge -lsocket -lnsl -lpthread
bridge.o: bridge.c bridge.h
	gcc bridge.c -c
list.o: list.c bridge.h
	gcc list.c -c
host.o: host.c bridge.h
	gcc host.c -c

