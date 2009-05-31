public class BinarySearch {

  public static int binarySearch(int value, int[] values) {
    int lo = 0;
    int hi = values.length - 1;
    while (lo <= hi) {
      int mid = (hi - lo) / 2 + lo;
      if (values[mid] == value) {
        return mid;
      } else if (values[mid] < value) {
        lo = mid + 1;
      } else {
        hi = mid - 1;
      }
    }
    return -1;
  }

  public static int binarySearch(int value, int lo, int hi, int[] values) {
    if (lo > hi) return -1;
    int mid = (hi - lo) / 2 + lo;
    if (values[mid] == value) {
      return mid;
    } else if (values[mid] < value) {
      lo = mid + 1;
    } else {
      hi = mid - 1;
    }

    return binarySearch(value, lo, hi, values);
  }

  public static void main(String[] args) {
    long time = System.currentTimeMillis();


    assert (binarySearch(3, 0, -1, new int[0]) == -1)
        : "(binarySearch(3, 0, -1, new int[0]) == -1)";
    assert (binarySearch(3, 0, 2, new int[] {1, 3, 5}) == 1)
        : "(binarySearch(3, 0, 2, new int[] {1, 3, 5}) == 1)";
    assert (binarySearch(5, 0, 2, new int[] {1, 3, 5}) == 2)
        : "(binarySearch(5, 0, 2, new int[] {1, 3, 5}) == 2)";
    assert (binarySearch(0, 0, 2, new int[] {1, 3, 5}) == -1)
        : "(binarySearch(0, 0, 2, new int[] {1, 3, 5}) == -1)";
    assert (binarySearch(2, 0, 2, new int[] {1, 3, 5}) == -1)
        : "(binarySearch(2, 0, 2, new int[] {1, 3, 5}) == -1)";
    assert (binarySearch(4, 0, 2, new int[] {1, 3, 5}) == -1)
        : "(binarySearch(4, 0, 2, new int[] {1, 3, 5}) == -1)";
    assert (binarySearch(6, 0, 2, new int[] {1, 3, 5}) == -1)
        : "(binarySearch(6, 0, 2, new int[] {1, 3, 5}) == -1)";

    assert (binarySearch(1, 0, 3, new int[] {1, 3, 5, 7}) == 0)
        : "(binarySearch(1, 0, 3, new int[] {1, 3, 5, 7}) == 0)";
    assert (binarySearch(3, 0, 3, new int[] {1, 3, 5, 7}) == 1)
        : "(binarySearch(3, 0, 3, new int[] {1, 3, 5, 7}) == 1)";
    assert (binarySearch(5, 0, 3, new int[] {1, 3, 5, 7}) == 2)
        : "(binarySearch(5, 0, 3, new int[] {1, 3, 5, 7}) == 2)";
    assert (binarySearch(7, 0, 3, new int[] {1, 3, 5, 7}) == 3)
        : "(binarySearch(7, 0, 3, new int[] {1, 3, 5, 7}) == 3)";
    assert (binarySearch(0, 0, 3, new int[] {1, 3, 5, 7}) == -1)
        : "(binarySearch(0, 0, 3, new int[] {1, 3, 5, 7}) == -1)";
    assert (binarySearch(2, 0, 3, new int[] {1, 3, 5, 7}) == -1)
        : "(binarySearch(2, 0, 3, new int[] {1, 3, 5, 7}) == -1)";
    assert (binarySearch(4, 0, 3, new int[] {1, 3, 5, 7}) == -1)
        : "(binarySearch(4, 0, 3, new int[] {1, 3, 5, 7}) == -1)";
    assert (binarySearch(6, 0, 3, new int[] {1, 3, 5, 7}) == -1)
        : "(binarySearch(6, 0, 3, new int[] {1, 3, 5, 7}) == -1)";
    assert (binarySearch(8, 0, 3, new int[] {1, 3, 5, 7}) == -1)
        : "(binarySearch(8, 0, 3, new int[] {1, 3, 5, 7}) == -1)";


    /*
    assert (binarySearch(3, new int[0]) == -1)
        : "(binarySearch(3, new int[]) == -1)";
    assert (binarySearch(3, new int[] {1, 3, 5}) == 1)
        : "(binarySearch(3, new int[] {1, 3, 5}) == 1)";
    assert (binarySearch(5, new int[] {1, 3, 5}) == 2)
        : "(binarySearch(5, new int[] {1, 3, 5}) == 2)";
    assert (binarySearch(0, new int[] {1, 3, 5}) == -1)
        : "(binarySearch(0, new int[] {1, 3, 5}) == -1)";
    assert (binarySearch(2, new int[] {1, 3, 5}) == -1)
        : "(binarySearch(2, new int[] {1, 3, 5}) == -1)";
    assert (binarySearch(4, new int[] {1, 3, 5}) == -1)
        : "(binarySearch(4, new int[] {1, 3, 5}) == -1)";
    assert (binarySearch(6, new int[] {1, 3, 5}) == -1)
        : "(binarySearch(6, new int[] {1, 3, 5}) == -1)";

    assert (binarySearch(1, new int[] {1, 3, 5, 7}) == 0)
        : "(binarySearch(1, new int[] {1, 3, 5, 7}) == 0)";
    assert (binarySearch(3, new int[] {1, 3, 5, 7}) == 1)
        : "(binarySearch(3, new int[] {1, 3, 5, 7}) == 1)";
    assert (binarySearch(5, new int[] {1, 3, 5, 7}) == 2)
        : "(binarySearch(5, new int[] {1, 3, 5, 7}) == 2)";
    assert (binarySearch(7, new int[] {1, 3, 5, 7}) == 3)
        : "(binarySearch(7, new int[] {1, 3, 5, 7}) == 3)";
    assert (binarySearch(0, new int[] {1, 3, 5, 7}) == -1)
        : "(binarySearch(0, new int[] {1, 3, 5, 7}) == -1)";
    assert (binarySearch(2, new int[] {1, 3, 5, 7}) == -1)
        : "(binarySearch(2, new int[] {1, 3, 5, 7}) == -1)";
    assert (binarySearch(4, new int[] {1, 3, 5, 7}) == -1)
        : "(binarySearch(4, new int[] {1, 3, 5, 7}) == -1)";
    assert (binarySearch(6, new int[] {1, 3, 5, 7}) == -1)
        : "(binarySearch(6, new int[] {1, 3, 5, 7}) == -1)";
    assert (binarySearch(8, new int[] {1, 3, 5, 7}) == -1)
        : "(binarySearch(8, new int[] {1, 3, 5, 7}) == -1)";
    */

    System.out.println(System.currentTimeMillis() - time);
  }

}
