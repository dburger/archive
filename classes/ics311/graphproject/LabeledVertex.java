/**
 * The type of object representing a LabeledVertex in a graph
 * 
 * @author digitalOverflow
 */
public class LabeledVertex extends Vertex {

    private int label;
    private String tag;

    /**
     * Constructor for the LabeledVertex object
     * 
     * @param e      Object to hold at this vertex
     * @param c      Container of this position
     * @param l      label for this vertex
     */
    LabeledVertex(Object e, Container c, int l) {
        super(e,c);
        label = l;
    }


    /**
     * Returns the label for this LabeledVertex object
     * 
     * @return the label for this LabeledVertex object
     */
    public int getLabel() {
        return label;
    }

    /**
     * Sets the label for this LabeledVertex object
     * 
     * @param l    the new label for this LabeledVertex
     */
    public void setLabel(int l) {
        label = l;
    }

    /**
     * Returns the tag for this LabeledVertex object
     * 
     * @return the tag for this LabeledVertex object
     */
    public String getTag() {
        return tag;
    }
    /**
     * Sets the tag for this LabeledVertex object
     * 
     * @param t    the new tag for this LabeledVertex
     */
    public void setTag(String t) {
        tag = t;
    }

}
