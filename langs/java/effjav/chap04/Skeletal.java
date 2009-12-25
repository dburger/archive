interface Foo {

    void bonks();

    void honks();

}

/*
  abstract blank Impl makes it easy to subclass and only override what you need
*/

class AbstractFoo implements Foo {

    public void bonks() {}

    public void honks() {}

}

public class Skeletal {

    public static void main(String[] args) {
        Foo myFoo = new AbstractFoo() {
                public void bonks() {System.out.println("actually bonks");}
        };

        myFoo.bonks();
    }

}
