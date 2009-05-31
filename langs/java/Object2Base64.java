import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.ObjectOutputStream;
import java.io.ObjectInputStream;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

public class Object2Base64 {

  public static void main(String[] args) {
    try {
      String foo = "this is the string that will be round tripped into base64";

      ByteArrayOutputStream baOut = new ByteArrayOutputStream();
      ObjectOutputStream out = new ObjectOutputStream(baOut);
      out.writeObject(foo);
      out.close();

      String base64 = new BASE64Encoder().encode(baOut.toByteArray());

      byte[] buf = new sun.misc.BASE64Decoder().decodeBuffer(base64);
      ByteArrayInputStream baIn = new ByteArrayInputStream(buf);
      ObjectInputStream in = new ObjectInputStream(baIn);
      Object read = in.readObject();

      System.out.println("I read: " + read);
    } catch (Exception exc) {
      exc.printStackTrace();
    }
  }

}
