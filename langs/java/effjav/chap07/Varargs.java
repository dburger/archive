public class Varargs {

    public static int sum(int... args) {
        int sum = 0;
        for (int arg : args) sum += arg;
        return sum;
    }

    // for one or more trick it out
    public static int sumMoreThanOne(int first, int... more) {
        int sum = first;
        for (int arg : more) sum += arg;
        return sum;
    }

    public static void main(String[] args) {
        System.out.println("sum is: " + sum(1, 3, 4, 5, 6));
    }

}
