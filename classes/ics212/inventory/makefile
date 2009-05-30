inventory: main.o item.o book.o software.o
	g++ main.o item.o book.o software.o -o inventory
main.o: main.cc
	g++ -c main.cc
book.o: book.cc book.h
	g++ -c book.cc
software.o: software.cc software.h
	g++ -c software.cc
item.o: item.cc item.h
	g++ -c item.cc
