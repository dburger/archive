/**
 * Represents an abstract position object.  It is held 
 * within a container, and holds an element.
 * It must retain references to both.
 *
 *
 */
class NSNode implements Position {

  private NSNode prev, next;
  private Object element;
  private Container cont;

  NSNode(NSNode newPrev, NSNode newNext, Container container, Object elem) {
    prev = newPrev;
    next = newNext;
    cont = container;
    element = elem;
  }
  
  /**
   * returns element stored at this position
   *
   * @return Object = element stored here
   */
  public Object element() throws InvalidPositionException {
    if(cont == null)
      throw new InvalidPositionException
        ("Position has no container");
    return element;
  }

  /**
   * return the container holding this position
   *
   * @return Container = container holding this position
   */
  public Container container() throws InvalidPositionException {
    if(cont == null)
      throw new InvalidPositionException
        ("Position has no container");
    return cont;
  }

  NSNode getNext() { return next; }
  NSNode getPrev() { return prev; }

  void setNext(NSNode newNext) { next = newNext; }
  void setPrev(NSNode newPrev) { prev = newPrev; }
  void setElement(Object newElement) { element = newElement; }
  void setContainer(Container newCont) { cont = newCont; }

}
