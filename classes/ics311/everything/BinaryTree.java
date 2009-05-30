/**
 * An interface for a Binary Tree
 * 
 * @author digitalOverflow
 */
public interface BinaryTree extends SimpleTree {

    /**
     * returns the leftChild of a Position v
     * 
     * @param v      the Position to return the leftChild of
     * @return Position = leftChild of Position v
     */
    public Position leftChild(Position v);

    /**
     * returns the rightChild of a Position v
     * 
     * @param v      the Position to return the rightChild of
     * @return Position = rightChild of Position v
     */
    public Position rightChild(Position v);


    /**
     * returns the sibling of a Position v
     * 
     * @param v      the Position to return the sibling of
     * @return Position = sibling of Position v
     */
    public Position sibling(Position v);

    /**
     * transforms external Node v into an internal node by creating two children and making them the left and right children of v
     * 
     * @param v      the Position to add children to and make internal
     */
    public void expandExternal(Position v);

    /**
     * removes the external Node v and its parent u, replacing u with the sibling of v, returning the element previously stored at u
     * 
     * @param v      the external node to remove
     * @return Object = the Object previously stored at the parent of v
     */
    public Object removeAboveExternal(Position v);

}
