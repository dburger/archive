.SUFFIXES: .c .o

SRCS = ip.c tcp.c testtcp.c ipsim.h
OBJS = ip.o tcp.o testtcp.o
LINK = 			# linux
# LINK = -lsocket -lnsl  		# SunOS/Solaris
CC = gcc
CFLAGS = -g
#-DDEBUG

.c.o:
	$(CC) -c $(CFLAGS) $*.c

all: testtcp

testtcp: $(OBJS) $(SRCS)
	gcc -o testtcp -g $(OBJS) $(LINK)

clean:
	rm $(OBJS) testtcp

# dependencies
ip.o: ipsim.h

tcp.o: ipsim.h

test.o: ipsim.h

install:
	cp $(SRCS) makefile /home/ftp/

