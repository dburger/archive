//****************************************************************************************
/*

Programmer:      David J. Burger
Project Number:  3
Course:          ICS 211
Filename:        TowersOfHanoi.java

Program Description:  This program shows how to solve the famous Towers of Hanoi problem
                      starting with a user supplied number of disks on the source pole.

class TowersOfHanoi - The class containing the main entry point for the program.  It is
                      designed to run the solveTowers method with user supplied input,
                      showing how to solve the Towers of Hanoi problem given the input.
                      
    static void main(String args[]) - The main entry point for the program.  This method
        accepts user input and executes the solveTowers method with that input.  0 is
        entered to quit the program.

    static void solveTowers(int count, char source, char dest, char spare) - This method
        shows the steps necessary to solve the Towers of Hanoi problem with the given
        inputs.

class TowersActivationRecord - A class used to simulate activation records from a
    recursive version of solveTowers.
            
    TowersActivationRecord(int theDiskCount, char theSource, char theDest, char theSpare,
                           char theRecursionPoint) - creates a new instance of the
        TowersActivationRecord class initializing the private data fields to the passed
        in values.    
        
    public int diskCount() - this method returns the count of disks for the activation
        record held in int diskCount.
    
    public char source() - this method returns the source pole for the activation record
        held in char source.

    public char dest() - this method returns the destination pole for the activation
        record held in char dest.
    
    public char spare() - this method returns the spare pole for the activation record
        held in char spare.

    public char recursionPoint() - this method returns the recursion point for the
        activation record held in char recursionPoint.

    public void setRecursionPoint(char theRecursionPoint) - this method changes the
        recursion point for the activation record.
        
class Node - A class used as a node object used in the implementation of
    StackReferenceBased

    Node(Object anObject) - Creates a new Node object with the item field set to the
        Object anObject

    Node(Object anObject, Node nextNode) - Creates a new Node object with the item field
        set to Object anObject and the Node next set to Node nextNode

    public void setNext(Node nextNode) - Sets the Node next reference to the Node held in
        Node nextNode

    public Node getNext() - Returns a reference to the Node object held in the Node next
        data field.
    
    public Object getItem() - Returns a reference to the Object held in the Object item
        reference variable.
        
class StackException - A class used for throwing exceptions when working with stacks.

    StackException(String s) - Creates and returns a reference to a StackException with
        the message set to String s.

interface StackInterface - A standard interface to be implemented by Abstract Data Types
    of the stack type.
    
    public boolean isEmpty() - Returns whether or not the stack is empty.

    public void push(Object newItem) - Puts the Object newItem at the top of the stack.

    public Object pop() throws StackException - Returns a reference to the top item of the
        stack and removes it as well.  If the stack was empty, a StackException is thrown.

    public void popAll() - Removes all items from the stack.

    public Object peek() throws StackException - Returns a reference to the top item on
        the stack.  If the stack is empty, a StackException is thrown.
        
class StackReferenceBased - A class that implements a stack using a reference based
    implementation.
    
    StackReferenceBased() - Creates and returns a reference to a reference based stack.

    public boolean isEmpty() - Returns whether or not the stack is empty.

    public Object peek() throws StackException - Returns a reference to the top item on
        the stack.  If the stack is empty, a StackException is thrown.

    public void push(Object newItem) - Puts the Object newItem at the top of the stack.
    
    public Object pop() throws StackException - Returns a reference to the top item of the
        stack and removes it as well.  If the stack was empty, a StackException is thrown.

    public void popAll() - Removes all items from the stack.

*/
//****************************************************************************************

import java.io.*;

//****************************************************************************************
/*
class TowersOfHanoi - The class containing the main entry point for the program.  It is
                      designed to run the solveTowers method with user supplied input,
                      showing how to solve the Towers of Hanoi problem given the input.
*/
//****************************************************************************************
public class TowersOfHanoi {

    //Purpose:  this is the main entry point of the program, it allows for the testing
    //    of the solveTowers method
    //Preconditions:  none
    //Postconditions:  the solveTowers method is called with user supplied inputs and the
    //    moves necessary to complete the Towers of Hanoi with the given inputs are
    //    displayed on the screen.  the user enters 0 to quit
    public static void main(String args[]) {
        BufferedReader stdin = new BufferedReader(new InputStreamReader(System.in));
        System.out.println("======================================================" +
                           "===========");
        System.out.println("This program solves the Towers of Hanoi problem.");
        System.out.println("The problem starts with a given number of disks on pole A.");
        System.out.println("The destination is pole B and there is a spare pole C.");
        System.out.println("The object is to move all the disks, one disk at a time,");
        System.out.println("from pole A to pole B without ever placing a larger disk");
        System.out.println("over a smaller one.");
        System.out.println("======================================================" +
                           "===========");
        System.out.println("Please enter the number of disks on starting pole A or" +
                           " 0 to quit.");
        try {
            int nInput;
            String sInput = stdin.readLine();
            while (!sInput.equals("0")) {
                try {
                    //NumberFormatException will be thrown if the conversion does not work
                    nInput = Integer.parseInt(sInput);
                    //we will throw the same exception if the integer is less than 0
                    if (nInput<0) throw new NumberFormatException();
                    solveTowers(nInput,'A','B','C');
                } catch (NumberFormatException e) {
                    System.out.println("The number of disks must be an integer > 0.");
                } catch (RuntimeException e) {
                    System.out.println("Exception: " + e + " has occurred");
                }
                System.out.println("Please enter the number of disks on starting pole A" +
                                   " or enter 0 to quit.");
                sInput = stdin.readLine();
            }
        } catch (IOException e) {
            System.out.println("An IOException occurred, the program will be shut down.");
        }
        
    }

    //Purpose:  to show the steps necessary to solve the Towers of Hanoi problem
    //Preconditions:  a nonnegative number of disks on the source pole is passed
    //    in as int count, the names of the source, destination, and spare poles
    //    are passed in as char source, char dest, and char spare respectively
    //Postconditions:  the steps necessary to solve the Towers of Hanoi problem with
    //    the given inputs is displayed on the screen
    public static void solveTowers(int count, char source, char dest, char spare) {
        StackReferenceBased stack = new StackReferenceBased();
        TowersActivationRecord tar = new TowersActivationRecord(count,source,dest,spare,
                                                                ' ');
        stack.push(tar);
        while (!stack.isEmpty()) {
            //make tar a reference to the top TowersActivationRecord on the stack
            tar = (TowersActivationRecord)stack.peek();
            if (tar.diskCount()==1) {
                System.out.println("Move the top disk from pole " + tar.source()
                                   + " to pole " + tar.dest() + ".");
                stack.pop();
            } else {
                switch (tar.recursionPoint()) {
                    case (' '):
                        //modify the activation record to indicate its new recursion
                        //point
                        tar.setRecursionPoint('x');
                        //create and push the new activation record on
                        tar = new TowersActivationRecord(tar.diskCount()-1,tar.source(),
                                                         tar.spare(),tar.dest(),' ');
                        stack.push(tar);
                        break;
                    case ('x'):
                        //modify the activation record to indicate its new recursion
                        //point
                        tar.setRecursionPoint('y');
                        //create and push the new activation record on
                        tar = new TowersActivationRecord(1,tar.source(),tar.dest(),
                                                         tar.spare(),' ');
                        stack.push(tar);
                        break;
                    case ('y'):
                        //modify the activation record to indicate its new recursion
                        //point
                        tar.setRecursionPoint('z');
                        //create and push the new activation record on
                        tar = new TowersActivationRecord(tar.diskCount()-1,tar.spare(),
                                                         tar.dest(),tar.source(),' ');
                        stack.push(tar);
                        break;
                    case ('z'):
                        //we returned to point z, the activation record will be removed
                        stack.pop();
                        break;
                } //switch
            } //if
        } //while
    } //solveTowers
}


//****************************************************************************************
/*
class TowersActivationRecord - A class used to simulate activation records from the
    recursive version of solveTowers shown here (recursion points labeled with x, y,
    and z):
    
public static void solveTowers(int count, char source, char destination, char spare) {
    if (count==1) {
        System.out.println("Move top disk from pole " + source +
                           " to pole " + destination);
    }
    else {
        solveTowers(count-1, source, spare, destination); //x
        solveTowers(1, source, destination, spare);       //y
        solveTowers(count-1, spare, destination, source); //z
    }
}
*/
//****************************************************************************************
class TowersActivationRecord {

    private int diskCount;
    private char source;
    private char dest;
    private char spare;
    private char recursionPoint;

    //Purpose:  to create a new instance of the TowersActivationRecord class
    //Preconditions:  int theDiskCount is the number of disks for the activation record,
    //    the source, destination, and spare poles are passed in as char theSource,
    //    char theDest, and char theSpare respectively.  The point from which the
    //    recursion would be taking place from is passed in char theRecursionPoint with
    //    ' ' indicating no recursion from this activation record, 'x' indicating
    //    recursion from point x, 'y' indicating recursion from point y, and 'z'
    //    indicating recursion from point z.  For reference the recursive version of the
    //    method that we are implementing iteratively is shown at the top of this
    //    class
    //Postconditions:  a TowersActivationRecord object is created with the private data
    //    fields matching those supplied in this constructor
    TowersActivationRecord(int theDiskCount, char theSource, char theDest, char theSpare,
                           char theRecursionPoint) {
        diskCount = theDiskCount;
        source = theSource;
        dest = theDest;
        spare = theSpare;
        recursionPoint = theRecursionPoint;
    }

    //Purpose:  to return the count of disks for the activation record held in
    //    int diskCount
    //Preconditions:  none
    //Postconditions:  the value of int diskCount is returned
    public int diskCount() {
        return diskCount;
    }

    //Purpose:  to return the source pole for the activation record held in char source
    //Preconditions:  none
    //Postconditions:  the value of char source is returned
    public char source() {
        return source;
    }

    //Purpose:  to return the destination pole for the activation record held in char dest
    //Preconditions:  none
    //Postconditions:  the value of char dest is returned
    public char dest() {
        return dest;
    }

    //Purpose:  to return the spare pole for the activation record held in char spare
    //Preconditions:  none
    //Postconditions:  the value of char spare is returned
    public char spare() {
        return spare;
    }

    //Purpose:  to return the recursion point for the activation record held in
    //    char recursionPoint
    //Preconditions:  none
    //Postconditions:  the value of char recursionPoint is returned
    public char recursionPoint() {
        return recursionPoint;
    }

    //Purpose:  to change the recursion point for the activation record
    //Preconditions:  char theRecursionPoint is passed to the method
    //    representing the recursion point for the activation record
    //Postconditions:  char recursionPoint is changed to the value in
    //    char theRecursionPoint
    public void setRecursionPoint(char theRecursionPoint) {
        recursionPoint = theRecursionPoint;
    }
}
