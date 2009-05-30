//****************************************************************************************
/*

Programmer:     David J. Burger
Project Number: 2
Course:         ICS 211
Filename:       CharListTester.java

Program Description:  This program demonstrates and tests the abilities of the CharList
                      class.

class CharListTester - The class containing the main entry point for the program.  It is
    designed to test the CharList class in the following areas:  appending, extracting,
    locating, determining substrings, and replacing.

    static void main(String args[]) - The main entry point for the program.  This routine
        puts the CharList through various tests to make sure that the methods of the
        CharList work as specified.

class CharList - A class that implements typical string operations using a linked list of
    characters.

    CharList() - create a new instance of the CharList class.

    CharList(CharList cl) - create a new instance of the CharList class that is holds the
        same data as passed in CharList cl.

    CharList(String s) - create a new instance of the CharList class that holds the same
        data as the passed in String s.

        //private List operations
    private boolean isEmpty() - returns whether or not the list of characters is empty.

    private char getItem(int index) throws ListIndexOutOfBoundsException - returns the
        character in the CharacterNode reference by index.

    private int size() - returns the number of CharacterNodes in the CharList.

    private void removeAll() - removes all the CharacterNodes from the CharList.

    private void add(int index, char item) throws ListIndexOutOfBoundsException - Adds a
        new CharacterNode at position index with data value item.

        //not in a typical list but added to help with appending to the end of the list
    private void addAtEnd(char item) - adds a new CharacterNode at the end of the
        CharList with data value item.

    private void remove(int index) throws ListIndexOutOfBoundsException - removes the
        CharacterNode reference by index from the CharList.

    private CharacterNode find(int index) - returns a reference to the CharacterNode
        referenced by index.

        //public CharList operations
    public int length() - returns the number of items or CharacterNodes in the CharList.
    
    public void append(CharList cl) - appends the passed in CharList cl to the end of the
        CharList.

    public void append(char c) - appends the char c to the end of the CharList.

    public void append(String s) - appends the characters in String s to the end of the
        CharList.

    public int charLocation(char c, int start) - returns the location of the first
        CharacterNode with the same value as char c starting at location start.  If char c
        is not found 0 is returned.
        
    public int charLocation(char c) - returns the location of the first CharacterNode with
        the same value as char c starting at position 1.  If char c is not found 0 is
        returned.

    public CharList substring(int start, int length) - returns a CharList containing a
        substring from position int start and of length int length.

    public CharList substring(int start) - returns a CharList containing a substring from
        position int start to the end of the CharList.

    public int substringLocation(CharList cl,int start) - returns the index position of
        the left most occurance of substring CharList cl starting from position int start.
        If the substring is not found 0 is returned.

    public int substringLocation(CharList cl) - returns the index position of the left
        most occurance of the substring CharList cl starting from position 1.  If the
        substring is not found 0 is returned.

    public int substringLocation(String s,int start) - returns the index position of the
        left most occurance of the string in String s starting from position int start.
        If the substring is not found 0 is returned.

    public int substringLocation(String s) - returns the index position of the left most
        occurance of the string in String s starting from position 1.  If the substring
        is not found 0 is returned.
    
    public void clear() - removes all the CharacterNodes from the CharList.

    public String toString() - returns the String representation of the CharList.

class CharacterNode - The class that is used as a node for the character linked list used
     by CharList.

    CharacterNode(char newItem) - creates a new CharacterNode with the data value set to
        the value of char newItem.

    CharacterNode(char newItem, CharacterNode nextNode) - creates a new CharacterNode with
        the data value set to the value of char newItem and sets its next reference to the
        CharacterNode nextNode.
    
    public void setItem(char newItem) - sets the data value of the CharacterNode to the
        value of char newItem

    public char getItem() - returns the data value of the CharacterNode.

    public CharacterNode getNext() - returns a reference to the CharacterNode referenced
        by the private next reference variable.

    public void setNext(CharacterNode nextNode) - sets the value of the next reference
        variable to the CharacterNode nextNode.

class ListIndexOutOfBoundsException - A class that is thrown as an exception when access
    to the list is attempted outside of the valid range.
    
    ListIndexOutOfBoundsException(String s) - creates a ListIndexOutOfBoundsException with
         the String s.
         
*/
//****************************************************************************************



//****************************************************************************************
/*
class CharListTester:  The class that contains the main entry point for the program.  This
    class tests the methods of CharList to make sure that the methods work as specified.
*/
//****************************************************************************************
public class CharListTester {

    //************************************************************************************
    //Purpose:  The main entry poiHP32SIInt for the program.  This routine puts the CharList
    //    through various tests to make sure that the methods of the CharList work as
    //    specified.
    //Preconditions:  None.
    //Postconditions:  The methods of the CharList are called with various inputs and the
    //    results are outputted to the screen.
    //************************************************************************************
    public static void main (String args[]) {
        System.out.println(                                                                
            "***********************************************************************");    
        System.out.println("CharListTester:");                                             
        System.out.println(                                                                
            "This program uses the CharList class to perform string like operations.");    
        System.out.println(                                                                
            "It is designed to make sure the CharList performs as specified.");            
                                                                                           
        System.out.println(                                                                
            "***********************************************************************");    
        System.out.println("Testing the constructors");                                    
        System.out.println("First, we will create an empty CharList1");                    
        CharList cl1 = new CharList();                                                     
        System.out.println("->The current length of the CharList1 is " + cl1.length());    
        System.out.println("->The characters currently in CharList1 are " + cl1);          
        System.out.println(                                                                
            "Now we create a CharList1 by passing in the string \"This is a\"");           
        cl1 = new CharList("This is a");                                                   
        System.out.println("->The current length of the CharList1 is " + cl1.length());    
        System.out.println("->The characters currently in CharList1 are " + cl1);          
        System.out.println("Now we will create a CharList2 by passing in the existing " +  
                           "CharList1");                                                   
        CharList cl2 = new CharList(cl1);                                                  
        System.out.println("->The current length of CharList2 is " + cl2.length());        
        System.out.println("->The characters currently in CharList2 are " + cl2);          
                                                                                           
                                                                                           
        System.out.println(                                                                
            "***********************************************************************");    
        System.out.println("Testing append operations");                                   
        System.out.println("Now we will append \" test strin\" to the end of CharList1");  
        cl1.append(" test strin");                                                         
        System.out.println("->The current length of CharList1 is " + cl1.length());        
        System.out.println("->The characters currently in the CharList1 are " + cl1);      
        System.out.println("Now we will append \'g\' to the end of CharList1");            
        cl1.append('g');                                                                   
        System.out.println("->The current length of CharList1 is " + cl1.length());        
        System.out.println("->The characters currently in CharList1 are " + cl1);          
        System.out.println("Now we will append CharList1 to CharList2");                   
        cl2.append(cl1);                                                                   
        System.out.println("->The current length of CharList2 is " + cl2.length());        
        System.out.println("->The characters currently in CharList2 are " + cl2);          
                                                                                           
        System.out.println(                                                                
            "***********************************************************************");    
        System.out.println("Testing the locating of characters");                          
        System.out.println("->The first position of the char 's' in CharList1 is " +       
                           cl1.charLocation('s'));                                         
        System.out.println("->The first position of the char 's' starting from position "+ 
                           "5 in CharList1 is " + cl1.charLocation('s',5));                
        System.out.println("->The first position of the char 's' starting from position "+ 
                           "17 in CharList1 is " + cl1.charLocation('s',17));              
        System.out.println("->The first position of the char 's' starting from position "+ 
                           "100 in CharList1 is " + cl1.charLocation('s',100));            
        System.out.println(                                                                
            "***********************************************************************");    
        System.out.println("Testing substring operations");                                
        System.out.println(                                                                
            "Now we will construct CharList2 by taking a substring of CharList1 from " +   
            "position 6-7");                                                               
        cl2 = new CharList(cl1.substring(6,2));                                            
        System.out.println("->The current length of CharList2 is " + cl2.length());        
        System.out.println("->The current characters in CharList2 are " + cl2);            
        System.out.println("Now we will construct CharList2 by taking a substring of " +   
                           "CharList1 from position 16 - 100");                            
        cl2 = new CharList(cl1.substring(16,85));                                          
        System.out.println("->The current length of CharList2 is " + cl2.length());        
        System.out.println("->The current characters in CharList2 are " + cl2);            
                                                                                           
                                                                                           
        System.out.println(                                                                
            "***********************************************************************");    
        System.out.println("Testing substring location operations");                       
        System.out.println("->The position of the substring \"string\" in CharList1 is " + 
                           cl1.substringLocation("string"));                               
        System.out.println("->The position of the substring \"string\" in CharList1 " +    
                           "starting from position 17 is " +                               
                           cl1.substringLocation("string",17));                            
        System.out.println(                                                                
            "->The position of the substring \"stringy\" in CharList1 is " +               
            cl1.substringLocation("stringy"));                                             
                                                                                           
        System.out.println(                                                                
            "***********************************************************************");    
        System.out.println("Testing the clear method");                                    
        System.out.println("Now we will clear the CharList");                              
        cl1.clear();                                                                       
        System.out.println("->The current length of the CharList1 is " + cl1.length());    
        System.out.println("->The current characters in the CharList1 are " + cl1);        
    }
}



//****************************************************************************************
/*
class CharList:  A class that implements String like features using a linked list of
    characters.
*/
//****************************************************************************************
class CharList {
    private CharacterNode head;
    private int numItems;

    //************************************************************************************
    //Purpose:  To create a new instance of the CharList class.
    //Preconditions:  None.
    //Postconditions:  Creates a new CharList object setting the head to null and the
    //    numItems to 0.
    //************************************************************************************
    CharList() {
        head = null;
        numItems = 0;
    }

    //************************************************************************************
    //Purpose:  To create a new instance of the CharList class that is holds the same data
    //    as passed in CharList cl.
    //Preconditions:  The passed in CharList cl is a valid CharList object.
    //Postconditions:  A CharList is created with the same data as the passed in CharList
    //    cl.
    //************************************************************************************
    CharList(CharList cl) {
        this();
        for (int i=1;i<=cl.length();i++)
            append(cl.getItem(i));
    }

    //************************************************************************************
    //Purpose:  To create a new instance of the CharList class that holds the same data as
    //    the passed in String s.
    //Preconditions:  The passed in String s is a valid String.
    //Postconditions:  A CharList is created with the characters in the CharList being the
    //    the same as the characters in String s.
    //************************************************************************************
    CharList(String s) {
        this();
        for (int i=0;i<s.length();i++)
            append(s.charAt(i));
    }

        //private List operations*********************************************************

    //************************************************************************************
    //Purpose:  To return whether or not the list of characters is empty.
    //Preconditions:  None.
    //Postconditions:  true is returned if numItems==0, otherewise, false is returned.
    //************************************************************************************
    private boolean isEmpty() {
        return numItems==0;
    }

    //************************************************************************************
    //Purpose:  To return the character in the CharacterNode reference by index.
    //Preconditions:  int index is an index to the character list.
    //Postconditions:  The character referenced by int index is returned.  If int index is
    //    not within the range of valid indices (1 <= index <= numItems), a
    //    ListIndexOutOfBoundsException is thrown.
    //************************************************************************************
    private char getItem(int index) throws ListIndexOutOfBoundsException {
        if (index >=1 && index <= numItems) {
            CharacterNode aNode = find(index);
            return aNode.getItem();
        } else
            throw new ListIndexOutOfBoundsException("List index out of bounds on get.");
    }

    //************************************************************************************
    //Purpose:  To return the number of CharacterNodes in the CharList.
    //Preconditions:  None.
    //Postconditions:  The number of items in the character list is returned.
    //************************************************************************************
    private int size() {
        return numItems;
    }

    //************************************************************************************
    //Purpose:  To remove all the CharacterNodes from the CharList.
    //Preconditions:  None.
    //Postconditions:  The items in the list are removed by setting head=null, which will
    //    cause the list to be garbage collected, and setting numItems=0.
    //************************************************************************************
    private void removeAll() {
        head = null;
        numItems = 0;
    }

    //************************************************************************************
    //Purpose:  To add a new CharacterNode at position index with data value item.
    //Preconditions:  int index is an index to the character list and char item is a valid
    //    char.
    //Postconditions:  The char item is added to the list at position int index.  If int
    //    index is not within a valid range (1 <= index <= numItems+1) a
    //    ListIndexOutOfBoundsException is thrown.
    //************************************************************************************
    private void add(int index, char item) throws ListIndexOutOfBoundsException {
        if (index>=1 && index<=numItems + 1) {
            if (index==1) {
                CharacterNode newNode = new CharacterNode(item, head);
                head = newNode;
            } else {
                CharacterNode prevNode = find(index - 1);
                CharacterNode newNode = new CharacterNode(item,prevNode.getNext());
                prevNode.setNext(newNode);
            }
            numItems++;
        } else {
            throw new ListIndexOutOfBoundsException("List index out of bounds on add.");
        }
    }

        //not in a typical list but added to help with appending to the end of the list***

    //************************************************************************************
    //Purpose:  To add a new CharacterNode at the end of the CharList with data value
    //    item.
    //Preconditions:  char item is a valid char.
    //Postconditions:  char item is added at the end of the list.  If the list was empty
    //    before calling this method then char item is both the first and last character
    //    in the list.
    //************************************************************************************
    private void addAtEnd(char item) {
        add(numItems + 1,item);
    }

    //************************************************************************************
    //Purpose:  To remove the CharacterNode reference by index from the CharList.
    //Preconditions:  int index is an index to the character list.
    //Postconditions:  The character referenced by int index is removed from the character
    //    list.  If int index was not within the valid range (1 <= index <= numItems) a
    //    ListIndexOutOfBoundsException is thrown.
    //************************************************************************************
    private void remove(int index) throws ListIndexOutOfBoundsException {
        if (index>=1 && index<=numItems) {
            if (index==1) {
                head = null;
            } else {
                CharacterNode prevNode = find(index - 1);
                CharacterNode currNode = prevNode.getNext();
                prevNode.setNext(currNode.getNext());
            }
            numItems--;

        } else {
            throw new ListIndexOutOfBoundsException(
                "List index out of bounds on remove.");
        }
    }

    //************************************************************************************
    //Purpose:  To return a reference to the CharacterNode referenced by index.
    //Preconditions:  index is the number of the desired CharacterNode.  Assumes that
    //    1 <= index <= numItems + 1
    //Postconditions:  A reference to the CharacterNode at int index is returned.
    //************************************************************************************
    private CharacterNode find(int index) {
        CharacterNode curr = head;
        for (int i = 1;i < index;i++)
            curr = curr.getNext();
        return curr;
    }

        
        //public CharList operations******************************************************

    //************************************************************************************
    //Purpose:  To return the number of of items or CharacterNodes in the CharList.
    //Preconditions:  None.
    //Postconditions:  Returns the number of items in the character list.
    //************************************************************************************
    public int length() {
        return numItems;
    }

    //************************************************************************************
    //Purpose:  To append the passed in CharList cl to the end of the CharList.
    //Preconditions:  CharList cl references a valid CharList.
    //Postconditions:  The characters of CharList cl are appended to the end of CharList.
    //************************************************************************************
    public void append(CharList cl) {
          //VERY IMPORTANT TEST, if the user attempts to append a
          //CharList to itself an infinite loop would result as
          //this class attempted to append an ever growing CharList,
          //we will make it work so the contents are appended
        if (cl==this) {
            CharList clNew = new CharList(cl);
            cl = clNew;
        }
        for (int i=1;i<=cl.length();i++)
            addAtEnd(cl.getItem(i));
    }

    //************************************************************************************
    //Purpose:  To append the char c to the end of the CharList.
    //Preconditions:  A valid char c is passed into this method.
    //Postconditions:  The char c is added to the end of the character list.
    //************************************************************************************
    public void append(char c) {
        addAtEnd(c);
    }

    //************************************************************************************
    //Purpose:  To append the characters in String s to the end of the CharList.
    //Preconditions:  A valid String s is passed to the method.
    //Postconditions:  The characters of String s are appended to the end of CharList.
    //************************************************************************************
    public void append(String s) {
        for (int i=0;i<s.length();i++)
            addAtEnd(s.charAt(i));
    }

    //************************************************************************************
    //Purpose: To return the location of the first CharacterNode with the same value as
    //    char c starting at location start.
    //Preconditions:  A valid char c and an index position int start are passed to the
    //    method.
    //Postconditions:  The index location of char c within the the character list starting
    //    from position start is returned.  If the character is not found  or start is not
    //    a valid index position, 1 <= start <= numItems, 0 is returned.
    //************************************************************************************
    public int charLocation(char c, int start) {
        int location = 0;
        if (start>=1 && start<=numItems) {
            for (int i = start;i <= numItems;i++)
                if (c==getItem(i)) {
                    location = i;
                    break;
                }
        }
        return location;
    }

    //************************************************************************************
    //Purpose:  To return the location of the first CharacterNode with the same value as
    //    char c starting at position 1.
    //Preconditions:  A valid char c is passed to this method.
    //Postconditions:  The index location of char c within the character list is returned.
    //    If the character is not found 0 is returned.
    //************************************************************************************
    public int charLocation(char c) {
        return charLocation(c,1);
    }

    //************************************************************************************
    //Purpose:  To return a CharList containing a substring from position int start and of
    //    of length int length.
    //Preconditions:  The position to start from is passed in int start and the number
    //    of characters to include in the substring is passed in int length.
    //Postconditions:  The CharList with characters starting at position int start and
    //    extending int length characters is returned.  If start lies outside the valid
    //    range (valid 1<= start <= numItems) or length is not of the valid range
    //    (valid 0 < length) an empty CharList is returned.  If length extends the
    //    substring past the end of the CharList only the available characters to the end
    //    of the CharList are returned.
    //************************************************************************************
    public CharList substring(int start, int length) {
        CharList newCharList = new CharList();
        if (start>=1 && start<=numItems && length>0) {
            int lastChar;
            if (start+length-1>numItems)
                lastChar = numItems;
            else
                lastChar = start+length-1;
            for (int i = start;i <= lastChar;i++)
                newCharList.addAtEnd(getItem(i));
        }
        return newCharList;
    }

    //************************************************************************************
    //Purpose:  To return a CharList containing a substring from position int start to the
    //    end of the CharList.
    //Preconditions:  The index int start of where you want to start pulling the substring
    //    from is passed to this method.
    //Postconditions:  The CharList with characters from index position start to the end
    //    of the CharList is returned.  If int start is not valid
    //    (valid 1 <= start <= numItems) an empty CharList is returned.
    //************************************************************************************
    public CharList substring(int start) {
        return substring(start, numItems - start + 1);
    }

    //************************************************************************************
    //Purpose:  To return the index position of the left most occurance of the substring
    //    CharList cl starting from position int start.
    //Preconditions:  The substring to locate is passed in as CharList cl and the position
    //    to start searching from is passed in in int start.
    //Postconditions:  The index of the location of the substring within the CharList is
    //    returned.  If the substring is not found  or int start is an invalid index
    //    position (valid 1 <= start <= numItems) 0 is returned.
    //************************************************************************************
    public int substringLocation(CharList cl,int start) {
        int location = 0;
            //the last comparison, start+cl.length()-1<=numItems checks to make sure that
            //there is room for the substring being searched for starting at positition
            //start before hitting the end of the string, if there is not, obviously the
            //the string is not going to be found so 0 is returned.
        if(start>=1 && start<=numItems && cl.length()>0 && start+cl.length()-1<=numItems){
            int j;
            for (int i = start;i <= numItems - cl.length() + 1;i++) {
                for (j = 1;j <= cl.length();j++) {
                    if (cl.getItem(j) != getItem(i + j - 1))
                        break;
                }
                if (j>cl.length()) {
                    location = i;
                    break;
                }
            }
        }
        return location;
    }

    //************************************************************************************
    //Purpose:  To return the index position of the left most occurance of the substring
    //    CharList cl starting from position 1.
    //Preconditions:  A valid CharList cl is passed to the method.  
    //Postconditions:  The index location of the substring within the CharList starting
    //    from position 1 is returned.  If it is not found, 0 is returned.
    //************************************************************************************
    public int substringLocation(CharList cl) {
        return substringLocation(cl, 1);
    }

    //************************************************************************************
    //Purpose:  To return the index position of the left most occurance of the string in
    //    String s starting from position int start.
    //Preconditions:  A valid String s and position to begin searching int start are
    //    passed to this method.
    //Postconditions:  The index location of the substring s starting from position start
    //    is returned.  If the substring is not found or int start is an invalid index
    //    position (valid 1 <= start <= numItems) 0 is returned.
    //************************************************************************************
    public int substringLocation(String s,int start) {
        CharList cl = new CharList(s);
        return substringLocation(cl,start);
    }

    //************************************************************************************
    //Purpose:  To return the index position of the left most occurance of the string in
    //    String s starting from position 1.
    //Preconditions:  A valid String s is passed to this method.
    //Postconditions:  The index location of the substring starting from position 1 is
    //    returned.  If it is not found 0 is returned.
    //************************************************************************************
    public int substringLocation(String s) {
        return substringLocation(s,1);
    }

    //************************************************************************************
    //Purpose:  To remove all the CharacterNodes from the CharList.
    //Preconditions:  None.
    //Postconditions:  All of the CharacterNodes of the list are removed.
    //************************************************************************************
    public void clear() {
        removeAll();
    }

    //************************************************************************************
    //Purpose:  To return the String representation of of the CharList.
    //Preconditions:  None.
    //Postconditions:  A String representation of the CharList is returned.
    //************************************************************************************
    public String toString() {
        String s = "";
        for (int i=1;i<=numItems;i++)
            s = s + getItem(i);
        return s;
    }


}



//****************************************************************************************
/*
class CharacterNode:  This class is used as the node for the character linked list
    CharList.
*/
//****************************************************************************************
class CharacterNode {
    private char item;
    private CharacterNode next;

    //************************************************************************************
    //Purpose:  To create a new CharacterNode with the data value set to the value of char
    //    newItem.
    //Preconditions:  A valid char newItem is passed to this method.
    //Postconditions:  A new CharacterNode is created with the data item holding the char
    //    in newItem and the next reference being set to null.
    //************************************************************************************
    CharacterNode(char newItem) {
        item = newItem;
        next = null;
    }

    //************************************************************************************
    //Purpose:  To create a new CharacterNode with the data value set to the value of char
    //    newItem and sets its next reference to the CharacterNode nextNode.
    //Preconditions:  A valid char newItem and CharacterNode nextNode are passed to this
    //    method.
    //Postconditions:  A new CharacterNode is created with the data item holding the char
    //    in newItem and the next reference being set the the CharacterNode newNode.
    //************************************************************************************
    CharacterNode(char newItem, CharacterNode nextNode) {
        item = newItem;
        next = nextNode;
    }
    
    //************************************************************************************
    //Purpose:  To set the data value of the CharacterNode to the value of char newItem.
    //Preconditions:  A valid char newItem is passed to this method.
    //Postconditions:  The value of item is set to the char in newItem.
    //************************************************************************************
    public void setItem(char newItem) {
        item = newItem;
    }
    
    //************************************************************************************
    //Purpose:  To return the data value of the CharacterNode.
    //Preconditions:  None.
    //Postconditions:  The character value in item is returned.
    //************************************************************************************
    public char getItem() {
        return item;
    }

    //************************************************************************************
    //Purpose:  To return a reference to the CharacterNode referenced by the private next
    //    reference variable.
    //Preconditions:  None.
    //Postconditions:  The reference variable to a CharacterNode held in next is returned.
    //************************************************************************************
    public CharacterNode getNext() {
        return next;
    }

    //************************************************************************************
    //Purpose:  To set the value of the next reference variable to the CharacterNode
    //    nextNode.
    //Preconditions:  A valid CharacterNode nextNode is passed to this method.
    //Postconditions:  The CharacterNode reference variable next is set to the
    //    CharacterNode nextNode.
    //************************************************************************************
    public void setNext(CharacterNode nextNode) {
        next = nextNode;
    }
}



//****************************************************************************************
/*
class LinstIndexOutOfBoundsException:  This class is used for throwing exceptions when
    working with the linked list of characters and attempts are made to access the list at
    invalid index positions.
*/
//****************************************************************************************
class ListIndexOutOfBoundsException extends IndexOutOfBoundsException {

    //************************************************************************************
    //Purpose:  To create an exception to be thrown in cases where list access is
    //    attempted outside of the valid range.
    //Preconditions:  None.
    //Postconditions:  A ListIndexOutOfBoundsException is created with String s.
    //************************************************************************************
    public ListIndexOutOfBoundsException(String s) {
        super(s);
    }
}
