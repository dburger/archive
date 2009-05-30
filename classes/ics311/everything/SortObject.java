/**
 * A sorting interface
 * 
 * @author digitalOverflow
 */
public interface SortObject {
    /**
     * Sort method interface for a sort of Sequence S using Comparator C.
     * 
     * @param S      the Sequence to sort
     * @param C      the Comparator to use in the sort
     */
    public void sort(Sequence S, Comparator C);
}
