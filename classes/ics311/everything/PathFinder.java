import java.util.Enumeration;

    /**
     * Interface for objects the find paths through a
     * WeightedAdjacencyListGraph from a source to a sink.  Implmentors
     * must implement the findPath method.
     */
public interface PathFinder {
    /**
     * The findPath method that for search for a path through
     * a graph
     * 
     * @param G      graph that we are search for the path within
     * @param s      the source vertex
     * @param f      the sink or final vertex
     * @return an Enumeration of edges from s to f or an empty Enumeration
     *         if no such path exists
     */
    public Enumeration findPath(WeightedAdjacencyListGraph G, LabeledVertex s, LabeledVertex f);

}
