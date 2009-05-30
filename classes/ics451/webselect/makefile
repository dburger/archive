webselect: webselect.o wserv.o util.o
	gcc webselect.o wserv.o util.o -o webselect -lsocket -lnsl
webselect.o: webselect.c defs.h util.h wserv.h
	gcc -c webselect.c
wserv.o: wserv.c util.h wserv.h defs.h
	gcc -c wserv.c
util.o: util.c defs.h
	gcc -c util.c
