import java.util.Enumeration;

/**
 * This object contains a method that returns the
 * edges in a BFS path from one vertex to another vertex.
 * 
 * @author digitalOverflow
 */
public class BFSPathFinder implements PathFinder {
    
    /**
     * Implementation of finding the edges between two
     * vertices using a BFS traversal.
     * 
     * @param G      The WeightedAdjacencyListGraph that we are going
     *               to do the search upon
     * @param s      the source vertex in the BFS traversal
     * @param f      the destination vertex in the BFS traversal
     * @return an Enumeration of the edges of the BFS traversal
     *         from vertex s to vertex f.  If there is no path
     *         from s to f then an empty Enumeration is returned
     */
    public Enumeration findPath(WeightedAdjacencyListGraph G, LabeledVertex s, LabeledVertex f) {
        //for G=(V,E) clear the markers used in the BFS
        clearMarkers(G);
        Enumeration edges;
        LinkedSequence S = new LinkedSequence();
        S.insertFirst(new BFSObject(s,null,null));
        while (!S.isEmpty()) {
            BFSObject b = (BFSObject)S.remove(S.first());
            //b contains a sequence containing all edges to its vertex
            LabeledVertex v = b.getVertex();
            //if v is our target we're done
            if (v==f) return b.getEdges();
            v.setTag("visited");
            edges = G.outIncidentEdges(v);
            while (edges.hasMoreElements()) {
                WeightedEdge e = (WeightedEdge)edges.nextElement();
                //checks to see if tag is still clear, if clear look at opposite vertex
                if (e.getTag().length()==0) {
                    LabeledVertex opp = (LabeledVertex)G.opposite(v,e);
                    //see if opposite vertex has been marked
                    if (opp.getTag().length()==0) {
                        e.setTag("discovery");
                        S.insertLast(new BFSObject(opp,e,b));
                    } else
                        e.setTag("cross");
                    opp.setTag("marked");
                }
            }
        }
        //didn't find t, return an empty enumeration
        return new SequenceEnumerator(S);
    }


    /**
     * Clears the tag labels used in marking vertices during
     * the BFS traversal
     * 
     * @param graph  The graph to clear the markers of.
     */
    private void clearMarkers(WeightedAdjacencyListGraph graph) {
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
