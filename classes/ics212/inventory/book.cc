#include "item.h"
#include "book.h"

/*
   book.cc 
   by
   David J. Burger
   for ICS 212
*/

double Book::totalValue;

Book::Book(char *sn, char *nm, char *auth, char *pub): Item(sn, nm) {
    author = dupstr(auth);
    publisher = dupstr(pub);
}

Book::Book(char *sn, char *nm, char *pub, char *auth,
           double prc, int qnty): Item(sn, nm, prc, qnty) {
    author = dupstr(auth);
    publisher = dupstr(pub);
    totalValue+=prc*qnty;
}

void Book::addStock(int n) {
    Item::addStock(n);
    totalValue+=getPrice()*n;
}

void Book::removeStock(int n) {
    Item::removeStock(n);
    totalValue-=getPrice()*n;
}

void Book::setPrice(double p) {
    totalValue-=getPrice()*getInStock();
    Item::setPrice(p);
    totalValue+=getPrice()*getInStock();
}

void Book::print() {
    Item::print();
    printf("  Author:  %20-s  Publisher:  %20-s\n", author, publisher);
}
