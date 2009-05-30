#include <stdio.h>
#include <string.h>

/*
   item.h
   by
   David J. Burger
   for ICS 212
*/

class Item {
private:
    char *stockNum;
    char *name;
    double price;
    int numInStock;
    static double totalValue;
public:
    Item(char *sn, char *nm);
    Item(char *sn, char *nm, double prc, int qnty);
    char *getStockNo() {return stockNum;};
    char *getName() {return name;};
    double getPrice() {return price;};
    int getInStock() {return numInStock;};
    virtual void addStock(int n);
    virtual void removeStock(int n);
    virtual void setPrice(double p);
    virtual void print();
    static double getTotalValue() {return totalValue;};
};

char *dupstr(char *s);
