import java.util.EnumSet;
import java.util.Set;

public class EnumSetter {

    public enum Mondo {
        FIRST, SECOND, THIRD, FOURTH;
    }

    // receive them into a set
    public static void grind(Set<Mondo> mondos) {
        for (Mondo m : mondos) {
            System.out.println("received a " + m);
        }
    }

    // EnumSet.of packages them up for you
    public static void main(String[] args) {
        grind(EnumSet.of(Mondo.FIRST, Mondo.THIRD));
    }

}
