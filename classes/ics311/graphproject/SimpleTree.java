/**
 * The Simple Tree interface
 * 
 * @author digitalOverflow
 */
public interface SimpleTree extends PositionalContainer {

    /**
     * returns the root of the tree
     * 
     * @return Position = root of the tree
     */
    public Position root();

    /**
     * returns the parent of Position v
     * 
     * @param v      the Position to return the parent of
     * @return Position = parent of v
     */
    public Position parent(Position v);

    /**
     * returns an Enumeration of the children of v
     * 
     * @param v      Position to return the Enumeration of the children of
     * @return Enumeration = children Positions of v
     */
    //public Enumeration children(Position v);

    /**
     * determines whether or not v is internal
     * 
     * @param v      the Position to check if internal
     * @return boolean = true if internal, false otherwise
     */
    public boolean isInternal(Position v);

    /**
     * determines whether or not v is external
     * 
     * @param v      the Position to check if external
     * @return boolean = true if external, false otherwise
     */
    public boolean isExternal(Position v);

    /**
     * determine whether Position v is the root of the tree
     * 
     * @param v      the Position to check if root of tree
     * @return boolean = true if v is the root, false otherwise
     */
    public boolean isRoot(Position v);

}
