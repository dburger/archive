//****************************************************************************************
/*

Programmer:      David J. Burger
Project Number:  3
Course:          ICS 211
Filename:        StackException.java

Class Description:  This class provides an exception to be used when working with
    stacks.

    StackException(String s) - Creates and returns a reference to a StackException with
        the message set to String s.
            
*/
//****************************************************************************************                      
public class StackException extends RuntimeException {

    //Purpose:  to create an exception to be used when working with stacks
    //Preconditions:  none
    //Postconditions:  a StackException is created and returned
    StackException(String s) {
        super(s);
    }

}
