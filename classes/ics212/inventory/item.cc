#include "item.h"

/*
   item.cc
   by
   David J. Burger
   for ICS 212
*/

double Item::totalValue;

Item::Item(char *sn, char *nm) {
    stockNum = dupstr(sn);
    name = dupstr(nm);
    price = 0;
    numInStock = 0;
}

Item::Item(char *sn, char *nm, double prc, int qnty) {
    stockNum = dupstr(sn);
    name = dupstr(nm);
    price = prc;
    numInStock = qnty;
    totalValue+=price*numInStock;
}

void Item::addStock(int n) {
    numInStock+=n;
    totalValue+=price*n;
}

void Item::removeStock(int n) {
    numInStock-=n;
    totalValue-=price*n;
}

void Item::setPrice(double p) {
    totalValue-=price*numInStock;
    price = p;
    totalValue+=price*numInStock;
}

void Item::print() {
    printf("%6-s     %30-s  Price:  $%6.2f  %3d in stock\n", stockNum, name,
           price, numInStock);
}

char *dupstr(char *s) {
    return strcpy(new char[strlen(s)+1],s);
}
