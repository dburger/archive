
/**
 * Defines an ADT Container that holds Position objects.
 * 
 * @author digitalOverflow
 */
public interface PositionalContainer extends Container {

    /**
     * returns an Enumeration of the elements in the PositionalContainer
     * 
     * @return Enumeration = enumeration of the elements in the PositionalContainer
     */
    //public Enumeration elements();

    /**
     * returns an Enumeration of the Positions in the PositionalContainer
     * 
     * @return Enumeration = enumeration of the Positions in the PositionalContainer
     */
    //public Enumeration positions();

    /**
     * swaps the elements at Positions v and w
     * 
     * @param v      first Position to swap
     * @param w      second Position to swap
     */
    public void swap(Position v, Position w);

    /**
     * replaces the element at Position v with Object e and returns the current Object stored at v
     * 
     * @param v      Position to replace at
     * @param e      new element for Position v
     * @return the Object that was stored at Position v
     */
    public Object replace(Position v, Object e);

}
