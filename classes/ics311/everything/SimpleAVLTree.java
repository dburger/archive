/**
 * A simple avl tree.
 */
public class SimpleAVLTree extends SimpleBinarySearchTree implements Dictionary {
    /**
     * Basic constructor for SimpleAVLTree
     * 
     * @param c      comparator for AVL tree
     */
    public SimpleAVLTree(Comparator c)  {
        super(c);
        T = new RestructurableNodeBinaryTree();
    }

    /**
     * determines the height of a given Position p
     * 
     * @param p      the Position to determine the heigh tof
     * @return int = height of Position p
     */
    private int height(Position p)  {
        if (T.isExternal(p))
            return 0;
        else
            return((AVLItem) p.element()).height();
    }

    /**
     * sets the height for a given Position p
     * 
     * @param p      the Position to set the height of
     */
    private void setHeight(Position p)  { // called only if p is internal
        ((AVLItem) p.element()).setHeight(1+Math.max(height(T.leftChild(p)),
                                                     height(T.rightChild(p))));
    }

    /**
     * determines whether or not the tree is balanced at Position p
     * 
     * @param p      the Position to check for balance
     * @return boolean = true if balanced, false otherwise
     */
    private boolean isBalanced(Position p)  {
        // test whether node p has balance factor between -1 and 1
        int bf = height(T.leftChild(p)) - height(T.rightChild(p));
        return((-1 <= bf) &&  (bf <= 1));
    }

    /**
     * returns the taller child of a given Position p
     * 
     * @param p      node to return the taller child of
     * @return Position = node representing taller child
     */
    private Position tallerChild(Position p)  {
        // return a child of p with height no smaller than that of the other child
        if (height(T.leftChild(p)) >= height(T.rightChild(p)))
            return T.leftChild(p);
        else
            return T.rightChild(p);
    }

    /**
     * backtracks to the root of the tree starting from zPos rebalancing where necessary
     * 
     * @param zPos   node to check for imbalance
     */
    private void rebalance(Position zPos) {
        // traverse the path of T from zPos to the root; for each node encountered,
        // recompute its height and perform a rotation if it is unbalanced
        while (!T.isRoot(zPos)) {
            zPos = T.parent(zPos);
            setHeight(zPos);
            if (!isBalanced(zPos)) { // perform a rotation
                Position xPos =  tallerChild(tallerChild(zPos));
                zPos = ((RestructurableNodeBinaryTree)T).restructure(xPos);
                setHeight(T.leftChild(zPos));
                setHeight(T.rightChild(zPos));
                setHeight(zPos);
            }
        }
    }

    /**
     * inserts the given Object into the tree with the given key
     * 
     * @param key     key of item to insert
     * @param element element of insertion
     * @exception InvalidKeyException
     */
    public void insertItem(Object key, Object element)
    throws InvalidKeyException  {
        super.insertItem(key, element);// may throw an InvalidKeyException
        Position zPos = actionPos; // start at the insertion position
        T.replace(zPos, new AVLItem(key, element, 1));
        rebalance(zPos);
    }

    /**
     * removes and returns the Object stored with key key
     * 
     * @param key    the key of the Object to return
     * @return Object = the Object in the tree with the given key or NO_SUCH_KEY if it does not exist
     * @exception InvalidKeyException
     */
    public Object remove(Object key) throws InvalidKeyException {
        Object toReturn = super.remove(key); // may throw an InvalidKeyException
        if (toReturn != NO_SUCH_KEY) {
            Position zPos = actionPos; // start at the removal position
            rebalance(zPos);
        }
        return toReturn;
    }
}
