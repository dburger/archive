//****************************************************************************************
/*

Programmer:     David J. Burger
Project Number: 4
Course:         ICS 211
Filename:       PhoneBookFrontEnd.java

Program Description:  This program functions as a phonebook porgram.  When the program is
                      started the existed phonebook data is read from a file called
                      phonebook.txt.  The user of the program can look up a person's
                      phone number based on name, change a phone number, add a new person
                      with a phone number, or delete a person from the phonebook.                     

class PhoneBookFrontEnd - The class containing the main entry point for the program.  It
    creates a Menu object which is the user interface for the program and then runs it.
    
    public static void main(String args[]) - The main entry point for the program.  This
        method creates a Menu object and runs it.  The Menu object handles the user
        interface for the program.
        
class Person - The class which defines the Person objects that are stored in the Phonebook
    
    Person(String fullName, String phoneNumber) - creates a new Person object with the
        given String fullName and String phoneNumber.
        
    public String getFullName() - returns the fullName of the Person object.
    
    public String getPhoneNumber() - returns the phoneNumber of the Person object.

    public void setFullName(String fullName) - sets the fullName of the Person object.

    public void setPhoneNumber(String phoneNumber) - sets the phoneNumber of the Person
        object.

    public String toString() - returns a string representation of the Person object.  This
        is used when saving the PhoneBook to a file.  The string version is the fullName
        and the phoneNumber concatenated together with a piping symbol as the delimiter.

class PhoneBook - The class that holds the phone book data.

    PhoneBook() - creates a new PhoneBook object.

    public void add(String name, String phoneNumber) - adds a new Person with the given
        String name and String phoneNumber to the PhoneBook.  If a Person object with the
        given String name already existed in the PhoneBook, a PhoneBookException is
        thrown.  Clients should check using exists(String name) before attempting
        additions.

    public boolean exists(String name) - returns true if a Person object with the given
        String name already exists in the PhoneBook, false otherwise.

    public void delete(String name) - deletes the Person object from the PhoneBook with
        the given String name.  If a Person object with String name is not found, a
        PhoneBookException is thrown.  Clients should check using exists(String name)
        before attempting deletions.

    public String getPhoneNumber(String name) - returns the phoneNumber of the Person
        object with the given String name.  If a Person object with the given String
        name is not found, a PhoneBookException is thrown.

    public void change(String name, String phoneNumber) - changes the phoneNumber of the
        Person object with the given String name to the passed in phoneNumber.  If a
        Person object with the given String name is not found, a PhoneBookException is
        thrown.

    public void save(String filename) - saves the data in the PhoneBook into the file
        passed in in String filename for later retreival.

    public void load(String filename) -  loads the data from the file String filename into
        the PhoneBook.

class Menu - The class that provides the user interface used in the PhoneBook program.

    public void run() - initiates the user interface used in the PhoneBook program.
    
class PhoneBookException - The exception thrown when errors occur when working with the
    PhoneBook

    PhoneBookException(String s) - creates a new PhoneBookException object with the given
        String s.
*/
//****************************************************************************************


import java.io.*;
import java.util.*;
import BinaryTrees.*;
import SearchKeys.*;


//****************************************************************************************
/*
class PhoneBookFrontEnd - The class containing the main entry point for the program.  It
    creates a Menu object which is the user interface for the program and then runs it.
*/
//****************************************************************************************
public class PhoneBookFrontEnd {


    //Purpose:  the main entry point of the program
    //Preconditions:  none
    //Postconditions:  the Phonebook program is executed, Phonebook data is
    //    modified, and the data is saved upon exit
    public static void main(String args[]) {
        Menu mnu = new Menu();
        mnu.run();
    }

}


//****************************************************************************************
/*
class Person - The class which defines the Person objects that are stored in the Phonebook
*/
//****************************************************************************************
class Person extends KeyedItem {
    
    private String fullName;
    private String phoneNumber;

    //Purpose:  to create and return a Person object
    //Preconditions:  the String fullName as String phoneNumber are passed to this
    //    constructor
    //Postconditions:  the Person object with the given String phoneNumber and String
    //    fullName is created and returned
    Person(String fullName, String phoneNumber) {
        super(fullName);
        this.fullName = fullName;
        this.phoneNumber = phoneNumber;
    }

    //Purpose:  to return the fullName of the Person object
    //Preconditions:  none
    //Postconditions:  the value in String fullName is returned
    public String getFullName() {
        return fullName;
    }

    //Purpose:  to return the phoneNumber of the Person object
    //Preconditions:  none
    //Postconditions:  the value in String phoneNumber is returned
    public String getPhoneNumber() {
        return phoneNumber;
    }

    //Purpose:  to set the fullName of the Person object
    //Preconditions:  a String fullName is passed to this method
    //Postconditions:  the String fullName private data variable is set to the
    //    passed in String fullName
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    //Purpose:  to set the phoneNumber of the Person object
    //Preconditions:  a String phoneNumber is passed to this method
    //Postconditions:  the String phoneNumber private data variable is set to the
    //    passed in String phoneNumber
    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    //Purpose:  to return a String representation of the Person object
    //Preconditions:  none
    //Postconditions:  the fullName and phoneNumber are returned in a concatenated
    //    string with a piping symbol in between as the delimiter
    public String toString() {
        return fullName + "|" + phoneNumber;
    }

}

//****************************************************************************************
/*
class PhoneBook - The class that holds the phone book data.
*/
//****************************************************************************************
class PhoneBook {

    private BinarySearchTree phoneBookData;

    //Purpose:  to create and return a PhoneBook object
    //Preconditions:  none
    //Postconditions:  a PhoneBook object is created and returned
    PhoneBook() {
        phoneBookData = new BinarySearchTree();
    }

    //Purpose:  to add a new Person to the PhoneBook
    //Preconditions:  a unique String name and String phoneNumber of the Person
    //    are passed to this method.
    //Postconditions:  the new Person is added to the PhoneBook.  if a Person object
    //    with the given SearchKey String name already existed in the PhoneBook
    //    a PhoneBookException is thrown
    public void add(String name, String phoneNumber) {
        if (!exists(name))
            phoneBookData.insert(new Person(name, phoneNumber));
        else
            throw new PhoneBookException("Duplicate record error.");
    }

    //Purpose:  to determine whether or not a given person exists in the PhoneBook
    //Preconditions:  a String name of the person to check for is passed to this
    //    method
    //Postconditions:  true is returned if a record with the given SearchKey name
    //    already exists in the PhoneBook, otherwise, false is returned
    public boolean exists(String name) {
        return phoneBookData.retrieve(name)!=null;
    }

    //Purpose:  to delete the Person is the PhoneBook with String name
    //Preconditions:  the String name of the person to delete from the phone book
    //    is passed to this method
    //Postconditions:  the Person with SearchKey String name is deleted from the
    //    PhoneBook.  If the Person object with the SearchKey String name is not
    //    found, a PhoneBookException is thrown
    public void delete(String name) {
        if (exists(name))
            phoneBookData.delete(name);
        else
            throw new PhoneBookException("Record to delete not found.");
    }

    //Purpose:  to return the phone number of the Person with the given name
    //Preconditions:  a String name is passed to this method
    //Postconditions:  the String phoneNumber of the Person with the given
    //    SearchKey String name is returned.  If a Person with the given
    //    SearchKey String name is not found, a PhoneBookException is thrown
    public String getPhoneNumber(String name) {
        if (exists(name))
            return ((Person)phoneBookData.retrieve(name)).getPhoneNumber();
        else
            throw new PhoneBookException("Record to retreive not found.");
    }

    //Purpose:  to change the String phoneNumber of the Person with the
    //    SearchKey String name to String phoneNumber
    //Preconditions:  a String name is passed to this method
    //Postconditions:  the Person with the SearchKey String name has his
    //    phone number changed to the one in String phoneNumber.  If a Person
    //    object with the given SearchKey String name is not found, a
    //    PhoneBookException is thrown
    public void change(String name, String phoneNumber) {
        Person personTemp = (Person)phoneBookData.retrieve(name);
        if (personTemp!=null)
            personTemp.setPhoneNumber(phoneNumber);
        else
            throw new PhoneBookException("Record to retreive not found.");
    }

    //Purpose:  to save the phonebook in a text file for later retreival
    //Preconditions:  the String filename to use when saving the file is passed
    //    to this method
    //Postconditions:  the data in the PhoneBook is saved to a file with the
    //    filename in String filename
    public void save(String filename) {
      TreeIterator ti = new TreeIterator(phoneBookData);
      ti.setPreorder();
      Person tempPerson;
      try {
          PrintWriter fileOutput = new PrintWriter(
              new FileOutputStream("phonebook.txt", false));
          while (ti.hasNext()) {
              tempPerson = (Person)ti.next();
              fileOutput.println(tempPerson.toString());
          }
          fileOutput.close();
      } catch (IOException e) {
          System.out.println("Unable to save the address book:  " + e.getMessage());
      }
    }

    //Purpose:  to load phonebook data from a text file
    //Preconditions:  the String filename of the file to load the data from is
    //    passed to this method
    //Postconditions:  the PhoneBook is loaded with the data in the file indicated
    //    in String filename
    public void load(String filename) {
        try {
            BufferedReader fileInput = new BufferedReader(
                new FileReader("phonebook.txt"));
            String input;
            StringTokenizer st;
            while ((input=fileInput.readLine())!=null) {
                st = new StringTokenizer(input,"|");
                add(st.nextToken(),st.nextToken());
            }
        } catch (IOException e) {
            //the phonebook.txt doesn't exist yet or it has been moved or deleted
        }
    }

}

//****************************************************************************************
/*
class Menu - The class that provides the user interface used in the PhoneBook program.
*/
//****************************************************************************************
class Menu {

    //Purpose:  to present a user interface to the user of the PhoneBook program
    //Preconditions:  none
    //Postconditions:  the program runs giving the user the options of the program,
    //    data is added, changed, deleted, and found at the users discretion.  When
    //    the program terminates the contents of the PhoneBook are saved to a file.
    public void run() {
        BufferedReader stdin = new BufferedReader(new InputStreamReader(System.in));
        PhoneBook pb = new PhoneBook();
        pb.load("phonebook.txt");
        System.out.println("*********************************************************");
        System.out.println("**                  Phonebook Program                  **");
        System.out.println("**                                                     **");
        System.out.println("**  This program functions as an electronic phonebook. **");
        System.out.println("**  It store phone numbers indexed by name.            **");
        System.out.println("**  Data is persisted between sessions in a file       **");
        System.out.println("**  called phonebook.txt.                              **");
        System.out.println("**                                                     **");
        System.out.println("**  The function keys are defined below.               **");
        System.out.println("*********************************************************");
        System.out.println("*     (a)dd - (c)hange - (d)elete - (f)ind - (q)uit     *");
        System.out.println("*********************************************************");
        System.out.print("==>");
        String input;
        String fullName;
        String phoneNumber;
        try { 
            while (!(input=stdin.readLine()).equals("q")) {
                if (input.equals("a")) {
                    System.out.print("Enter the name of the person to add:  ");
                    fullName = stdin.readLine();
                    if (pb.exists(fullName)) {
                        System.out.println(fullName +" already exists in the phonebook.");
                    } else {
                        System.out.print("Enter the phone number:  ");
                        phoneNumber = stdin.readLine();
                        pb.add(fullName, phoneNumber);
                    }
                } else if (input.equals("c")) {
                    System.out.print("Enter the name of the person to change:  ");
                    fullName = stdin.readLine();
                    if (pb.exists(fullName)) {
                        System.out.print("Enter the new phone number:  ");
                        phoneNumber = stdin.readLine();
                        pb.change(fullName, phoneNumber);
                    } else {
                        System.out.println(
                            "Unable to locate " + fullName + " in the phonebook.");
                    }
                } else if (input.equals("d")) {
                    System.out.print("Enter the name of the person to delete:  ");
                    fullName = stdin.readLine();
                    if (pb.exists(fullName))
                        pb.delete(fullName);
                    else
                        System.out.println("Unable to find " + fullName + ".");
                } else if (input.equals("f")) {
                    System.out.print("Enter the name of the person to find:  ");
                    fullName = stdin.readLine();
                    if (pb.exists(fullName)) {
                        phoneNumber = pb.getPhoneNumber(fullName);
                        System.out.println("Phone number:  " + phoneNumber);
                    } else
                        System.out.println("Unable to find " + fullName + ".");
                } else {
                    System.out.println("Unrecognized command.");
                }
                System.out.println("*****************************************************"
                                   + "****");
                System.out.println("*     (a)dd - (c)hange - (d)elete - (f)ind - (q)uit  "
                                   + "   *");
                System.out.println("*****************************************************"
                                   + "****");
                System.out.print("==>");
            }
        } catch (IOException e) {
            System.out.println("An IOException has occurred:  " + e.getMessage());
        }
            //quiting the program, save the phonebook
        pb.save("phonebook.txt");
    }

}

//****************************************************************************************
/*
class PhoneBookException - The exception thrown when errors occur when working with the
    PhoneBook
*/
//****************************************************************************************
class PhoneBookException extends RuntimeException {

    PhoneBookException(String s) {
        super(s);
    }
}
