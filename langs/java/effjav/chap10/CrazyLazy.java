public class CrazyLazy {

    // you get Lazy Initialization with this technique with no synchro
    // usually you could just synchro the getter I suppose, this may be
    // more confusion that it is worth

    private static class FieldHolder {

        public static final int something = computeFieldValue();
    }

    private static int computeFieldValue() {return 5;}

    private static String scomputeFieldValue() {return "bob";}

    public String getMessage() {
        return "the message is " + FieldHolder.something;
    }

    // and lastly the double check idiom, hardcore, must be volatile !!!!!!!!
    // because first check is without the lock

    private volatile String value;

    public String getValue() {
        String result = value;
        if (result == null) {
            synchronized(this) {
                result = value;
                if (result == null) {
                    value = result = scomputeFieldValue();
                }
            }
        }
        return result;
    }

    public static void main(String[] args) {
        CrazyLazy cl = new CrazyLazy();
        System.out.println(cl.getMessage());
        System.out.println(cl.getValue());
    }

}
