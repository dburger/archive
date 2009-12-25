import java.util.Arrays;

/*
  Cloneable determines the behavoir of Object's protected clone implementation,
    it returns a field-by-field copy of the object, otherwise throws
    CloneNotSupportedException

  This example shows tweaking cloning to prevent the clone of Clone from using
    the same storage array.

  Immutables really don't need cloning.

  A copy constructor or static factory is a fine alternative.
*/

public class Clone implements Cloneable {

    private Object[] _elements;
    private int _size = 0;
    private static final int DEFAULT_CAPACITY = 16;

    public Clone() {
        _elements = new Object[DEFAULT_CAPACITY];
    }

    public void push(Object e) {
        ensureCapacity();
        _elements[_size++] = e;
    }

    public Object pop() {
        if (_size == 0) throw new IllegalStateException();
        Object e = _elements[--_size];
        _elements[_size] = null;
        return e;
    }

    private void ensureCapacity() {
        if (_size == _elements.length) {
            _elements = Arrays.copyOf(_elements, 2 * _size + 1);
        }
    }

    @Override
    public Clone clone() {
        try {
            Clone result = (Clone)super.clone();
            // if you didn't do this you'd end up pointing at the same array
            // fall down go boom
            result._elements = _elements.clone();
            return result;
        } catch (CloneNotSupportedException exc) {
            throw new AssertionError();
        }
    }

    public static void main(String[] args) {
        Clone c1 = new Clone();
        c1.push(1);
        c1.push(2);
        c1.push(3);
        Clone c2 = c1.clone();
        c1.pop();
        for (int i = 0; i < 3; i++) {
            System.out.println(c2.pop());
        }
    }

}
