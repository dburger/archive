frontend: frontend.o fd.o
	gcc frontend.o fd.o -Wall -o frontend
frontend.o: frontend.c fd.h
	gcc frontend.c -Wall -c
fd.o: fd.c
	gcc fd.c -Wall -c
simpledemo: simpledemo.c
	gcc simpledemo.c -Wall -o simpledemo
