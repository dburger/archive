// Java seems to make it hard to make generics that work with arrays.
// Complaints abound if you google for it.  I found this code which seems to
// join arrays of the same type.  It won't work with primitives, it won't work
// if the arrays are of different types.  It may be suitable for your needs
// sometimes:
import java.lang.reflect.Array;

public class ArrayUtils {

    public static <T> T[] join(T[] ... arrays) {
        // if the arrays aren't of all the same type the compiler will stop it
        // not sure how this works
        Class type = arrays.getClass().getComponentType().getComponentType();

        int size = 0;
        for (T[] array : arrays) size += array.length;

        T[] joined = (T[])Array.newInstance(type, size);

        int pos = 0;
        for (T[] array : arrays) {
            System.arraycopy(array, 0, joined, pos, array.length);
            pos += array.length;
        }

        return joined;
    }

}
