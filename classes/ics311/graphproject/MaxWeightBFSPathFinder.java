import java.util.Enumeration;
/**
 * This object contains a method that returns the
 * edges in the maximum BFS path from one vertex to another vertex.
 * 
 * @author digitalOverflow
 */
public class MaxWeightBFSPathFinder implements PathFinder {

    LinkedSequence paths;

    /**
     * Implementation of finding the edges between two
     * vertices using the maximum BFS traversal.
     * 
     * @param G      The WeightedAdjacencyListGraph that we are going
     *               to do the search upon
     * @param s      the source vertex in the maximum BFS traversal
     * @param f      the destination vertex in the maximum BFS traversal
     * @return an Enumeration of the edges of the maximum BFS traversal
     *         from vertex s to vertex f.  If there is no path
     *         from s to f then an empty Enumeration is returned
     */    
    public Enumeration findPath(WeightedAdjacencyListGraph G, LabeledVertex s, LabeledVertex f) {
        paths = new LinkedSequence();
        boolean done = false;
        //for G=(V,E) clear the markers used in the BFS
        clearMarkers(G);
        Enumeration edges;
        LinkedSequence S = new LinkedSequence();
        S.insertFirst(new BFSObject(s,null,null));
        while (!S.isEmpty()) {            
            BFSObject b = (BFSObject)S.remove(S.first());
            LabeledVertex v = b.getVertex();
            if (v==f) {
                done = true;
                paths.insertFirst(b.getEdges());
                //all the possible paths that get to f in this bfs layer must already be in the
                //sequence, cycle through, removing all, putting the ones that get to f
                //into paths, this will also empty the sequence so no more iterations of the while
                //loop occur
                while (!S.isEmpty()) {
                    b = (BFSObject)S.remove(S.first());
                    v = b.getVertex();
                    if (v==f)
                        paths.insertFirst(b.getEdges());
                }
            } else {
                v.setTag("visited");
                //everything from the same "layer" is already in the Sequence so don't add
                //any more possiblities if done because they will lead to results that are
                //at least layer + 1 from the source
                if (!done) {
                    edges = G.outIncidentEdges(v);
                    while (edges.hasMoreElements()) {
                        WeightedEdge e = (WeightedEdge)edges.nextElement();
                        if (e.getTag().length()==0) {
                            LabeledVertex opp = (LabeledVertex)G.opposite(v,e);
                            if (!opp.getTag().equals("visited")) {
                                e.setTag("discovery");
                                if (!done)
                                    S.insertLast(new BFSObject(opp,e,b));
                            } else
                                e.setTag("cross");
                            opp.setTag("marked");
                        }
                    }
                }
            }
        }
        if (paths.isEmpty())
            //didn't find t, return an empty enumeration
            return new SequenceEnumerator(S);
        else {
            //here we cycle through all the bfs paths choosing the one with the
            //largest augmentation
            int largestAugmentation = 0;
            Enumeration greatestAugmentationEdges = null;
            Enumeration possiblePath = new SequenceEnumerator(paths);
            while (possiblePath.hasMoreElements()) {
                edges = (Enumeration)possiblePath.nextElement();
                //set to pos infinity so will find anything less
                int thisFlowsLeastEdge = Integer.MAX_VALUE;
                while (edges.hasMoreElements()) {
                    WeightedEdge e = (WeightedEdge)edges.nextElement();
                    if (e.getWeight()<thisFlowsLeastEdge)

                        thisFlowsLeastEdge = e.getWeight();
                }
                if (thisFlowsLeastEdge>largestAugmentation) {
                    largestAugmentation = thisFlowsLeastEdge;
                    greatestAugmentationEdges = edges;
                }
            }
            ((SequenceEnumerator)greatestAugmentationEdges).reset();
            //returns the greatest BFS augmentation
            return greatestAugmentationEdges;
        }
    }

    /**
    * Clears the tag labels used in marking vertices during
    * the maximum BFS traversal
    * 
    * @param graph  The graph to clear the markers of.
    */
    private void clearMarkers(WeightedAdjacencyListGraph graph) {
        //clear the vertex markers
        Enumeration enum = graph.vertices();
        while (enum.hasMoreElements()) {
            LabeledVertex v = (LabeledVertex)enum.nextElement();
            v.setTag("");
        }
        //clear the edge markers
        enum = graph.edges();
        while (enum.hasMoreElements()) {
            WeightedEdge e = (WeightedEdge)enum.nextElement();
            e.setTag("");
        }
    }
}
