import java.util.Hashtable;
/**
 * This object is the result passed back from a CreateResidualGraph
 * call.  It allows the return to return not only the graph
 * but also a Hashtable with the representative vertices within
 * the residual graph indexed by the corresponding vertex in the
 * original graph
 * 
 * @author digitalOverflow
 */
public class ResidualGraphResult {
    
    private WeightedAdjacencyListGraph graph;
    private Hashtable vertices;

    /**
     * Constructor for ResidualGraphResult
     * 
     * @param g      residual graph to hold in this result
     * @param verts  a Hashtable containing the vertices within the residual
     *               graph indexed by the corresponding vertices of the original
     *               graph
     */
    ResidualGraphResult(WeightedAdjacencyListGraph g, Hashtable verts) {
        graph = g;
        vertices = verts;
    }

    /**
     * Returns the graph held within the result
     * 
     * @return returns the graph held within the result
     */
    public WeightedAdjacencyListGraph getGraph() {
        return graph;
    }

    /**
     * Returns the vertex within the residual graph that corresponds
     * to the original vertex from the original graph
     * 
     * @param v      vertex to return the corresponding vertex of
     * @return the corresponding vertex in the residual graph of vertex v
     */
    public LabeledVertex getCorresVertex(LabeledVertex v) {
        return (LabeledVertex)vertices.get(v);
    }

}
