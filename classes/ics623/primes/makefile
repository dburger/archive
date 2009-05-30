primes: long.o main.o primetest.o
	gcc primetest.o long.o main.o -o primes
main.o: main.c long.h primetest.h
	gcc main.c -c
primetest.o: primetest.c
	gcc primetest.c -c
long.o: long.c
	gcc long.c -c
