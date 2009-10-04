import java.util.Arrays;
import java.util.Iterator;
import java.util.NoSuchElementException;

public class Combinatorics {

    public static void swap(int[] a, int i, int j) {
        int tmp = a[j];
        a[j] = a[i];
        a[i] = tmp;
    }

    /** nPn without replacement index permutation lexicographic order. */
    public static int[] nextPerm(int[] a) {
        // find largest subscript j with a[j] < a[j + 1]
        int j = a.length - 2;
        while (a[j] > a[j + 1]) j--;

        // find the largest subscript k with a[k] < a[j]
        int k = a.length - 1;
        while (a[j] > a[k]) k--;

        swap(a, j, k);

        // put the tail of the permutation in increasing order
        int r = a.length - 1;
        int s = j + 1;
        while (r > s) swap(a, r--, s++);

        return a;
    }

    /** Returns Iterator over nPn without replacement index permutation lexicographic order. */
    public static Iterator<int[]> permIterator(final int length) {
        return new Iterator<int[]>() {
            boolean done = false;
            int[] currPerm = null;
            int[] lastPerm = null;

            private void initPerms() {
                currPerm = new int[length];
                lastPerm = new int[length];
                for (int i = 0; i < length; i++) {
                    currPerm[i] = i;
                    lastPerm[length - 1 - i] = i;
                }
            }

            public boolean hasNext() {
                if (currPerm == null) initPerms();
                return !done;
            }

            public int[] next() {
                if (currPerm == null) initPerms();
                if (!hasNext()) throw new NoSuchElementException();
                int[] ret = Arrays.copyOf(currPerm, currPerm.length);
                if (Arrays.equals(ret, lastPerm)) {
                    done = true;
                } else {
                    currPerm = nextPerm(currPerm);
                }
                return ret;
            }

            public void remove() {
                throw new UnsupportedOperationException();
            }
        };
    }

    /** nPn with replacement index permutation lexicographic order. */
    public static int[] nextPermWithReplacement(int[] perm, int n) {
        int hiValue = n - 1;
        int digit = perm.length - 1;
        while (digit > -1) {
            if (perm[digit] < hiValue) {
                perm[digit]++;
                return perm;
            } else {
                perm[digit--] = 0;
            }
        }
        throw new IllegalArgumentException("Illegal permutation state.");
    }

    /** Returns Iterator over nPn with replacement index permutation lexicographic order. */
    public static Iterator<int[]> permsWithReplacementIterator(final int n, final int r) {
        return new Iterator<int[]>() {
            int[] currPerm = null;
            int[] lastPerm = null;
            boolean done = false;

            private void initPerms() {
                currPerm = new int[r];
                lastPerm = new int[r];
                Arrays.fill(currPerm, 0);
                Arrays.fill(lastPerm, n - 1);
            }

            public boolean hasNext() {
                if (currPerm == null) initPerms();
                return !done;
            }

            public int[] next() {
                if (currPerm == null) initPerms();
                if (!hasNext()) throw new NoSuchElementException();
                int[] ret = Arrays.copyOf(currPerm, currPerm.length);
                if (Arrays.equals(ret, lastPerm)) {
                    done = true;
                } else {
                    currPerm = nextPermWithReplacement(currPerm, n);
                }
                return ret;
            }

            public void remove() {
                throw new UnsupportedOperationException();
            }
        };
    }

    /** nCr index combination lexicographic order. */
    public static int[] nextRComb(int[] a, int n) {
        int r = a.length;
        int i = r - 1;
        while (a[i] == n - r + i) i--;

        a[i]++;

        for (int j = i + 1; j < r; j++) a[j] = a[i] + j - i;

        return a;
    }

    /** Returns Iterator over nCr index combination lexicographic order. */
    public static Iterator<int[]> rCombsIterator(final int n, final int r) {
        return new Iterator<int[]>() {
            int[] currComb = null;
            int[] lastComb = null;
            boolean done = false;

            private void initCombs() {
                currComb = new int[r];
                lastComb = new int[r];
                for (int i = 0; i < r; i++) {
                    currComb[i] = i;
                    lastComb[i] = n - r + i;
                }
            }

            public boolean hasNext() {
                if (currComb == null) initCombs();
                return !done;
            }

            public int[] next() {
                if (currComb == null) initCombs();
                if (!hasNext()) throw new NoSuchElementException();
                int[] ret = Arrays.copyOf(currComb, currComb.length);
                if (Arrays.equals(ret, lastComb)) {
                    done = true;
                } else {
                    currComb = nextRComb(currComb, n);
                }
                return ret;
            }

            public void remove() {
                throw new UnsupportedOperationException();
            }
        };
    }

    public static void main(String[] args) {
        System.out.println("generate all permutations of length 3");
        for (Iterator<int[]> i = permIterator(3); i.hasNext();) {
            int[] a = i.next();
            System.out.println(Arrays.toString(a));
        }

        System.out.println("generate all permutations of length 2 with replacement from 3 items");
        for (Iterator<int[]> i = permsWithReplacementIterator(3, 2); i.hasNext();) {
            int[] a = i.next();
            System.out.println(Arrays.toString(a));
        }

        System.out.println("generate all combinations of 5 choose 2");
        for (Iterator<int[]> i = rCombsIterator(5, 2); i.hasNext();) {
            int[] a = i.next();
            System.out.println(Arrays.toString(a));
        }

    }

}
