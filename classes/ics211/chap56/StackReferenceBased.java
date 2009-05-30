public class StackReferenceBased 
                  implements StackInterface {
  private Node top;

  public StackReferenceBased() {
    top = null; 
  }  // end default constructor
  
  //Purpose:  to display all the items in the stack as a debugging aid.
  //Preconditions:  none.
  //Postconditions:  the contents of the stack are displayed with
  //    System.out.println statements.  The contents of the stack
  //    are unaffected.
  public void display() {
      Object anObject;
      StackReferenceBased tempStack = new StackReferenceBased();
      while (!isEmpty()) {
          anObject = pop();
          System.out.println(anObject);
          tempStack.push(anObject);
      }
      while (!tempStack.isEmpty()) {
          anObject = tempStack.pop();
          push(anObject);
      }
  }
  
  //Purpose:  to display all the items in the stack as a debugging aid.
  //Preconditions:  none.
  //Postconditions:  the contents of the stack are displayed with
  //    System.out.println statements.  The contents of the stack
  //    are unaffected.
  public void display() {
      Object anObject;
      Node curr = top;
      while (curr!=null) {
          anObject = curr.getItem();
          System.out.println(anObject);
          curr = curr.getNext();
      }
  }

  public boolean isEmpty() {
    return top ==  null;
  }  // end isEmpty

  public void push(Object newItem) {
    top = new Node(newItem, top);
  }  // end push
  
  public Object pop() throws StackException {
    if (!isEmpty()) {
      Node temp = top;
      top = top.getNext();
      return temp.getItem();
    }
    else {
      throw new StackException("StackException on " +
                               "pop: stack empty");
    }  // end if
  }  // end pop
  
  public void popAll() {
    top = null;
  }  // end popAll
  
  public Object peek() throws StackException {
    if (!isEmpty()) {
      return top.getItem();
    }
    else {
      throw new StackException("StackException on " +
                               "peek: stack empty");
    }  // end if
  }  // end peek
}  // end StackReferenceBased