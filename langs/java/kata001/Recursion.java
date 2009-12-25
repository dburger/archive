import java.util.ArrayList;
import java.util.List;

public class Recursion {

    public static int rbinarySearch(int[] arr, int lo, int hi, int target) {
        if (lo > hi) return -1;
        int mid = (hi + lo) / 2;
        if (arr[mid] > target) {
            return rbinarySearch(arr, lo, mid - 1, target);
        } else if (arr[mid] < target) {
            return rbinarySearch(arr, lo + 1, hi, target);
        } else {
            return mid;
        }
    }

    public static int ibinarySearch(int[] arr, int lo, int hi, int target) {
        while (lo <= hi) {
            int mid = (hi + lo) / 2;
            if (arr[mid] > target) {
                hi = mid - 1;
            } else if (arr[mid] < target) {
                lo = mid + 1;
            } else {
                return mid;
            }
        }
        return -1;
    }

    /*
    public static void iperms(String s) {
        for (int i = 0; i < s.length(); i++) {

        }
    }
    */

    public static List<String> rperms(String s) {
        List<String> perms = new ArrayList<String>();
        for (int i = 0; i < s.length(); i++) {
            String firstChar = s.substring(i, i + 1);
            List<String> sperms = rperms(s.substring(0, i) + s.substring(i + 1));
            for (int j = 0; j < sperms.size(); j++) {
                perms.add(firstChar + sperms.get(j));
            }
        }
        if (s.equals("")) perms.add("");
        return perms;
    }

    public static List<String> rcombs(String s) {
        List<String> combs = new ArrayList<String>();
        if (s.equals("")) {
            combs.add("");
        } else {
            String firstChar = s.substring(0, 1);
            List<String> scombs = rcombs(s.substring(1));
            combs.addAll(scombs);
            for (String t :scombs) combs.add(firstChar + t);
        }
        return combs;
    }

    public static String[] getOpts(String c) {
        String[] opts;
        if (c.equals("0")) {
            opts = new String[] {"0"};
        } else if (c.equals("1")) {
            opts = new String[] {"1"};
        } else if (c.equals("2")) {
            opts = new String[] {"A", "B", "C"};
        } else if (c.equals("3")) {
            opts = new String[] {"D", "E", "F"};
        } else if (c.equals("4")) {
            opts = new String[] {"G", "H", "I"};
        } else if (c.equals("5")) {
            opts = new String[] {"J", "K", "L"};
        } else if (c.equals("6")) {
            opts = new String[] {"M", "N", "O"};
        } else if (c.equals("7")) {
            opts = new String[] {"P", "R", "S"};
        } else if (c.equals("8")) {
            opts = new String[] {"T", "U", "V"};
        } else if (c.equals("9")) {
            opts = new String[] {"W", "X", "Y"};
        } else {
            opts = new String[] {"x"};
        }
        return opts;
    }

    public static List<String> rteleWords(String num) {
        List<String> words = new ArrayList<String>();
        if (num.equals("")) {
            words.add("");
        } else {
            String car = num.substring(0, 1);
            String cdr = num.substring(1);
            List<String> swords = rteleWords(cdr);
            String[] opts = getOpts(car);
            for (int i = 0; i < opts.length; i++) {
                for (int j = 0; j < swords.size(); j++) {
                    words.add(opts[i] + swords.get(j));
                }
            }
        }
        return words;
    }

    public static List<String> iteleWords(String num) {
        List<String> words = new ArrayList<String>();
        int[] states = new int[] {0, 0, 0, 0, 0, 0, -1};
        int pos = 6;
        while (pos >= 0) {
            while (pos >= 0 &&
                    states[pos] == getOpts(num.substring(pos, pos + 1)).length - 1) {
                states[pos--] = 0;
            }
            if (pos >= 0) {
                states[pos] += 1;
                StringBuilder buf = new StringBuilder();
                for (int i = 0; i < states.length; i++) {
                    buf.append(getOpts(num.substring(i, i + 1))[states[i]]);
                }
                words.add(buf.toString());
                pos = 6;
            }
        }
        return words;
    }

    public static void main(String[] args) {
        int[] arr = new int[] {1, 4, 6, 8, 9, 10, 22, 34, 56, 78};
        System.out.println(ibinarySearch(arr, 0, arr.length - 1, 6));
        System.out.println(ibinarySearch(arr, 0, arr.length - 1, 9));
        System.out.println(ibinarySearch(arr, 0, arr.length - 1, 34));
        System.out.println(ibinarySearch(arr, 0, arr.length - 1, 78));
        System.out.println(ibinarySearch(arr, 0, arr.length - 1, 1));
        System.out.println(ibinarySearch(arr, 0, arr.length - 1, 101));

        List<String> perms = rperms("hellox");
        for (String s : perms) {
            System.out.println(s);
        }
        System.out.println("perms: " + perms.size());

        List<String> combs = rcombs("abc");
        for (String s : combs) {
            System.out.println(s);
        }
        System.out.println("combs: " + combs.size());

        List<String> teleWords = rteleWords("2948430");
        for (String s : teleWords) {
            System.out.println("teleword: " + s);
        }
        System.out.println("num teleword: " + teleWords.size());
    }

}
