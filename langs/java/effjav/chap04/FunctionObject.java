import java.util.Comparator;

interface Puter {

    int pute(int n);

}

// formal function object in the jdk...Comparator

class MyCompar implements Comparator<String> {

    public int compare(String s1, String s2) {
        return s1.compareTo(s2);
    }

}

// exporting concrete strategies

class MyHamajing {

    private static String reverse(String s) {
        StringBuilder buf = new StringBuilder();
        for (int i = s.length() - 1; i > -1; i--) {
            buf.append(s.charAt(i));
        }
        return buf.toString();
    }

    private static class StrLenCmp implements Comparator<String> {

        public int compare(String s1, String s2) {
            return s1.compareTo(s2);
        }

    }

    private static class StrRevCmp implements Comparator<String> {

        public int compare(String s1, String s2) {
            String r1 = reverse(s1);
            String r2 = reverse(s2);
            return r1.compareTo(r2);
        }

    }

    public static final Comparator<String> STR_LEN_CMP = new StrLenCmp();
    public static final Comparator<String> STR_REV_CMP = new StrRevCmp();

}

public class FunctionObject {

    public static void main(String[] args) {
        Puter myPuter = new Puter() {
                public int pute(int n) {return n + 1;}
        };

        System.out.println("my function objects says 5 becomes: "
                + myPuter.pute(5));

        System.out.println("comparing foo and faa: "
                + new MyCompar().compare("foo", "faa"));
    }

}
