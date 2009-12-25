public class NewSpan {

    public static void printArray(int[] ary) {
        StringBuilder buf = new StringBuilder("[");
        for (int i = 0; i < ary.length; i++) {
            buf.append(ary[i]);
            if (i < ary.length) buf.append(", ");
        }
        buf.append("]");
        System.out.println(buf.toString());
    }

    public static int[] spans(int[] ary) {
        int[] spans = new int[ary.length];
        spans[0] = 1;
        for (int i = 1; i < ary.length; i++) {
            if (ary[i] >= ary[i - 1]) {
                spans[i] = spans[i - 1] + 1;
            } else {
                spans[i] = 1;
            }
        }
        return spans;
    }

    public static void main(String[] args) {
        int[] ary = new int[] {1, 2, 3, 4, 5, 3, 4, 5, 4, 2, 1};
        int[] spans = spans(ary);
        printArray(spans);
    }

}
