public class Partition {

    public static void swap(int a, int b, int[] ary) {
        int tmp = ary[b];
        ary[b] = ary[a];
        ary[a] = tmp;
    }

    public static int partition(int left, int right, int pivot, int[] ary) {
        int pivotValue = ary[pivot];
        swap(pivot, right, ary);
        pivot = right--;
        while (left < right) {
            while (left < right && ary[left] < pivotValue) left++;
            while (right > left && ary[right] >= pivotValue) right--;
            if (ary[left] > ary[right]) swap(left, right, ary);
        }
        swap(pivot, left, ary);
        return left;
    }

    public static void printArray(int[] ary) {
        for (int i : ary) System.out.print(i + "  ");
        System.out.println();
    }

    public static void quickSort(int lo, int hi, int[] ary) {
        if (lo >= hi) return;
        int pivot = partition(lo, hi, hi, ary);
        quickSort(lo, pivot - 1, ary);
        quickSort(pivot + 1, hi, ary);
    }

    public static void main(String[] args) {
        int[] ary = new int[] {2, 5, 1, 5, 7, 9, 4, 2, 65, 5, 7, -3, 9, 21, -1, 8, 14, 37};
        // partition(0, ary.length - 1, 4, ary);
        quickSort(0, ary.length - 1, ary);
        printArray(ary);
    }

}
