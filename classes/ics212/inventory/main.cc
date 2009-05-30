#include "item.h"
#include "book.h"
#include "software.h"

/*
   main.cc provided by
   Dr. Peterson
   for ICS 212 assignment #8
*/

void main(void) 
{
    Item *pi[8];

    Book b1("abc123", "Learn C++ in Two Hours", 
        "Prentice-Hall", "Jones", 79.98, 25);
    Book b2("cde321", "C++ for Dummies", 
        "Osborne", "Smith", 25.50, 17);
    Book *pb3 = new Book("ax5645", "Unix in a Nutshell",
        "O'Reilly", "Gilly", 22.85, 30);
    Book *pb4 = new Book("ax7831", "WindowsNT in a Nutshell",
        "O'Reilly", "Pearce", 27.95, 15);

    pi[0] = &b1; pi[1] = &b2; pi[2] = pb3; pi[3] = pb4;

    Software s1("xyz321", "Visual Cafe", "Symantec", "3.5",
        110, 7);
    Software s2("zyx434", "Visual C++", "Microsoft",
        "6.0", 120, 11);

    Software *ps3 = new Software("uvw444", "Visual Basic",
        "Microsoft", "7.14", 125, 10);
    Software *ps4 = new Software("wvu678", "J-Builder",
        "Borland", "4.5", 99.95, 6);

    pi[4] = &s1; pi[5] = &s2; pi[6] = ps3; pi[7] = ps4;


    b1.print();
    b2.print();
    pb3->print();
    pb4->print();
    s1.print();
    s2.print();
    ps3->print();
    ps4->print();


    printf("Total Value of Books: $%0.2f\n", 
        Book::getTotalValue());
    printf("Total Value of Software: $%0.2f\n", 
        Software::getTotalValue());
    printf("Total Value of Everything: $%0.2f\n", 
        Item::getTotalValue());
        


    printf("\n");
    for(int i = 0; i<8; i++) {
        printf("There are %d of pi[%d]\n",
            pi[i]->getInStock(), i);
        pi[i]->print();
    }

    b1.addStock(15);
    pb3->removeStock(10);
    s1.addStock(10);
    ps3->removeStock(10);

    printf("\nAfter adding 10 b1 and 10 s1"
        " and removing 10 b3 and 10 s3\n");
    printf("Total Value of Books: $%0.2f\n", 
        Book::getTotalValue());
    printf("Total Value of Software: $%0.2f\n", 
        Software::getTotalValue());
    printf("Total Value of Everything: $%0.2f\n", 
        Item::getTotalValue());
    
    b2.setPrice(27.50);
    ps4->setPrice(89.95);
    printf("\nAfter changing price b2 to 27.50"
        " and s4 to 89.95\n");

    printf("Total Value of Books: $%0.2f\n", 
        Book::getTotalValue());
    printf("Total Value of Software: $%0.2f\n", 
        Software::getTotalValue());
    printf("Total Value of Everything: $%0.2f\n", 
        Item::getTotalValue());
        
}
