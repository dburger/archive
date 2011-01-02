public class Sequence {

    public static interface Listener {
        void tick(int[] arr);
    }

    public static void runOdometer(int digits, int base, Listener l) {
        int[] odometer = new int[digits];
        l.tick(odometer);
        int hiValue = base - 1;
        int maxDigit = digits - 1;
        int digit = maxDigit;
        while (digit > -1) {
            if (odometer[digit] < hiValue) {
                odometer[digit]++;
                digit = maxDigit;
                l.tick(odometer);
            } else {
                odometer[digit] = 0;
                digit--;
            }
        }
    }

    public static void main(String[] args) {
        final String[] values = new String[] {"unknown", "yes", "no", "maybe"};
        runOdometer(6, values.length, new Listener() {

            public void tick(int[] arr) {
                for (int i = 0; i < arr.length; i++) {
                    System.out.print("'" + values[arr[i]] + "'");
                    if (i < arr.length) System.out.print(", ");
                }
                System.out.println();
            }

        });
    }

}
