import java.util.ArrayList;
import java.util.List;

public class Unchecked {

    // if you can't (which is this case of course I could) eliminate the
    // unchecked warning, then @SuppressWarnings

    @SuppressWarnings("unchecked")
    public static void main(String[] args) {
        List l = new ArrayList();
        l.add("hello");
    }

}
