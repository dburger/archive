import java.security.MessageDigest;

public class MessageDigest {

    public static void main(String[] args) throws Exception {
        MessageDigest md = MessageDigest.getInstance("MD5");
        md.update(args[0].toString().getBytes());
        byte[] digest = md.digest();

        for (int i = 0; i < digest.length; i++) {
            String digits = Integer.toHexString(0x00FF & digest[i]);
            if (digits.length() == 1) digits = "0" + digits;
            System.out.print(digits);
        }
        System.out.println();
    }

}
