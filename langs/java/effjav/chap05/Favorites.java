import java.util.HashMap;
import java.util.Map;

/*
  typesafe: it will never return an Integer when you ask for String
  heterogeneous: all the keys are of different types

  note techniques, no @SuppressWarnings("unchecked") necessary
*/


public class Favorites {

    // <Class<?>, Object>
    private Map<Class<?>, Object> _favorites
            = new HashMap<Class<?>, Object>();

    public <T> void putFavorite(Class<T> type, T instance) {
        _favorites.put(type, instance);
    }

    public <T> T getFavorite(Class<T> type) {
        // Class has a cast ???
        return type.cast(_favorites.get(type));
    }

    public static void main(String[] args) {
        Favorites f = new Favorites();
        f.putFavorite(String.class, "hello world");
        f.putFavorite(Integer.class, 0xcafebabe);
        System.out.println("favorite string is: " + f.getFavorite(String.class));
        System.out.println("favorite integer is: " + f.getFavorite(Integer.class));
        // lookie lookie, %n no \n
        System.out.printf("%s %x%n", f.getFavorite(String.class),
                f.getFavorite(Integer.class));
    }

}
