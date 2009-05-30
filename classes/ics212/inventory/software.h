/*
   software.h
   by
   David J. Burger
   for ICS 212
*/

class Software: public Item {
private:
    char *publisher;
    char *version;
    static double totalValue;
public:
    Software(char *sn, char *nm, char *pub, char *ver);
    Software(char *sn, char *nm, char *pub, char *ver,
             double prc, int qnty);
    char *getPublisher() {return publisher;};
    char *getVersion() {return version;};
    void addStock(int n);
    void removeStock(int n);
    void setPrice(double p);
    void print();
    static double getTotalValue() {return totalValue;};
};





