/**
 * A Sequence implemented with a circular array
 */
public class ArraySequence implements Sequence {

    /**
     * the default capacity for the ArraySequence
     */
    private final static int DEFAULT_CAPACITY = 1000;

    /**
     * the capacity that the ArraySequence was constructed with
     */
    private int originalCapacity;
    /**
     * the current capacity of the ArraySequence
     */
    private int capacity;
    /**
     * the index of the front item in the array
     */
    private int front;
    /**
     * rear points to the next available location in the array
     */
    private int rear;
    /**
     * the array that holds the ArrayPositions
     */
    private ArrayPosition items[];

    /**
     * constructor for an ArraySequence of default capacity
     *
     */
    ArraySequence() {
        this(DEFAULT_CAPACITY);
    }

    /**
     * constructor for an ArraySequence of given capacity
     * 
     * @param cap     capacity for the sequence
     */
    ArraySequence(int cap) {
        capacity = originalCapacity = cap;
        items = new ArrayPosition[capacity];
        front = 0;
        rear = 0;
    }

    /**
     * returns a <code>java.lang.Object</code>, which
     * is contained at the given rank.
     * 
     * @param rank    rank of element to return
     * @return Object = element at given rank
     * @exception thrown if rank is invalid
     * @exception BoundaryViolationException
     */
    public Object elemAtRank(int rank) throws BoundaryViolationException {
        checkRank(rank);
        return items[rankToIndex(rank)].element();
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
        return items[front];
    }

    /**
     * return the last <code>Position</code> in the sequence
     *
     * @return Position = first position in sequence
     * @exception thrown if sequence is empty
     */
    public Position last() throws EmptyContainerException {
        if (isEmpty())
            throw new EmptyContainerException("Empty Container Exception on last() with empty Sequence.");
        return items[rankToIndex(size()-1)];
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
        checkRank(rank);
        int index = rankToIndex(rank);
        Object e = items[index].element();
        items[index].setElement(element);
        return e;
    }

    /**
     * insert object at given rank.
     * 
     * @param rank     rank to place element
     * @param element  element to be placed at given rank
     * @exception thrown if rank is invalid
     * @exception BoundaryViolationException
     * @exception FullContainerException
     */
    public void insertElemAtRank(int rank, Object element) throws BoundaryViolationException, FullContainerException {
        //they can insert one past the last rank so
        //don't checkRank in that case
        if (rank!=size())
            checkRank(rank);
        checkFull();
        //NOTE:  the index for the ArrayPosition will
        //be set to the proper index when it is determined
        ArrayPosition ap = new ArrayPosition(0,element,this);
        int insertIndex;
        int mid = (size()-1)/2;
        //in using a circular array,
        //insertElemAtRank(0,e), insertFirst(e)
        //insertElemAtRank(size()), insertLast(e)
        //are all O(1).  Also, because we shift to the
        //closer end, a typical insertion into the inner
        //part of the sequence will be asymptotically faster
        //than always shifting to the rear.
        if (rank<=mid) { //object is closer to front, shift items down
            insertIndex = (capacity + rankToIndex(rank) - 1) % capacity;
            int i = (capacity + front - 1) % capacity;
            front = i;
            while (i!=insertIndex) {
                items[i] = items[(i+1) % capacity];
                items[i].setIndex(i);
                i = (i + 1) % capacity;
            }
        } else { //object is closer to rear, shift items up
            insertIndex = rankToIndex(rank);
            int i = rear;
            while (i!=insertIndex) {
                items[i] = items[(capacity + i-1) % capacity];
                items[i].setIndex(i);
                i = (capacity + i - 1) % capacity;
            }
            rear = (rear + 1) % capacity;
        }
        ap.setIndex(insertIndex);
        items[insertIndex] = ap;
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
        ArrayPosition ap = checkPosition(atRank(rank));
        //invalidate the postion for this sequence
        ap.setContainer(null);
        Object e = ap.element();
        int mid = (size()-1)/2;
        int i = ap.index();
        //because we have used a circular array,
        //removeElemAtRank(0), removeFirst(),
        //removeElemAtRank(size()-1), removeLast(),
        //are all O(1).  Also, because we shift in from
        //the closer end, removals from the inner part
        //of the sequence will be constant time faster
        //than always shifting in from the rear.
        if (rank<=mid) { //object is closer to front, shift items in from front
            while (i!=front) {
                items[i] = items[(capacity + i - 1) % capacity];
                items[i].setIndex(i);
                i = (capacity + i - 1) % capacity;
            }
            items[front] = null;
            front = (front + 1) % capacity;
        } else {         //object is closer to rear, shift items in from rear
            while (((i + 1) % capacity)!=rear) {
                items[i] = items[(i + 1) % capacity];
                items[i].setIndex(i);
                i = (i + 1) % capacity;
            }
            rear = (capacity + rear - 1) % capacity;
            items[rear] = null;            
        }
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
        ArrayPosition ap = checkPosition(pos);
        Object e = ap.element();
        ap.setElement(element);
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
        ArrayPosition ap1 = checkPosition(pos1);
        ArrayPosition ap2 = checkPosition(pos2);
        Object temp = ap1.element();
        ap1.setElement(ap2.element());
        ap2.setElement(temp);
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
        ArrayPosition ap = checkPosition(pos);
        if (isFirst(pos))
            throw new BoundaryViolationException("Boundary Violation Exception on before(), the given Position is the first Position.");
        return items[(capacity + ap.index() - 1) % capacity];
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
        ArrayPosition ap = checkPosition(pos);
        if (isLast(pos))
            throw new BoundaryViolationException("Boundary Violation Exception on after(), the given Position is the last Position.");
        return items[(ap.index() + 1) % capacity];
    }

    /**
     * insert given element into sequence before given position
     * 
     * @param pos      current position
     * @param element  element to insert at position before given position
     * @return Position = position of newly inserted element
     * @exception thrown if position is invalid
     * @exception InvalidPositionException
     * @exception FullContainerException
     */
    public Position insertBefore(Position pos, Object element) throws InvalidPositionException, FullContainerException {
        ArrayPosition ap = checkPosition(pos);
        checkFull();
        insertElemAtRank(rankOf(pos),element);
        return before(pos);
    }

    /**
     * insert given element into sequence after given position
     * 
     * @param pos      element to insert at position before given position
     * @param element  element to be inserted at position after given position
     * @return Position = position of newly inserted element
     * @exception thrown if position is invalid
     * @exception InvalidPositionException
     * @exception FullContainerException
     */
    public Position insertAfter(Position pos, Object element) throws InvalidPositionException, FullContainerException {
        ArrayPosition ap = checkPosition(pos);
        checkFull();
        insertElemAtRank(rankOf(pos) + 1,element);
        return after(pos);
    }

    /**
     * insert element given as the first element
     *  and return this Position
     * 
     * @param element  element to be inserted at the first position
     * @return Position = position of newly inserted element
     * @exception FullContainerException
     */
    public Position insertFirst(Object element) throws FullContainerException {
        checkFull();
        insertElemAtRank(0,element);
        return first();
    }

    /**
     * insert element given into sequence as the last element
     * 
     * @param element  element to be inserted at last position
     * @return Position = position of newly inserted element
     * @exception FullContainerException
     */
    public Position insertLast(Object element) throws FullContainerException {
        checkFull();
        insertElemAtRank(size(),element);
        return last();
    }

    /**
     * return the rank of the element at given position
     * 
     * @param pos     position of element
     * @return rank = rank of element at given position
     * @exception thrown if position is invalid
     * @exception InvalidPositionException
     */
    public int rankOf(Position pos) throws InvalidPositionException {
        ArrayPosition ap = checkPosition(pos);
        return (capacity + ap.index() - front) % capacity;
    }

    /**
     * remove and return element at given position
     * 
     * @param pos     position of element to remove
     * @return Object = element at given position
     * @exception thrown if position is invalid
     * @exception InvalidPositionException
     */
    public Object remove(Position pos) throws InvalidPositionException {
        return removeElemAtRank(rankOf(pos));
    }

    /**
     * return the Position of the element at given rank
     * 
     * @param rank    rank of Position to return
     * @return Position = position of element at rank
     * @exception thrown if rank is invalid
     * @exception BoundaryViolationException
     */
    public Position atRank(int rank) throws BoundaryViolationException {
        checkRank(rank);
        return items[rankToIndex(rank)];
    }

    /**
     * return the index of the element at given valid rank
     * 
     * @param rank    rank of given element
     * @return int = index of element at rank
     */
    protected int rankToIndex(int rank) {
        return (front + rank) % capacity;
    }

    /**
     * returns how many elements are in the container.
     *
     * @return int = number of elements in the container.
     */
    public int size() {
        return (capacity - front + rear) % capacity;
    }

    /**
     * returns true if the container is empty, false otherwise.
     *
     * @return boolean true if container is empty
     */
    public boolean isEmpty() {
        return size()==0;
    }

    /**
     * returns true if the container is full, false otherwise.
     *
     * @return boolean true if container is full
     */
    protected boolean isFull() {
        return size()==capacity-1;
    }

    /**
     * checks to see if the container is full, and expands it if necessary
     *
     * @exception thrown if the Sequence is full and no room is left for expansion
     */
    protected void checkFull() throws FullContainerException {
        //if we are full, double the capacity
        if (isFull()) {
            resize(2*capacity);
        }
    }

    /**
     * returns the current capacity of the items array, can be used
     * to determine if a contract() would result in reclaimed memory
     * @return int = current capacity of the items array
     */
    public int capacity() {
        return capacity;
    }

    /**
     * contracts the capacity of the sequence to:
     *   1.  the original capacity, if all items will fit, or
     *   2.  repeatedly divides the current capacity by 2 to
     *   the smallest capacity that will still hold all elements
     */
    public void contract() {
        int newCapacity;
        if (capacity!=originalCapacity) {
            //if size() is less than the original capacity
            //we can contract back to the original capacity
            if (size()<originalCapacity) {
                newCapacity = originalCapacity;
            } else {
                //divide the current capacity by 2 as many times
                //as we can and still hold all items
                newCapacity = capacity;
                while ((newCapacity/2)>size())
                    newCapacity = newCapacity/2;
            }
            resize(newCapacity);
        }
    }

    /**
     * resizes the array holding the sequence to the given capacity
     * 
     * @param newCapacity
     *                the new capacity for the items array
     */
    protected void resize(int newCapacity) {
        ArrayPosition newItems[] = new ArrayPosition[newCapacity];
        for (int i=0;i<size();i++) {
            newItems[i] = items[(i + front) % capacity];
            newItems[i].setIndex(i);
        }
        //in this order
        rear = size();
        front = 0;
        capacity = newCapacity;
        items = newItems;
    }

    /**
     * return the ArrayPosition of the given Position
     * 
     * @param pos     the position to return the ArrayPosition for
     * @return ArrayPosition = ArrayPosition object represented by Position p
     * @exception thrown if the Position is invalid for this  Container
     * @exception InvalidPositionException
     */
    protected ArrayPosition checkPosition(Position pos) throws InvalidPositionException {
        if (pos.container()!=this)
           throw new InvalidPositionException("Position does not belong to this container.");
        try {
            ArrayPosition ap = (ArrayPosition)pos;
            return ap;
        } catch (ClassCastException e) {
            throw new InvalidPositionException("Position is of wrong type for this container.");
        }
    }

    /**
     * check that the rank is in the rank 0 <= rank < size()
     * 
     * @param r       rank to check
     * @exception thrown if the rank is invalid
     * @exception BoundaryViolationException
     */
    protected void checkRank(int r) throws BoundaryViolationException {
        if (r<0 || r>size()-1)
            throw new BoundaryViolationException("Boundary Violation Exception, rank " + r + " is invalid for this Sequence of " + size() + " elements.");
    }
     
    /**
     * checks to see if the given Position is the first Position
     * 
     * @param pos     Position to check if first
     * @return boolean = true if p is first, false otherwise
     * @exception thrown if Position p is invalid
     */
    public boolean isFirst(Position pos) {
        checkPosition(pos);
        return pos == first();
    }

    /**
     * checks to see if the given Position is the last Position
     * 
     * @param pos     Position to check if last
     * @return boolean = true if p is last, false otherwise
     * @exception thrown is Position p is invalid
     * @exception InvalidPositionException
     */
    public boolean isLast(Position pos) throws InvalidPositionException {
        checkPosition(pos);
        return pos == last();
    }

    /*
    * used for testing, only works with Sequences storing Integer objects
    public void displaySequence() {
        int curr = front;
        System.out.print("{ ");
        for (int i=0;i<size();i++) {
            ArrayPosition ap = items[curr];
            System.out.print("(" + ap.index() + ", " + ((Integer)ap.element()).intValue() + ") ");
            curr = (curr + 1) % capacity;
        }
        System.out.println("}");
    }
    */


}
