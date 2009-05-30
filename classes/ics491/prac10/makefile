all: manager supervisor worker

manager: manager.c primes.h
	mpcc manager.c -o manager -lm
supervisor: supervisor.c primes.h
	mpcc supervisor.c -o supervisor
worker: worker.c primes.h
	mpcc worker.c -o worker -lm
