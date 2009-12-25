import java.util.Random;

public class Rando {

    public static void main(String[] args) {
        int max = -1;
        int min = 101;
        Random rnd = new Random();
        for (int i = 0; i < 1000000; i++) {
            int next = rnd.nextInt(100);
            if (next > max) max = next;
            if (next < min) min = next;
        }
        System.out.printf("found to be %d and %d%n", min, max);
    }

}
