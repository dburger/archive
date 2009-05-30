/**
 * Represents a generic Sequence which can hold 
 * and manipulate elements in the form of 
 * <code>java.lang.Object</code>.  This interface
 * also extends the generic <code>Container</code>
 * interface.
 *
 * @see Container
 * @author Bruce Harris
 * @version 1.0
 */
public interface Sequence extends Container{



  // ranked sequence methods
  /**
   * returns a <code>java.lang.Object</code>, which
   * is contained at the given rank.
   * 
   * @param rank    rank of element in sequence
   * @return Object = element at given rank
   * @exception thrown if rank is invalid
   * @exception BoundaryViolationException
   */
  public Object elemAtRank(int rank)
      throws BoundaryViolationException;


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
  public Object replaceElemAtRank(int rank, Object element)
      throws BoundaryViolationException;

  /**
   * insert object at given rank.
   * 
   * @param rank     rank to place element
   * @param element  element to be placed at given rank
   * @exception thrown if rank is invalid
   * @exception BoundaryViolationException
   */
  public void insertElemAtRank(int rank, Object element)
      throws BoundaryViolationException;  
  
  /**
   * remove element at given rank from the sequence
   * 
   * @param rank   the rank to remove
   * @return Object = element removed from sequence
   * @exception thrown if rank is invalid
   * @exception BoundaryViolationException
   */
  public Object removeElemAtRank(int rank)
      throws BoundaryViolationException;
  
  // positional sequence methods
  /**
   * return the first <code>Position</code> in the sequence
   * 
   * @return Position = first position in the sequence
   * @exception thrown if sequence is empty
   */
  public Position first()
      throws EmptyContainerException;

  /**
   * return the last <code>Position</code> in the sequence
   *
   * @return Position = first position in sequence
   * @exception thrown if sequence is empty
   */  
  public Position last()
      throws EmptyContainerException;

  /**
   * return the <code>Position</code> before the given position
   * 
   * @param pos     current position
   * @return Position = position before current position
   * @exception thrown if pos = first position
   * @exception BoundaryViolationException
   * @exception InvalidPositionException
   */
  public Position before(Position pos)
      throws BoundaryViolationException, InvalidPositionException;


  /**
   * return the <code>Position</code> after the given position
   * 
   * @param pos     current position
   * @return Position = position after current position
   * @exception thrown if pos = last position
   * @exception BoundaryViolationException
   * @exception InvalidPositionException
   */
  public Position after(Position pos)
      throws BoundaryViolationException, InvalidPositionException;


  /**
   * replace and return element at given position with given element
   * 
   * @param pos      current position
   * @param element  element to be placed at current position
   * @return Object = element being replaced at current position
   * @exception thrown if position is invalid
   * @exception InvalidPositionException
   */
  public Object replace(Position pos, Object element)
      throws InvalidPositionException;


  /**
   * Swap the elements stored at position 1 and position 2.
   * 
   * @param pos1    position containing 1st element to swap
   * @param pos2    position containing 2nd element to swap
   * @exception thrown if position is invalid
   * @exception InvalidPositionException
   */
  public void swap(Position pos1, Position pos2)
      throws InvalidPositionException;


    /**
     * insert element given as the first element
     *  and return this Position
     * 
     * @param element the element to insert at the first position
     * @return Position = position of newly inserted element
     */
    public Position insertFirst(Object element);


  /**
   * insert element given into sequence as the last element
   * 
   * @param element the element to insert at the last position
   * @return Position = position of newly inserted element
   */
  public Position insertLast(Object element);


  /**
   * insert given element into sequence before given position
   * 
   * @param pos      current position
   * @param element  element to insert at position before given position
   * @return Position = position of newly inserted element
   * @exception thrown if position is invalid
   * @exception InvalidPositionException
   */
  public Position insertBefore(Position pos, Object element)
      throws InvalidPositionException;


  /**
   * insert given element into sequence after given position
   * 
   * @param pos      current position
   * @param element  element to be inserted at position after given position
   * @return Position = position of newly inserted element
   * @exception thrown if position is invalid
   * @exception InvalidPositionException
   */
  public Position insertAfter(Position pos, Object element)
      throws InvalidPositionException;


  /**
   * remove and return element at given position
   * 
   * @param pos     position of element to remove
   * @return Object = element at given position
   * @exception thrown if position is invalid
   * @exception InvalidPositionException
   */
  public Object remove(Position pos)
       throws InvalidPositionException;

  
  // general sequence methods = conversion methods
  /**
   * return the Position of the element at given rank
   * 
   * @param rank    rank of given element
   * @return Position = position of element at rank
   * @exception thrown if rank is invalid
   * @exception BoundaryViolationException
   */
  public Position atRank(int rank)
      throws BoundaryViolationException;


  /**
   * return the rank of the element at given position
   * 
   * @param pos     position of element
   * @return rank = rank of element at given position
   * @exception thrown if position is invalid
   * @exception InvalidPositionException
   */
  public int rankOf(Position pos)
        throws InvalidPositionException;
}
