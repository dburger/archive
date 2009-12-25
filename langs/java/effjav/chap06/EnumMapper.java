import java.util.EnumMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

class Herb {

    public enum Type {ANNUAL, PERENNIAL, BIENNIAL}

    private final String _name;
    private final Type _type;

    Herb(String name, Type type) {
        _name = name;
        _type = type;
    }

    @Override
    public String toString() {
        return _name;
    }

    public Type getType() {return _type;}
}

public class EnumMapper {

    public static void main(String[] args) {
        Herb[] herbs = new Herb[] {new Herb("foo", Herb.Type.ANNUAL),
                                   new Herb("bar", Herb.Type.PERENNIAL),
                                   new Herb("baz", Herb.Type.BIENNIAL)};
        // using an EnumMap --
        // map from type to set of herb
        Map<Herb.Type, Set<Herb>> herbsByType =
                new EnumMap<Herb.Type, Set<Herb>>(Herb.Type.class);

        // for each type, create its set of herb
        for (Herb.Type t : Herb.Type.values()) {
            herbsByType.put(t, new HashSet<Herb>());
        }

        // now get the set and add the herb
        for (Herb h : herbs) {
            herbsByType.get(h.getType()).add(h);
        }

        // pretty print me
        System.out.println(herbsByType);
    }

}
