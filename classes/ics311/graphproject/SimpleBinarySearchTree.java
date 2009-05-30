public class SimpleBinarySearchTree implements Dictionary {
    Comparator C;
    BinaryTree T;

    public static final Object NO_SUCH_KEY = new Object();

    protected Position actionPos;

    /**
     * constructor for SimpleBinarySearchTree
     * 
     * @param c      the Comparator to use with this tree
     */
    public SimpleBinarySearchTree(Comparator c) {
        C = c;
        T = (BinaryTree)new LinkedBinaryTree();
    }

    /**
     * returns the key for the given position
     * 
     * @param pos    position of key to remove
     * @return Object = key of given position
     */
    protected Object key(Position pos) {
        return ((Item)pos.element()).key();
    }

    /**
     * returns the element stored at Position pos
     * 
     * @param pos    the Position to return the element of
     * @return Object = element stored in Position pos
     */
    protected Object element(Position pos) {
        return ((Item)pos.element()).element();
    }

    /**
     * determine whether or not key is a valid key for the Comparator
     * 
     * @param key    the key to check if valid
     * @exception InvalidKeyException
     */
    protected void checkKey(Object key) throws InvalidKeyException {
        if (!C.isComparable(key))
            throw new InvalidKeyException("Key " + key + " is not comparable.");
    }

    /**
     * finds the Position with the given key or insertion point for given key starting from Position pos
     * 
     * @param key    the key to search for
     * @param pos    the Position to search from
     * @return Position = position with given key or external node representing point of insertion of not found
     */
    protected Position findPosition(Object key, Position pos) {
        if (T.isExternal(pos))
            return pos;         //key not found and external node reached
        else {
            Object curKey = key(pos);
            if (C.isLessThan(key,curKey))
                return findPosition(key,T.leftChild(pos));
            else if (C.isGreaterThan(key,curKey))
                return findPosition(key,T.rightChild(pos));
            else
                return pos;
        }
    }

    /**
     * returns the number of Items
     *
     * @return int = number of Items
     */
    public int size() {
        return (T.size()-1)/2;
    }

    /**
     * removes the Item with key k
     *
     * @param k      key of item to remove
     * @return Object = element of Item removed or NO_SUCH_KEY if doesn't exist
     */
    public Object remove(Object k) {
        Object toReturn;
        checkKey(k);
        Position remPos = findPosition(k,T.root());
        if (T.isExternal(remPos)) {
            actionPos = remPos;
            return NO_SUCH_KEY;
        } else {
            toReturn = element(remPos);
            if (T.isExternal(T.leftChild(remPos)))
                remPos = T.leftChild(remPos);
            else if (T.isExternal(T.rightChild(remPos)))
                remPos = T.rightChild(remPos);
            else {
                Position swapPos = remPos;
                remPos = T.rightChild(swapPos);
                do
                    remPos = T.leftChild(remPos);
                while (T.isInternal(remPos));
                T.swap(swapPos,T.parent(remPos));
            }
            actionPos = T.sibling(remPos);
            T.removeAboveExternal(remPos);
            return toReturn;
        }
    }

    /**
     * returns true if empty, false otherwise
     *
     * @return boolean = true if empty false otherwise
     */
    public boolean isEmpty() {
        return T.size()==1;
    }

    /**
     * insert an element with key k and element e
     *
     * @param k      key for item
     * @param e      object for item
     */
    public void insertItem(Object k, Object e) throws InvalidKeyException {
        checkKey(k);
        Position insPos = T.root();
        do {
            insPos = findPosition(k,insPos);
            if (T.isExternal(insPos))
                break;
            else
                insPos = T.rightChild(insPos);
        } while (true);
        T.expandExternal(insPos);
        Item newItem = new Item(k,e);
        T.replace(insPos,newItem);
        actionPos = insPos;
    }

    /**
     * returns the element for the Item with key k or NO_SUCH_KEY if doesn't exist
     * 
     * @param k      the key of the Item to locate
     * @return Object = element with key k or NO_SUCH_KEY if doesn't exist
     */
    public Object findElement(Object k) {
        checkKey(k);
        Position curPos = findPosition(k,T.root());
        actionPos = curPos;
        if (T.isInternal(curPos))
            return element(curPos);
        else
            return NO_SUCH_KEY;
    }

    /**
     * returns an Enumeration of all Items with key k
     *
     * @param k      the key of the Items to return an Enumeration of
     * @return Enumeration = elements with key k
     */
    //public Enumeration findAllElements(Object k)

    /**
     * removes all items with key k
     *
     * @param k      the key of the items to remove
     * @return Enumeration = enumeration of items removed
     */
    //public Enumeration removeAll(Object k)

}
