/**
 * A heap implemented with a Binary Tree.
 * 
 * @author digitalOverflow
 */
public class LinkedBinaryTreeHeap implements PriorityQueue {
    protected LinkedBinaryTree T;
    protected Position last;
    Comparator C;

    /**
     * Basic Heap constructor.
     * 
     * @param comp   The comparator to use with the Heap
     */
    public LinkedBinaryTreeHeap(Comparator comp) {
        T = new LinkedBinaryTree();
        C = comp;
    }

    /**
     * Returns the number of items in the Priority Queue.
     *
     * @return the number of items in the Priority Queue
     */
    public int size() {
        return (T.size()-1)/2;
    }

    /**
     * Used to determine whether or not the Priority Queue is empty.
     *
     * @return true if empty, otherwise false
     */
    public boolean isEmpty() {
        return size()==0;
    }

    /**
     * Returns the element in the Priority Queue with the smallest key.
     *
     * @return the element in the Priority Queue with the smallest key
     * @exception EmptyQueueException
     *                   thrown when minElement() is attempted on an empty Priority Queue
     */
    public Object minElement() throws EmptyContainerException {
        if (isEmpty())
            throw new EmptyContainerException("Empty priority queue exception on minElement().");
        return (elemOfPosition(T.root()));
    }

    /**
     * Returns and removes the element with the minimum key from the Priority Queue.
     *
     * @return the element with the minimum key in the Priority Queue.
     * @exception EmptyQueueException
     *                   thrown when removeMinElement() is attempted on an empty Priority Queue
     */
    public Object removeMinElement() throws EmptyContainerException {
        if (isEmpty())
           throw new EmptyContainerException("Empty priority queue exception on removeMinElement().");
        //store away the item at the root and replace the root with the item at last
        Item i = (Item)T.replace(T.root(), last.element());
        //remove last
        Position z = T.leftChild(last);
        T.removeAboveExternal(T.rightChild(last));
        if (!isEmpty()) {
            //bubble the root down into its proper place
            downBubble(T.root());
            //locate the new last
            while (!T.isRoot(z) && !isRightChild(z))
                z = T.parent(z);
            if (!T.isRoot(z))
                z = T.leftChild(T.parent(z));
            while (!T.isExternal(T.rightChild(z)))
                z = T.rightChild(z);
        }
        //set last reference for next call
        last = z;
        return i.element();
    }

    /**
     * Inserts the given object with the given key in the Priority Queue.
     *
     * @param k      The key for the given object.
     * @param e      The object to insert in the Priority Queue.
     * @exception InvalidKeyException
     *                   thrown if the key is reported as invalid by the Comparator
     */
    public void insertItem(Object k, Object e) throws InvalidKeyException {
        if (!C.isComparable(k))
            throw new InvalidKeyException("Invalid key exception on insertItem(k,e).");
        Position z;
        //locate new last for insertion
        if (isEmpty())
            z = T.root();
        else {
            z = last;
            while (!T.isRoot(z) && !isLeftChild(z))
                z = T.parent(z);
            if (!T.isRoot(z))
                z = T.rightChild(T.parent(z));
            while (!T.isExternal(z))
                z = T.leftChild(z);
        }
        //expand at last
        T.expandExternal(z);
        //put the item at last
        T.replace(z,new Item(k,e));
        //set last reference for next call
        last = z;
        //up bubble last into proper location
        upBubble(z);
    }

    /**
     * Returns the minimum key in the Priority Queue.
     *
     * @return the minimum key in the Priority Queue
     * @exception EmptyQueueException
     *                   thrown when minKey() is attempted on an empty Priority Queue
     */
    public Object minKey() throws EmptyContainerException {
        if (isEmpty())
           throw new EmptyContainerException("Empty priority queue exception on minKey().");
        return ((Item)T.root().element()).key();
    }

    /**
     * This method bubbles a node down to its proper position in the Heap
     * 
     * @param r      the Position that is being bubbled down
     */
    private void downBubble(Position r) {
        Position smallerChild, leftChild;
        //set smallerChild to leftChild
        smallerChild = leftChild = T.leftChild(r);
        //if left child is internal we check to see if we should bubble down
        if (T.isInternal(leftChild)) {
            //determine which child is smaller
            Position rightChild = T.rightChild(r);
            if (T.isInternal(rightChild))
                if (C.isLessThan(keyOfPosition(rightChild),keyOfPosition(leftChild)))
                    smallerChild = rightChild;
            //determine if down bubble is necessary
            if (C.isLessThan(keyOfPosition(smallerChild),keyOfPosition(r))) {
                T.swap(smallerChild,r);
                //recurse at new position
                downBubble(smallerChild);
            }
        }
    }

    /**
     * This method bubbles a node up to its proper position in the Heap
     * 
     * @param r      the Position that is being bubbled up
     */
    private void upBubble(Position p) {
        Position parent;
        //can't bubble up over the root
        if (!T.isRoot(p)) {
            parent = T.parent(p);
            //see if p is less than the parent
            if (C.isGreaterThan(keyOfPosition(parent),keyOfPosition(p))) {
                T.swap(parent,p);
                //recurse on the parent
                upBubble(parent);
            }
        }
    }

    /**
     * This routine returns the key of a given Position.
     * 
     * @param p      the Position to return the key of
     * @return the key of the given Position
     */
    protected Object keyOfPosition(Position p) {
        return ((Item)p.element()).key();
    }

    /**
     * This routine returns the element of a given Position.
     * 
     * @param p      the Position to return the element of
     * @return the element of the given Position
     */
    protected Object elemOfPosition(Position p) {
        return ((Item)p.element()).element();
    }

    /**
     * Determine whether or not a given Position is a left child.
     * 
     * @param p      the Position to check
     * @return true if the given Position is a left child, otherwise false
     */
    protected boolean isLeftChild(Position p) {
        try {
            return T.leftChild(T.parent(p)).equals(p);
        } catch (BoundaryViolationException e) {
            return false; //happens when p is the root
        }
    }


    /**
     * Determine whether or not a given Position is a right child.
     * 
     * @param p      the Position to check
     * @return true if the given Position is a right child, otherwise false
     */
    protected boolean isRightChild(Position p) {
        try {
            return T.rightChild(T.parent(p)).equals(p);
        } catch (BoundaryViolationException e) {
            return false; //happens when p is the root
        }
    }

}
