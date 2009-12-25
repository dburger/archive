import java.util.HashMap;
import java.util.Map;

/*
  advantages:
  they have names
  may reuse objects - Boolean.valueOf
  can return any subtype
  reduce verbosity parameterized instances BELOW

  disadvantages:
  cannot be subclassed if no public / protected constructors
  not distinguished from other public statics
*/

public class StaticFactory extends HashMap {

    public static <K, V> HashMap<K, V> newInstance() {
        return new HashMap<K, V>();
    }

    public static void main(String[] args) {
        Map<String, Integer> m = StaticFactory.newInstance();
        m.put("hello", 5);
        System.out.println("have found it to be: " + m.get("hello"));
    }

}
