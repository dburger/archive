secret: secret.o gfarith.o
	gcc secret.o gfarith.o -o secret
secret.o: secret.c secret.h
	gcc secret.c -c
gfarith.o: gfarith.c
	gcc gfarith.c -c
