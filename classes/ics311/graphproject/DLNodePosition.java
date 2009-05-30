/**
 * The node object for the LinkedSequence
 */
public class DLNodePosition implements Position {
    /**
     * link to previous and next nodes
     */
    private DLNodePosition prev, next;
    /**
     * the object held at this node
     */
    private Object element;
    /**
     * the Container for this node
     */
    private Container cont;

    /**
     * constructor for DLNodePosition
     *
     * @param newPrev   DLNodePosition newPrev = previous node
     * @param newNext   DLNodePositionNext newNext = next node
     * @param container Container container = container for this position
     * @param elem      Object elem = element this position holds
     */
    DLNodePosition(DLNodePosition newPrev, DLNodePosition newNext,
                   Container container, Object elem) {
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
    public Object element() {
        return element;
    }

    /**
     * return the container holding this position
     *
     * @return Container = container holding this position
     */
    public Container container() throws InvalidPositionException {
        return cont;
    }

    /**
     * return the next node for this position
     *
     * @return DLNodePosition = next node for this position
     */
    DLNodePosition getNext() {
        return next;
    }

    /**
     * return the previous node for this position
     *
     * @return DLNodePosition = previous node for this position
     */
    DLNodePosition getPrev() {
        return prev;
    }

    /**
     * sets the next node for this position
     *
     * @param newNext  next node for this position
     */
    protected void setNext(DLNodePosition newNext) {
        next = newNext;
    }

    /**
     * sets the previous node for this position
     *
     * @param newPrev  previous node for this position
     */
    protected void setPrev(DLNodePosition newPrev) {
        prev = newPrev;
    }

    /**
     * sets the element for this position
     *
     * @param newElement  element for this position
     */
    protected void setElement(Object newElement) {
        element = newElement;
    }

    /**
     * sets the new container for this position
     *
     * @param newCont  container for this position
     */
    protected void setContainer(Container newCont) {
        cont = newCont;
    }

}
