import java.util.Enumeration;

/**
 * This object contains a method that returns the
 * edges in a DFS path from one vertex to another vertex.
 * 
 * @author digitalOverflow
 */
public class DFSPathFinder implements PathFinder {

    private LinkedSequence edges;
    private WeightedAdjacencyListGraph graph;
    private LabeledVertex start;
    private LabeledVertex finish;

    private boolean done;

    /**
     * Implementation of finding the edges between two
     * vertices using a DFS traversal.
     * 
     * @param G      The WeightedAdjacencyListGraph that we are going
     *               to do the search upon
     * @param s      the source vertex in the DFS traversal
     * @param f      the destination vertex in the DFS traversal
     * @return an Enumeration of the edges of the DFS traversal
     *         from vertex s to vertex f.  If there is no path
     *         from s to f then an empty Enumeration is returned
     */
    public Enumeration findPath(WeightedAdjacencyListGraph G, LabeledVertex s, LabeledVertex f) {
        edges = new LinkedSequence();
        graph = G;
        start = s;
        finish = f;
        done = false;
        //for G=(V,E) clear the markers used in the DFS
        clearMarkers();
        //call the recursive findPath function
        findPath(s);
        return new SequenceEnumerator(edges);
    }

    /**
     * A recursive algorithm that performs a dfs traversal
     * 
     * @param v      Current vertex of traversal
     */
    private void findPath(LabeledVertex v) {
        //enumerate the outgoing neighbors
        Enumeration outEdges = graph.outIncidentEdges(v);
        while (outEdges.hasMoreElements() && !done) {
            WeightedEdge e = (WeightedEdge)outEdges.nextElement();
            //check the tag
            if (e.getTag().length()==0) {
                //e is an unexplored edge
                LabeledVertex opp = (LabeledVertex)graph.opposite(v,e);
                if (opp.getTag().length()==0) {
                    //opp was an unexplored vertex
                    e.setTag("discovery");
                    edges.insertLast(e);
                    if (opp!=finish)
                        findPath(opp);
                    else
                        done = true;
                } else
                    e.setTag("back");
                //when the findPath fails you don't want to try to remove
                //an edge that isn't there
                if (!done && !edges.isEmpty()) edges.remove(edges.last());
            }
        }
    }

    /**
     * Clears the tag labels used in marking vertices during
     * the DFS traversal
     * 
     * @param graph  The graph to clear the markers of.
     */
    private void clearMarkers() {
        //clear the markers on the vertices
        Enumeration enum = graph.vertices();
        while (enum.hasMoreElements()) {
            LabeledVertex v = (LabeledVertex)enum.nextElement();
            v.setTag("");
        }
        //clear the markers on the edges
        enum = graph.edges();
        while (enum.hasMoreElements()) {
            WeightedEdge e = (WeightedEdge)enum.nextElement();
            e.setTag("");
        }
    }

}
