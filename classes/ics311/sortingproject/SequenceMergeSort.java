/**
 * Implements a merge sort algorithm for sorting sequences.
 * 
 * @author digitalOverflow
 */
public class SequenceMergeSort implements SortObject {
    /**
     * Sort method interface for a sort of Sequence S using Comparator C.
     *
     * @param S      the Sequence to sort
     * @param C      the Comparator to use in the sort
     */
    public void sort(Sequence S, Comparator C) {
        int n = S.size();
        //already sorted if 0 or 1 elements
        if (n<2) return;
        Sequence S1 = new LinkedSequence();
        //the larger half
        for (int i=1;i<=(n+1)/2;i++)
            S1.insertLast(S.remove(S.first()));
        Sequence S2 = new LinkedSequence();
        //the smaller half
        for (int i=1;i<=n/2;i++)
            S2.insertLast(S.remove(S.first()));
        sort(S1,C);
        sort(S2,C);
        merge(S1,S2,C,S);
    }

    /**
     * Performs the merging of two sorted sequences into one sorted sequence using the comparator.
     * 
     * @param S1     sequence 1 for the merge
     * @param S2     sequence 2 for the merge
     * @param C      the comparator used in the merge
     * @param S      the sequence to merge the other two into in sorted order
     */
    public void merge(Sequence S1, Sequence S2, Comparator C, Sequence S) {
        while (!S1.isEmpty() && !S2.isEmpty()) {
            if (C.isLessThanOrEqualTo(S1.first().element(),S2.first().element()))
                S.insertLast(S1.remove(S1.first()));
            else
                S.insertLast(S2.remove(S2.first()));
        }
        //only one of these can still have elements
        while (!S1.isEmpty())
            S.insertLast(S1.remove(S1.first()));
        while (!S2.isEmpty())
            S.insertLast(S2.remove(S2.first()));
    }
}
