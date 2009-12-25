public class BinarySearch {

    public static int binarySearch(int val, int[] ary) {
        int lo = 0;
        int hi = ary.length - 1;
        while (hi >= lo) {
            int mid = lo + (hi - lo) / 2;
            if (ary[mid] == val) {
                return mid;
            } else if (ary[mid] > val) {
                hi = mid - 1;
            } else {
                lo = mid + 1;
            }
        }
        return -1;
    }

    public static int rbinSearch(int val, int[] ary, int hi, int lo) {
        if (lo > hi) return -1;
        int mid = (hi + lo) / 2;
        if (ary[mid] == val) {
            return mid;
        } else if (ary[mid] > val) {
            return rbinSearch(val, ary, mid - 1, lo);
        } else {
            return rbinSearch(val, ary, hi, mid + 1);
        }
    }

    public static void main(String[] args) {
        int[] ary = new int[] {1, 2, 3, 4, 5, 6};
        System.out.println(binarySearch(0, ary));
        System.out.println(binarySearch(1, ary));
        System.out.println(binarySearch(2, ary));
        System.out.println(binarySearch(3, ary));
        System.out.println(binarySearch(4, ary));
        System.out.println(binarySearch(5, ary));
        System.out.println(binarySearch(6, ary));
        System.out.println(binarySearch(7, ary));

        System.out.println(rbinSearch(0, ary, ary.length - 1, 0));
        System.out.println(rbinSearch(1, ary, ary.length - 1, 0));
        System.out.println(rbinSearch(2, ary, ary.length - 1, 0));
        System.out.println(rbinSearch(3, ary, ary.length - 1, 0));
        System.out.println(rbinSearch(4, ary, ary.length - 1, 0));
        System.out.println(rbinSearch(5, ary, ary.length - 1, 0));
        System.out.println(rbinSearch(6, ary, ary.length - 1, 0));
        System.out.println(rbinSearch(7, ary, ary.length - 1, 0));
    }

    public static int str2int(String s) {
        int i = 0;
        boolean neg = (s.charAt(0) == '-');
        if (neg) i++;
        int val = 0;
        for (; i < s.length; i++) {
            val += 10 * val + (s.charAt(i) - '0')
        }
        if (neg) val *= -1;
        return val;
    }

    public static String int2str(int i) {
        StringBuilder buf = new StringBuilder();
        boolean neg = (i < 0);
        if (neg) i *= -1;
        while (i > 0) {
            buf.prepend(i % 10 + "");
            i /= 10;
        }
        if (neg) buf.prepend("-");
        return buf.toString();
    }

}
