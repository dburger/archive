import java.io.FileInputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.FileOutputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;

class Person implements Serializable {

    private transient String _firstName;
    private transient String _lastName;

    public Person(String firstName, String lastName) {
        checkName(firstName);
        checkName(lastName);
        _firstName = firstName;
        _lastName = lastName;
    }

    public Person setFirstName(String firstName) {
        checkName(firstName);
        _firstName = firstName;
        return this;
    }

    public Person setLastName(String lastName) {
        checkName(lastName);
        _lastName = lastName;
        return this;
    }

    private void checkName(String name) {
        if (name.indexOf("|") > -1) throw new IllegalArgumentException();
    }

    public void sayHello() {
        System.out.println("Hello from " + _firstName + " " + _lastName);
    }

    // this demonstrates a custom format, although in this case it is quite
    // weird as we don't allow a | and then right out the format as a single
    // string split by |

    private void writeObject(ObjectOutputStream s) throws IOException {
        // everything is transient
        s.defaultWriteObject();
        s.writeObject(_firstName + "|" + _lastName);
    }

    private void readObject(ObjectInputStream s) throws IOException,
            ClassNotFoundException {
        s.defaultReadObject();
        String content = (String)s.readObject();
        String[] parts = content.split("\\|");
        _firstName = parts[0];
        _lastName = parts[1];
    }

}

public class Serializin {

    public static void main(String[] args) throws Exception {
        Person p = new Person("John", "Doe");
        FileOutputStream fos = new FileOutputStream("temp");
        ObjectOutputStream oos = new ObjectOutputStream(fos);
        oos.writeObject(p);
        oos.close();

        p.sayHello();


        FileInputStream fis = new FileInputStream("temp");
        ObjectInputStream ois = new ObjectInputStream(fis);
        p = (Person)ois.readObject();
        ois.close();

        p.sayHello();
    }

}
