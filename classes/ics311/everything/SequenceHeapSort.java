/**
 * An object for sorting that uses a linked heap heap sort.
 * 
 * @author digitalOverflow
 */
public class SequenceHeapSort implements SortObject {
    /**
     * Sort method interface for a sort of Sequence S using Comparator C.
     *
     * @param S      the Sequence to sort
     * @param C      the Comparator to use in the sort
     */
    public void sort(Sequence S, Comparator C) {
        LinkedBinaryTreeHeap H = new LinkedBinaryTreeHeap(C);
        while(!S.isEmpty()) {
            Object e = S.remove(S.first());
            H.insertItem(e,e);
        }
        while(!H.isEmpty())
            S.insertLast(H.removeMinElement());
    }
}
