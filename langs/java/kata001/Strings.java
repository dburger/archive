import java.util.HashMap;

public class Strings {

    public static Character nonRepeat(String s) {
        HashMap<Character, Boolean> h = new HashMap<Character, Boolean>();
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            Boolean b = h.get(c);
            if (b == null) {
                h.put(c, Boolean.FALSE);
            } else if (b == Boolean.FALSE) {
                h.put(c, Boolean.TRUE);
            }
        }
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (h.get(c) == Boolean.FALSE) return c;
        }
        return null;
    }

    public static String removeChars(String s, String r) {
        HashMap<Character, Boolean> h = new HashMap<Character, Boolean>();
        for (int i = 0; i < r.length(); i++) {
            h.put(r.charAt(i), Boolean.TRUE);
        }
        char[] c = s.toCharArray();
        int src = 0;
        int dst = 0;
        while (src < c.length) {
            if (h.get(c[src]) != Boolean.TRUE) c[dst++] = c[src];
            src++;
        }
        return new String(c, 0, dst);
    }

    public static int str2int(String s) {
        char[] c = s.toCharArray();
        int i = 0;
        int v = 0;
        boolean neg = c[0] == '-';
        if (neg) i++;
        while (i < c.length) {
            v = (v * 10) + (c[i++] - '0');
        }
        if (neg) v *= -1;
        return v;
    }

    public static String int2str(int i) {
        boolean neg = i < 0;
        if (neg) i *= -1;
        StringBuilder buf = new StringBuilder();
        while (i > 0) {
            buf.insert(0, (char)('0' + (i % 10)));
            i /= 10;
        }
        if (neg) buf.insert(0, "-");
        return buf.toString();
    }

    public static void main(String[] args) {
        // System.out.println(nonRepeat(args[0]));
        // System.out.println(removeChars("hello there special world", "aeiou"));
        // System.out.println(str2int(args[0]));
        int i = Integer.parseInt(args[0]);
        System.out.println("converting: " + i + " " + int2str(i));
    }

}
