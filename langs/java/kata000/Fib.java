public class Fib {

    public static int fib(int n) {
        if (n < 0) throw new IllegalArgumentException();
        int prev1 = 1;
        int prev2 = 1;
        int ret = 1;
        while (n-- > 1) {
            ret = prev1 + prev2;
            prev2 = prev1;
            prev1 = ret;
        }
        return ret;
    }

    public static void main(String[] args) {
        for (String arg : args) {
            int n = Integer.parseInt(arg);
            System.out.printf("found fib(%d) to be %d%n", n, fib(n));
        }
    }

}
