import java.util.Vector;
import org.apache.xmlrpc.XmlRpcClient;

public class AddressClient {

  public static void main(String[] args) {
    try {
      XmlRpcClient client = new XmlRpcClient(args[0]);
      Object ret = client.execute("getAddress", new Vector());
      System.out.println("Called getAddress, received: " + ret);

      ret = client.execute("getSomethingElse", new Vector());
      System.out.println("Called getSomethingElse, received: " + ret);
    } catch (Exception exc) {
      exc.printStackTrace();
    }
  }

}
