import java.util.Vector;
import org.apache.xmlrpc.WebServer;

public class AddressServer {

  public String getAddress() {
    return "address";
  }

  public String getSomethingElse() {
    return "something else";
  }

  public static void main(String[] args) {
    WebServer server = new WebServer(Integer.parseInt(args[0]));
    server.addHandler("$default", new AddressServer());
    server.start();
    System.out.println("AddressServer listening on port: " + args[0]);
  }

}
