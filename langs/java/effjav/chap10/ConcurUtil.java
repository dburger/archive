import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;


public class ConcurUtil {

    public static void main(String[] args) {
        // this stuff supercedes the old Collections.synchronizedMap and of
        // course Hashtable
        ConcurrentMap<String, Integer> m =
                new ConcurrentHashMap<String, Integer>();
    }
}
