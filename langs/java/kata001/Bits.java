public class Bits {

    public static int countBits(int v) {
        int m = 1;
        int cnt = 0;
        while (v != 0) {
            if ((v & m) > 0) cnt++;
            v >>>= 1;
        }
        return cnt;
    }

    public static int fcountBits(int v) {
        int cnt = 0;
        while (v > 0) {
            cnt++;
            v = v & (v - 1);
        }
        return cnt;
    }

    public static void main(String[] args) {
        int v = Integer.parseInt(args[0]);
        System.out.println("the count was found to be: " + fcountBits(v));
    }

}
