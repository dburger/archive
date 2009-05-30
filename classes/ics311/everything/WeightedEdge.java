/**
 * The type of object representing a WeightedEdge in a graph
 * 
 * @author digitalOverflow
 */
public class WeightedEdge extends Edge {

    private int weight;
    private String tag;

    /**
     * Constructor for WeightedEdge object
     * 
     * @param o      Object to hold at this Edge
     * @param c      Container of this Edge
     * @param d      true for a directed edge, false otherwise
     * @param orig   one of the vertices of the edge, and,
     *               if directed, origination vertex
     * @param dest   one of the vertices of the edge, and,
     *               if directed, destination vertex
     * @param w      weight to hold at this edge
     */
    WeightedEdge(Object o, Container c, boolean d, Vertex orig, Vertex dest, int w) {
        super(o,c,d,orig,dest);
        weight = w;
    }


    /**
     * Returns the weight for this WeightedEdge object
     * 
     * @return the weight for this WeightedEdge object 
     */
    public int getWeight() {
        return weight;
    }


    /**
     * sets the weight for this WeightedEdge
     * 
     */
    public void setWeight(int w) {
        weight = w;
    }

    /**
     * Returns the tag for this WeightedEdge object
     * 
     * @return the tag for this WeightedEdge object
     */
    public String getTag() {
        return tag;
    }
    /**
     * Sets the tag for this WeightedEdge object
     * 
     * @param t    the new tag for this WeightedEdge
     */
    public void setTag(String t) {
        tag = t;
    }

}
