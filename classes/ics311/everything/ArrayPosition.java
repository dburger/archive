/**
 * The type of object held in an ArraySequence
 */
public class ArrayPosition implements Position {

    /**
     * the Object held in this ArrayPosition
     */
    private Object elem;
    /**
     * the Container for this ArrayPosition
     */
    private Container cont;
    /**
     * the index in the array for this ArrayPosition
     */
    private int index;

    /*
     * default constructor for ArrayPosition object
     */
    ArrayPosition() {
        elem = null;
        cont = null;
    }

    /**
     * constructor for ArrayPosition object
     * 
     * @param i       index of position within the contiainer
     * @param e       element to hold in this position
     * @param c       container holding this position
     */
    ArrayPosition(int i, Object e, Container c) {
        index = i;
        elem = e;
        cont = c;
    }

    /**
     * returns element stored at this position
     *
     * @return Object  element stored here
     */
    public Object element() {
        return elem;
    }

    /**
     * return the container holding this position
     *
     * @return Container = container holding this position
     */
    public Container container() {
        return cont;
    }

    /**
     * returns the index of this position
     * 
     * @return int = index of this position within the container
     */
    protected int index() {
        return index;
    }

    /**
     * sets the element held in this position
     * 
     * @param e       element to hold in this position
     */
    protected void setElement(Object e) {
        elem = e;
    }

    /**
     * sets the container for this position
     * 
     * @param c       container that holds this position
     */
    protected void setContainer(Container c) {
        cont = c;
    }

    /**
     * sets the index for this position within the container
     * 
     * @param i       index for this position within the container
     */
    protected void setIndex(int i) {
        index = i;
    }
}
