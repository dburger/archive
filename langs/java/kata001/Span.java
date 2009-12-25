public class Span {

    public static int[] spans(int[] vals) {
        int[] ret = new int[vals.length];
        int run = 1;
        ret[0] = 1;
        for (int i = 1; i < vals.length; i++) {
            if (vals[i] >= vals[i - 1]) {
                run++;
            } else {
                run = 1;
            }
            ret[i] = run;
        }
        return ret;
    }

    public static void main(String[] args) {
        System.out.print("spans: ");
        int[] res = spans(new int[] {1, 2, 3, 3, 2, 5, 5, 6, 4, 3});
        for (int i : res) System.out.print(i + ":");
        System.out.println("");
    }

}
