import java.util.Arrays;
import java.util.Set;

public class Reflective {

    // run with java.util.HashSet one two three
    // or       java.util.TreeSet one two three
    public static void main(String[] args) {
        Class<?> cl = null;
        try {
            cl = Class.forName(args[0]);
        } catch (ClassNotFoundException exc) {
            System.err.println("Class not found.");
            System.exit(1);
        }

        Set<String> s = null;
        try {
            // simplistic reflextive use of newInstance making the impl
            // an appropriate Set type, HashSet or TreeSet here
            s = (Set<String>)cl.newInstance();
        } catch (IllegalAccessException exc) {
            System.err.println("Class not accessible.");
            System.exit(1);
        } catch (InstantiationException exc) {
            System.err.println("Class not instantiable.");
            System.exit(1);
        }

        s.addAll(Arrays.asList(args).subList(1, args.length));
        System.out.println(s);
    }

}
