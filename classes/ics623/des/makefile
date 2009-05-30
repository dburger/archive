dessamp: dessamp.o des.o desf.o f.o keycalc.o
	gcc dessamp.o des.o desf.o f.o keycalc.o -o dessamp

descfb: descfb.o des.o desf.o f.o keycalc.o
	gcc descfb.o des.o desf.o f.o keycalc.o -o descfb

des: des1.o des.o desf.o f.o keycalc.o
	gcc -g des1.o des.o desf.o f.o keycalc.o -o des

dessamp.o: dessamp.c des.h
	gcc -c dessamp.c

descfb.o: descfb.c des.h
	gcc -c descfb.c

des1.o: des1.c des.h
	gcc -c -g des1.c

des.o: des.c des.h
	gcc -c -g des.c

desf.o: desf.c des.h
	gcc -c -g desf.c

f.o: f.c des.h
	gcc -c -g f.c

keyclaclo: keycalc.c des.h
	gcc -c -g keycalc.c

