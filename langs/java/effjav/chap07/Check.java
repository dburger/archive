public class Check {

    // fib(0) == 0
    // fib(1) == 1
    // fib(n) == fib(n - 1) + fib(n - 2)
    public static int ifib(int n) {
        // check parameters for validity
        if (n < 0) throw new IllegalArgumentException();
        if (n < 2) return 1;
        int prev1 = 1;
        int prev2 = 1;
        int ret = 0;
        while (n-- > 1) {
            ret = prev2 + prev1;
            prev1 = prev2;
            prev2 = ret;
        }
        return ret;
    }

    public static int rfib(int n) {
        if (n < 0) throw new IllegalArgumentException();
        if (n < 2) return 1;
        return rfib(n - 1) + rfib(n - 2);
    }

    public static void main(String[] args) {
        // not good example here -- but book says --
        // "nonpublic methods should generally check thier parameters using
        //  assertions"
        assert args != null;
        int i = 42;
        System.out.println("ifib");
        System.out.printf("value of fib(%d) is %d%n", i, ifib(i));
        System.out.println("rfib");
        System.out.printf("value of fib(%d) is %d%n", i, rfib(i));

        for (i = 0; i < 10; i++) {
            System.out.printf("fib of %d is %d%n", i, ifib(i));
        }
    }

}
