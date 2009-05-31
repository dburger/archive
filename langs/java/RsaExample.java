import java.nio.ByteBuffer;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.PrivateKey;
import java.security.spec.PKCS8EncodedKeySpec;
import javax.crypto.Cipher;

public class RsaExample {

  public static void main(String[] args) throws Exception {
    KeyPairGenerator keyPairGen = KeyPairGenerator.getInstance("RSA");
    KeyPair keyPair = keyPairGen.genKeyPair();

    // System.out.println("private key is: " + keyPair.getPrivate());
    // System.out.println("public key is: " + keyPair.getPublic());


    /*
    byte[] encodedPrivKey = keyPair.getPrivate().getEncoded();

    // this shows that if you get the encoded key to the other partner then
    // the private key can be reconstituted as follows:

    PKCS8EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(encodedPrivKey);
    KeyFactory keyFactory = KeyFactory.getInstance("RSA");
    PrivateKey privateKey = keyFactory.generatePrivate(keySpec);
    System.out.println("equals?: " + privateKey.equals(keyPair.getPrivate()));
    */

    Cipher cipher = Cipher.getInstance("RSA");
    cipher.init(Cipher.ENCRYPT_MODE, keyPair.getPublic());

    byte[] message = "hello there bob!".getBytes();
    byte[] encoded = cipher.doFinal(message, 0, message.length);

    /*
    System.out.println("message: " + new String(message));
    System.out.println("encoded: " + new String(encoded));
    */

    cipher.init(Cipher.DECRYPT_MODE, keyPair.getPrivate());

    byte[] decoded = cipher.doFinal(encoded, 0, encoded.length);
    System.out.println("decoded: " + new String(decoded));
  }

}
