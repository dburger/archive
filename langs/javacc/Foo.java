import java.io.StringBufferInputStream;

public class Foo {

    public static void main(String[] args) throws Exception {
        StringBufferInputStream in = new StringBufferInputStream("66403");
        AddressParser parser = new AddressParser(in);
        String ret = parser.drive();
        System.out.println(ret);
    }

}
