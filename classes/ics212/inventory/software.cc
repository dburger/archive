#include "item.h"
#include "software.h"

/*
   software.cc
   by
   David J. Burger
   for ICS 212
*/

double Software::totalValue;

Software::Software(char *sn, char *nm, char *pub, char *ver): Item(sn, nm) {
    publisher = dupstr(pub);
    version = dupstr(ver);
}

Software::Software(char *sn, char *nm, char *pub, char *ver,
                   double prc, int qnty): Item(sn, nm, prc, qnty) {
    publisher = dupstr(pub);
    version = dupstr(ver);
    totalValue+=prc*qnty;
}

void Software::addStock(int n) {
    Item::addStock(n);
    totalValue+=getPrice()*n;
}

void Software::removeStock(int n) {
    Item::removeStock(n);
    totalValue-=getPrice()*n;
}

void Software::setPrice(double p) {
    totalValue-=getPrice()*getInStock();
    Item::setPrice(p);
    totalValue+=getPrice()*getInStock();
}

void Software::print() {
    Item::print();
    printf("  Publisher:  %20-s  Version:  %10-s\n", publisher, version);
}
