public class Visy {

    // without synchronization different threads could see different values

    private int _foo = 0;

    public synchronized void setFoo(int foo) {
        _foo = foo;
    }

    public synchronized int getFoo() {
        return _foo;
    }

    public static void main(String[] args) {
        Visy v = new Visy();
        v.setFoo(12);
        System.out.println(v.getFoo());
    }

    // as a side not all variables are atomc except long or double
    // ie, get value stored by a thread

}
