//****************************************************************************************
/*

Programmer:      David J. Burger
Project Number:  3
Course:          ICS 211
Filename:        StackReferenceBased.java

Class Description:  A class that implements a stack using a reference based
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

public class StackReferenceBased implements StackInterface {

    private Node top;
    

    //Purpose:  to create a reference based stack
    //Preconditions:  none
    //Postconditions:  a reference based stack is created
    //    and returned
    StackReferenceBased() {
        top = null;
    }

    //Purpose:  to find out whether or not the stack is empty
    //Preconditions:  none
    //Postconditions:  true is returned if the stack is empty,
    //    otherwise false is returned
    public boolean isEmpty() {
        return top==null;
    }

    //Purpose:  to return the top item of the stack
    //Preconditions:  none
    //Postconditions:  the top item of the stack is returned, if
    //    the stack was empty when this routine is called a
    //    StackException is thrown
    public Object peek() throws StackException {
        if (isEmpty())
            throw new StackException("Stack exception on peek, empty stack.");
        else
            return top.getItem();            
    }

    //Purpose:  to put a new item on the stack
    //Preconditions:  none
    //Postconditions:  Object newItem is placed on the top of
    //    the stack
    public void push(Object newItem) {
        Node newNode = new Node(newItem,top);
        top = newNode;
    }

    //Purpose:  to return and remove the top item of the stack
    //Preconditions:  none
    //Postconditions:  the top item of the stack is returned
    //    and removed.  If the stack was empty when this is called
    //    a StackException is thrown
    public Object pop() throws StackException {
        if (isEmpty())
            throw new StackException("Stack exception on pop, stack empty.");
        else {
            Object theData = top.getItem();
            top = top.getNext();
            return theData;
        }
    }

    //Purpose:  all items are removed from the stack
    //Preconditions:  none
    //Postconditions:  the stack is empty
    public void popAll() {
        top = null;
    }

}
