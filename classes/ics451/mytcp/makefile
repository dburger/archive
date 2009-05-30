mytcp: mytcp.o tcp.o list.o data.o
	gcc mytcp.o tcp.o list.o data.o -o mytcp -lnsl -lpthread -lsocket
mytcp.o: mytcp.c mytcp.h
	gcc mytcp.c -c
tcp.o: tcp.c mytcp.h
	gcc tcp.c -c
list.o: list.c mytcp.h
	gcc list.c -c
data.o: data.c mytcp.h
	gcc data.c -c
