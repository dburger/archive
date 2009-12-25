interface Foo {

    void doit();

}

public class Nested {

    // non static nested class has access to enclosing instance through
    // NestedClass.this

    private class MyFoo implements Foo {

        public void doit() {
            System.out.println(Nested.this.wanker());
        }

    }

    public String wanker() {return "hello world";}

    public Foo getFoo() {
        return new MyFoo();
    }

    public static void main(String[] args) {
        Nested n1 = new Nested();
        Foo f = n1.getFoo();
        f.doit();
    }

}
