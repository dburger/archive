import java.util.Enumeration;
/**
 * The type of object representing a Vertex in a graph
 * 
 * @author digitalOverflow
 */
public class Vertex implements Position {

    private Object elem;
    private Container cont;

    private Sequence inEdges, outEdges, unEdges;

    private Position vertexPos;

    /**
     * Constructor for the Vertex object
     * 
     * @param e      Object to hold at this vertex
     * @param c      Container of this position
     */
    Vertex(Object e, Container c) {
        elem = e;
        cont = c;
        inEdges = new LinkedSequence();
        outEdges = new LinkedSequence();
        unEdges = new LinkedSequence();
    }


    /**
     * Returns the Position for this Vertex object for the
     * container in which it is held
     * 
     * @return the Position for this Vertex object for the container
     *         in which it is held
     */
    public Position getContainerPosition() {
        return vertexPos;
    }

    /**
     * Sets the Position for this Vertex object for the container
     * in which it is held
     * 
     * @param pos    the new Position for this Vertex
     */
    public void setContainerPosition(Position pos) {
        vertexPos = pos;
    }


    /**
     * Returns the degree of this Vertex
     * 
     * @return the degree of this Vertex
     */
    public int degree() {
        return inEdges.size() + outEdges.size() + unEdges.size();
    }

    /**
     * Returns the number of in incident edges for this Vertex
     * 
     * @return the number of in incident edges
     */
    public int inDegree() {
        return inEdges.size();
    }

    /**
     * Returns the number of out incident edges for this Vertex
     * 
     * @return the number of out incident edges
     */
    public int outDegree() {
        return outEdges.size();
    }
    /**
     * Returns the number of undirected incident edges for this Vertex
     * 
     * @return the number of undirected incident edges
     */
    public int unDegree() {
        return unEdges.size();
    }


    /**
     * Adds the given Edge e as an in incident Edge and returns
     * a Position to that Edge in the inEdges Sequence
     * 
     * @param e      The Edge to add as an in incident Edge
     * @return the Position containing Edge in the inEdges Sequence
     */
    public Position addInEdge(Edge e) {
        return inEdges.insertLast(e);
    }

    /**
     * Adds the given Edge e as an out incident Edge and returns
     * a Position to that Edge in the outEdges Sequence
     * 
     * @param e      The Edge to add as an out incident Edge
     * @return the Position containing Edge in the outEdges Sequence
     */
    public Position addOutEdge(Edge e) {
        return outEdges.insertLast(e);
    }

    /**
     * Adds the given Edge e as an undirected incident Edge and
     * returns a Position to that Edge in the unEdges Sequence
     * 
     * @param e      The Edge to add as an undirected incident Edge
     * @return the Position containing Edge in the unEdges Sequence
     */
    public Position addUnEdge(Edge e) {
        return unEdges.insertLast(e);
    }

    /**
     * Returns an Enumeration of the in Edges incident upon
     * this Vertex
     * 
     * @return an Enumeration of the in Edges incident upon this Vertex
     */
    public Enumeration inEdges() {
        return new SequenceEnumerator(inEdges);
    }

    /**
     * Returns an Enumeration of the out Edges incident upon
     * this Vertex
     * 
     * @return an Enumeration of the out Edges incident upon this Vertex
     */    
    public Enumeration outEdges() {
        return new SequenceEnumerator(outEdges);
    }

    /**
     * Returns an Enumeration of the undirected Edges incident upon
     * this Vertex
     * 
     * @return an Enumeration of the undirected Edges incident upon this Vertex
     */
    public Enumeration unEdges() {
        return new SequenceEnumerator(unEdges);
    }

    /**
     * Returns an Enumeration of all Edges incident upon
     * this Vertex
     * 
     * @return an Enumeration of all Edges incident upon this Vertex
     */
    public Enumeration edges() {
        LinkedSequence S = new LinkedSequence();
        Enumeration se = inEdges();
        while (se.hasMoreElements())
            S.insertLast(se.nextElement());
        se = outEdges();
        while (se.hasMoreElements())
            S.insertLast(se.nextElement());
        se = unEdges();
        while (se.hasMoreElements())
            S.insertLast(se.nextElement());
        return new SequenceEnumerator(S);
    }

    /**
     * Remove the given Edge from the inEdges in incident
     * Edges Sequence
     * 
     * @param e      the Edge e to remove from inEdges
     * @exception InvalidPositionException
     *                   thrown if the Position is invalid for this Sequence
     */
    public void removeInEdge(Position p) throws InvalidPositionException {
        inEdges.remove(p);
    }

    /**
     * Remove the given Edge from the ouEdges out incident
     * Edges Sequence
     * 
     * @param e      the Edge e to remove from outEdges
     * @exception InvalidPositionException
     *                   thrown if the Position is invalid for this Sequence
     */
    public void removeOutEdge(Position p) throws InvalidPositionException {
        outEdges.remove(p);
    }

    /**
     * Remove the given Edge from the unEdges undirected incident
     * Edges Sequence
     * 
     * @param e      the Edge e to remove from unEdges
     * @exception InvalidPositionException
     *                   thrown if the Position is invalid for this Sequence
     */
    public void removeUnEdge(Position p) throws InvalidPositionException {
        unEdges.remove(p);
    }

    /**
     * returns element stored at this position
     *
     * @return Object = element stored here
     */
    public Object element() {
        return elem;
    }

    /**
     * return the container holding this position
     *
     * @return Container = container holding this position
     */
    public Container container() {
        return cont;
    }

    /**
     * Sets the container for this Position
     * 
     * @param c      the new Container for this Position
     */
    protected void setContainer(Container c) {
        cont = c;
    }

    private Edge checkEdgePosition(Position p) throws InvalidPositionException {
        try {
            Edge e = (Edge)p;
            return e;
        } catch (ClassCastException e) {
            throw new InvalidPositionException("Given Position does not contain an Edge.");
        }
    }

}
