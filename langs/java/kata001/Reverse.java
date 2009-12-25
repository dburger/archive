public class Reverse {

    public static void reverse(int[] ary) {
        int mid = ary.length / 2;
        for (int i = 0; i <= mid; i++) {
            int tmp = ary[i];
            ary[i] = ary[ary.length - 1 - i];
            ary[ary.length - 1 - i] = tmp;
        }
    }

    public static int[] computeSpans(int[] ary) {
        int[] spans = new int[ary.length];
        if (ary.length == 0) return spans;
        int run = 1;
        spans[0] = 1;
        for (int i = 1; i < ary.length; i++) {
            if (ary[i] >= ary[i - 1]) {
                run++;
            } else {
                run = 1;
            }
            spans[i] = run;
        }
        return spans;
    }

    public static void main(String[] args) {
        int[] ary = new int[] {1, 2, 3, 4, 12, 6, 7, 8, 9};
        int[] spans = computeSpans(ary);
        for (int i = 0; i < spans.length; i++) {
            System.out.println(spans[i]);
        }
    }

}
