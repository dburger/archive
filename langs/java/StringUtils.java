import java.util.Random;

public class StringUtils {

    /**
     * Returns a string with the given chars trimmed from the head and or tail.
     *
     * @param str string to trim
     * @param chars set of characters to trim from the head and or tail
     * @param trimHead whether or not to trim chars from the head of the string
     * @param trimTail whether or not to trim chars from the tail of the string
     * @return string with characters trimmed from the head and or tail
     */
    public static String trim(String str, String chars, boolean trimHead,
            boolean trimTail) {
        int head = 0;
        int tail = str.length() - 1;
        if (trimHead) {
            while (head <= tail && chars.indexOf(str.charAt(head)) > -1) head++;
        }
        if (trimTail) {
            while (tail >= head && chars.indexOf(str.charAt(tail)) > -1) tail--;
        }
        return str.substring(head, tail + 1);
    }

    /**
     * Generates a random string of the given length from the characters in
     * the passed in character arrays.  Example:
     * <code>String foo = genRandstring(5, "0123456789".toCharArray())</code>
     *
     * @param length length of random string to generate
     * @param arys one or more character arrays to pull random characters from
     * @return random string of given length with characters from arrays
     */
    public static String genRandString(int length, char[]... arys) {
        int numChars = 0;
        char[] chars = null;

        // slight optimization if only one array given
        if (arys.length == 1) {
            numChars = arys[0].length;
            chars = arys[0];
        } else {
            for (int i = 0; i < arys.length; i++) numChars += arys[i].length;
            chars = new char[numChars];
            for (int i = 0, j = 0; i < arys.length; i++) {
                System.arraycopy(arys[i], 0, chars, j, arys[i].length);
                j += arys[i].length;
            }
        }

        StringBuilder buf = new StringBuilder();
        Random rand = new Random();
        while (length-- > 0) buf.append(chars[rand.nextInt(numChars)]);

        return buf.toString();
    }

    public static void main(String[] args) {
        System.out.println("head:" + trim(args[0], " ", true, false) + ":");
        System.out.println("tail:" + trim(args[0], " ", false, true) + ":");
        System.out.println("both:" + trim(args[0], " ", true, true) + ":");
        System.out.println("neit:" + trim(args[0], " ", false, false) + ":");
        System.out.println(genRandString(50,
                        "abcdefghijklmnopqrstuvwxyz".toCharArray(),
                        "ABCDEFGHIJKLMNOPQRSTUVWXYZ".toCharArray(),
                        "0123456789".toCharArray()));
    }

}
