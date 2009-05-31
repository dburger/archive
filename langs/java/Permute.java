import java.util.Iterator;
import java.util.NoSuchElementException;

class PermutationIterator implements Iterator {

  private String _string;

  private int[] _positions;

  public PermutationIterator(String string) {
    _string = string;
    _positions = new int[_string.length()];
    for (int i = 0; i < _positions.length; i++) {_positions[i] = i;}
  }

  public boolean hasNext() {
    int j = _positions.length - 2;
    for (; j > -1; j--) {
      if (_positions[j] < _positions[j + 1]) break;
    }

    return (j != -1);
  }

  public Object next() {
    int j = _positions.length - 2;
    for (; j > -1; j--) {
      if (_positions[j] < _positions[j + 1]) break;
    }

    if (j == -1) throw new NoSuchElementException();

    int l = _positions.length - 1;
    while (_positions[j] >= _positions[l]) l--;
    int temp = _positions[j];
    _positions[j] = _positions[l];
    _positions[l] = temp;

    int k = j + 1;
    l = _positions.length - 1;
    while (k < l) {
      temp = _positions[k];
      _positions[k] = _positions[l];
      _positions[l] = temp;
      k++;
      l--;
    }

    StringBuffer buf = new StringBuffer();
    for (int i = 0; i < _positions.length; i++) {
      buf.append(_string.charAt(_positions[i]));
    }

    return buf;
  }

  public void remove() {
    throw new UnsupportedOperationException();
  }

}

public class Permute {

  // recursive permutation generation
  public static String[] permute(String string) {
    if (string.length() == 1) return new String[] {string};

    String[] in = permute(string.substring(1));
    String[] out = new String[in.length * string.length()];

    for (int i = 0; i < in.length; i++) {
      for (int j = 0; j < string.length(); j++) {
        out[(i * string.length()) + j] = in[i].substring(0, j)
            + string.charAt(0) + in[i].substring(j);
      }
    }

    return out;
  }

  public static void main(String[] args) {
    /*
    String[] res = permute(args[0]);
    for (int i = 0; i < res.length; i++) {
      System.out.println(res[i]);
    }
    System.out.println("total perms: " + res.length);
    */

    Iterator piter = new PermutationIterator(args[0]);
    while (piter.hasNext()) System.out.println(piter.next());
  }

}
