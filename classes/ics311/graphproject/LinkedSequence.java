/**
 * A Sequence implemented with a doubly linked list.
 */
public class LinkedSequence implements Sequence {
    /**
     * the front and rear sentinels of the dl list
     */
    private DLNodePosition head, tail;
    /**
     * the number of elements in the Sequence
     */
    private int numElements;

    /**
     * linked sequence constructor
     */
    LinkedSequence() {
        head = new DLNodePosition(null,null,this,null);
        tail = new DLNodePosition(head,null,this,null);
        head.setNext(tail);
        numElements = 0;
    }

    /**
     * returns a <code>java.lang.Object</code>, which
     * is contained at the given rank.
     * 
     * @param rank    rank of element in sequence
     * @return Object = element at given rank
     * @exception thrown if rank is invalid
     * @exception BoundaryViolationException
     */
    public Object elemAtRank(int rank) throws BoundaryViolationException {
        DLNodePosition np = checkRank(rank);
        return np.element();
    }

    /**
     * return the first <code>Position</code> in the sequence
     *
     * @return Position = first position in the sequence
     * @exception thrown if sequence is empty
     */
    public Position first() throws EmptyContainerException {
        if (isEmpty())
            throw new BoundaryViolationException("Empty Container Exception on first() with empty sequence.");
        return head.getNext();
    }

    /**
     * return the last <code>Position</code> in the sequence
     *
     * @return Position = first position in sequence
     * @exception thrown if sequence is empty
     */
    public Position last() throws EmptyContainerException {
        if (isEmpty())
            throw new BoundaryViolationException("Empty Container Exception on last() with empty sequence.");
        return tail.getPrev();
    }

    /**
     * replace object at given rank with new object
     * and return original object.
     * 
     * @param rank     rank of element to replace
     * @param element  new element to be placed at rank
     * @return Object = original element replaced at given rank
     * @exception thrown if rank is invalid
     * @exception BoundaryViolationException
     */
    public Object replaceElemAtRank(int rank, Object element) throws BoundaryViolationException {
        DLNodePosition np = checkRank(rank);
        Object e = np.element();
        np.setElement(element);
        return e;
    }

    /**
     * insert object at given rank.
     * 
     * @param rank     rank to place element
     * @param element  element to be placed at given rank
     * @exception thrown if rank is invalid
     * @exception BoundaryViolationException
     */
    public void insertElemAtRank(int rank, Object element) throws BoundaryViolationException {
        if (rank==numElements)
            insertLast(element);
        else {
            DLNodePosition np = checkRank(rank);
            DLNodePosition new_np = new DLNodePosition(np.getPrev(),np,this,element);
            np.getPrev().setNext(new_np);
            np.setPrev(new_np);
            numElements++;
        }
    }

    /**
     * remove element at given rank from the sequence
     * 
     * @param rank    rank of element to be removed
     * @return Object = element removed from sequence
     * @exception thrown if rank is invalid
     * @exception BoundaryViolationException
     */
    public Object removeElemAtRank(int rank) throws BoundaryViolationException {
        DLNodePosition np = checkRank(rank);
        Object e = np.element();
        np.getPrev().setNext(np.getNext());
        np.getNext().setPrev(np.getPrev());
        // make the position invalid
        np.setContainer(null);
        // and unlink it from the list
        np.setNext(null);
        np.setPrev(null);
        numElements--;
        return e;
    }

    /**
     * replace and return element at given position with given element
     * 
     * @param pos      current position
     * @param element  element to be placed at current position
     * @return Object = element being replaced at current position
     * @exception thrown if position is invalid
     * @exception InvalidPositionException
     */
    public Object replace(Position pos, Object element) throws InvalidPositionException {
        DLNodePosition np = checkPosition(pos);
        Object e = np.element();
        np.setElement(element);
        return e;
    }

    /**
     * Swap the elements stored at position 1 and position 2.
     * 
     * @param pos1    position containing 1st element to swap
     * @param pos2    position containing 2nd element to swap
     * @exception thrown if position is invalid
     * @exception InvalidPositionException
     */
    public void swap(Position pos1, Position pos2) throws InvalidPositionException {
        DLNodePosition np1 = (DLNodePosition)pos1;
        DLNodePosition np2 = (DLNodePosition)pos2;
        Object temp = np1.element();
        np1.setElement(np2.element());
        np2.setElement(temp);
    }

    /**
     * return the <code>Position</code> before the given position
     * 
     * @param pos     current position
     * @return Position = position before current position
     * @exception thrown if pos = first position
     * @exception BoundaryViolationException
     * @exception InvalidPositionException
     */
    public Position before(Position pos) throws BoundaryViolationException,InvalidPositionException {
        DLNodePosition np = checkPosition(pos);
        if (isFirst(pos))
            throw new BoundaryViolationException("Boundary Violation Exception on before(), the given Position is the first Position.");
        return np.getPrev();
    }

    /**
     * return the <code>Position</code> after the given position
     * 
     * @param pos     current position
     * @return Position = position after current position
     * @exception thrown if pos = last position
     * @exception BoundaryViolationException
     * @exception InvalidPositionException
     */
    public Position after(Position pos) throws BoundaryViolationException,InvalidPositionException {
        DLNodePosition np = checkPosition(pos);
        if (isLast(pos))
            throw new BoundaryViolationException("Boundary Violation Exception on after(), the given Position is the last Position.");
        return np.getNext();
    }

    /**
     * insert given element into sequence before given position
     * 
     * @param pos      current position
     * @param element  element to insert at position before given position
     * @return Position = position of newly inserted element
     * @exception thrown if position is invalid
     * @exception InvalidPositionException
     */
    public Position insertBefore(Position pos, Object element) throws InvalidPositionException {
        DLNodePosition np = checkPosition(pos);
        DLNodePosition new_np = new DLNodePosition(np.getPrev(),np,this,element);
        np.getPrev().setNext(new_np);
        np.setPrev(new_np);
        numElements++;
        return new_np;
    }

    /**
     * insert given element into sequence after given position
     * 
     * @param pos      current position
     * @param element  element to be inserted at position after given position
     * @return Position = position of newly inserted element
     * @exception thrown if position is invalid
     * @exception InvalidPositionException
     */
    public Position insertAfter(Position pos, Object element) throws InvalidPositionException {
        DLNodePosition np = checkPosition(pos);
        DLNodePosition new_np = new DLNodePosition(np,np.getNext(),this,element);
        np.getNext().setPrev(new_np);
        np.setNext(new_np);
        numElements++;
        return new_np;
    }

    /**
     * insert element given as the first element
     *  and return this Position
     * 
     * @param element the element to insert at the first position
     * @return Position = position of newly inserted element
     */
    public Position insertFirst(Object element) {
        DLNodePosition first_np = head.getNext();
        DLNodePosition new_np = new DLNodePosition(head,first_np,this,element);
        head.setNext(new_np);
        first_np.setPrev(new_np);
        numElements++;
        return new_np;
    }


    /**
     * insert element given into sequence as the last element
     * 
     * @param element the element to insert at the last position
     * @return = position of newly inserted element
     */
    public Position insertLast(Object element) {
        DLNodePosition last_np = tail.getPrev();;
        DLNodePosition new_np = new DLNodePosition(last_np,tail,this,element);
        last_np.setNext(new_np);
        tail.setPrev(new_np);
        numElements++;
        return new_np;
    }

    /**
     * return the rank of the element at given position
     * 
     * @param pos     the position to return the rank of
     * @return rank = rank of element at given position
     * @exception thrown if position is invalid
     * @exception InvalidPositionException
     */
    public int rankOf(Position pos) throws InvalidPositionException {
        DLNodePosition np = checkPosition(pos);
        DLNodePosition curr_np = head.getNext();
        int rank = 0;
        while (curr_np!=np) {
            curr_np= curr_np.getNext();
            rank++;
        }
        return rank;
    }

    /**
     * remove and return element at given position
     * 
     * @param pos    the position to remove from the Sequence
     * @return Object = element at given position
     * @exception thrown if position is invalid
     * @exception InvalidPositionException
     */
    public Object remove(Position pos) throws InvalidPositionException {
        DLNodePosition np = checkPosition(pos);
        np.getPrev().setNext(np.getNext());
        np.getNext().setPrev(np.getPrev());
        // make the position invalid
        np.setContainer(null);
        // and unlink it from the list
        np.setNext(null);
        np.setPrev(null);
        numElements--;
        return np.element();
    }

    /**
     * return the Position of the element at given rank
     * 
     * @param rank    rank of given element
     * @return Position = position of element at rank
     * @exception thrown if rank is invalid
     * @exception BoundaryViolationException
     */
    public Position atRank(int rank) throws BoundaryViolationException {
        return checkRank(rank);
    }

    /**
     * returns how many elements are in the container.
     *
     * @return int = number of elements in the container.
     */
    public int size() {
        return numElements;
    }

    /**
     * returns true if the container is empty, false otherwise.
     *
     * @return boolean true if container is empty
     */
    public boolean isEmpty() {
        return numElements == 0;
    }

    /**
     * returns the DLNodePosition for the given Position
     * 
     * @param pos     the position to check
     * @return DLNodePosition = DLNodePosition of given Position
     * @exception throw  if the Position is invalid
     * @exception InvalidPositionException
     */
    protected DLNodePosition checkPosition(Position pos) throws InvalidPositionException {
        if (pos==head)
            throw new InvalidPositionException("Head of the sequence is not a valid position.");
        if (pos==tail)
            throw new InvalidPositionException("Tail of the sequence is not a valid position.");
        if (pos.container()!=this)
            throw new InvalidPositionException("Position does not belong to this container.");
        try {
            DLNodePosition np = (DLNodePosition)pos;
            return np;
        } catch (ClassCastException e) {
            throw new InvalidPositionException("Position is of wrong type for this container.");
        }
    }

    /**
     * returns the DLNodePosition of the Position at the given rank
     * 
     * @param rank    rank of an element in the Sequence
     * @return DLNodePosition = DLNodePosition of Position at rank
     * @exception thrown if rank is invalid
     * @exception BoundaryViolationException
     */
    protected DLNodePosition checkRank(int rank) throws BoundaryViolationException {
        if (rank<0 || rank>size()-1)
            throw new BoundaryViolationException("Rank " + rank + " is invalid for this sequence of " + numElements + " elements.");
        DLNodePosition curr_np;
        //because we are stepping in from the closer end,
        //this method is asymptotically faster than always
        //stepping from one of the ends
        if (rank < (numElements-1)/2) {  //in the front half
            curr_np = head.getNext();
            while (rank!=0) {
                curr_np = curr_np.getNext();
                rank--;
            }
        } else {  //in the last half
            curr_np = tail.getPrev();
            while (rank!=numElements-1) {
                curr_np = curr_np.getPrev();
                rank++;
            }
        }
        return curr_np;
    }

    /**
     * check to see if a Position pos is the first Position
     * 
     * @param pos     the Position to check if first
     * @return boolean = true if first, false otherwise
     * @exception throw  in Position pos is invalid
     */
    public boolean isFirst(Position pos) {
        checkPosition(pos);
        return pos == (Position)head.getNext();
    }


    /**
     * check to see if a Position pos is the last Position
     * 
     * @param pos     the Position to check if first
     * @return boolean = true if last, false otherwise
     * @exception throw  in Position pos is invalid
     */
    public boolean isLast(Position pos) {
        checkPosition(pos);
        return pos == (Position)tail.getPrev();
    }

    /*
    * used for testing, only works with sequence storing Integer objects
    public void displaySequence() {
        DLNodePosition curr = head.getNext();
        System.out.print("{ ");
        while (curr!=tail) {
            System.out.print("(" + ((Integer)curr.element()).intValue() + ") ");
            curr = curr.getNext();
        }
        System.out.println("}");
    }
    */

}
