/**
 * A Node class used in tree ADT's
 * 
 * @author digitalOverflow
 */
public class Node implements Position {

    private Container container;  //container storing this node
    private Object element;       //object stored at this node

    private Node left;            //left child of this node
    private Node right;           //right child of this node
    private Node parent;          //parent of this node

    /**
     * default constructor
     */
    public Node() {};

    /**
     * parameterized constructor
     * 
     * @param o      Object to be held in Node
     * @param u      parent of this Node
     * @param v      left child of this Node
     * @param w      right child of this Node
     * @param c      container of this Node
     */
    public Node(Object o,Node u,Node v,Node w,Container c) {
        setElement(o);
        setContainer(c);
        setParent(u);
        setLeft(v);
        setRight(w);
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
     * sets the Object for this Node
     * 
     * @param o      the new Object for this Node
     */
    protected void setElement(Object o) {
        element = o;
    }

    /**
     * return the container holding this position
     *
     * @return Container = container holding this position
     */
    public Container container() {
        return container;
    }

    /**
     * sets the Container for this Node
     * 
     * @param c      the Container for this Node
     */
    protected void setContainer(Container c) {
        container = c;
    }

    /**
     * returns the left child of this Node
     * 
     * @return left child of this Node
     */
    protected Node getLeft() {
        return left;
    }

    /**
     * sets the left child of this Node
     * 
     * @param v      Node = left child of this Node
     */
    protected void setLeft(Node v) {
        left = v;
    }

    /**
     * returns the right child of this Node
     * 
     * @return Node = right child of this Node
     */
    protected Node getRight() {
        return right;
    }

    /**
     * sets of the right child of this Node
     * 
     * @param v      right child of this Node
     */
    protected void setRight(Node v) {
        right = v;
    }

    /**
     * returns the parent of this Node
     * 
     * @return Node = parent of this Node
     */
    protected Node getParent() {
        return parent;
    }

    /**
     * sets the parent of this Node
     * 
     * @param v      Node = parent of this Node
     */
    protected void setParent(Node v) {
        parent = v;
    }
}
