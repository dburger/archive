import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

/*
  this was about returning an empty array or list instead of a null
  also here I think I made defensive copies
*/

public class Empty {

    private String[] cheesesArr;
    private List<String> cheesesLst;

    public Empty(String... cheeses) {
        cheesesArr = new String[cheeses.length];
        cheesesLst = new ArrayList<String>();
        for (int i = 0; i < cheeses.length; i++) {
            cheesesArr[i] = cheeses[i];
            cheesesLst.add(cheeses[i]);
        }
    }

    public String[] getCheesesArr() {
        // making a copy
        return Arrays.copyOf(cheesesArr, cheesesArr.length);
    }

    public List<String> getCheesesLst() {
        // using the old empty
        if (cheesesLst.isEmpty()) return Collections.emptyList();
        // make a copy
        // (if going to array could have used toArray)
        return new ArrayList<String>(cheesesLst);
    }

    public static void main(String[] args) {
        Empty e = new Empty(args);

        // now we could pull cheese arrays and list with good empties
    }

}
