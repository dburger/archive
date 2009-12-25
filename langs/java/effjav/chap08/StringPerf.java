public class StringPerf {

    public static void main(String[] args) {
        int max = 100000;
        StringBuilder buf = new StringBuilder();
        System.out.println("before StringBuilder");
        for (int i = 0; i < max; i++) {
            buf.append(i);
        }

        System.out.println("before String");
        String s = "";
        for (int i = 0; i < max; i++) {
            s += i;
        }
    }

}
