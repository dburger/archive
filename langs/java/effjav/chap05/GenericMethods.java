import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class GenericMethods {

    private static interface Function<E> {

        E compute(E e1, E e2);

    }

    // return type
    // parameterized type
    // argument types

    public static <E> Set<E> union(Set<E> s1, Set<E> s2) {
        Set<E> tmp = new HashSet<E>(s1);
        tmp.addAll(s2);
        return tmp;
    }

    // also the reduce verbosity trick...wow syntax

    public static <E> Set<E> newSetInstance() {
        return new HashSet<E>();
    }

    // and finally a nightmare declaration

    public static <E> E reduce(List<? extends E> list, Function<E> fn,
            E initVal) {
        for (E elem : list) {
            initVal = fn.compute(elem, initVal);
        }

        return null;
    }

    public static void main(String[] args) {
        Set<String> s1 = new HashSet<String>();
        // less verbosity?
        Set<String> s2 = newSetInstance();

        s1.add("bill");
        s1.add("bob");

        s2.add("bob");
        s2.add("bryce");

        Set<String> s3 = union(s1, s2);
        for (String s : s3) {
            System.out.println(s);
        }
    }
}
