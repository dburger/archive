import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Text;
import org.xml.sax.SAXException;

/**
 * Demonstration class that shows how to work with XML in Java.
 *
 * @author David J. Burger
 */
public class JavaXml {

  /**
   * Main entry point.  Since this is just a demo, all Exceptions are thrown
   * to make the code a little clearer.
   */
  public static void main(String[] args) throws ParserConfigurationException,
    TransformerException, FileNotFoundException, IOException, SAXException {

    if (args.length != 1) {
      System.out.println("Proper usage is Test file");
      System.exit(1);
    }

    // how to build a document
    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
    DocumentBuilder builder = factory.newDocumentBuilder();
    Document document = builder.newDocument();
    Element root = document.createElement("rootElement");
    root.setAttribute("anAttribute", "whatever");
    Text text = document.createTextNode("how about a little text");
    root.appendChild(text);
    document.appendChild(root);

    // how to transform the document, here to a file
    TransformerFactory tf = TransformerFactory.newInstance();
    Transformer transformer = tf.newTransformer();
    DOMSource source = new DOMSource(document);
    FileOutputStream outputStream = new FileOutputStream(new File(args[0]));
    StreamResult result = new StreamResult(outputStream);
    transformer.transform(source, result);
    outputStream.close();

    // how to read in the document
    FileInputStream inputStream = new FileInputStream(new File(args[0]));
    document = builder.parse(inputStream);
    inputStream.close();
    System.out.println(document.getDocumentElement());
  }

}
