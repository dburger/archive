/*
   book.h
   by
   David J. Burger
   for ICS 212
*/

class Book: public Item {
private:
    char *author;
    char *publisher;
    static double totalValue;
public:
    Book(char *sn, char *nm, char *auth, char *pub);
    Book(char *sn, char *nm, char *pub, char *auth,
         double prc, int qnty);
    char *getPublisher() {return publisher;};
    char *getAuthor() {return author;};
    void addStock(int n);
    void removeStock(int n);
    void setPrice(double p);
    void print();
    static double getTotalValue() {return totalValue;};
};
