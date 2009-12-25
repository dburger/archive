import java.math.BigDecimal;

public class Money {

    // use BigDecimal, int, or long for monetary calculations

    public static void main(String[] args) {
        BigDecimal bd1 = new BigDecimal(1.03);
        BigDecimal bd2 = new BigDecimal(.42);
        System.out.println("from BigDecimal: " + bd1.subtract(bd2));
        int int1 = 103;
        int int2 = 42;
        System.out.println("from int: " + (int1 - int2));
    }

}
