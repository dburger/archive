import java.util.Arrays;
import java.util.Collection;

public class GenericStack<E> {

    private static final int INITIAL_CAPACITY = 16;
    private E[] _elements;
    private int _size = 0;

    // getting the generic array problem kicked in the butt

    @SuppressWarnings("unchecked")
    public GenericStack() {
        _elements = (E[])new Object[INITIAL_CAPACITY];
    }

    public void push(E element) {
        ensureCapacity();
        _elements[_size++] = element;
    }

    public E pop() {
        if (_size == 0) throw new IllegalStateException();
        E element = _elements[--_size];
        _elements[_size] = null;
        return element;
    }

    private void ensureCapacity() {
        if (_size == _elements.length) {
            _elements = Arrays.copyOf(_elements, _elements.length * 2);
        }
    }

    public boolean empty() {
        return _size == 0;
    }

    // PECS = producer extends, consumer super

    // bounded wildcard !!!
    public void pushAll(Iterable<? extends E> src) {
        for (E e : src) push(e);
    }

    // and again
    public void popAll(Collection<? super E> dst) {
        while (!empty()) dst.add(pop());
    }

    public static void main(String[] args) {
        GenericStack<String> gs = new GenericStack<String>();
        for (String arg : args) {
            gs.push(arg);
        }
        while (!gs.empty()) {
            System.out.println(gs.pop());
        }
    }

}
