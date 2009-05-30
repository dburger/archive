import java.util.Enumeration;
/**
 * This object is used for BFS searches when returning
 * the paths traveled from a source to a sink in a BFS
 * traversal.
 * 
 * @author digitalOverflow
 */
public class BFSObject {
    
    /**
     * A reference to the vertex that this step of the BFS
     * got to.
     */
    private LabeledVertex vertex;

    /**
     * A sequence that contains all the edges necessary to
     * get to the vertex held in vertex.
     */
    private LinkedSequence edgesToVertex;

    /**
     * Basic constructor for a BFSObject
     * 
     * @param v      the vertex that this step of the BFS gets to
     * @param e      the edge used to get to this vertex in the BFS
     *               traversal
     * @param b      the BFSObject of the vertex that reached this
     *               vertext
     */
    BFSObject(LabeledVertex v, WeightedEdge e, BFSObject b) {
        vertex = v;
        edgesToVertex = new LinkedSequence();
        if (b!=null) {
            Enumeration enum = b.getEdges();
            while (enum.hasMoreElements())
                edgesToVertex.insertLast(enum.nextElement());
        }
        if (e!=null)
            edgesToVertex.insertLast(e);
    }

    /**
     * returns the vertex held in this BFSObject
     * 
     * @return the vertex held in this BFSObject
     */
    public LabeledVertex getVertex() {
        return vertex;
    }

    /**
     * Returns an Enumeration of the edges necessary to get
     * to this vertex in a BFS traversal
     * 
     * @return returns an Enumeration of the edges necessary to get
     *         to this vertex in a BFS traversal
     */
    public Enumeration getEdges() {
        return new SequenceEnumerator(edgesToVertex);
    }

}
