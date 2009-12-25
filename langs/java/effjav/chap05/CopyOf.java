import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class CopyOf {

    public static void main(String[] args) {
        // the old way, but more flexible?
        int[] foo = new int[] {1, 2, 3};
        int[] bar = new int[foo.length];
        System.arraycopy(foo, 0, bar, 0, foo.length);
        System.out.println("bar is a copy with: ");
        System.out.println(Arrays.toString(bar));

        // the new way? -- only start at 0?
        int[] baz = Arrays.copyOf(foo, foo.length);
        System.out.println("baz is a copy with: ");
        System.out.println(Arrays.toString(baz));

        // and don't forget that crazy toArray crap
        List<String> l = new ArrayList<String>();
        l.add("first");
        l.add("second");
        l.add("third");

        // if not large enough will make and return to you
        String[] moo = l.toArray(new String[0]);
        System.out.println("moo is a copy with: ");
        System.out.println(Arrays.toString(moo));

        // or can return in place if fits
        String[] mar = new String[l.size()];
        l.toArray(mar);
        System.out.println("mar is a copy with: ");
        System.out.println(Arrays.toString(mar));

        // i didn't know about this
        List<String> names = Arrays.asList("bob", "bill", "bart");
        // makes a List backed by an array
        for (String name: names) {
            System.out.println("found it to be " + name);
        }
    }

}
