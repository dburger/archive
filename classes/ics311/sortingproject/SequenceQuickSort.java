import java.util.Random;
/**
 * Implements a merge sort algorithm for sorting sequences.
 * 
 * @author digitalOverflow
 */
public class SequenceQuickSort implements SortObject {
    /**
     * Sort method interface for a sort of Sequence S using Comparator C.
     *
     * @param S      the Sequence to sort
     * @param C      the Comparator to use in the sort
     */
    Random r;

    public void sort(Sequence S, Comparator C) {
        r = new Random();
        quicksort(S,C,0,S.size()-1);
    }

    private void quicksort(Sequence S, Comparator C, int leftBound, int rightBound) {
        //0 or 1 element or right crossing left nothing to sort
        if (rightBound-leftBound+1<2) return;
        //where the pivot is picked, here you can go
        //with a rightBound or random to make it
        //O(nlog(n)) expected time complexity even for
        //sorted data
        int pivotIndex = (int)(r.nextDouble() * (rightBound - leftBound + 1)) + leftBound;
        S.swap(S.atRank(pivotIndex),S.atRank(rightBound));
        Object pivot = S.atRank(rightBound).element();
        //indices used in scan step
        int leftIndex = leftBound;
        int rightIndex = rightBound-1;
        //this keeps the loop going until the indices cross
        while(leftIndex<=rightIndex) {
            //scan leftIndex to the left until something > pivot is found
            //or indices cross
            while((leftIndex<=rightIndex) && C.isLessThanOrEqualTo(S.atRank(leftIndex).element(),pivot))
                leftIndex++;
            //scan the rightIndex to the right until something < pivot is
            //found of indices cross
            while((rightIndex>=leftIndex) && C.isGreaterThanOrEqualTo(S.atRank(rightIndex).element(),pivot))
                rightIndex--;
            //if the leftIndex is still to the left of the rightIndex an
            //item pointed at by leftIndex is greater than the pivot and
            //an item pointed at by rightIndex is less than the pivot,
            //swap them
            if (leftIndex<rightIndex)
                S.swap(S.atRank(leftIndex),S.atRank(rightIndex));
        }
        //the indices have now crossed
        S.swap(S.atRank(leftIndex),S.atRank(rightBound));
        //now the pivot is at leftIndex, recurse around it
        quicksort(S,C,leftBound,leftIndex-1);
        quicksort(S,C,leftIndex+1,rightBound);
    }
}
