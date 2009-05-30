//import java.util.Enumeration;
public class LinkedBinaryTree implements BinaryTree {

    private Position root; //reference to the root
    private int size;      //number of nodes

    public LinkedBinaryTree() {
        root = new Node(null,null,null,null,this);
        size = 1;
    }

   /**
     * returns how many elements are in the container.
     *
     * @return int = number of elements in the container.
     */
    public int size() {
        return size;
    }

    /**
     * returns true if the container is empty, false otherwise.
     *
     * @return boolean true if container is empty
     */
    public boolean isEmpty() {
        return size==0;
    }

    /**
     * removes the external Node v and its parent u, replacing u with the
     * sibling of v, returning the element previously stored at u
     *
     * @param v      the external node to remove
     * @return Object = the Object previously stored at the parent of v
     */
     public Object removeAboveExternal(Position p) throws InvalidPositionException {         
         checkPosition(p);
         if (!isExternal(p))
             throw new InvalidPositionException("Given node not external on removeAboveExternal.");
         if(isRoot(p))
             throw new InvalidPositionException("Cannot remove root node on removeAboveExternal.");
         //nodes named according to diagram in Goodrich and Tamassia
         //p. 162.
         //w = the node called upon and v is the parent
         //these nodes are removed and replaced by z,
         //the sibling of w
         Node w = (Node) p;
         Node v = w.getParent();
         Node u = v.getParent();
         Node z = (Node)sibling(w);
         //if v was the root set
         //z as the root
         if(isRoot(v)) {
             setRoot(z);
         } else {  //make sure the parent of v points down at z
             if(v.getParent().getRight() == v)
                 u.setRight(z);
             else //if(v.getParent().getLeft() == v)
                 u.setLeft(z);
         }
         z.setParent(u);
         //invalidate removed positions for this container
         v.setContainer(null);
         w.setContainer(null);
         //removed two nodes
         size -= 2;
         return v.element();
     }

    /**
     * transforms external Node v into an internal node by creating two children and making them the left and right children of v
     *
     * @param v      the Position to add children to and make internal
     */
    public void expandExternal(Position v) throws InvalidPositionException {
        checkPosition(v);
        if (!isExternal(v))
            throw new InvalidPositionException("Given node not external on expandExternal.");
        ((Node)v).setLeft(new Node(null,(Node)v,null,null,this));
        ((Node)v).setRight(new Node(null,(Node)v,null,null,this));
        size+=2;
    }

    /**
     * returns the rightChild of a Position v
     *
     * @param v      the Position to return the rightChild of
     * @return Position = rightChild of Position v
     */    
    public Position rightChild(Position v) throws InvalidPositionException {
        checkPosition(v);
        return ((Node)v).getRight();
    }

    /**
     * returns the leftChild of a Position v
     *
     * @param v      the Position to return the leftChild of
     * @return Position = leftChild of Position v
     */
    public Position leftChild(Position v) throws InvalidPositionException {
        checkPosition(v);
        return ((Node)v).getLeft();
    }
    
    /**
     * returns the parent of Position v
     *
     * @param v      the Position to return the parent of
     * @return Position = parent of v
     */
    public Position parent(Position v) throws InvalidPositionException {
        checkPosition(v);
        return ((Node)v).getParent();
    }

    /**
     * returns the sibling of a Position v
     * 
     * @param v      the Position to return the sibling of
     * @return Position = sibling of Position v
     */
    public Position sibling(Position v) throws InvalidPositionException {
        checkPosition(v);
        if (isRoot(v))
            throw new InvalidPositionException("Root has no sibling.");
        Node parent = (Node)parent(v);
        Position sib = parent.getRight();
        if (v==sib)
            sib = parent.getLeft();
        return sib;
    }

    /**
     * returns the root of the tree
     *
     * @return Position = root of the tree
     */
    public Position root() {
        return root;
    }

    /**
     * sets the root node for the tree
     * 
     * @param r      the new root node of the tree
     */
    protected void setRoot(Node r) {
        root = r;
    }

    /**
     * determines whether or not v is external
     *
     * @param v      the Position to check if external
     * @return boolean = true if external, false otherwise
     */
    public boolean isExternal(Position v) throws InvalidPositionException {
        checkPosition(v);
        return ((Node)v).getLeft()==null && ((Node)v).getRight()==null;
    }

    /**
     * determines whether or not v is internal
     *
     * @param v      the Position to check if internal
     * @return boolean = true if internal, false otherwise
     */
    public boolean isInternal(Position v) throws InvalidPositionException {
        checkPosition(v);
        return ((Node)v).getLeft()!=null && ((Node)v).getRight()!=null;
    }

    /**
     * determine whether Position v is the root of the tree
     *
     * @param v      the Position to check if root of tree
     * @return boolean = true if v is the root, false otherwise
     */
    public boolean isRoot(Position v) throws InvalidPositionException {
        checkPosition(v);
        return v==root;
    }

    /**
     * returns an Enumeration of the children of v
     *
     * @param v      Position to return the Enumeration of the children of
     * @return Enumeration = children Positions of v
     */
    //public Enumeration children(Position v)

    /**
     * returns an Enumeration of the elements in the PositionalContainer
     *
     * @return Enumeration = enumeration of the elements in the PositionalContainer
     */
    //public Enumeration elements()

    /**
     * returns an Enumeration of the Positions in the PositionalContainer
     *
     * @return Enumeration = enumeration of the Positions in the PositionalContainer
     */
    //public Enumeration positions()

    /**
     * swaps the elements at Positions v and w
     *
     * @param v      first Position to swap
     * @param w      second Position to swap
     */
    public void swap(Position v, Position w) throws InvalidPositionException {
        checkPosition(v);
        checkPosition(w);
        Object temp = ((Node)v).element();
        ((Node)v).setElement(((Node)w).element());
        ((Node)w).setElement(temp);
    }

    /**
     * replaces the element at Position v with Object e and returns the current Object stored at v
     *
     * @param v      Position to replace at
     * @param e      new element for Position v
     * @return the Object that was stored at Position v
     */
    public Object replace(Position v, Object e) throws InvalidPositionException {
        Object temp = ((Node)v).element();
        ((Node)v).setElement(e);
        return temp;
    }

    protected void checkPosition(Position v) throws InvalidPositionException {
        if (v.container()!=this)
            throw new InvalidPositionException("Position does not belong to this container.");
    }
}
