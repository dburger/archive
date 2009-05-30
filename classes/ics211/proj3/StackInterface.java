//****************************************************************************************
/*

Programmer:      David J. Burger
Project Number:  3
Course:          ICS 211
Filename:        StackInterface.java

Interface Description:  A standard interface to be implemented by Abstract Data Types
    of the stack type.
    
    public boolean isEmpty() - Returns whether or not the stack is empty.

    public void push(Object newItem) - Puts the Object newItem at the top of the stack.

    public Object pop() throws StackException - Returns a reference to the top item of the
        stack and removes it as well.  If the stack was empty, a StackException is thrown.

    public void popAll() - Removes all items from the stack.

    public Object peek() throws StackException - Returns a reference to the top item on
        the stack.  If the stack is empty, a StackException is thrown.

*/
//****************************************************************************************
  
public interface StackInterface {

    //Purpose:  to find out whether or not the stack is empty
    //Preconditions:  none
    //Postconditions:  true is returned if the stack is empty,
    //    otherwise false is returned
    public boolean isEmpty();

    //Purpose:  to put a new item on the stack
    //Preconditions:  none
    //Postconditions:  Object newItem is placed on the top of
    //    the stack
    public void push(Object newItem);

    //Purpose:  to return and remove the top item of the stack
    //Preconditions:  none
    //Postconditions:  the top item of the stack is returned
    //    and removed.  If the stack was empty when this is called
    //    a StackException is thrown
    public Object pop() throws StackException;

    //Purpose:  all items are removed from the stack
    //Preconditions:  none
    //Postconditions:  the stack is empty
    public void popAll();

    //Purpose:  to return the top item of the stack
    //Preconditions:  none
    //Postconditions:  the top item of the stack is returned, if
    //    the stack was empty when this routine is called a
    //    StackException is thrown
    public Object peek() throws StackException;
}
