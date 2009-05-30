import java.util.Enumeration;
/**
 * A directed adjacency list interface
 * 
 * @author digitalOverflow
 */
public interface Graph extends Container {

    /**
     * returns how many elements are in the container.
     *
     * @return int = number of elements in the container.
     */
    public int size();

    /**
     * returns true if the container is empty, false otherwise.
     *
     * @return boolean true if container is empty
     */
    public boolean isEmpty();

    /**
     * return the number of vertices in the graph
     * 
     * @return number of vertices in the graph
     */
    public int numVertices();

    /**
     * returns the number for edges in the graph
     * 
     * @return number of edges in the graph
     */
    public int numEdges();

    /**
     * returns an Enumeration of the vertices in the graph
     * 
     * @return vertices in the graph
     */
    public Enumeration vertices();

    
    /**
     * returns an Enumeration of the edges in the graph
     * 
     * @return edges in the graph
     */
    public Enumeration edges();


    /**
     * Returns an enumeration of the directed edges in the Graph
     * 
     * @return an enumeration of the directed edges in the Graph
     */
    public Enumeration directedEdges();

    /**
     * Returns an enumeration of the directed edges in the Graph
     * 
     * @return an enumeration of the directed edges in the Graph
     */
    public Enumeration undirectedEdges();

    /**
     * returns the degree of the passed in Vertex vp
     * 
     * @param vp      Vertex to return the degree of
     * @return degree of Vertex vp
     * @exception InvalidPositionException
     *                   thrown when vp is invalid for Vertex container V
     */
    public int degree(Position vp) throws InvalidPositionException;

    /**
     * returns the in degree of the passed in Vertex vp
     * 
     * @param vp      Vertex to return the in degree of
     * @return in degree of Vertex vp
     * @exception InvalidPositionException
     *                   thrown when vp is invalid for Vertex container V
     */
    public int inDegree(Position vp) throws InvalidPositionException;

    /**
     * returns the out degree of the passed in Vertex vp
     * 
     * @param vp      Vertex to return the out degree of
     * @return out degree of Vertex vp
     * @exception InvalidPositionException
     *                   thrown when vp is invalid for Vertex container V
     */
    public int outDegree(Position vp) throws InvalidPositionException;

    /**
     * Returns an enumeration of vertices adjacent to Vertex vp
     * 
     * @param vp     Position of Vertex to return the adjacent vertices of
     * @return enumeration of vertices adjacent to Vertex vp
     * @exception InvalidPositionException
     *                   thrown if vp is not a valid Vertex for this Graph
     */
    public Enumeration adjacentVertices(Position vp) throws InvalidPositionException;

    /**
     * Returns an enumeration of vertices in adjacent to Vertex vp
     * 
     * @param vp     Position of Vertex to return the in adjacent vertices of
     * @return enumeration of vertices in adjacent to Vertex vp
     * @exception InvalidPositionException
     *                   thrown if vp is not a valid Vertex for this Graph
     */
    public Enumeration inAdjacentVertice(Position vp) throws InvalidPositionException;

    /**
     * Returns an enumeration of vertices out adjacent to Vertex vp
     * 
     * @param vp     Position of Vertex to return the out adjacent vertices of
     * @return enumeration of vertices out adjacent to Vertex vp
     * @exception InvalidPositionException
     *                   thrown if vp is not a valid Vertex for this Graph
     */
    public Enumeration outAdjacentVertices(Position vp) throws InvalidPositionException;

    /**
     * Returns an Enumeration of the edges incident upon the
     * Vertex in Position vp
     * 
     * @param vp     the Position to holding the Vertex to return the
     *               Enumeration of
     * @return the Enumeration of edges incident upon vp
     * @exception InvalidPositionException
     */
    public Enumeration incidentEdges(Position vp) throws InvalidPositionException;

    /**
     * Returns an Enumeration of the edges in incident upon the
     * Vertex in Position vp
     * 
     * @param vp     the Position to holding the Vertex to return the
     *               Enumeration of
     * @return the Enumeration of edges in incident upon vp
     * @exception InvalidPositionException
     */
    public Enumeration inIncidentEdges(Position vp) throws InvalidPositionException;

    /**
     * Returns an Enumeration of the edges out incident upon the
     * Vertex in Position vp
     * 
     * @param vp     the Position to holding the Vertex to return the
     *               Enumeration of
     * @return the Enumeration of edges out incident upon vp
     * @exception InvalidPositionException
     */
    public Enumeration outIncidentEdges(Position vp) throws InvalidPositionException;

    public Position[] endVertices(Position ep) throws InvalidPositionException;

    /**
     * Returns the Vertex on Edge ep opposite from Vertex vp
     * 
     * @param vp     Vertex to find opposite of
     * @param ep     Edge containing the vertices
     * @return 
     * @exception InvalidPositionException
     */
    public Position opposite(Position vp, Position ep) throws InvalidPositionException;

    /**
     * Determine whether or not two vertices are adjacent
     * 
     * @param vp     Position of one Vertex to check
     * @param wp     Position of other Vertex to check
     * @return true if they are adjacent, false otherwise
     * @exception InvalidPositionException
     *                   thrown if either Position is invalid for this container
     */
    public boolean areAdjacent(Position vp, Position wp) throws InvalidPositionException;

    /**
     * Returns the destination Vertex of the given Edge Position
     * 
     * @param ep     Edge Position to return the destination Vertex of
     * @return the destination Vertex of the given Edge Position
     * @exception InvalidPositionException
     *                   thrown if the Edge Position is invalid
     */
    public Position destination(Position ep) throws InvalidPositionException;

    /**
     * Returns the origin Vertex of the given Edge Position
     * 
     * @param ep     Edge Position to return the origin Vertex of
     * @return the origin Vertex of the given Edge Position
     * @exception InvalidPositionException
     *                   thrown if the Edge Position is invalid
     */
    public Position origin(Position ep) throws InvalidPositionException;

    /**
     * Returns true if the given Edge Position is directed,
     * otherwise false
     * 
     * @param ep     Edge Position to check directed on
     * @return true if directed, otherwise false
     * @exception InvalidPositionException
     */
    public boolean isDirected(Position ep) throws InvalidPositionException;

    /**
     * Inserts a new undirected Edge into the graph with end
     * Vertices given by Positions vp and wp storing Object o,
     * returns a Position object for the new Edge
     * 
     * @param vp     Position holding one Vertex endpoint
     * @param wp     Position holding the other Vertex endpoint
     * @param o      Object to store at the new Edge
     * @return Position containing the new Edge object
     * @exception InvalidPositionException
     *                   thrown if either of the given vertices are invalid for
     *                   this container
     */
    public Position insertEdge(Position vp,Position wp, Object o) throws InvalidPositionException;

    /**
     * Inserts a new directed Edge into the graph with end
     * Vertices given by Positions vp, the origin, and wp,
     * the destination, storing Object o,
     * returns a Position object for the new Edge
     * 
     * @param vp     Position holding the origin Vertex
     * @param wp     Position holding the destination Vertex
     * @param o      Object to store at the new Edge
     * @return Position containing the new Edge object
     * @exception InvalidPositionException
     *                   thrown if either of the given vertices are invalid for
     *                   this container
     */
    public Position insertDirectedEdge(Position vp, Position wp, Object o) throws InvalidPositionException;

    /**
     * Inserts a new Vertex into the graph holding Object o
     * and returns a Position holding the new Vertex
     * 
     * @param o      the Object to hold in this Vertex
     * @return the Position holding the Vertex
     */
    public Position insertVertex(Object o);

    /**
     * This method removes the Vertex held in the passed in
     * Position from the Graph
     * 
     * @param vp     the Position holding the Vertex to remove
     * @exception InvalidPositionException
     *                   thrown if the given Position is invalid for this container
     */
    public void removeVertex(Position vp) throws InvalidPositionException;

    /**
     * Used to remove the Edge held in Position ep from the Graph
     * 
     * @param ep     the Position holding the Edge to remove
     * @exception InvalidPositionException
     *                   thrown if Position ep is invalid for this container
     */
    public void removeEdge(Position ep) throws InvalidPositionException;

    /**
     * This routine is used to change a directed Edge into an
     * undirected Edge
     * 
     * @param ep     a Position holding the Edge to change from directed to
     *               undirected
     * @exception InvalidPositionException
     */
    public void makeUndirected(Position ep) throws InvalidPositionException;

    /**
     * This routine can be used to reverse the diretion of a 
     * directed Edge
     * 
     * @param ep     a Position holding the Edge to reverse
     * @exception InvalidPositionException
     *                   thrown if the given Position is invalid for this container
     */
    public void reverseDirection(Position ep) throws InvalidPositionException;

    /**
     * Changes the direction of the given Edge to be out incident
     * upone the Vertex held in the given Position
     * 
     * @param ep     the Edge to change the direction of
     * @param vp     the Position holding the Vertex that the Edge is going
     *               to be out incident upon
     * @exception InvalidPositionException
     *                   thrown if either of the given positions are invalid for this container
     */
    public void setDirectionFrom(Position ep, Position vp) throws InvalidPositionException;


    /**
     * Changes the direction of the given Edge to be in incident
     * upone the Vertex held in the given Position
     * 
     * @param ep     the Edge to change the direction of
     * @param vp     the Position holding the Vertex that the Edge is going
     *               to be in incident upon
     * @exception InvalidPositionException
     *                   thrown if either of the given positions are invalid for this container
     */
    public void setDirectionTo(Position ep, Position vp) throws InvalidPositionException;

}
